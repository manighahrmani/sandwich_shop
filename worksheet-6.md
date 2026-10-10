# Worksheet 6 — Two kinds of local persistence

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 5](#continue-from-worksheet-5)
  - [Switch to branch 5](#switch-to-branch-5)
- [Two kinds of persistence](#two-kinds-of-persistence)
- [Adding the dependencies](#adding-the-dependencies)
  - [Add the persistence packages](#add-the-persistence-packages)
  - [Commit your changes (1)](#commit-your-changes-1)
- [Remembering order options with shared preferences](#remembering-order-options-with-shared-preferences)
  - [Define the preference keys](#define-the-preference-keys)
  - [Load saved options when the screen opens](#load-saved-options-when-the-screen-opens)
  - [Save options as the user changes them](#save-options-as-the-user-changes-them)
  - [Commit your changes (2)](#commit-your-changes-2)
- [Storing orders in SQLite](#storing-orders-in-sqlite)
  - [Define the order record model](#define-the-order-record-model)
  - [Create the database helper](#create-the-database-helper)
  - [Create the orders table and seed past orders](#create-the-orders-table-and-seed-past-orders)
  - [Insert and query orders](#insert-and-query-orders)
  - [Commit your changes (3)](#commit-your-changes-3)
- [Adding an orders button to every screen](#adding-an-orders-button-to-every-screen)
  - [Create the orders button](#create-the-orders-button)
  - [Show both buttons on the menu and order screens](#show-both-buttons-on-the-menu-and-order-screens)
  - [Commit your changes (4)](#commit-your-changes-4)
- [Saving an order at checkout](#saving-an-order-at-checkout)
  - [Build the order record from the basket](#build-the-order-record-from-the-basket)
  - [Save and navigate on checkout](#save-and-navigate-on-checkout)
  - [Commit your changes (5)](#commit-your-changes-5)
- [Showing past orders](#showing-past-orders)
  - [Create the orders screen](#create-the-orders-screen)
  - [Register the orders route](#register-the-orders-route)
  - [Commit your changes (6)](#commit-your-changes-6)
- [Running the app on a mobile emulator](#running-the-app-on-a-mobile-emulator)
  - [Lab machines: the Android emulator beta bundle](#lab-machines-the-android-emulator-beta-bundle)
  - [Your own Windows or Mac laptop: Android Studio](#your-own-windows-or-mac-laptop-android-studio)
  - [Mac only: the iOS simulator](#mac-only-the-ios-simulator)
- [Testing persistence](#testing-persistence)
  - [Update existing order screen tests](#update-existing-order-screen-tests)
  - [Test the shared preferences flow](#test-the-shared-preferences-flow)
  - [Set up an in-memory database](#set-up-an-in-memory-database)
  - [Test inserting and reading orders](#test-inserting-and-reading-orders)
  - [Update the basket screen tests](#update-the-basket-screen-tests)
  - [Test the orders screen](#test-the-orders-screen)
  - [Test the app bar navigation actions](#test-the-app-bar-navigation-actions)
  - [Commit your changes (7)](#commit-your-changes-7)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 5

You can continue directly with the Sandwich Shop project you completed in Worksheet 5. Open your project folder in VS Code with **File > Open Folder**.

### Switch to branch 5

If you prefer a clean copy matching the Worksheet 5 end state, switch to branch `5`:

```bash
git checkout 5
```

Run `flutter test` in your terminal to confirm that all existing tests pass before continuing.

## Two kinds of persistence

In Worksheet 5 everything lived in memory. The order options a user picked and the sandwiches in their basket vanished the moment the app restarted or the browser tab refreshed. In this worksheet we make two different kinds of data survive a restart, using the right tool for each.

The order options, whether a sandwich is toasted or vegan and the note for the kitchen, are small, loose pieces of interface state. There are only a few of them and we never need to search or sort them. For data like that we use shared preferences, a simple store of key-and-value pairs saved on the device. We read the last-used options back when the order screen opens, so a returning user does not retype them.

The orders themselves are different. Each is a structured record with a number, a summary, a date, and a total, and we want to list them newest first and could later filter them by date. For structured, queryable records like that we use SQLite, a small relational database stored in a single file. We save each completed order as a row and read them back on an orders screen.

The contrast is the lesson: reach for shared preferences for a handful of simple settings, and for a relational database such as SQLite when you have many structured records you need to query. We build the shared preferences part first because it extends the order screen you already know, then move on to the database.

## Adding the dependencies

Both kinds of persistence come from packages we add to the project.

### Add the persistence packages

Open `pubspec.yaml` in your project root. Under `dependencies:`, add the packages below. `shared_preferences` gives us the key-value store. The database packages are split by platform: `sqflite` is the standard plugin that opens SQLite on Android and iOS, `path` lets us build a file path that works on any platform, and the two `sqflite_common_ffi` packages give us SQLite on desktop, test, and web. We also pin `sqlite3` to version `3.5.2` so web builds match the compiled WebAssembly binary in `web/sqlite3.wasm`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.0
  shared_preferences: ^2.2.0
  sqflite: ^2.3.0
  path: ^1.8.0
  sqflite_common_ffi: ^2.3.0
  sqflite_common_ffi_web: ^0.4.0
  # Pinned so the committed web/sqlite3.wasm (the sqlite3-3.5.2 build) matches
  # the sqlite3 version the app resolves, otherwise the browser fails to load
  # the WebAssembly module.
  sqlite3: "3.5.2"
```

Run `flutter pub get` in your terminal to download the packages:

```bash
flutter pub get
```

### Commit your changes (1)

Stage `pubspec.yaml` and `pubspec.lock`, then commit your changes with a short, descriptive message of your own.

## Remembering order options with shared preferences

We start with the lighter kind of persistence. The order screen already has two switches and a note field. We make the app remember the user's last choices and pre-fill the form with them next time.

Shared preferences stores values under string keys. You read a value with a typed getter such as `getBool` or `getString`, and write one with `setBool` or `setString`. Reading and writing touch the device, so the methods are asynchronous and return a `Future` (the pattern from Worksheet 4).

### Define the preference keys

Open `lib/screens/order_screen.dart`. First import the package, then define three constant keys at the top of the file so we never mistype a key name:

```dart
import 'package:shared_preferences/shared_preferences.dart';

const String prefToasted = 'order_toasted';
const String prefVegan = 'order_vegan';
const String prefNote = 'order_note';
```

Each key is a plain `const String`. Using named constants rather than typing `'order_toasted'` in several places means the compiler, not you, keeps the names consistent. Add this import alongside the existing imports at the top of the file, and the three keys just below them.

### Load saved options when the screen opens

We load the saved options as soon as the screen appears. Add a loader method to `_OrderScreenState`, and call it from `initState`.

First add the loader. It reads the three values and copies them into the screen's state:

```dart
  Future<void> _loadSavedOptions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool toasted = prefs.getBool(prefToasted) ?? false;
    final bool vegan = prefs.getBool(prefVegan) ?? false;
    final String note = prefs.getString(prefNote) ?? '';
    if (!mounted) {
      return;
    }
    setState(() {
      _toasted = toasted;
      _vegan = vegan;
      _noteController.text = note;
    });
  }
```

`SharedPreferences.getInstance()` hands back the shared store, which we `await`. Then `prefs.getBool(prefToasted)` reads the saved toasted flag. The first time the app runs, nothing is stored yet, so that call returns `null`. The `??` operator handles this: it is the null-coalescing operator, and `prefs.getBool(prefToasted) ?? false` means "use the stored value, or `false` when it is null". The operator evaluates to its right-hand side only when the left-hand side is null, and to the left-hand side otherwise. We default the two booleans to `false` and the note to the empty string.

The `if (!mounted) return;` check is new. After an `await`, time has passed and the user may already have left this screen, which disposes its `State`. Calling `setState` on a disposed `State` is an error, so we first check `mounted`, which is `true` only while the `State` is still on screen, and return early if it is not, calling `setState` only when the screen is still displayed.

Now call the loader from `initState`, just after creating the controller:

```dart
  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _loadSavedOptions();
  }
```

### Save options as the user changes them

Next add a method that writes the current options back to the store:

```dart
  Future<void> _saveOptions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefToasted, _toasted);
    await prefs.setBool(prefVegan, _vegan);
    await prefs.setString(prefNote, _noteController.text.trim());
  }
```

Each `set` call stores one value under its key, overwriting what was there. We call `_saveOptions` at two moments: whenever either switch is toggled, and when the sandwich is added to the basket. Update the two `Switch` widgets in the `build` method so their `onChanged` saves after updating state:

```dart
            Row(
              children: [
                const Expanded(child: Text('Toasted')),
                Switch(
                  value: _toasted,
                  onChanged: (bool value) {
                    setState(() {
                      _toasted = value;
                    });
                    _saveOptions();
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Vegan')),
                Switch(
                  value: _vegan,
                  onChanged: (bool value) {
                    setState(() {
                      _vegan = value;
                    });
                    _saveOptions();
                  },
                ),
              ],
            ),
```

The note `TextField` is left as it was in Worksheet 5; we read its text when the sandwich is added rather than saving on every keystroke. In `_addToBasket`, call `_saveOptions()` right after adding the item to the repository, so the current toggles and note are stored together:

```dart
      CartRepository.instance.addItem(item);
      _saveOptions();
```

Now toggle a switch, type a note, hot restart the app, open the order screen again, and the options you left are already filled in.

<!-- TODO screenshot: images/6/order_screen_prefilled.png — the order screen reopened after a restart with the toasted switch on and a note already present -->

### Commit your changes (2)

Stage your updated `order_screen.dart` and commit your changes with a message of your own.

## Storing orders in SQLite

Now for the heavier kind of persistence. We store each completed order as a row in a SQLite database so the orders survive restarts and can be listed and queried.

SQLite is a small relational database engine. It needs no separate server; the whole database is a single file on disk, or kept in memory for tests. We store orders in a table of rows and columns, give each row a unique id, and read them back sorted by order number.

### Define the order record model

Create a new file named `lib/models/order_record.dart`. Start with the fields and the `const` constructor:

```dart
class OrderRecord {
  final int? id;
  final int orderNumber;
  final String summary;
  final String note;
  final int toasted;
  final int vegan;
  final double total;
  final String date;

  const OrderRecord({
    this.id,
    required this.orderNumber,
    required this.summary,
    required this.note,
    required this.toasted,
    required this.vegan,
    required this.total,
    required this.date,
  });
}
```

The `id` field has the nullable type `int?` and is not `required`. A record we have just built in memory has no `id` yet: SQLite assigns one when the row is inserted. So `id` is `null` before saving and holds a number afterwards. Note that `toasted` and `vegan` are stored as `int` here, not `bool`: SQLite has no boolean type, so we use `1` for true and `0` for false.

This model converts to and from a database row, just as `Sandwich` converted to and from JSON in Worksheet 5. The database equivalent of `toJson` and `fromJson` is a pair named `toMap` and `fromMap`, which produce and read the `Map<String, Object?>` of column names to values that the database methods expect. Add `toMap` first, inside the class:

```dart
  Map<String, Object?> toMap() {
    final Map<String, Object?> data = <String, Object?>{
      'order_number': orderNumber,
      'summary': summary,
      'note': note,
      'toasted': toasted,
      'vegan': vegan,
      'total': total,
      'date': date,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
```

Each map key matches a column in the orders table we create shortly. We add the `id` entry only when `id` is not `null`, so a brand-new record leaves `id` out and lets SQLite fill it in.

Now add the `fromMap` constructor, which reads a row map back into an `OrderRecord`. It is a `factory` constructor, the kind you met in Worksheet 5:

```dart
  factory OrderRecord.fromMap(Map<String, Object?> map) {
    final int orderNumber = map['order_number'] as int;
    final String summary = map['summary'] as String;
    final String note = map['note'] as String;
    final int toasted = map['toasted'] as int;
    final int vegan = map['vegan'] as int;
    final num totalNumber = map['total'] as num;
    final double total = totalNumber.toDouble();
    final String date = map['date'] as String;

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
  }
}
```

As in Worksheet 5, we read each value out of the map and use `as` to assert its type, reading the total as a `num` and calling `.toDouble()`. The `id` might be missing, so we read it as the nullable `int?`.

### Create the database helper

Create a new file named `lib/database/sandwich_db.dart`. We manage every database operation through one helper class, `SandwichDatabase`, and build it in stages so each piece is explained before the next.

Start with the imports and the class with its private constructor and shared instance:

```dart
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite/sqflite.dart' as sqflite_plugin;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SandwichDatabase {
  SandwichDatabase._internal();

  static final SandwichDatabase instance = SandwichDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }
}
```

This is the same singleton pattern you built for `CartRepository` in Worksheet 5. The private constructor `SandwichDatabase._internal()` cannot be called from outside this file, and the one shared instance is exposed through `static final SandwichDatabase instance`, so every screen talks to the same database helper and no other code can create a second one. The two `sqflite_common_ffi` imports give us the FFI engine and the types we use below, such as `Database`, `DatabaseFactory`, and `OpenDatabaseOptions`. The `package:sqflite/sqflite.dart` import brings in the standard plugin we use on a phone; we give it the prefix `sqflite_plugin` so it is clear which package each name comes from. The `package:path/path.dart` import gives us `join`, which builds a file path safely, and `package:flutter/foundation.dart` gives us `kIsWeb` and `defaultTargetPlatform`, both used shortly. The `_database` field caches the open connection, a `Database`, and starts as `null`. The `setDatabase` method lets our tests supply their own connection.

Now add the getter that opens the database on first use:

```dart
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    final Database db = await _initDB('sandwich_data.db');
    _database = db;
    return db;
  }
```

The `database` getter is `async` and returns a `Future<Database>`: it returns the cached connection if one exists, otherwise opens one with `_initDB`, caches it, and returns it.

Now add `_initDB`, which opens the connection. A database must be opened differently on each platform, so we handle the four cases one at a time. Start the method with the shared options, then handle a test run:

```dart
  Future<Database> _initDB(String fileName) async {
    final OpenDatabaseOptions options = OpenDatabaseOptions(
      version: 1,
      onCreate: _createDB,
    );

    const bool runningInTest = bool.fromEnvironment('FLUTTER_TEST');
    if (runningInTest) {
      sqfliteFfiInit();
      final DatabaseFactory testFactory = databaseFactoryFfi;
      final Database testDatabase = await testFactory.openDatabase(
        inMemoryDatabasePath,
        options: options,
      );
      return testDatabase;
    }
```

`OpenDatabaseOptions` sets the schema `version` and the `onCreate` callback, which we point at `_createDB` (written next) so our table is created the first time the database is made. The expression `bool.fromEnvironment('FLUTTER_TEST')` is `true` while a `flutter test` run is in progress; when it is, we call `sqfliteFfiInit()` to prepare the FFI engine and open `inMemoryDatabasePath`, a special path that keeps the database in memory so tests run quickly and leave no file behind.

Next handle the web. In a browser the data is stored for us, so a bare database name is all we need:

```dart
    if (kIsWeb) {
      final DatabaseFactory webFactory = databaseFactoryFfiWebNoWebWorker;
      final Database webDatabase = await webFactory.openDatabase(
        fileName,
        options: options,
      );
      return webDatabase;
    }
```

`kIsWeb` is a compile-time boolean that is `true` in a web browser. When it is, we use `databaseFactoryFfiWebNoWebWorker` from `sqflite_common_ffi_web`, which loads the WebAssembly build of SQLite, and open the database by its name.

Now handle a phone. On Android and iOS the standard `sqflite` plugin owns the SQLite engine, and it cannot open a bare file name. If you pass just `sandwich_data.db`, the app fails at checkout with the error "unable to open database file", because the phone gives each app its own private folder and will not let it write just anywhere. We ask the plugin where that folder is with `getDatabasesPath()` and build a full path to the file with `join`:

```dart
    final TargetPlatform platform = defaultTargetPlatform;
    final bool runningOnMobile =
        platform == TargetPlatform.android || platform == TargetPlatform.iOS;
    if (runningOnMobile) {
      final DatabaseFactory mobileFactory = sqflite_plugin.databaseFactory;
      final String databasesFolder = await sqflite_plugin.getDatabasesPath();
      final String mobilePath = join(databasesFolder, fileName);
      final Database mobileDatabase = await mobileFactory.openDatabase(
        mobilePath,
        options: options,
      );
      return mobileDatabase;
    }
```

`defaultTargetPlatform` tells us which platform the app runs on, and we treat `TargetPlatform.android` and `TargetPlatform.iOS` as a phone. We use this value rather than checking the operating system directly, because the usual way of doing that does not compile for the web. On a phone we take the plugin's own `databaseFactory`, ask it for the writable folder, join the file name onto that folder, and open the real file there. This is the fix for the "unable to open database file" error.

Finally handle the desktop (Windows, macOS, and Linux). There we keep the FFI engine, but we still open a real file in a writable folder rather than a bare name:

```dart
    sqfliteFfiInit();
    final DatabaseFactory desktopFactory = databaseFactoryFfi;
    final String desktopFolder = await sqflite_plugin.getDatabasesPath();
    final String desktopPath = join(desktopFolder, fileName);
    final Database desktopDatabase = await desktopFactory.openDatabase(
      desktopPath,
      options: options,
    );
    return desktopDatabase;
  }
```

If the code reaches this point it is not a test, not the web, and not a phone, so it must be the desktop. We call `sqfliteFfiInit()` to prepare the FFI engine, use `databaseFactoryFfi`, and build a full path the same way as on a phone. Each of the four cases returns an opened `Database`, so the right engine and the right path are always paired together.

### Create the orders table and seed past orders

Still inside `SandwichDatabase`, add `_createDB`. The engine calls this once, through the `onCreate` callback, the first time the database is created. Start the method and create the `orders` table:

```dart
  Future<void> _createDB(Database db, int version) async {
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

The `db.execute` method runs a raw SQL statement that returns no rows, which is what we need to create a table. The SQL `CREATE TABLE IF NOT EXISTS orders (...)` makes a table called `orders` only if it does not already exist. Inside the brackets each line names a column and its type: `INTEGER` for whole numbers, `TEXT` for strings, and `REAL` for decimal numbers. `PRIMARY KEY` marks `id` as the unique identifier for each row, and `AUTOINCREMENT` tells SQLite to fill it in automatically with the next number, so we never set it ourselves. `NOT NULL` means a column must always have a value. The triple-quoted string (`'''`) lets the SQL span several lines. The columns match the keys in `OrderRecord.toMap`.

Now seed a few past orders so the orders screen has something to show the first time a student opens it. Still inside `_createDB`, insert three rows and close the method:

```dart
    // Seed a few past orders so the orders screen has content on first run.
    await db.insert('orders', <String, Object?>{
      'order_number': 1003,
      'summary': '2 x Footlong Sub',
      'note': 'Extra napkins please',
      'toasted': 1,
      'vegan': 0,
      'total': 15.00,
      'date': '18 Apr 2026 12:45',
    });
    await db.insert('orders', <String, Object?>{
      'order_number': 1002,
      'summary': '1 x Six-Inch Sub',
      'note': '',
      'toasted': 0,
      'vegan': 1,
      'total': 4.50,
      'date': '2 Mar 2026 18:10',
    });
    await db.insert('orders', <String, Object?>{
      'order_number': 1001,
      'summary': '3 x Footlong Sub',
      'note': 'No onions',
      'toasted': 1,
      'vegan': 0,
      'total': 22.50,
      'date': '11 Jan 2026 13:02',
    });
  }
```

The `db.insert` method adds one row to a named table from a `Map<String, Object?>` whose keys match the column names. Because `_createDB` runs only when the database is first created, this seeding happens once. The coursework asks you to seed your own account history in the same way.

### Insert and query orders

Add a method that inserts one order and returns its new id:

```dart
  Future<int> insertOrder(OrderRecord order) async {
    final Database db = await database;
    final int id = await db.insert('orders', order.toMap());
    return id;
  }
```

It opens the connection through the `database` getter, then calls `db.insert('orders', order.toMap())`, which inserts the row map and returns the row's auto-generated id.

Now add a method that reads every order, newest first:

```dart
  Future<List<OrderRecord>> getAllOrders() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.query(
      'orders',
      orderBy: 'order_number DESC',
    );
    final List<OrderRecord> orders = [];
    for (final Map<String, Object?> row in records) {
      orders.add(OrderRecord.fromMap(row));
    }
    return orders;
  }
```

The `db.query` method reads rows from a named table and is simpler than writing raw SQL for everyday reads. The `orderBy: 'order_number DESC'` argument sorts by order number in descending order (`DESC`), so the newest order comes first. We loop over the row maps with a `for-in` loop, turning each into an `OrderRecord` with `fromMap`.

Next, add a method that works out the next order number by reading the current highest one:

```dart
  Future<int> getNextOrderNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(order_number) as max_num FROM orders',
    );
    if (records.isNotEmpty && records[0]['max_num'] != null) {
      final int currentMax = records[0]['max_num'] as int;
      return currentMax + 1;
    }
    return 1001;
  }
```

Here `db.rawQuery` runs a SQL query that returns rows, giving back a `List<Map<String, Object?>>` where each map is one row. The SQL `SELECT MAX(order_number) as max_num FROM orders` asks SQLite for the largest `order_number` and labels that result `max_num`. If a value comes back we add one to it; if the table is empty we start at `1001`.

Finally, add a method that closes the database. Our tests use it to reset between runs:

```dart
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
```

### Commit your changes (3)

Stage your new `order_record.dart` and `sandwich_db.dart`, then commit your changes with a message of your own.

## Adding an orders button to every screen

Now that orders are saved, the user needs a way to reach them from anywhere in the app. In Worksheet 5 you built the reusable `BasketButton` as an app bar action shown on every screen. We follow the same pattern here with an orders button, so a single widget carries the behaviour and every screen simply lists it.

### Create the orders button

Create a new file named `lib/widgets/orders_button.dart`, mirroring `basket_button.dart`:

```dart
import 'package:flutter/material.dart';

class OrdersButton extends StatelessWidget {
  const OrdersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.receipt_long),
      onPressed: () {
        final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
        if (currentRoute != '/orders') {
          Navigator.pushNamed(context, '/orders');
        }
      },
    );
  }
}
```

`OrdersButton` is the same shape as `BasketButton`. It draws `Icons.receipt_long`, a receipt icon that suits a list of past orders, and its `onPressed` reads the current route name and pushes `'/orders'` unless it is already there. We register the `'/orders'` route and build the screen it opens later in this worksheet.

### Show both buttons on the menu and order screens

Open `lib/screens/menu_screen.dart`. Import the orders button and list it after the basket button in the app bar `actions`:

```dart
import 'package:sandwich_shop/widgets/orders_button.dart';
```

```dart
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton(), OrdersButton()],
      ),
```

Open `lib/screens/order_screen.dart` and make the same change: import `orders_button.dart` and update its app bar `actions` to `const [BasketButton(), OrdersButton()]`. The basket app bar gets the same pair when we edit it next.

### Commit your changes (4)

Stage your new `orders_button.dart` and the updated `menu_screen.dart` and `order_screen.dart`, then commit your changes with a message of your own.

## Saving an order at checkout

The basket screen already has a Checkout button that clears the basket. We now make it save the order to SQLite first, then take the user to a screen listing their orders.

### Build the order record from the basket

Open `lib/screens/basket_screen.dart`. First add the three imports we need at the top, alongside the existing ones. Two give us the database and the record model, and the third is the orders button we add to the app bar shortly:

```dart
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/widgets/orders_button.dart';
```

A basket can hold several items, but an order is one record, so we need small helpers that fold the basket down into the summary, note, and flags one row stores. Add these inside `_BasketScreenState`:

```dart
  String _buildSummary(List<CartItem> items) {
    final List<String> lines = [];
    for (final CartItem item in items) {
      lines.add('${item.quantity} x ${item.name}');
    }
    return lines.join(', ');
  }

  bool _anyToasted(List<CartItem> items) {
    for (final CartItem item in items) {
      if (item.toasted) {
        return true;
      }
    }
    return false;
  }

  bool _anyVegan(List<CartItem> items) {
    for (final CartItem item in items) {
      if (item.vegan) {
        return true;
      }
    }
    return false;
  }

  String _buildNote(List<CartItem> items) {
    final List<String> notes = [];
    for (final CartItem item in items) {
      if (item.note.isNotEmpty) {
        notes.add(item.note);
      }
    }
    return notes.join('; ');
  }
```

`_buildSummary` joins each line into a short string such as `2 x Footlong Sub, 1 x Six-Inch Sub`. `_buildNote` gathers any notes into one string. `_anyToasted` and `_anyVegan` return `true` if any item in the basket has that option set; we convert each to the `1` or `0` the table stores when we build the record.

The record also needs a date. Add a helper that formats the current date and time into a readable string:

```dart
  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/${now.year} $hour:$minute';
  }
```

A `DateTime` holds a point in time, and its `.day`, `.month`, `.year`, `.hour`, and `.minute` properties give the parts. The `padLeft(2, '0')` call pads each part to two digits so `9:5` reads as `09:05`, giving a date such as `18/04/2026 12:45`.

### Save and navigate on checkout

Saving to a database can go wrong: on some platforms the database file may fail to open, and we do not want the app to freeze or crash silently when that happens. So we give the user feedback through the same `_confirmationMessage` field the Worksheet 5 basket already has, and we wrap the save in a `try`/`catch` block so a failure shows a message instead of breaking the app.

Add the method that runs when the user checks out. It is `async` because saving to the database takes time:

```dart
  Future<void> _checkout(CartRepository cart, List<CartItem> items) async {
    setState(() {
      _confirmationMessage = 'Saving your order...';
    });
    try {
      final SandwichDatabase database = SandwichDatabase.instance;
      final int orderNumber = await database.getNextOrderNumber();
      final OrderRecord record = OrderRecord(
        orderNumber: orderNumber,
        summary: _buildSummary(items),
        note: _buildNote(items),
        toasted: _anyToasted(items) ? 1 : 0,
        vegan: _anyVegan(items) ? 1 : 0,
        total: cart.getTotalDue(),
        date: _formatDate(DateTime.now()),
      );
      await database.insertOrder(record);
      cart.clear();
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Order $orderNumber saved';
      });
      Navigator.pushNamed(context, '/orders');
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Could not save your order: $error';
      });
    }
  }
```

First it shows "Saving your order..." so the user knows something is happening. Inside the `try` block it asks the database for the next order number, builds an `OrderRecord` from the basket using the helpers, saves it with `insertOrder`, and clears the basket. The `_anyToasted(items) ? 1 : 0` expression turns each `bool` flag into the `1` or `0` the table stores. The `if (!mounted) return;` guard is the same `mounted` check as on the order screen: after the `await`, we only touch the screen if it is still on display. On success it shows "Order N saved" and navigates to the orders screen by its registered name. If anything goes wrong, the `catch` block shows "Could not save your order:" followed by the error, so a problem such as the database file failing to open is reported to the user instead of failing silently.

Next, change the Checkout button in `_buildBasketList` so it calls `_checkout` instead of clearing the basket inline:

```dart
    children.add(
      SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          label: 'Checkout',
          onPressed: () {
            _checkout(cart, items);
          },
        ),
      ),
    );
```

Keep the `_confirmationMessage` field and the lines in `_buildBasketList` that show it, since `_checkout` now sets it. The only part to tidy is the empty-basket case: in `build`, when the basket is empty just show the empty-state widget. Change that branch so it reads `content = _buildEmptyState();` with no confirmation message, because once an order is saved the screen navigates away to the orders page.

Finally, add the orders button to the basket app bar so the user can reach their orders from here too. Change the `actions` of the `AppBar` in `build` to list both buttons:

```dart
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton(), OrdersButton()],
      ),
```

### Commit your changes (5)

Stage your updated `basket_screen.dart` and commit your changes with a message of your own.

## Showing past orders

Now we build a screen that lists the saved orders, so the user can see the ones we seeded and any they place.

### Create the orders screen

Create a new file named `lib/screens/orders_screen.dart`. It is a `StatefulWidget` because it loads its data after it appears. Start with the imports, the shell, and the two pieces of state:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
import 'package:sandwich_shop/widgets/orders_button.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() {
    return _OrdersScreenState();
  }
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderRecord> _orders = [];
  bool _loading = true;
}
```

The `_orders` list holds the loaded orders, and `_loading` is `true` until the first load finishes, so we can show nothing rather than an empty list while the database is read. The two widget imports give us the app bar actions used below.

Now add `initState` (from Worksheet 5) to start loading as soon as the screen appears, and the asynchronous loader it calls:

```dart
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final List<OrderRecord> orders = await SandwichDatabase.instance
        .getAllOrders();
    if (!mounted) {
      return;
    }
    setState(() {
      _orders = orders;
      _loading = false;
    });
  }
```

The loader reads every order from the database, and once the data is back it stores it in `_orders` and sets `_loading` to `false` with `setState`, guarded by the `mounted` check so we never update a screen the user has left.

Next add a helper that turns one order's options into a short line of text, so the toggles and note show beneath the summary. It builds a list of the parts that apply and joins them, returning an empty box when none do:

```dart
  Widget _buildOptionsText(OrderRecord order) {
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
  }
```

Because the table stores `toasted` and `vegan` as `1` or `0`, we check each against `1`. This mirrors the options line you built on the basket screen in Worksheet 5.

Now add the helper that builds one card per order. We use a plain `Card` with no decoration or coloured circles, matching the simple basket style from Worksheet 5:

```dart
  Widget _buildOrderCard(OrderRecord order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 4),
            Text(order.summary),
            _buildOptionsText(order),
            const SizedBox(height: 4),
            Text(
              order.date,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
```

A `Card` is Flutter's lightly raised panel. Inside it, a top `Row` places the order number on the left and the total on the right with `MainAxisAlignment.spaceBetween`, then come the summary, the options line, and the date in small grey text. There is no `Divider` and no coloured quantity circle, so the orders list reads as cleanly as the basket.

Finally, add the `build` method. It picks between three states: nothing while loading, the empty-state message when there are no orders, and a scrolling list of cards otherwise:

```dart
  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (_loading) {
      body = const SizedBox.shrink();
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
    } else {
      body = ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildOrderCard(_orders[index]);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton(), OrdersButton()],
      ),
      body: body,
    );
  }
}
```

While `_loading` is `true` the body is an empty `SizedBox.shrink()`, which takes no space. Once loading finishes, an empty table shows the "No orders yet" message, and a filled one shows a `ListView.builder` (from Worksheet 3) of order cards. The app bar carries the same `const [BasketButton(), OrdersButton()]` pair as every other screen.

Your orders screen, showing the seeded orders and any you place, should look like this:

<!-- TODO screenshot: images/6/orders_screen.png — the orders screen listing past orders as plain cards with the order number, summary, options, date, and total -->

The orders button is already shown on every screen, so a short note on how the receipt icon reaches this screen is worth repeating: the `OrdersButton` pushes the `'/orders'` route, which we register next.

### Register the orders route

Open `lib/main.dart` and register the orders screen under `'/orders'`, the name the checkout navigates to. Import the screen and add the route to the `routes` map:

```dart
import 'package:sandwich_shop/screens/orders_screen.dart';
```

```dart
        '/orders': (BuildContext context) {
          return const OrdersScreen();
        },
```

### Commit your changes (6)

Stage your new `orders_screen.dart` and the updated `main.dart`, then commit your changes with a message of your own.

## Running the app on a mobile emulator

Every earlier worksheet ran the app in a web browser on Chrome or Edge, and it still runs there exactly as before. The browser is fine for most of what we do, but it hides one thing this worksheet is about: the on-disk SQLite file. In the browser the database lives in storage the browser manages for us, so you cannot watch a real file survive a full close and reopen the way it would on a phone.

A mobile emulator is a virtual Android phone that runs on your computer, and a simulator is the same idea for iOS on a Mac. Running the app on one of these lets you place an order, close the app completely, reopen it, and see the saved orders still there, because the SQLite database is a genuine file in the device's private folder. The emulator is not a hard requirement; the app runs on the web just as it did before, and the emulator is only there to show native persistence.

There are three routes to the same outcome, and you only need one. On a university lab machine, use the emulator beta bundle. On your own Windows or Mac laptop, install Android Studio. On a Mac, you can instead use the iOS simulator. Pick the route that matches your machine and follow it.

### Lab machines: the Android emulator beta bundle

Earlier worksheets set up the lab machines with a portable Flutter and VS Code bundle. That standard bundle does not include the Android SDK, so it cannot run an emulator. A separate experimental build of the bundle adds everything an emulator needs. You can find it in the Experimental section of the bundle README at [the flutter_vscode_package repository](https://github.com/manighahrmani/flutter_vscode_package), listed as the Android emulator beta release.

On top of the normal portable environment, the beta bundle ships a JDK, a command-line Android SDK, and a pre-made virtual device, an AVD named `flutter_emulator`. Like the main script, it finishes by opening VS Code on your cloned project, so you land in the same place as before with the extra tooling in place. The beta is experimental and needs hardware acceleration enabled on the machine, which the lab machines already have.

Install it by running the beta script in a PowerShell terminal on Windows:

```bash
irm https://raw.githubusercontent.com/manighahrmani/flutter_vscode_package/main/install-android-beta.ps1 | iex
```

Let the script finish and open VS Code on your project. Then open a new terminal and run the following commands in order, changing the first line to the path where you cloned the project:

```bash
cd path/to/sandwich_shop
flutter pub get
flutter emulators --launch flutter_emulator
flutter devices
flutter run -d emulator-5554
```

After `flutter emulators --launch flutter_emulator`, wait for the Android home screen to appear before carrying on. A black screen for a minute or two is normal, as the virtual phone is still booting. Once it has booted, `flutter devices` lists it as a device. The emulator's id, such as `emulator-5554`, only exists while the emulator is booted and disappears when you close it. If `flutter devices` shows a different id, use the one it reports in the `flutter run -d` command.

You can run the app from VS Code instead of the terminal. With the emulator booted, pick it as the target device in the status bar device selector in the bottom-right (or through the Command Palette entry **Flutter: Select Device**), then start the app with **F5** or Run.

<!-- TODO screenshot: images/6/device_selector.png — the VS Code status bar device selector listing the booted emulator -->

Choose the emulator as your run device, or Edge if you want the web version. Do not choose the `Windows` device: Windows desktop builds need Developer Mode and fail with a `Building with plugins requires symlink support` error. If you see that error, switch the device back to the emulator or Edge.

The first emulator build is slow, because it downloads `Gradle` and the build-tools and compiles the app, so give it time. During the build you may also see warnings that certain `Gradle`, `AGP`, or `Kotlin` versions will soon be dropped. These are harmless, the app still builds and runs, and no action is needed.

The emulator shows its home screen once booting has finished, as shown below.

<!-- TODO screenshot: images/6/emulator_home_screen.png — the Android emulator showing its home screen once booting has finished -->

Either way, the app launches inside the emulator.

<!-- TODO screenshot: images/6/app_running_on_emulator.png — the Sandwich Shop app running inside the Android emulator -->

Now place an order, check out, and confirm it appears on the orders page. Then fully close the app and reopen it: the order is still there, because SQLite saved it to a real file in the emulator's private folder.

<!-- TODO screenshot: images/6/orders_page_on_emulator.png — the orders page on the emulator showing the order that persisted after closing and reopening the app -->

### Your own Windows or Mac laptop: Android Studio

If you have admin rights on your own machine, install [Android Studio](https://developer.android.com/studio) to get the Android SDK and an emulator. During setup, open the SDK Manager and install the Android SDK and a system image, then open the Device Manager and create a virtual device, which is the AVD you will run. The [Flutter install guide](https://docs.flutter.dev/get-started/install) has the full platform setup steps if you need them.

VS Code can set up the toolchain for you as well. Run `flutter doctor`, which checks the Android toolchain and reports anything missing:

```bash
flutter doctor
```

Accept the Android licences when it asks:

```bash
flutter doctor --android-licenses
```

Once an AVD exists, launching and running it is the same as on the lab machines: launch the emulator with `flutter emulators --launch`, pick it in the device selector, and run.

### Mac only: the iOS simulator

On a Mac you can use the iOS simulator instead of an Android emulator. The simulator is Mac-only, as it depends on Apple's developer tools. Install [Xcode](https://docs.flutter.dev/get-started/install/macos) from the App Store, then start the simulator from a terminal:

```bash
open -a Simulator
```

You can also list devices with `flutter emulators` or pick the simulator in the VS Code device selector. With the simulator running, run the app and choose it as the target:

```bash
flutter run
```

The per-platform database open you wrote earlier already covers iOS through the same `sqflite` plugin branch (`TargetPlatform.iOS`), so no code changes are needed to see the same on-disk persistence on the simulator.

## Testing persistence

We test both kinds of persistence. The shared preferences test uses a mock store so no real device storage is touched, and the database tests use SQLite's in-memory mode so they run quickly and leave no file behind. These tests run with `flutter test` just as before, and do not need an emulator; the emulator in [Running the app on a mobile emulator](#running-the-app-on-a-mobile-emulator) is only for seeing the saved file persist by hand.

### Update existing order screen tests

In Worksheet 5, we created `test/order_screen_test.dart`. Because `OrderScreen` now reads and writes shared preferences, open `test/order_screen_test.dart`, import `shared_preferences`, and initialise the mock key-value store in its `setUp` block:

```dart
import 'package:shared_preferences/shared_preferences.dart';
```

```dart
  setUp(() {
    CartRepository.instance.clear();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });
```

This ensures any tests running against `OrderScreen` have a clean, mocked preferences instance.

### Test the shared preferences flow

Create a new file named `test/order_options_prefs_test.dart`. Shared preferences offers `setMockInitialValues`, which fills the store with test data (or clears it) so a test runs without a real device:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Sandwich testSandwich = Sandwich(
  id: 'test',
  name: 'Test Sub',
  description: 'Test description',
  price: 5.0,
  imagePath: 'assets/images/footlong.jpeg',
);

final Finder noteFieldFinder = find.byWidgetPredicate((Widget widget) {
  return widget is TextField &&
      widget.decoration?.labelText == 'Note for the kitchen';
});

void main() {
  setUp(() {
    CartRepository.instance.clear();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('Order screen pre-fills saved options on open', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      prefToasted: true,
      prefVegan: true,
      prefNote: 'No onions',
    });

    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );
    await tester.pumpAndSettle();

    final Switch toastedSwitch = tester.widget<Switch>(
      find.byType(Switch).first,
    );
    final Switch veganSwitch = tester.widget<Switch>(find.byType(Switch).last);
    expect(toastedSwitch.value, isTrue);
    expect(veganSwitch.value, isTrue);
    expect(find.text('No onions'), findsOneWidget);
  });

  testWidgets('Toggling and adding to basket saves options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(prefToasted), isTrue);

    await tester.enterText(noteFieldFinder, 'Extra cheese');
    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.tap(find.text('Add to Basket'));
    await tester.pumpAndSettle();

    final SharedPreferences updated = await SharedPreferences.getInstance();
    expect(updated.getString(prefNote), 'Extra cheese');
  });
}
```

The `setUp` clears the mock store and the basket before each test. The first test seeds the store with saved options before the screen opens and verifies the switches and note field pre-fill. The second test flips the toasted switch, enters a note, taps Add to Basket, and verifies the updated options are saved to `SharedPreferences`.

### Set up an in-memory database

The database tests use two setup functions. `setUpAll` runs its callback once, before all the tests in the file, which suits one-off initialisation. That contrasts with `setUp`, which runs before each test. In `setUpAll` we call `sqfliteFfiInit()` and set `databaseFactory = databaseFactoryFfi` once to prepare the engine. In `setUp` we open a fresh in-memory database and hand it to the helper with `setDatabase`, so each test starts clean. A `tearDown` closes it afterwards.

### Test inserting and reading orders

Create a new file named `test/sandwich_db_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database database;

  setUp(() async {
    database = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE orders (
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
        },
      ),
    );
    SandwichDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await database.close();
    SandwichDatabase.instance.setDatabase(null);
  });

  OrderRecord buildRecord(int orderNumber, String summary, double total) {
    return OrderRecord(
      orderNumber: orderNumber,
      summary: summary,
      note: '',
      toasted: 0,
      vegan: 0,
      total: total,
      date: '01/01/2026 10:00',
    );
  }

  test('insertOrder stores an order and returns its id', () async {
    final int id = await SandwichDatabase.instance.insertOrder(
      buildRecord(1001, '1 x Footlong Sub', 7.50),
    );
    expect(id, greaterThan(0));
    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders.length, 1);
    expect(orders.first.summary, '1 x Footlong Sub');
    expect(orders.first.total, 7.50);
  });

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

  test('getNextOrderNumber increments the current maximum', () async {
    expect(await SandwichDatabase.instance.getNextOrderNumber(), 1001);
    await SandwichDatabase.instance.insertOrder(
      buildRecord(1005, 'Order', 5.0),
    );
    expect(await SandwichDatabase.instance.getNextOrderNumber(), 1006);
  });
}
```

The `setUp` opens an in-memory database with the same orders table and injects it with `setDatabase`, and `tearDown` closes it and clears the injected connection. The small `buildRecord` helper keeps each test short. The three tests check that an inserted order comes back from `getAllOrders` with the right summary and total, that orders return newest first by order number, and that `getNextOrderNumber` starts at `1001` on an empty table and returns one more than the current highest after an insert.

### Update the basket screen tests

In Worksheet 5, `test/basket_screen_test.dart` tested the old checkout behaviour that cleared the basket and printed an inline confirmation. In this worksheet, checkout inserts the order into the SQLite database and navigates to the orders screen.

Update `test/basket_screen_test.dart` to initialise the in-memory SQLite database and test that checkout stores the order record and navigates to `OrdersScreen`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database database;

  setUp(() async {
    CartRepository.instance.clear();
    database = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE orders (
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
        },
      ),
    );
    SandwichDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await database.close();
    SandwichDatabase.instance.setDatabase(null);
  });

  Widget buildApp() {
    return MaterialApp(
      home: const BasketScreen(),
      routes: <String, WidgetBuilder>{
        '/orders': (BuildContext context) {
          return const OrdersScreen();
        },
      },
    );
  }

  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Checkout'), findsNothing);
  });

  testWidgets(
    'BasketScreen renders items and removes item when delete pressed',
    (WidgetTester tester) async {
      const CartItem item = CartItem(
        id: 'footlong',
        name: 'Footlong',
        price: 10.0,
        quantity: 2,
      );
      CartRepository.instance.addItem(item);

      await tester.pumpWidget(buildApp());

      expect(find.text('Your basket'), findsOneWidget);
      expect(find.text('2 x Footlong'), findsOneWidget);
      expect(find.text('£20.00'), findsWidgets);
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    },
  );

  testWidgets(
    'BasketScreen checkout stores the order and navigates to orders',
    (WidgetTester tester) async {
      const CartItem item = CartItem(
        id: 'footlong',
        name: 'Footlong',
        price: 10.0,
        quantity: 1,
      );
      CartRepository.instance.addItem(item);

      await tester.pumpWidget(buildApp());

      late List<Map<String, Object?>> rows;
      await tester.runAsync(() async {
        await tester.tap(find.text('Checkout'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
        rows = await database.query('orders');
      });
      await tester.pump();

      expect(find.byType(OrdersScreen), findsOneWidget);
      expect(CartRepository.instance.getItems(), isEmpty);
      expect(rows.length, 1);
      expect(rows.first['summary'], '1 x Footlong');
      expect(find.byType(SnackBar), findsNothing);
    },
  );
}
```

### Test the orders screen

Create a new file named `test/orders_screen_test.dart` to verify that `OrdersScreen` displays past orders newest first and shows an empty state when no orders have been placed:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<Database> openDatabaseForTest() async {
    final Database database = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE orders (
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
        },
      ),
    );
    SandwichDatabase.instance.setDatabase(database);
    return database;
  }

  testWidgets('OrdersScreen lists seeded orders newest-first', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final Database database = await openDatabaseForTest();
      await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1001,
          summary: '1 x Six-Inch Sub',
          note: '',
          toasted: 0,
          vegan: 0,
          total: 4.50,
          date: '01/01/2026 10:00',
        ),
      );
      await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1002,
          summary: '2 x Footlong Sub',
          note: '',
          toasted: 0,
          vegan: 0,
          total: 15.00,
          date: '02/01/2026 11:00',
        ),
      );

      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await database.close();
      SandwichDatabase.instance.setDatabase(null);
    });
    await tester.pump();

    expect(find.text('Order #1002'), findsOneWidget);
    expect(find.text('Order #1001'), findsOneWidget);
    expect(find.text('2 x Footlong Sub'), findsOneWidget);
    expect(find.byType(Divider), findsNothing);
  });

  testWidgets('OrdersScreen shows an empty state when there are no orders', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final Database database = await openDatabaseForTest();
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await database.close();
      SandwichDatabase.instance.setDatabase(null);
    });
    await tester.pump();

    expect(find.text('No orders yet'), findsOneWidget);
  });
}
```

### Test the app bar navigation actions

Create a new file named `test/widgets/app_bar_actions_test.dart` to verify that both app bar buttons appear across the screens and that tapping the orders action navigates to the orders screen:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const Sandwich testSandwich = Sandwich(
  id: 'test',
  name: 'Test Sub',
  description: 'Test description',
  price: 5.0,
  imagePath: 'assets/images/footlong.jpeg',
);

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    CartRepository.instance.clear();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<Database> openDatabaseForTest() async {
    final Database database = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE orders (
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
        },
      ),
    );
    SandwichDatabase.instance.setDatabase(database);
    return database;
  }

  Widget wrap(Widget home) {
    return MaterialApp(
      home: home,
      routes: <String, WidgetBuilder>{
        '/orders': (BuildContext context) {
          return const OrdersScreen();
        },
      },
    );
  }

  testWidgets('Menu screen shows both basket and orders actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const MenuScreen()));

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });

  testWidgets('Order screen shows both basket and orders actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const OrderScreen(sandwich: testSandwich)));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });

  testWidgets('Basket screen shows both basket and orders actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const BasketScreen()));

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });

  testWidgets('Orders screen shows both basket and orders actions', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final Database database = await openDatabaseForTest();
      await tester.pumpWidget(wrap(const OrdersScreen()));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await database.close();
      SandwichDatabase.instance.setDatabase(null);
    });
    await tester.pump();

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });

  testWidgets('Tapping the orders action navigates to the orders screen', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final Database database = await openDatabaseForTest();
      await tester.pumpWidget(wrap(const MenuScreen()));
      await tester.tap(find.byIcon(Icons.receipt_long));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await database.close();
      SandwichDatabase.instance.setDatabase(null);
    });
    await tester.pump();

    expect(find.byType(OrdersScreen), findsOneWidget);
  });
}
```

Run your test suite with `flutter test` to confirm everything passes:

```bash
flutter test
```

### Commit your changes (7)

Stage your test files, including the updated `order_screen_test.dart` and `basket_screen_test.dart`, and commit your changes with a message of your own.

## Exercises

The exercises below apply the concepts from this worksheet to the Southsea Cinema coursework application. They prepare you for Demo 3 of your coursework. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Remember to commit your changes to Git after each exercise.

1. Following [Adding the dependencies](#adding-the-dependencies), add `shared_preferences`, `sqflite`, `path`, `sqflite_common_ffi`, and `sqflite_common_ffi_web` to your Southsea Cinema fork's `pubspec.yaml`, and run `flutter pub get`.

2. Following [Remembering order options with shared preferences](#remembering-order-options-with-shared-preferences), make your booking screen remember the patron's last option choices with shared preferences, loading them in `initState` and saving them when they change. Decide which small options are worth remembering.

3. Following [Define the order record model](#define-the-order-record-model), add a `TicketTransaction` model in `lib/models/ticket_transaction.dart` with `toMap` and `fromMap`. Decide which fields a cinema ticket sale needs to record, remembering that SQLite stores booleans as `1` or `0`.

4. Following [Create the database helper](#create-the-database-helper), create `lib/database/cinema_db.dart` with a `CinemaDatabase` helper that opens the database, creates a `bookings` table, and seeds a few past bookings matching your own account history.

5. Following [Saving an order at checkout](#saving-an-order-at-checkout), make confirming a purchase save a `TicketTransaction` to `CinemaDatabase.instance`, clear the basket, and take the patron to a bookings screen. Then, following [Showing past orders](#showing-past-orders), build that bookings screen so it reads and lists the stored bookings newest first.

6. Following [Testing persistence](#testing-persistence), write a shared preferences test using `SharedPreferences.setMockInitialValues` for your remembered options, and an in-memory SQLite test using `sqfliteFfiInit`, `databaseFactoryFfi`, and `inMemoryDatabasePath` for your bookings.

7. Decide what matters most about your Demo 3 experience and prove it works: cover the behaviour you care about with automated tests, and make sure `dart analyze` and `flutter test` both pass cleanly. **Show your running application with live SQLite booking persistence to a member of staff** for your Demo 3 sign-off.
