# Worksheet 7 — SQLite and order history

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Clone the Sandwich Shop repository](#clone-the-sandwich-shop-repository)
  - [Switch to branch 6](#switch-to-branch-6)
- [Choosing a database for completed orders](#choosing-a-database-for-completed-orders)
- [Preparing an Android emulator](#preparing-an-android-emulator)
  - [Install the Android bundle on university computers](#install-the-android-bundle-on-university-computers)
  - [Set up an emulator on your own computer](#set-up-an-emulator-on-your-own-computer)
  - [Select the emulator and run the app](#select-the-emulator-and-run-the-app)
- [Adding the SQLite packages](#adding-the-sqlite-packages)
  - [Stop the app running in a browser](#stop-the-app-running-in-a-browser)
- [Representing a saved order](#representing-a-saved-order)
  - [Create the order record and its constructor](#create-the-order-record-and-its-constructor)
  - [Convert an order into a database row](#convert-an-order-into-a-database-row)
  - [Convert a database row into an order](#convert-a-database-row-into-an-order)
- [Creating the SQLite database helper](#creating-the-sqlite-database-helper)
  - [Create one shared database helper](#create-one-shared-database-helper)
  - [Open the database in the app folder](#open-the-database-in-the-app-folder)
  - [Create the orders table](#create-the-orders-table)
  - [Seed past orders only when creating the database](#seed-past-orders-only-when-creating-the-database)
  - [Insert an order and read saved orders](#insert-an-order-and-read-saved-orders)
  - [Find the next order number and close the connection](#find-the-next-order-number-and-close-the-connection)
- [Displaying saved orders](#displaying-saved-orders)
  - [Create the orders screen and its state](#create-the-orders-screen-and-its-state)
  - [Load orders and report a database error](#load-orders-and-report-a-database-error)
  - [Build the options line for an order](#build-the-options-line-for-an-order)
  - [Build an order card in stages](#build-an-order-card-in-stages)
  - [Choose the loading, error, empty or list body](#choose-the-loading-error-empty-or-list-body)
  - [Register the orders route and add navigation buttons](#register-the-orders-route-and-add-navigation-buttons)
- [Saving the basket at checkout](#saving-the-basket-at-checkout)
  - [Build the order summary and date](#build-the-order-summary-and-date)
  - [Save the order before clearing the basket](#save-the-order-before-clearing-the-basket)
  - [Connect the checkout button and verify a restart](#connect-the-checkout-button-and-verify-a-restart)
  - [Inspect the database on the emulator](#inspect-the-database-on-the-emulator)
- [Testing SQLite without an emulator](#testing-sqlite-without-an-emulator)
  - [Prepare a fresh database for each test](#prepare-a-fresh-database-for-each-test)
  - [Test inserting, reading and numbering orders](#test-inserting-reading-and-numbering-orders)
  - [Test order map conversion](#test-order-map-conversion)
  - [Update the basket checkout test](#update-the-basket-checkout-test)
  - [Test the orders list and its empty state](#test-the-orders-list-and-its-empty-state)
  - [Test supported platforms and run the complete suite](#test-supported-platforms-and-run-the-complete-suite)
- [Organising tests and inspecting coverage](#organising-tests-and-inspecting-coverage)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

This worksheet is a draft for Demo 4. Continue with the Sandwich Shop application you completed in [Worksheet 6](worksheet-6.md). Keep its JSON catalogue, saved profile preferences, basket and existing navigation. We now save completed purchases in a database; the basket stays in memory until checkout.

### Clone the Sandwich Shop repository

If you need a fresh copy, clone the [Sandwich Shop repository](https://github.com/manighahrmani/sandwich_shop) into a folder that is not synchronised to cloud storage, such as your `Downloads` folder:

```bash
cd ~/Downloads
git clone https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
```

Open the folder in VS Code with **File > Open Folder**.

### Switch to branch 6

Do not switch branches over unfinished work. Select the Worksheet 6 end state and check the existing tests:

```bash
git checkout 6
flutter pub get
flutter test
```

Branch `7` contains the draft completed Sandwich Shop application for this worksheet. Use it to compare your work, not as your starting point.

## Choosing a database for completed orders

JSON assets supply the catalogue and shared preferences remembers profile settings. Neither is a suitable store for a growing purchase history. SQLite stores completed orders as rows in a table on the device, without a separate database server.

A table has named columns. Each row holds one order, and its primary key identifies that row. We create the table with `CREATE TABLE`, insert purchases with `insert` and read them with `query`; these helper methods build SQL `INSERT` and `SELECT` statements. Read the [Flutter SQLite recipe](https://docs.flutter.dev/cookbook/persistence/sqlite) alongside this example.

We record completed purchases rather than edit or delete purchase history. Updating and deleting records are not required for this checkout flow. No Provider package, notifier or new state-management layer is needed.

## Preparing an Android emulator

For this worksheet, run the app on an Android emulator, not Edge, Chrome or Windows desktop. An emulator is a virtual Android device running on your computer. The standard `sqflite` plugin works on Android without a separate database server or browser database setup.

Automated tests will use an in-memory database and do not need an emulator. Prepare your emulator now, before adding database code.

### Install the Android bundle on university computers

The browser-only bundle from [Worksheet 1](worksheet-1.md#b---using-the-university-machines-on-campus) does not include the Android tools. Use the [Android emulator release of the portable bundle](https://github.com/manighahrmani/flutter_vscode_package#android-emulator-setup-worksheet-6-onwards) instead. Open PowerShell and run its installer:

```powershell
irm https://raw.githubusercontent.com/manighahrmani/flutter_vscode_package/main/install-android-beta.ps1 | iex
```

This is the Android bundle release, not a request to build your Flutter app in release mode. It installs a JDK, the Android SDK and a virtual device named `flutter_emulator`, then opens VS Code on your project. The download is several gigabytes and takes longer than the original bundle. Let the installer finish; the university machines provide the hardware acceleration the emulator needs.

In the new VS Code terminal, from your project folder, launch the virtual device:

```bash
flutter emulators --launch flutter_emulator
```

Wait for the Android home screen before continuing.

### Set up an emulator on your own computer

If Flutter is already installed on your own Windows, macOS or Linux computer, follow the [Flutter Android setup guide](https://docs.flutter.dev/platform-integration/android/setup). Install Android Studio and its Android SDK tools, then create a virtual device in **Device Manager** using a system image suitable for your computer.

Check the toolchain and accept the SDK licences:

```bash
flutter doctor
flutter doctor --android-licenses
```

Start the device from **Device Manager**, or run `flutter emulators` and then `flutter emulators --launch` followed by the listed emulator name. You only need this setup or the university bundle, not both.

### Select the emulator and run the app

Use the [device selector introduced in Worksheet 1](worksheet-1.md#selecting-a-target-device) to choose the booted Android emulator.

Alternatively, list the devices and run on the emulator:

```bash
flutter devices
flutter run -d emulator-5554
```

Replace `emulator-5554` with the actual id reported by `flutter devices`. The first build downloads Android build dependencies and can take several minutes. If it fails, read the reported error and check `flutter doctor`; do not assume every warning or failure is harmless.

The app should appear inside the emulator.

## Adding the SQLite packages

From the project root, add the mobile database packages and the separate test dependency:

```bash
flutter pub add sqflite path
flutter pub add --dev sqflite_common_ffi
```

`sqflite` opens SQLite on Android. `path` provides `join` to build a file path, and `sqflite_common_ffi` supplies SQLite for tests on your computer, not the mobile app. Keep the `shared_preferences` dependency from Worksheet 6.

We do not need web database packages or WebAssembly files. Run the app on your emulator. After adding plugins, stop and restart the app rather than only hot reloading.

### Stop the app running in a browser

`sqflite` does not work in a browser or on Windows or Linux desktop. Remove the `web`, `windows` and `linux` folders from your project so these targets are no longer offered. Flutter can still build a web version without the `web` folder, so we also check the platform when the app starts.

Open `lib/main.dart` and add this import above the existing Material import:

```dart
import 'package:flutter/foundation.dart';
```

`kIsWeb` is `true` when the app is compiled for a browser, and `defaultTargetPlatform` tells us which operating system the app runs on. Replace the `main` function with:

```dart
// SQLite (sqflite) only works on Android, iOS and macOS, not in a browser.
bool isSupportedPlatform() {
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return true;
  }
  if (defaultTargetPlatform == TargetPlatform.macOS) {
    return true;
  }
  return false;
}

void main() {
  if (isSupportedPlatform()) {
    runApp(const App());
  } else {
    runApp(const UnsupportedPlatformApp());
  }
}
```

At the end of the file, add the small app shown on unsupported platforms:

```dart
class UnsupportedPlatformApp extends StatelessWidget {
  const UnsupportedPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'This app saves orders with SQLite, which does not work in a '
              'web browser or on Windows or Linux desktop. Stop the app and '
              'run it on an Android emulator instead.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
```

From now on, select your Android emulator before running the app, as described in [Preparing an Android emulator](#preparing-an-android-emulator).

## Representing a saved order

SQLite is a local database engine: it stores tables in a file without a separate server. A table contains rows, and each row has named columns. Our `orders` table will store one completed basket per row.

### Create the order record and its constructor

Create `lib/models/order_record.dart` with `class OrderRecord {}`. Use the [model-building pattern from Worksheet 3](worksheet-3.md#define-the-sandwich-data-model). Inside its braces, declare:

```dart
  final int? id;
  final int orderNumber;
  final String summary;
  final String note;
  final int toasted;
  final int vegan;
  final double total;
  final String date;
```

`id` is absent before insertion; SQLite assigns it when saving the row. The `note`, `toasted` and `vegan` fields describe the sample order history. SQLite does not accept Dart `bool` values, so we store `1` for true and `0` for false, as explained in the [sqflite supported types](https://pub.dev/packages/sqflite#supported-sqlite-types).

Add the constructor:

```dart
  const OrderRecord({
    this.id,
    required this.orderNumber,
    required this.summary,
    this.note = '',
    this.toasted = 0,
    this.vegan = 0,
    required this.total,
    required this.date,
  });
```

The optional fields have defaults so checkout can record a basket without inventing sandwich options. `CartItem` still contains only a sandwich and quantity; do not add option controls or change that model.

### Convert an order into a database row

A `Map<String, Object?>` pairs string keys with values: each key is a column name, and each value is the data for that column. `Object?` allows any Dart value, including `null`; here we only use SQLite-supported values. Inside `OrderRecord`, add an empty `Map<String, Object?> toMap() {}` method.

Inside the method, build the row:

```dart
    final Map<String, Object?> data = <String, Object?>{
      'order_number': orderNumber,
      'summary': summary,
      'note': note,
      'toasted': toasted,
      'vegan': vegan,
      'total': total,
      'date': date,
    };
```

After the map, add the id only if it exists, then return the row:

```dart
    if (id != null) {
      data['id'] = id;
    }
    return data;
```

The keys are column names, not necessarily Dart field names. Leaving out a new order's id lets SQLite generate it.

### Convert a database row into an order

Add `factory OrderRecord.fromMap(Map<String, Object?> map) {}`. Inside it, read the values using the same conversion pattern as [the sandwich JSON constructor](worksheet-6.md#convert-a-json-map-into-a-sandwich). A map lookup returns `Object?`; `as int` tells Dart that this value must be an integer, and fails if it is not. We know the types because our table defines them:

```dart
    final int orderNumber = map['order_number'] as int;
    final String summary = map['summary'] as String;
    final String note = map['note'] as String;
    final int toasted = map['toasted'] as int;
    final int vegan = map['vegan'] as int;
    final num totalNumber = map['total'] as num;
    final double total = totalNumber.toDouble();
    final String date = map['date'] as String;
```

Return the record:

```dart
    return OrderRecord(
      id: map['id'] as int?,
      orderNumber: orderNumber,
      summary: summary,
      note: note,
      toasted: toasted,
      vegan: vegan,
      total: total,
      date: date,
    );
```

## Creating the SQLite database helper

We keep database operations in `lib/database/sandwich_db.dart`, following the [SQLite cookbook recipe](https://docs.flutter.dev/cookbook/persistence/sqlite). Screens call this helper instead of repeating SQL.

### Create one shared database helper

Create the file with these imports and an empty class:

```dart
import 'package:path/path.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite/sqflite.dart';

class SandwichDatabase {}
```

Inside the class, reuse the [singleton pattern from Worksheet 5](worksheet-5.md#create-the-cart-repository-singleton). A singleton gives the screens one shared helper, just as `CartRepository.instance` gives them one shared basket. `_internal` is a private named constructor, so other files cannot create their own helper:

```dart
  SandwichDatabase._internal();

  static final SandwichDatabase instance = SandwichDatabase._internal();

  static Database? _database;
```

`static` means a field belongs to the class rather than an individual object. The `static final instance` field creates the shared helper once; `_database` holds its connection and starts as `null`. `Database` represents an open SQLite connection. Add a method that lets tests supply their own connection:

```dart
  void setDatabase(Database? db) {
    _database = db;
  }
```

As a reminder from Worksheet 6, a `Future<T>` represents a result that arrives later, `async` lets a method use `await`, and `await` waits for that result without blocking the interface. Here `T` is `Database`. A getter is read like a property, so callers use `await database` rather than `await database()`. Add the asynchronous getter:

```dart
  Future<Database> get database async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      return cachedDatabase;
    }
    final Database db = await _initDB('sandwich_data.db');
    _database = db;
    return db;
  }
```

This reuses the connection after the first call. Checking the local `cachedDatabase` for `null` lets Dart treat it as a non-null `Database` inside the `if` block.

### Open the database in the app folder

`getDatabasesPath` finds the app's writable database folder. `join` from the `path` package combines that folder with a file name using the operating system's path separator. `openDatabase` opens the file, creating it if necessary. Inside `SandwichDatabase`, add `_initDB`:

```dart
  Future<Database> _initDB(String fileName) async {
    final String folder = await getDatabasesPath();
    final String filePath = join(folder, fileName);
    final Database db = await openDatabase(
      filePath,
      version: 1,
      onCreate: _createDB,
    );
    return db;
  }
```

`version` identifies the table structure. `onCreate` receives a callback, `_createDB`, which runs only when the database is first created.

We define `_createDB` below. There is no platform switch here: the app uses the Android plugin, and tests supply their own connection through `setDatabase`.

### Create the orders table

Add an empty `Future<void> createTables(Database db, int version) async {}` method. We give it a public name so tests can create the exact same table without duplicating SQL.

SQL is the language used to define and query database tables. `CREATE TABLE` defines the columns of a new table; `IF NOT EXISTS` leaves an existing table alone. Inside the method, use `execute` to run this statement:

```dart
    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        note TEXT NOT NULL,
        toasted INTEGER NOT NULL,
        vegan INTEGER NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
```

`execute` runs the statement without returning rows. `INTEGER`, `TEXT` and `REAL` store whole numbers, strings and decimal numbers. `PRIMARY KEY` uniquely identifies a row; `AUTOINCREMENT` assigns ids without reusing earlier automatically generated ids. `NOT NULL` requires a value.

The triple quotes let a Dart string span several lines. Each column matches a key in `OrderRecord.toMap`. See [creating a table in the SQLite recipe](https://docs.flutter.dev/cookbook/persistence/sqlite#4-create-the-dogs-table).

### Seed past orders only when creating the database

Add `_createDB`:

```dart
  Future<void> _createDB(Database db, int version) async {
    await createTables(db, version);
  }
```

After the table call, insert the first sample order:

```dart
    await db.insert('orders', <String, Object?>{
      'order_number': 1003,
      'summary': '2 x Footlong Sub',
      'note': 'Extra napkins please',
      'toasted': 1,
      'vegan': 0,
      'total': 15.00,
      'date': '18 Apr 2026 12:45',
    });
```

`insert` builds an SQL `INSERT` statement, which adds a row using the map's column names. Add a second sample after it:

```dart
    await db.insert('orders', <String, Object?>{
      'order_number': 1002,
      'summary': '1 x Six-Inch Sub',
      'note': '',
      'toasted': 0,
      'vegan': 1,
      'total': 4.50,
      'date': '2 Mar 2026 18:10',
    });
```

Then add the third:

```dart
    await db.insert('orders', <String, Object?>{
      'order_number': 1001,
      'summary': '3 x Footlong Sub',
      'note': 'No onions',
      'toasted': 1,
      'vegan': 0,
      'total': 22.50,
      'date': '11 Jan 2026 13:02',
    });
```

These are seed data: example rows added once to populate a new database. Reopening the app does not add them again. Tests call `createTables` directly when they need an empty table.

Changing this SQL or the seed values does not change an existing database. During development, clearing the emulator app's storage or uninstalling it creates a fresh start, but also deletes saved orders and preferences. Real updates need a schema migration rather than deleting user data.

### Insert an order and read saved orders

Add the insert method:

```dart
  Future<int> insertOrder(OrderRecord order) async {
    final Database db = await database;
    final int id = await db.insert('orders', order.toMap());
    return id;
  }
```

`insert` returns the generated row id. Add the outline of the read method:

```dart
  Future<List<OrderRecord>> getAllOrders() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.query(
      'orders',
      orderBy: 'order_number DESC',
    );
  }
```

`query` builds an SQL `SELECT` statement to retrieve rows. Its `orderBy` argument supplies SQL `ORDER BY`, which sorts the result. `DESC` means descending order, so the highest order number appears first. We sort by number, not the displayed date string.

After the query, convert the rows and return the list:

```dart
    final List<OrderRecord> orders = [];
    for (final Map<String, Object?> row in records) {
      orders.add(OrderRecord.fromMap(row));
    }
    return orders;
```

### Find the next order number and close the connection

`rawQuery` runs an SQL `SELECT` statement that you write yourself. `MAX` finds the largest value in a column, and `as max_num` gives the result a column name. Start with the method and its query:

```dart
  Future<int> getNextOrderNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(order_number) as max_num FROM orders',
    );
  }
```

After the query, handle an empty result or a `null` maximum:

```dart
    if (records.isEmpty) {
      return 1001;
    }
    final Object? maxValue = records[0]['max_num'];
    if (maxValue == null) {
      return 1001;
    }
```

`MAX` returns `null` when the table has no orders. Otherwise, convert the value once and add one:

```dart
    final int currentMax = maxValue as int;
    return currentMax + 1;
```

An empty table starts at `1001`; a new app with our seed data starts at `1004`. This numbering is for our single-user teaching app, not a multi-user payment system.

Finally, add a method to close an existing connection and reset the field:

```dart
  Future<void> close() async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      await cachedDatabase.close();
      _database = null;
    }
  }
```

Tests close the connection after each test so no data leaks into the next one.

## Displaying saved orders

Build and register the destination screen before making checkout navigate to it.

### Create the orders screen and its state

Create `lib/screens/orders_screen.dart` with these imports:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
```

Create the widget using the [stateful structure from Worksheet 2](worksheet-2.md#define-the-orderscreen-stateful-widget):

```dart
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() {
    return _OrdersScreenState();
  }
}
```

Below it, create the state class with a temporary body:

```dart
class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderRecord> _orders = [];
  bool _loading = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

### Load orders and report a database error

Inside the state class, add `initState`:

```dart
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }
```

`try` contains work that might fail; `catch (error)` runs if that work throws an error. Following [the menu loader from Worksheet 6](worksheet-6.md#load-the-menu-when-the-screen-opens), add `Future<void> _loadOrders() async {}` with empty `try` and `catch (error)` blocks. `mounted` tells us whether this state still belongs to a widget on screen. After an `await`, check it before calling `setState`, because the user might have left the screen. Inside `try`, add:

```dart
      final List<OrderRecord> orders =
          await SandwichDatabase.instance.getAllOrders();
      if (!mounted) {
        return;
      }
      setState(() {
        _orders = orders;
        _loading = false;
      });
```

Inside `catch`, add:

```dart
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Could not load orders: $error';
        _loading = false;
      });
```

This uses the same asynchronous loading pattern once again, rather than introducing another widget or state-management approach.

### Build the options line for an order

Add `Widget _buildOptionsText(OrderRecord order) {}` inside the state class. In its braces, collect the applicable options:

```dart
    final List<String> parts = [];
    if (order.toasted == 1) {
      parts.add('Toasted');
    }
    if (order.vegan == 1) {
      parts.add('Vegan');
    }
    if (order.note.isNotEmpty) {
      parts.add('Note: ${order.note}');
    }
```

After those checks, choose the output:

```dart
    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        parts.join(' • '),
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
```

`join` combines the list of strings with the given separator. `SizedBox.shrink` is a zero-sized box, so orders without options do not show an extra line. These fields display the seeded history; newly checked-out baskets use their default values.

### Build an order card in stages

Add this helper:

```dart
  Widget _buildOrderCard(OrderRecord order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
```

The layout reuses the [card, padding and column from Worksheet 3](worksheet-3.md#lay-out-the-image-and-text). Inside the empty `children` list, add a row for the number and total:

```dart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('£${order.total.toStringAsFixed(2)}'),
              ],
            ),
```

After the row, add the summary, options and date:

```dart
            const SizedBox(height: 4),
            Text(order.summary),
            _buildOptionsText(order),
            const SizedBox(height: 4),
            Text(
              order.date,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
```

### Choose the loading, error, empty or list body

Replace the `Placeholder` return in `build`. First declare `body` and choose the first three states:

```dart
    final Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      body = Center(child: Text(_errorMessage));
    } else if (_orders.isEmpty) {
      body = const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            'No orders yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }
```

Immediately after that last closing brace, add the populated state:

```dart
    else {
      body = ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildOrderCard(_orders[index]);
        },
      );
    }
```

After the conditional, return the screen:

```dart
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton()],
      ),
      body: body,
    );
```

### Register the orders route and add navigation buttons

In `lib/main.dart`, import `orders_screen.dart` and add this entry to the existing `routes` map, following [named routes in Worksheet 5](worksheet-5.md#register-named-routes):

```dart
        '/orders': (BuildContext context) {
          return const OrdersScreen();
        },
```

Create `lib/widgets/orders_button.dart` by copying the completed [BasketButton from Worksheet 5](worksheet-5.md#create-the-basket-button). Rename the class and constructor to `OrdersButton`, replace `Icons.shopping_basket` with `Icons.receipt_long`, and replace both occurrences of `'/basket'` with `'/orders'`.

Keep the existing route-name check so pressing the receipt icon while already on orders does not push a second orders screen. No new navigation mechanism is needed.

`Navigator.pushNamed` opens the screen registered under a route name, just as it does for the basket in Worksheet 5. Import `orders_button.dart` into the order, basket and orders screens. In those three app bars, use:

```dart
        actions: const [OrdersButton(), BasketButton()],
```

Leave the menu and settings screens unchanged from Worksheet 6. On the emulator, open the basket from the menu, then select the receipt icon. You should see orders `1003`, `1002` and `1001`, in that order, with their summaries, totals, options and dates.

## Saving the basket at checkout

The [Worksheet 5 basket](worksheet-5.md#building-the-basket-screen) already calculates totals and clears its contents at checkout. We now save the order first, and only clear the basket if insertion succeeds.

### Build the order summary and date

In `lib/screens/basket_screen.dart`, add these imports:

```dart
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
```

Inside `_BasketScreenState`, add:

```dart
  String _buildSummary(List<CartItem> items) {
    final List<String> parts = [];
    for (final CartItem item in items) {
      parts.add('${item.quantity} x ${item.sandwich.name}');
    }
    return parts.join(', ');
  }
```

The list method `join` combines strings with a separator to create a summary such as `2 x Footlong Sub, 1 x Six-Inch Sub`. This is different from the file-path function imported in the database helper. Add a helper for the display date:

```dart
  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/${now.year} $hour:$minute';
  }
```

[`DateTime`](https://api.dart.dev/dart-core/DateTime-class.html) provides the date and time parts. `padLeft(2, '0')` gives each part two digits, so five minutes past nine displays as `09:05`. This string is for display; order numbers determine list order.

### Save the order before clearing the basket

Keep the existing `_confirmationMessage` field. Add this checkout method shell inside `_BasketScreenState`:

```dart
  Future<void> _checkout(CartRepository cart, List<CartItem> items) async {
    final String summary = _buildSummary(items);
    final double total = cart.getTotalDue();
    final String date = _formatDate(DateTime.now());

    try {
    } catch (error) {
    }
  }
```

`DateTime.now()` gives the current local date and time. We prepare the summary, total and display date before starting the database work.

Inside `try`, obtain a number and create the record:

```dart
      final SandwichDatabase database = SandwichDatabase.instance;
      final int orderNumber = await database.getNextOrderNumber();
      final OrderRecord record = OrderRecord(
        orderNumber: orderNumber,
        summary: summary,
        total: total,
        date: date,
      );
```

After creating the record, save it before calling the existing `CartRepository.clear` method:

```dart
      await database.insertOrder(record);
      cart.clear();
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Order $orderNumber saved';
      });
      Navigator.pushNamed(context, '/orders');
```

Inside `catch`, report the failure:

```dart
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Could not save your order: $error';
      });
```

If insertion fails, the cart is not cleared and no success navigation occurs. Never use an empty `catch` around a database write.

### Connect the checkout button and verify a restart

Keep `PrimaryButton` unchanged from Worksheet 6: its `onPressed` is a non-nullable `VoidCallback`. In `_buildBasketList`, replace the checkout callback with:

```dart
          onPressed: () {
            _checkout(cart, items);
          },
```

The callback starts `_checkout`; that method handles its own asynchronous work and errors. Keep the delete button's existing callback:

```dart
            onPressed: () {
              setState(() {
                cart.removeItem(index);
              });
            },
```

Keep the existing confirmation field, feedback widgets, empty-basket handling and app bar. Do not replace the whole basket screen.

On the emulator, save fictional profile details, add a sandwich and check out. Confirm the new order appears above the seeded history. Fully stop and reopen the app without uninstalling it or clearing its storage. Both the profile values and completed order should still be present.

Reopening the app must not duplicate the three seed orders. The basket itself is still in memory; only completed orders and the saved profile persist.

### Inspect the database on the emulator

This optional check opens a copy of the actual SQLite file. Stop the app's debug run first so there are no writes in progress, but leave the emulator running.

For the supplied Android project, the debug package is `com.example.sandwich_shop`. Copy the database to a temporary location on the emulator, then pull the copy into your project folder:

```bash
adb shell "run-as com.example.sandwich_shop cat databases/sandwich_data.db > /data/local/tmp/s.db"
adb pull /data/local/tmp/s.db sandwich_shop.db
```

`adb` communicates with the Android device. `run-as` reads the debug app's private files, and `pull` copies a file to your computer. If you changed the Android application id, use that id instead.

Open `sandwich_shop.db` in VS Code using the bundle's **SQLite Viewer** extension. Select the `orders` table and check that it contains the three seed rows and your saved order.

This is a snapshot, not a live connection. Remove the copied file after inspection; it is runtime data, not an application asset.

## Testing SQLite without an emulator

The [sqflite FFI package](https://pub.dev/packages/sqflite_common_ffi) runs SQLite directly on the test computer. FFI means foreign function interface: Dart calls a native library. We use it only in tests, with a fresh in-memory database rather than the user's file.

Organise the tests before adding new ones. Move the existing model tests into `test/models/`, repository tests into `test/repositories/`, and screen tests into `test/screens/`. Keep the button test under `test/widgets/`. Rename `sandwich_model_test.dart` to `sandwich_test.dart` so it matches `lib/models/sandwich.dart`.

Rename `test/widget_test.dart` to `test/main_test.dart` for the app tests. Move its `OrderItemDisplay` group and the two quantity-limit tests into `test/screens/order_screen_test.dart`. Remove the now-unused `Sandwich` import from `main_test.dart`. Keep explicit `Sandwich` types in the moved fixtures and add that type to the `const` declarations in the sandwich model tests too. Tests now follow the same folders as the application.

### Prepare a fresh database for each test

Create `test/database/sandwich_db_test.dart` with these imports and an empty `main`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {}
```

`setUp` runs before every test; `tearDown` runs afterwards, even when a test fails. Use them to give each test an empty database and close it afterwards. Add these inside `main`:

```dart
  setUp(() async {
    sqfliteFfiInit();
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: SandwichDatabase.instance.createTables,
      ),
    );
    SandwichDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });
```

`sqfliteFfiInit` prepares the native SQLite library. `databaseFactoryFfiNoIsolate` runs the database in the current Dart isolate, without starting a separate worker. `inMemoryDatabasePath` stores the rows in memory, so closing the connection discards them. `OpenDatabaseOptions` supplies the version and creation callback.

We pass the application's `createTables` method to `onCreate`, so tests exercise the real table definition without adding seed orders. `setDatabase` supplies this connection to the singleton; `close` also resets its cached connection. Copy this setup and cleanup into each of the database-backed screen test files below, rather than creating another helper layer.

### Test inserting, reading and numbering orders

Inside `main`, add a small fixture builder:

```dart
  OrderRecord buildRecord(int orderNumber, String summary, double total) {
    return OrderRecord(
      orderNumber: orderNumber,
      summary: summary,
      total: total,
      date: '01/01/2026 10:00',
    );
  }
```

Add the insert-and-read test:

```dart
  test('insertOrder stores an order and returns its id', () async {
    final int id = await SandwichDatabase.instance.insertOrder(
      buildRecord(1001, '1 x Footlong Sub', 7.50),
    );
    expect(id, greaterThan(0));

    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders.length, 1);
    expect(orders[0].id, id);
    expect(orders[0].summary, '1 x Footlong Sub');
    expect(orders[0].total, 7.50);
  });
```

This checks `toMap`, SQLite insertion and `fromMap` together. Add a test for numbering:

```dart
  test('getNextOrderNumber increments the current maximum', () async {
    expect(await SandwichDatabase.instance.getNextOrderNumber(), 1001);

    await SandwichDatabase.instance.insertOrder(
      buildRecord(1005, 'Order', 5.0),
    );
    expect(await SandwichDatabase.instance.getNextOrderNumber(), 1006);
  });
```

Add a third test for descending order:

```dart
  test('getAllOrders returns newest order number first', () async {
    await SandwichDatabase.instance.insertOrder(
      buildRecord(1001, 'First', 5.0),
    );
    await SandwichDatabase.instance.insertOrder(
      buildRecord(1003, 'Third', 9.0),
    );
    await SandwichDatabase.instance.insertOrder(
      buildRecord(1002, 'Second', 7.0),
    );

    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders[0].orderNumber, 1003);
    expect(orders[1].orderNumber, 1002);
    expect(orders[2].orderNumber, 1001);
  });
```

### Test order map conversion

Create `test/models/order_record_test.dart` with the test tools and `OrderRecord` imports. Start with an empty `main`. Inside it, add this fixture:

```dart
  const OrderRecord order = OrderRecord(
    orderNumber: 1004,
    summary: '2 x Footlong Sub',
    total: 16.50,
    date: '01/01/2026 09:05',
  );
```

Check that a new order omits its database id and uses the optional defaults:

```dart
  test('New orders omit database ids and default optional values', () {
    expect(order.id, isNull);
    expect(order.note, isEmpty);
    expect(order.toasted, 0);
    expect(order.vegan, 0);
    expect(order.toMap(), <String, Object?>{
      'order_number': 1004,
      'summary': '2 x Footlong Sub',
      'note': '',
      'toasted': 0,
      'vegan': 0,
      'total': 16.50,
      'date': '01/01/2026 09:05',
    });
  });
```

Check the reverse conversion with a complete database row:

```dart
  test('A database map converts back into an order', () {
    final Map<String, Object?> row = <String, Object?>{
      'id': 7,
      'order_number': 1010,
      'summary': '1 x Six-Inch Sub',
      'note': 'No onions',
      'toasted': 1,
      'vegan': 1,
      'total': 6.0,
      'date': '02/01/2026 10:20',
    };
    final OrderRecord restored = OrderRecord.fromMap(row);
    expect(restored.id, 7);
    expect(restored.note, 'No onions');
    expect(restored.toasted, 1);
    expect(restored.vegan, 1);
    expect(restored.toMap(), row);
  });
```

SQLite may return a whole number for a total. Check that our `num` conversion still produces a `double`:

```dart
  test('Whole-number SQLite totals become doubles', () {
    final Map<String, Object?> row = order.toMap();
    row['total'] = 6;
    final OrderRecord restored = OrderRecord.fromMap(row);
    expect(restored.total, 6.0);
    expect(restored.total, isA<double>());
  });
```

### Update the basket checkout test

Keep the two existing tests in `test/screens/basket_screen_test.dart`. Add these imports alongside its current imports:

```dart
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
```

Replace its `setUp` with the database setup above, keeping `CartRepository.instance.clear();` as the first statement inside it. Add the same `tearDown` to close the database. This keeps tests independent without changing their basket fixtures.

Add a checkout test shell inside `main`:

```dart
  testWidgets('Checkout saves the order, clears the basket and opens orders', (
    WidgetTester tester,
  ) async {
  });
```

Inside the test, add two sandwiches and render a basket with an orders route:

```dart
    CartRepository.instance.addItem(
      const CartItem(sandwich: testSandwich, quantity: 2),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: const BasketScreen(),
        routes: {
          '/orders': (BuildContext context) {
            return const OrdersScreen();
          },
        },
      ),
    );
```

[`runAsync`](https://api.flutter.dev/flutter/flutter_test/WidgetTester/runAsync.html) allows real asynchronous work inside a widget test, which otherwise controls time itself. Use it while checkout writes to SQLite, then let the navigation frames settle:

```dart
    await tester.runAsync(() async {
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
    });
    await tester.pumpAndSettle();
```

Read the saved records in another `runAsync` call:

```dart
    final List<OrderRecord>? orders = await tester.runAsync(() async {
      return await SandwichDatabase.instance.getAllOrders();
    });
```

`runAsync` returns a nullable result, so check the local variable before reading its list. Finish with these assertions:

```dart
    expect(orders, isNotNull);
    if (orders != null) {
      expect(orders.length, 1);
      expect(orders[0].orderNumber, 1001);
      expect(orders[0].summary, '2 x Footlong Sub');
      expect(orders[0].total, 21.50);
    }
    expect(CartRepository.instance.getItems(), isEmpty);
    expect(find.byType(OrdersScreen), findsOneWidget);
    expect(find.text('Order #1001'), findsOneWidget);
```

The fixture costs `10.0` per sandwich, so two sandwiches plus `1.50` delivery produce a saved total of `21.50`. The assertions check the database, basket and destination screen, not just a success message.

### Test the orders list and its empty state

Create `test/screens/orders_screen_test.dart` with these imports and an empty `main`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {}
```

Inside `main`, copy the database `setUp` and `tearDown` from the database tests. Start the populated-list test:

```dart
  testWidgets('OrdersScreen lists saved orders newest-first', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
    });
  });
```

Inside `runAsync`, insert the first fixture:

```dart
      await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1001,
          summary: '1 x Six-Inch Sub',
          total: 4.50,
          date: '01/01/2026 10:00',
        ),
      );
```

Insert the second fixture after it:

```dart
      await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1002,
          summary: '2 x Footlong Sub',
          total: 15.00,
          date: '02/01/2026 11:00',
        ),
      );
```

Still inside `runAsync`, render the screen and wait for it to settle:

```dart
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await tester.pumpAndSettle();
```

After `runAsync` closes, check both presence and position:

```dart
    await tester.pump();

    expect(find.text('Order #1002'), findsOneWidget);
    expect(find.text('Order #1001'), findsOneWidget);
    expect(find.text('2 x Footlong Sub'), findsOneWidget);
    final double newestY = tester.getTopLeft(find.text('Order #1002')).dy;
    final double oldestY = tester.getTopLeft(find.text('Order #1001')).dy;
    expect(newestY, lessThan(oldestY));
```

[`getTopLeft`](https://api.flutter.dev/flutter/flutter_test/WidgetController/getTopLeft.html) gives a widget's position. A smaller vertical coordinate means the newer order is above the older one; checking that both texts exist would not prove their order.

Add the empty-table test:

```dart
  testWidgets('OrdersScreen shows an empty state when there are no orders', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.text('No orders yet'), findsOneWidget);
  });
```

### Test supported platforms and run the complete suite

In `test/main_test.dart`, add the foundation import:

```dart
import 'package:flutter/foundation.dart';
```

Keep its existing app tests. Inside `main`, add checks for the platform helper. `debugDefaultTargetPlatformOverride` lets a test choose a target platform without changing computers; reset it to `null` afterwards:

```dart
  test('Android, iOS and macOS are supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = null;
  });
```

```dart
  test('Windows and Linux desktop are not supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = null;
  });
```

Check the explanation shown on unsupported platforms:

```dart
  testWidgets('The unsupported platform screen explains what to do',
      (WidgetTester tester) async {
    await tester.pumpWidget(const UnsupportedPlatformApp());
    expect(find.textContaining('Android emulator'), findsOneWidget);
  });
```

Use the [formatting, analysis and test workflow from Worksheet 4](worksheet-4.md#running-test-suites-and-static-analysis):

```bash
dart format lib test
dart analyze
flutter test
```

Compare your finished application with branch `7`. Check both the automated tests and the emulator restart behaviour; an in-memory database test cannot prove that a device file survives restarting the app.

## Organising tests and inspecting coverage

From Demo 4 onwards, your test folders must mirror the folders under `lib/`, as we arranged in the preceding section. Keep model, repository, screen, widget and database tests in their matching subfolders under `test/`.

For Sandwich Shop, screen tests belong under `test/screens/` because the application uses `lib/screens/`. The cinema application uses `lib/views/`, so its view tests belong under `test/views/`. Match the actual application structure rather than renaming folders to copy the example.

Tests for the root-level `lib/main.dart` may remain at the root of `test/`; model, repository and screen tests should not remain there.

Run the suite with coverage:

```bash
flutter test --coverage
```

This writes `coverage/lcov.info`. Install the [Flutter Coverage extension](https://marketplace.visualstudio.com/items?itemName=Flutterando.flutter-coverage) in VS Code and use it to inspect which lines the tests execute. Review the models, repositories, database helper and checkout screens, then add tests for important paths that are not exercised. Executed lines alone do not prove that the assertions check the correct behaviour.

Be ready to demonstrate the coverage in your editor at Demo 4, alongside passing tests and the mirrored folder structure.

## Exercises

The exercises below apply these concepts to your Southsea Cinema coursework. Together with Worksheet 8, they prepare you for Demo 4. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw).

Continue from cinema branch `3`, the Demo 3 state after Worksheets 5 and 6. Cinema branch `4` is the draft Demo 4 checkpoint, with database-backed bookings added to that state. Keep the existing JSON film catalogue, saved profile settings, drawer navigation and squared buttons. No notifier, Provider package or app-bar basket button is required.

1. Set up the [Android emulator](#preparing-an-android-emulator) and add the [SQLite packages](#adding-the-sqlite-packages) to the cinema app. Use the university Android bundle on lab machines or install an emulator on your own computer. Do not add web database packages or copy the Sandwich Shop's Android package id.

2. Following [Representing a saved order](#representing-a-saved-order), create `Booking` in `lib/models/booking.dart`, with an optional database `id`, `bookingNumber`, `saleSummary`, `saleDate` and `totalPrice`. Add `toMap` and `fromMap` methods and tests. Use `Booking` consistently for a completed ticket purchase rather than creating a second class for the same record.

3. Following [Creating the SQLite database helper](#creating-the-sqlite-database-helper), create `CinemaDatabase` in `lib/database/cinema_db.dart`. Open a file in the app's database folder, create a `bookings` table and seed fictional past bookings once in `onCreate`. Add methods to insert bookings, read them newest first, find the next booking number and close the connection.

4. Following [Displaying saved orders](#displaying-saved-orders), build a bookings view and register `'/bookings'`. Make the drawer's **My Tickets** entry open it. Show loading, error and empty feedback as well as the saved booking list.

5. Following [Saving the basket at checkout](#saving-the-basket-at-checkout), replace the temporary checkout with one that saves a `Booking` containing the basket summary and total. Only clear the basket and navigate after the insert succeeds. Show database errors without clearing the basket. Fully close and reopen the emulator app to verify that the purchase remains and seed rows are not duplicated. **Show the running app to a member of staff.**

6. Following [Testing SQLite without an emulator](#testing-sqlite-without-an-emulator), test the actual table definition using an in-memory database. Check generated ids and saved fields, descending booking order, numbering from an empty table and the next number after insertion. Add widget tests for successful checkout, the bookings list and its empty state. Verify that a failed insert leaves the basket intact.

7. Follow [Organising tests and inspecting coverage](#organising-tests-and-inspecting-coverage). Make your test folders mirror `lib/`, run `flutter test --coverage` and demonstrate the results with the Flutter Coverage extension. Keep `dart analyze` and the complete test suite passing.

8. For Demo 4, be ready to explain why profile preferences and booking tables have different jobs, how a row maps to a `Booking`, why seed data runs only once, why checkout saves before clearing the basket, and how an emulator restart check differs from an in-memory test. **Show your database-backed application, organised tests and editor coverage to a member of staff.**
