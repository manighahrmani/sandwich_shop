# Worksheet 6 — Local Persistence with SQLite

## Table of contents

- [What you need to know beforehand](#what-you-need-to-know-beforehand)
- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 5](#continue-from-worksheet-5)
  - [Switch to branch 5](#switch-to-branch-5)
- [Introduction to local databases](#introduction-to-local-databases)
  - [Why SQLite](#why-sqlite)
  - [Cross-platform SQLite in Flutter](#cross-platform-sqlite-in-flutter)
  - [Add database dependencies](#add-database-dependencies)
  - [Commit your changes (1)](#commit-your-changes-1)
- [Creating the database helper](#creating-the-database-helper)
  - [Define the database singleton](#define-the-database-singleton)
  - [Initialize database tables](#initialize-database-tables)
  - [Commit your changes (2)](#commit-your-changes-2)
- [Persisting and retrieving order transactions](#persisting-and-retrieving-order-transactions)
  - [Define the OrderTransaction model](#define-the-ordertransaction-model)
  - [Insert completed orders](#insert-completed-orders)
  - [Query order history](#query-order-history)
  - [Commit your changes (3)](#commit-your-changes-3)
- [Building the order history screen](#building-the-order-history-screen)
  - [Create the OrderHistoryScreen widget](#create-the-orderhistoryscreen-widget)
  - [Connect checkout to database persistence](#connect-checkout-to-database-persistence)
  - [Commit your changes (4)](#commit-your-changes-4)
- [Persisting user settings in SQLite](#persisting-user-settings-in-sqlite)
  - [Add settings database operations](#add-settings-database-operations)
  - [Load and save settings from SQLite](#load-and-save-settings-from-sqlite)
  - [Commit your changes (5)](#commit-your-changes-5)
- [Testing database operations](#testing-database-operations)
  - [Set up in-memory database testing](#set-up-in-memory-database-testing)
  - [Test database transactions](#test-database-transactions)
  - [Commit your changes (6)](#commit-your-changes-6)
- [Exercises](#exercises)

## What you need to know beforehand

Ensure that you have completed [Worksheet 1 — Dart, Git, GitHub and Flutter](./worksheet-1.md), [Worksheet 2 — Stateless and Stateful Widgets](./worksheet-2.md), [Worksheet 3 — Data Models, Repositories, Assets and In-Page Navigation](./worksheet-3.md), [Worksheet 4 — Unit and Widget Testing](./worksheet-4.md), and [Worksheet 5 — Navigation Drawer, Basket Management, and Forms](./worksheet-5.md). You should be comfortable building navigation drawers, managing in-memory repositories, and implementing form controllers.

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 5

You can continue directly with the Sandwich Shop project you completed in Worksheet 5. Open your project folder in VS Code with **File > Open Folder**.

### Switch to branch 5

If you prefer to start with a clean copy matching the Worksheet 5 end state, switch to branch `5`:

```bash
git checkout 5
```

Run `flutter test` in your terminal to ensure that all existing unit and widget tests pass.

## Introduction to local databases

In Worksheet 5, our `CartRepository` stored orders in memory. When the application restarts or the browser tab refreshes, in-memory state disappears. To keep receipts and user preferences between launches, we store them in a local relational database.

### Why SQLite

SQLite is a lightweight, embedded SQL database engine. It does not require a separate server process. The entire database is stored in a single file on disk or managed in memory.

Using SQL tables allows us to store structured records with primary keys, filter transactions by date, and query historical data efficiently.

### Cross-platform SQLite in Flutter

Flutter runs across desktop, mobile, and web browsers. In native desktop and mobile environments, the operating system permits writing files directly to disk. In web browsers, applications execute inside a secure sandbox.

To provide cross-platform SQLite support, we use `sqflite_common_ffi` on desktop and testing environments, and `sqflite_common_ffi_web` when running in a browser.

### Add database dependencies

Open `pubspec.yaml` in your project root. Under `dependencies:`, add the following packages:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite_common_ffi: ^2.3.0
  sqflite_common_ffi_web: ^0.4.0
```

Run `flutter pub get` in your terminal to download and install the packages:

```bash
flutter pub get
```

### Commit your changes (1)

Stage and commit `pubspec.yaml` and `pubspec.lock`:

```bash
git add pubspec.yaml pubspec.lock
git commit -m "Add SQLite database dependencies"
```

## Creating the database helper

We manage database connections through a dedicated helper class named `SandwichDatabase`.

### Define the database singleton

Create a new file named `lib/database/sandwich_db.dart`. We implement a singleton pattern so that all screens share a single open connection:

```dart
import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/models/order_transaction.dart';
import 'package:sandwich_shop/models/user_settings.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SandwichDatabase {
  SandwichDatabase._internal();

  static final SandwichDatabase instance = SandwichDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    final Database db = await _initDB('sandwich_shop.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String filePath) async {
    final DatabaseFactory dbFactory;
    if (kIsWeb) {
      dbFactory = databaseFactoryFfiWebNoWebWorker;
    } else {
      sqfliteFfiInit();
      dbFactory = databaseFactoryFfi;
    }

    final OpenDatabaseOptions options = OpenDatabaseOptions(
      version: 1,
      onCreate: _createDB,
    );

    final String resolvedPath;
    if (const bool.fromEnvironment('FLUTTER_TEST')) {
      resolvedPath = inMemoryDatabasePath;
    } else {
      resolvedPath = filePath;
    }

    return await dbFactory.openDatabase(
      resolvedPath,
      options: options,
    );
  }
```

Notice the check `kIsWeb`: if running on the web, it selects `databaseFactoryFfiWebNoWebWorker`. Otherwise, it initializes desktop FFI. In automated tests, it resolves to `inMemoryDatabasePath`.

### Initialize database tables

Within the same `SandwichDatabase` class, define `_createDB` to create the `transactions` and `settings` tables:

```dart
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        date TEXT NOT NULL,
        total_price REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        email TEXT NOT NULL,
        receive_news INTEGER NOT NULL
      )
    ''');

    // Insert default user settings record
    await db.insert('settings', <String, dynamic>{
      'id': 1,
      'name': 'Student User',
      'address': 'University of Portsmouth\nPortsmouth\nPO1 2UP',
      'email': 'student@port.ac.uk',
      'receive_news': 1,
    });
  }
```

### Commit your changes (2)

Stage and commit `sandwich_db.dart`:

```bash
git add lib/database/sandwich_db.dart
git commit -m "Create SQLite database helper and initialize tables"
```

## Persisting and retrieving order transactions

Next, we define an order transaction data model to represent completed purchases saved to SQLite.

### Define the OrderTransaction model

Create a new file named `lib/models/order_transaction.dart`:

```dart
class OrderTransaction {
  final int? id;
  final int transactionNumber;
  final String summary;
  final String date;
  final double totalPrice;

  const OrderTransaction({
    this.id,
    required this.transactionNumber,
    required this.summary,
    required this.date,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'transaction_number': transactionNumber,
      'summary': summary,
      'date': date,
      'total_price': totalPrice,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory OrderTransaction.fromMap(Map<String, dynamic> map) {
    final dynamic idVal = map['id'];
    final int? id = idVal is int ? idVal : null;
    final int transactionNumber = map['transaction_number'] as int;
    final String summary = map['summary'] as String;
    final String date = map['date'] as String;
    final num priceNum = map['total_price'] as num;
    final double totalPrice = priceNum.toDouble();

    return OrderTransaction(
      id: id,
      transactionNumber: transactionNumber,
      summary: summary,
      date: date,
      totalPrice: totalPrice,
    );
  }
}
```

### Insert completed orders

In `lib/database/sandwich_db.dart`, add methods to insert transactions and calculate sequential transaction numbers:

```dart
  Future<int> insertTransaction(OrderTransaction tx) async {
    final Database db = await database;
    final int id = await db.insert('transactions', tx.toMap());
    return id;
  }

  Future<int> getNextTransactionNumber() async {
    final Database db = await database;
    final List<Map<String, dynamic>> records = await db.rawQuery(
      'SELECT MAX(transaction_number) as max_num FROM transactions',
    );
    if (records.isNotEmpty && records[0]['max_num'] != null) {
      final int currentMax = records[0]['max_num'] as int;
      return currentMax + 1;
    }
    return 1001;
  }
```

### Query order history

Add a method to query all transactions ordered with the newest first:

```dart
  Future<List<OrderTransaction>> getAllTransactions() async {
    final Database db = await database;
    final List<Map<String, dynamic>> records = await db.query(
      'transactions',
      orderBy: 'transaction_number DESC',
    );
    final List<OrderTransaction> transactions = [];
    for (final Map<String, dynamic> row in records) {
      transactions.add(OrderTransaction.fromMap(row));
    }
    return transactions;
  }
```

### Commit your changes (3)

Stage and commit `order_transaction.dart` and `sandwich_db.dart`:

```bash
git add lib/models/order_transaction.dart lib/database/sandwich_db.dart
git commit -m "Implement order transaction model and database CRUD methods"
```

## Building the order history screen

Now let us build an `OrderHistoryScreen` to display past orders stored in the SQLite database.

### Create the OrderHistoryScreen widget

Create a new file named `lib/screens/order_history_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_transaction.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() {
    return _OrderHistoryScreenState();
  }
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderTransaction> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final List<OrderTransaction> loaded =
          await SandwichDatabase.instance.getAllTransactions();
      if (mounted) {
        setState(() {
          _orders = loaded;
        });
      }
    } catch (_) {}
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'No past orders found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    final List<Widget> cards = [];
    for (final OrderTransaction tx in _orders) {
      cards.add(
        Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${tx.transactionNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(tx.summary),
                const SizedBox(height: 4),
                Text(
                  tx.date,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  'Total Paid: £${tx.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cards,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget content;
    if (_orders.isEmpty) {
      content = _buildEmptyState();
    } else {
      content = _buildOrdersList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Past Orders',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}
```

Register `'/history'` in `lib/widgets/nav_drawer.dart` and `lib/main.dart`:

```dart
const DrawerTile(title: 'Order History', route: '/history'),
```

### Connect checkout to database persistence

Open `lib/screens/cart_screen.dart`. When the user taps **Checkout**, save the order into SQLite, clear the basket, and navigate to `/history`:

```dart
  Future<void> _placeOrder() async {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();
    if (items.isEmpty) {
      return;
    }

    final int nextTxNumber =
        await SandwichDatabase.instance.getNextTransactionNumber();
    final int totalItems = cart.getTotalItems();
    final String summary = '$totalItems items ordered';
    final DateTime now = DateTime.now();
    final String dateString = '${now.day}/${now.month}/${now.year}';

    final OrderTransaction tx = OrderTransaction(
      transactionNumber: nextTxNumber,
      summary: summary,
      date: dateString,
      totalPrice: cart.getTotalDue(),
    );

    await SandwichDatabase.instance.insertTransaction(tx);
    cart.clear();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/history');
    }
  }
```

### Commit your changes (4)

Stage and commit `order_history_screen.dart`, `cart_screen.dart`, and updated routes:

```bash
git add lib/screens/order_history_screen.dart lib/screens/cart_screen.dart lib/widgets/nav_drawer.dart lib/main.dart
git commit -m "Connect checkout to SQLite transaction persistence and add order history view"
```

## Persisting user settings in SQLite

Now let us update `lib/screens/settings_screen.dart` so that settings persist to the database.

### Add settings database operations

In `lib/database/sandwich_db.dart`, add methods to retrieve and update settings:

```dart
  Future<UserSettings> getSettings() async {
    final Database db = await database;
    final List<Map<String, dynamic>> records = await db.query(
      'settings',
      where: 'id = ?',
      whereArgs: [1],
    );
    if (records.isNotEmpty) {
      final Map<String, dynamic> row = records[0];
      return UserSettings(
        name: row['name'] as String,
        address: row['address'] as String,
        email: row['email'] as String,
        receiveNewsEmail: (row['receive_news'] as int) == 1,
      );
    }
    return const UserSettings(
      name: 'Student User',
      address: 'University of Portsmouth\nPortsmouth\nPO1 2UP',
      email: 'student@port.ac.uk',
      receiveNewsEmail: true,
    );
  }

  Future<int> updateSettings(UserSettings settings) async {
    final Database db = await database;
    final int rows = await db.update(
      'settings',
      <String, dynamic>{
        'name': settings.name,
        'address': settings.address,
        'email': settings.email,
        'receive_news': settings.receiveNewsEmail ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
    return rows;
  }
```

### Load and save settings from SQLite

Update `_SettingsScreenState` in `lib/screens/settings_screen.dart` to load saved settings in `initState` and persist updates on save:

```dart
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: _settings.address);
    _emailController = TextEditingController(text: _settings.email);
    _receiveNewsEmail = _settings.receiveNewsEmail;
    _loadSettingsFromDatabase();
  }

  Future<void> _loadSettingsFromDatabase() async {
    try {
      final UserSettings loaded =
          await SandwichDatabase.instance.getSettings();
      if (mounted) {
        setState(() {
          _settings = loaded;
          _addressController.text = loaded.address;
          _emailController.text = loaded.email;
          _receiveNewsEmail = loaded.receiveNewsEmail;
        });
      }
    } catch (_) {}
  }

  Future<void> _saveSettings() async {
    final UserSettings updated = _settings.copyWith(
      address: _addressController.text.trim(),
      email: _emailController.text.trim(),
      receiveNewsEmail: _receiveNewsEmail,
    );

    try {
      await SandwichDatabase.instance.updateSettings(updated);
    } catch (_) {}

    setState(() {
      _settings = updated;
      _isEditing = false;
    });
  }
```

### Commit your changes (5)

Stage and commit your settings persistence changes:

```bash
git add lib/database/sandwich_db.dart lib/screens/settings_screen.dart
git commit -m "Persist user settings and preferences in SQLite"
```

## Testing database operations

We test our database operations using SQLite's in-memory mode, ensuring that automated tests run quickly and independently without leaving temporary database files on disk.

### Set up in-memory database testing

In `setUpAll` of your test file, call `sqfliteFfiInit()` and set `databaseFactory = databaseFactoryFfi`.

In `setUp`, open an in-memory database with `databaseFactoryFfi.openDatabase(inMemoryDatabasePath, ...)` and pass it to `SandwichDatabase.instance.setDatabase(db)`.

### Test database transactions

Create a new file named `test/sandwich_db_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_transaction.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final Database db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS transactions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              transaction_number INTEGER NOT NULL,
              summary TEXT NOT NULL,
              date TEXT NOT NULL,
              total_price REAL NOT NULL
            )
          ''');
        },
      ),
    );
    SandwichDatabase.instance.setDatabase(db);
  });

  test('inserts and retrieves order transactions from SQLite', () async {
    final SandwichDatabase db = SandwichDatabase.instance;
    const OrderTransaction tx = OrderTransaction(
      transactionNumber: 1001,
      summary: '2x Footlong',
      date: '29/10/2026',
      totalPrice: 20.0,
    );

    await db.insertTransaction(tx);
    final List<OrderTransaction> records = await db.getAllTransactions();

    expect(records.length, 1);
    expect(records[0].transactionNumber, 1001);
    expect(records[0].summary, '2x Footlong');
    expect(records[0].totalPrice, 20.0);
  });
}
```

Run your test suite with `flutter test` to verify that all tests pass:

```bash
flutter test
```

### Commit your changes (6)

Stage and commit your database test file:

```bash
git add test/sandwich_db_test.dart
git commit -m "Add automated unit tests for SQLite database operations"
```

## Exercises

The exercises below apply the concepts from this worksheet to the Southsea Cinema coursework application. They prepare you for Demo 3 of your coursework. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Remember to commit your changes to Git after each exercise.

1. In your Southsea Cinema fork, add `sqflite_common_ffi` and `sqflite_common_ffi_web` to `pubspec.yaml`, matching [Add database dependencies](#add-database-dependencies).

2. Create `lib/database/cinema_db.dart` with a `CinemaDatabase` singleton. Create `transactions` and `settings` tables, following [Creating the database helper](#creating-the-database-helper). Seed default past transactions matching your cinema booking account history.

3. In `lib/models/ticket_transaction.dart`, create a `TicketTransaction` model containing `transactionNumber`, `saleSummary`, `saleDate`, and `totalPrice`, with `toMap` and `fromMap` methods.

4. Connect `BasketView` in `lib/views/basket_view.dart` so that clicking the purchase button creates a new `TicketTransaction`, inserts it into `CinemaDatabase.instance`, clears the basket, and navigates to the tickets page.

5. Build `MyTicketsView` in `lib/views/my_tickets_view.dart`, following [Building the order history screen](#building-the-order-history-screen). Query `CinemaDatabase.instance.getAllTransactions()` and display the tickets on clean cards without pop-up dialogues or horizontal dividers.

6. Update `SettingsView` in `lib/views/settings_view.dart` to persist address, email, patron number, and email preferences in the `settings` SQLite table.

7. Write automated tests for `TicketTransaction`, `CinemaDatabase`, `BasketView`, `MyTicketsView`, and `SettingsView`. Verify that all tests pass and `dart analyze` reports zero warnings. **Show your running application with live SQLite ticket persistence to a member of staff** for your Demo 3 sign-off.
