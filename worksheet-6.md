# Worksheet 6 — Local Persistence with SQLite

## Table of contents

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
  - [Initialise database tables](#initialise-database-tables)
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

Stage and commit `pubspec.yaml` and `pubspec.lock`.

## Creating the database helper

We manage database connections through a dedicated helper class named `SandwichDatabase`.

### Define the database singleton

Create a new file named `lib/database/sandwich_db.dart`. We build the helper in stages so each new piece is explained before the next appears.

Start with the imports and the singleton shell. This is the same singleton pattern you built for `CartRepository` in Worksheet 5: a private `._internal()` constructor and one `static final instance`:

```dart
import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/models/order_transaction.dart';
import 'package:sandwich_shop/models/user_settings.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SandwichDatabase {
  SandwichDatabase._internal();

  static final SandwichDatabase instance = SandwichDatabase._internal();
}
```

The two `sqflite_common_ffi` imports give us the database engine and the types we use below, such as `Database`, `DatabaseFactory`, and `OpenDatabaseOptions`. The `package:flutter/foundation.dart` import gives us `kIsWeb`, which we use in a moment.

Now add the field that caches the open connection, a method to set it (used by tests), and a getter that opens the database on first use:

```dart
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
```

`_database` is a nullable `Database?` that starts as `null`. A `Database` is the open connection the `sqflite` packages give us. The `database` getter is `async` and returns a `Future<Database>` (the asynchronous pattern from Worksheet 4): it returns the cached connection if one exists, otherwise it opens one with `_initDB`, caches it, and returns it. The `setDatabase` method lets our tests supply their own in-memory connection.

Now add the `_initDB` method that opens the connection. We take it in two parts. First, choose the right database engine for the platform:

```dart
  Future<Database> _initDB(String filePath) async {
    final DatabaseFactory dbFactory;
    if (kIsWeb) {
      dbFactory = databaseFactoryFfiWebNoWebWorker;
    } else {
      sqfliteFfiInit();
      dbFactory = databaseFactoryFfi;
    }
```

A `DatabaseFactory` is the object that opens databases. The right one depends on where the app runs. `kIsWeb` is a compile-time boolean that is `true` when the app runs in a web browser; when it is `true` we use `databaseFactoryFfiWebNoWebWorker`, the web engine from `sqflite_common_ffi_web`. Otherwise we call `sqfliteFfiInit()` once to prepare the desktop engine and use `databaseFactoryFfi` from `sqflite_common_ffi`. You do not need to memorise these names; just know they come from the two packages and provide the engine.

Now finish the method by choosing where the database lives and opening it:

```dart
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

`OpenDatabaseOptions` sets the schema version and the `onCreate` callback, which we point at `_createDB` (written next) so our tables are created the first time the database is made. The expression `const bool.fromEnvironment('FLUTTER_TEST')` is `true` while a `flutter test` run is in progress; when it is, we open `inMemoryDatabasePath`, a special path that keeps the database in memory so tests leave no file behind. Otherwise we open the real file. Finally `dbFactory.openDatabase(...)` opens the connection and returns it.

### Initialise database tables

Within the same `SandwichDatabase` class, define `_createDB`. The database engine calls this method once, through the `onCreate` callback we set above, the first time the database is created. We build it in stages.

Start the method and create the `transactions` table:

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
```

The `db.execute` method runs a raw SQL statement that does not return rows, which is exactly what we need to create a table. The SQL `CREATE TABLE IF NOT EXISTS transactions (...)` makes a table called `transactions` only if it does not already exist. Inside the brackets, each line names a column and its type: `INTEGER` for whole numbers, `TEXT` for strings, and `REAL` for decimal numbers. `PRIMARY KEY` marks the `id` column as the unique identifier for each row, and `AUTOINCREMENT` tells SQLite to fill it in automatically with the next number, so we never set it ourselves. `NOT NULL` means a column must always have a value. The triple-quoted string (`'''`) simply lets the SQL span several lines.

Next, still inside `_createDB`, create the `settings` table the same way:

```dart
    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        email TEXT NOT NULL,
        customer_id TEXT NOT NULL,
        receive_news INTEGER NOT NULL
      )
    ''');
```

SQLite has no dedicated boolean type, so the `receive_news` preference is stored as an `INTEGER` that holds `1` for true or `0` for false.

Now seed a short list of past orders so the history screen has something to show. Build the list of maps, then loop over it:

```dart
    // Seed a short list of past orders so the history screen has data to show
    final List<Map<String, dynamic>> seedOrders = <Map<String, dynamic>>[
      <String, dynamic>{
        'transaction_number': 1001,
        'summary': '2 items ordered',
        'date': '14/9/2026',
        'total_price': 16.50,
      },
      <String, dynamic>{
        'transaction_number': 1002,
        'summary': '1 item ordered',
        'date': '21/9/2026',
        'total_price': 6.00,
      },
      <String, dynamic>{
        'transaction_number': 1003,
        'summary': '3 items ordered',
        'date': '28/9/2026',
        'total_price': 24.00,
      },
    ];
    for (final Map<String, dynamic> order in seedOrders) {
      await db.insert('transactions', order);
    }
```

Each seed order is a `Map<String, dynamic>` (the map type from Worksheet 5) whose keys match the column names. The `db.insert` method adds one row to a named table from such a map: `db.insert('transactions', order)` inserts `order` into the `transactions` table. We use a `for-in` loop to insert each seed order in turn. Because `_createDB` runs only when the database is first created, this seeding happens once, so the order history screen has something to show the first time a student opens it. The coursework asks you to seed your own account history in the same way.

Finally, insert one default settings row so the settings screen always has something to load, then close the method:

```dart
    // Insert default user settings record
    await db.insert('settings', <String, dynamic>{
      'id': 1,
      'name': 'Student User',
      'address': 'University of Portsmouth\nPortsmouth\nPO1 2UP',
      'email': 'student@port.ac.uk',
      'customer_id': 'SS-1024',
      'receive_news': 1,
    });
  }
```

We give this row a fixed `id` of `1` so there is always exactly one settings record to read and update.

### Commit your changes (2)

Stage and commit `sandwich_db.dart`.

## Persisting and retrieving order transactions

Next, we define an order transaction data model to represent completed purchases saved to SQLite.

### Define the OrderTransaction model

Create a new file named `lib/models/order_transaction.dart`. Start with the fields and the `const` constructor:

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
}
```

The `id` field has the nullable type `int?` and is not `required`. That is because a transaction we have just built in memory does not have an `id` yet: SQLite assigns it when the row is inserted (through the `AUTOINCREMENT` column). So `id` is `null` before saving and holds a number after.

This model needs to convert to and from a database row, just as `Sandwich` converted to and from JSON in Worksheet 5. The database equivalent of `toJson`/`fromJson` is a pair named `toMap`/`fromMap`, which produce and read the `Map<String, dynamic>` of column names to values that the `db.*` methods expect. Add `toMap` first:

```dart
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
```

Each map key matches a column in the `transactions` table. We add the `id` entry only when `id` is not `null`, so a brand-new transaction leaves `id` out and lets SQLite fill it in.

Now add the `fromMap` constructor, which reads a row map back into an `OrderTransaction`. It is a `factory` constructor, the kind you met in Worksheet 5:

```dart
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

As in Worksheet 5, we read each value out of the map and use `as` to assert its type, reading the price as a `num` and calling `.toDouble()`. The `id` might be missing, so we check `idVal is int` and keep it only when it really is an integer.

### Insert completed orders

In `lib/database/sandwich_db.dart`, add a method that inserts one transaction:

```dart
  Future<int> insertTransaction(OrderTransaction tx) async {
    final Database db = await database;
    final int id = await db.insert('transactions', tx.toMap());
    return id;
  }
```

It opens the connection through the `database` getter, then calls `db.insert('transactions', tx.toMap())`, which inserts the row map from `toMap` and returns the new row's auto-generated `id`.

Now add a method that works out the next transaction number by reading the current highest one:

```dart
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

Here `db.rawQuery` runs a SQL query that returns rows, giving us back a `List<Map<String, dynamic>>` where each map is one row. The SQL `SELECT MAX(transaction_number) as max_num FROM transactions` asks SQLite for the largest `transaction_number` and labels that result `max_num`. If a value comes back we add one to it; if the table is empty we start at `1001`.

### Query order history

Add a method that reads every transaction, newest first:

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

The `db.query` method reads rows from a named table and is simpler than writing raw SQL for everyday reads. The `orderBy: 'transaction_number DESC'` argument sorts the rows by transaction number in descending order (`DESC`), so the newest order comes first. We then loop over the row maps with a `for-in` loop, turning each into an `OrderTransaction` with `fromMap`.

### Commit your changes (3)

Stage and commit `order_transaction.dart` and `sandwich_db.dart`.

## Building the order history screen

Now let us build an `OrderHistoryScreen` to display past orders stored in the SQLite database.

### Create the OrderHistoryScreen widget

Create a new file named `lib/screens/order_history_screen.dart`. We build it in stages.

Start with the imports, the `StatefulWidget` shell, and the one piece of state, a list of orders:

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
}
```

Now add `initState` (from Worksheet 5) to kick off loading as soon as the screen appears, and the asynchronous loader it calls:

```dart
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
```

Reading from a database can fail, so the loader wraps its work in a `try`/`catch`. The code inside `try { ... }` runs normally, but if it throws an error, execution jumps to the `catch` block instead of crashing the app. Here `catch (_) {}` catches any error and ignores it (the underscore means we do not need the error object), leaving the list empty.

The `if (mounted)` check is also new. After an `await`, time has passed and the user may have left this screen, which disposes its `State`. Calling `setState` on a disposed `State` is an error, so we first check `mounted`, which is `true` only while the `State` is still part of the screen. We only call `setState` when it is safe.

Next, add the empty-state helper, shown when there are no orders:

```dart
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
```

Now add the method that builds one `Card` per order. It uses the same procedural `List<Widget>` and `for-in` loop pattern from Worksheet 5:

```dart
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
```

Finally, add the `build` method. It chooses between the empty state and the list, then puts the result in the scrollable scaffold:

```dart
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
        title: const Text(appTitle, style: shopHeaderStyle),
        backgroundColor: shopBrand,
        foregroundColor: shopWhite,
        elevation: 0,
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

The method reads the next transaction number, then builds the receipt date from `DateTime.now()`, which returns the current date and time. Its `.day`, `.month`, and `.year` properties give the parts we format into a short date string. After saving the transaction and clearing the basket, it checks `mounted` before navigating, for the same reason as the loader above, then uses `pushReplacementNamed` (from Worksheet 5) to move to the history screen.

Your order history screen, showing the seeded orders and any you place, should look like this:

<!-- TODO screenshot: images/6/order_history_screen.png — show the OrderHistoryScreen listing past orders as cards with order number, summary, date, and total paid -->

### Commit your changes (4)

Stage and commit `order_history_screen.dart`, `cart_screen.dart`, and your updated routes.

## Persisting user settings in SQLite

Now let us update `lib/screens/settings_screen.dart` so that settings persist to the database.

### Add settings database operations

In `lib/database/sandwich_db.dart`, add a method to read the single settings row:

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
        customerId: row['customer_id'] as String,
        receiveNewsEmail: (row['receive_news'] as int) == 1,
      );
    }
    return const UserSettings(
      name: 'Student User',
      address: 'University of Portsmouth\nPortsmouth\nPO1 2UP',
      email: 'student@port.ac.uk',
      customerId: 'SS-1024',
      receiveNewsEmail: true,
    );
  }
```

This uses `db.query` with two new arguments. The `where: 'id = ?'` argument is a filter: the `?` is a placeholder, and `whereArgs: [1]` supplies the value that fills it, so together they read only the row whose `id` is `1`. Using a placeholder rather than building the string yourself is the safe way to pass values into SQL. If a row comes back we rebuild a `UserSettings` from its columns, remembering that `receive_news` is stored as `1` or `0`; if the table is somehow empty we return a sensible default.

Now add the method that saves changes back:

```dart
  Future<int> updateSettings(UserSettings settings) async {
    final Database db = await database;
    final int rows = await db.update(
      'settings',
      <String, dynamic>{
        'name': settings.name,
        'address': settings.address,
        'email': settings.email,
        'customer_id': settings.customerId,
        'receive_news': settings.receiveNewsEmail ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
    return rows;
  }
```

The `db.update` method changes existing rows: it takes the table name, a map of the new column values, and the same `where`/`whereArgs` filter so it updates only row `1`. It returns how many rows were changed.

### Load and save settings from SQLite

We change `_SettingsScreenState` in `lib/screens/settings_screen.dart` so it loads saved settings when it opens and persists them on save. We make three changes in turn.

First, add one line to the existing `initState` so it starts loading from the database after creating the controllers:

```dart
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: _settings.address);
    _emailController = TextEditingController(text: _settings.email);
    _customerIdController = TextEditingController(text: _settings.customerId);
    _receiveNewsEmail = _settings.receiveNewsEmail;
    _loadSettingsFromDatabase();
  }
```

Next, add the loader it calls. It follows the same `try`/`catch` and `mounted` pattern as the history screen, reading the saved settings and copying them into the controllers:

```dart
  Future<void> _loadSettingsFromDatabase() async {
    try {
      final UserSettings loaded =
          await SandwichDatabase.instance.getSettings();
      if (mounted) {
        setState(() {
          _settings = loaded;
          _addressController.text = loaded.address;
          _emailController.text = loaded.email;
          _customerIdController.text = loaded.customerId;
          _receiveNewsEmail = loaded.receiveNewsEmail;
        });
      }
    } catch (_) {}
  }
```

Finally, replace the Worksheet 5 `_saveSettings` method with an `async` version that writes the change to the database before leaving edit mode:

```dart
  Future<void> _saveSettings() async {
    final UserSettings updated = _settings.copyWith(
      address: _addressController.text.trim(),
      email: _emailController.text.trim(),
      customerId: _customerIdController.text.trim(),
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

It builds the updated settings with `copyWith` (from Worksheet 5), saves them with `updateSettings` inside a `try`/`catch`, then calls `setState` to store the new values and leave edit mode.

### Commit your changes (5)

Stage and commit your settings persistence changes.

## Testing database operations

We test our database operations using SQLite's in-memory mode, ensuring that automated tests run quickly and independently without leaving temporary database files on disk.

### Set up in-memory database testing

We use two setup functions here. `setUpAll` runs its callback once, before all the tests in the file, which suits one-off initialisation. That contrasts with `setUp` from Worksheet 5, which runs before each test. In `setUpAll` we call `sqfliteFfiInit()` and set `databaseFactory = databaseFactoryFfi` once to prepare the engine.

In `setUp`, which runs before every test, open a fresh in-memory database with `databaseFactoryFfi.openDatabase(inMemoryDatabasePath, ...)` and pass it to `SandwichDatabase.instance.setDatabase(db)`, so each test starts from a clean database.

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

Stage and commit your database test file.

## Exercises

The exercises below apply the concepts from this worksheet to the Southsea Cinema coursework application. They prepare you for Demo 3 of your coursework. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Remember to commit your changes to Git after each exercise.

1. In your Southsea Cinema fork, add `sqflite_common_ffi` and `sqflite_common_ffi_web` to the `dependencies:` section of `pubspec.yaml`, matching [Add database dependencies](#add-database-dependencies), and run `flutter pub get`.

2. Create `lib/database/cinema_db.dart` with a `CinemaDatabase` singleton that opens the database and creates `transactions` and `settings` tables, following [Creating the database helper](#creating-the-database-helper). Seed a short list of past transactions matching your own cinema booking account history, as shown in [Initialise database tables](#initialise-database-tables).

3. Add a `TicketTransaction` model in `lib/models/ticket_transaction.dart` with `toMap` and `fromMap` methods, mirroring the `OrderTransaction` model. Decide which fields a cinema ticket sale needs to record.

4. Connect your basket so that confirming a purchase saves a `TicketTransaction` to `CinemaDatabase.instance`, clears the basket, and takes the patron to their tickets page, following [Connect checkout to database persistence](#connect-checkout-to-database-persistence).

5. Build a My Tickets view that reads the stored transactions and presents each past booking. Choose how to lay out a booking so it reads cleanly, drawing on [Building the order history screen](#building-the-order-history-screen).

6. Make the patron's settings survive a restart by saving and loading them from the `settings` table. Decide which details to persist and keep the display and edit modes working.

7. Decide what matters most about your Demo 3 experience and prove it works: cover the behaviour you care about with automated tests, and make sure `dart analyze` and `flutter test` both pass cleanly. **Show your running application with live SQLite ticket persistence to a member of staff** for your Demo 3 sign-off.
