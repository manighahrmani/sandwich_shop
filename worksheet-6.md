# Worksheet 6 — Local data and persistence

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 5](#continue-from-worksheet-5)
  - [Switch to branch 5](#switch-to-branch-5)
- [Loading the menu from JSON](#loading-the-menu-from-json)
  - [Create the JSON asset file](#create-the-json-asset-file)
  - [Register the asset in pubspec](#register-the-asset-in-pubspec)
  - [Add JSON serialisation to the sandwich model](#add-json-serialisation-to-the-sandwich-model)
  - [Unit test JSON serialisation](#unit-test-json-serialisation)
  - [Load JSON data in the repository](#load-json-data-in-the-repository)
- [Two kinds of persistence](#two-kinds-of-persistence)
- [Adding the dependencies](#adding-the-dependencies)
  - [Add the persistence packages](#add-the-persistence-packages)
- [Remembering customer profile settings with shared preferences](#remembering-customer-profile-settings-with-shared-preferences)
  - [Define the preference keys](#define-the-preference-keys)
  - [Load saved settings when the screen opens](#load-saved-settings-when-the-screen-opens)
  - [Save settings when the user submits](#save-settings-when-the-user-submits)
- [Storing orders in SQLite](#storing-orders-in-sqlite)
  - [Define the order record model](#define-the-order-record-model)
  - [Create the database helper](#create-the-database-helper)
  - [Create the orders table and seed past orders](#create-the-orders-table-and-seed-past-orders)
  - [Insert and query orders](#insert-and-query-orders)
- [Adding an orders button to every screen](#adding-an-orders-button-to-every-screen)
  - [Create the orders button](#create-the-orders-button)
  - [Show both buttons on the menu and order screens](#show-both-buttons-on-the-menu-and-order-screens)
- [Saving an order at checkout](#saving-an-order-at-checkout)
  - [Build the order record from the basket](#build-the-order-record-from-the-basket)
  - [Save and navigate on checkout](#save-and-navigate-on-checkout)
- [Showing past orders](#showing-past-orders)
  - [Create the orders screen](#create-the-orders-screen)
  - [Register the orders route](#register-the-orders-route)
- [Running the app on a mobile emulator](#running-the-app-on-a-mobile-emulator)
  - [Lab machines: the Android emulator beta bundle](#lab-machines-the-android-emulator-beta-bundle)
  - [Inspecting the database](#inspecting-the-database)
  - [Your own Windows or Mac laptop: Android Studio](#your-own-windows-or-mac-laptop-android-studio)
  - [Mac only: the iOS simulator](#mac-only-the-ios-simulator)
- [Testing persistence](#testing-persistence)
  - [Test the shared preferences settings flow](#test-the-shared-preferences-settings-flow)
  - [Set up an in-memory database](#set-up-an-in-memory-database)
  - [Test inserting and reading orders](#test-inserting-and-reading-orders)
  - [Update the basket screen tests](#update-the-basket-screen-tests)
  - [Test the orders screen](#test-the-orders-screen)
  - [Test the app bar navigation actions](#test-the-app-bar-navigation-actions)
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

## Loading the menu from JSON

In Worksheet 5 our sandwich menu items were hardcoded in `SandwichRepository`. Hardcoded data is inflexible; adding a new sandwich or altering prices requires modifying Dart code. In this section we move the menu into an external JSON file, register the asset, and load it into our data models.

### Create the JSON asset file

Create a new file named `assets/data/sandwiches.json`:

```json
[
  {
    "id": "footlong",
    "name": "Footlong Sub",
    "description": "A freshly baked 12-inch sandwich filled with savoury ingredients.",
    "price": 7.50,
    "imagePath": "assets/images/footlong.jpeg"
  },
  {
    "id": "six-inch",
    "name": "Six-Inch Sub",
    "description": "A light 6-inch sandwich made with your favourite toppings.",
    "price": 4.50,
    "imagePath": "assets/images/six_inch.jpeg"
  }
]
```

This JSON array contains two sandwich objects matching the fields in our `Sandwich` class.

### Register the asset in pubspec

Flutter requires external assets to be registered in `pubspec.yaml` before they can be bundled with the application. Open `pubspec.yaml` and locate the `flutter:` section:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

Add `- assets/data/` to the list of assets:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/data/
```

Trailing slashes register entire directories. Run `flutter pub get` in your terminal to update the asset bundle. For more details on asset management, see the [Flutter Assets documentation](https://docs.flutter.dev/ui/assets/assets-and-images).

### Add JSON serialisation to the sandwich model

Open `lib/models/sandwich.dart`. We add a factory constructor `Sandwich.fromJson` to parse a `Map<String, dynamic>` into a `Sandwich`, and a `toJson` method to convert it back to a map.

First, add the factory constructor inside `Sandwich`:

```dart
  factory Sandwich.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final String name = json['name'] as String;
    final String description = json['description'] as String;
    final num priceNumber = json['price'] as num;
    final double price = priceNumber.toDouble();
    final String imagePath = json['imagePath'] as String;

    return Sandwich(
      id: id,
      name: name,
      description: description,
      price: price,
      imagePath: imagePath,
    );
  }
```

A factory constructor creates an instance from external data. In Dart, parsing numbers from JSON can yield either an `int` or a `double`. Reading `json['price']` as `num` and calling `.toDouble()` safely converts both representations to `double` without runtime casting errors. The remaining map entries are cast explicitly to `String`.

Now add `toJson` to convert a sandwich back to a map:

```dart
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
    };
    return data;
  }
```

The `toJson` method packs the sandwich fields into a `Map<String, dynamic>` ready for JSON encoding.

### Unit test JSON serialisation

Open `test/sandwich_model_test.dart`. Add a test verifying JSON decoding with `fromJson`:

```dart
    test('fromJson creates a Sandwich instance from valid JSON map', () {
      final Map<String, dynamic> jsonMap = <String, dynamic>{
        'id': 'veggie-delight',
        'name': 'Veggie Delight',
        'description': 'Crisp garden vegetables on fresh bread.',
        'price': 5.50,
        'imagePath': 'assets/images/six_inch.jpeg',
      };

      final Sandwich sandwich = Sandwich.fromJson(jsonMap);

      expect(sandwich.id, 'veggie-delight');
      expect(sandwich.name, 'Veggie Delight');
      expect(sandwich.price, 5.50);
      expect(sandwich.imagePath, 'assets/images/six_inch.jpeg');
    });
```

This test passes a map containing sandwich attributes to `Sandwich.fromJson` and asserts that each property is extracted and cast to its expected value.

Now add a test verifying map serialisation with `toJson`:

```dart
    test('toJson serialises a Sandwich instance into a JSON map', () {
      const Sandwich sandwich = Sandwich(
        id: 'meatball',
        name: 'Meatball Marinara',
        description: 'Italian meatballs in rich marinara sauce.',
        price: 8.00,
        imagePath: 'assets/images/footlong.jpeg',
      );

      final Map<String, dynamic> jsonMap = sandwich.toJson();

      expect(jsonMap['id'], 'meatball');
      expect(jsonMap['name'], 'Meatball Marinara');
      expect(jsonMap['price'], 8.00);
      expect(jsonMap['imagePath'], 'assets/images/footlong.jpeg');
    });
```

This test constructs a constant `Sandwich` model, calls `sandwich.toJson()`, and verifies that the output map contains the corresponding keys and values.

Run your model tests:

```bash
flutter test test/sandwich_model_test.dart
```

All model tests should pass.

### Load JSON data in the repository

Open `lib/repositories/sandwich_repository.dart`. First, import the necessary JSON and asset packages at the top of the file:

```dart
import 'dart:convert';

import 'package:flutter/services.dart';
```

The `dart:convert` library provides `jsonDecode` to convert JSON text into Dart lists and maps. The `package:flutter/services.dart` library provides `rootBundle`, which accesses static asset files bundled with your application.

Next, declare a nullable cache list inside `SandwichRepository` to store loaded sandwiches:

```dart
  List<Sandwich>? _cachedSandwiches;
```

Now add `loadSandwichesFromAsset` to load and decode the JSON asset:

```dart
  Future<List<Sandwich>> loadSandwichesFromAsset({
    String assetPath = 'assets/data/sandwiches.json',
  }) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;

    final List<Sandwich> loadedSandwiches = [];
    for (final dynamic item in jsonList) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Sandwich sandwich = Sandwich.fromJson(itemMap);
      loadedSandwiches.add(sandwich);
    }

    _cachedSandwiches = loadedSandwiches;
    return loadedSandwiches;
  }
```

Calling `rootBundle.loadString(assetPath)` reads the asset file asynchronously into a `String`. Calling `jsonDecode(jsonString)` parses the raw text into a `List<dynamic>`. The explicit `for-in` loop iterates through the decoded entries, casts each item to a `Map<String, dynamic>`, and decodes it using `Sandwich.fromJson`. The method saves the loaded list to `_cachedSandwiches` and returns it.

Update `getSandwiches()` to return the cached list when available:

```dart
  List<Sandwich> getSandwiches() {
    if (_cachedSandwiches != null) {
      return _cachedSandwiches!;
    }
    return const [
      Sandwich(
        id: 'footlong',
        name: 'Footlong Sub',
        description:
            'A freshly baked 12-inch sandwich filled with savoury ingredients.',
        price: 7.50,
        imagePath: 'assets/images/footlong.jpeg',
      ),
      Sandwich(
        id: 'six-inch',
        name: 'Six-Inch Sub',
        description:
            'A light 6-inch sandwich made with your favourite toppings.',
        price: 4.50,
        imagePath: 'assets/images/six_inch.jpeg',
      ),
    ];
  }
```

If `loadSandwichesFromAsset()` was previously awaited, `_cachedSandwiches` holds the loaded sandwiches and `getSandwiches()` returns them directly. If not, the method falls back to returning the const list of default sandwiches so callers that do not await asynchronous loading still receive data.

## Two kinds of persistence

Bundling a JSON file with your application provides static catalogue data, but it is read-only at runtime. In Worksheet 5 everything else lived in memory: the customer profile details a user entered and the sandwiches in their basket vanished the moment the app restarted or the browser tab refreshed. In this worksheet we make two different kinds of data survive a restart, using the right tool for each.

Customer profile settings, such as full name, delivery address, email, and whether to receive newsletter updates, are small, loose pieces of interface state. There are only a few of them and we never need to search or sort them. For data like that we use shared preferences, a simple store of key-and-value pairs saved on the device. We read the last-used settings back when the profile screen opens, so a returning user does not retype them.

The orders themselves are different. Each is a structured record with a number, a summary, a date, and a total, and we want to list them newest first and could later filter them by date. For structured, queryable records like that we use SQLite, a small relational database stored in a single file. We save each completed order as a row and read them back on an orders screen.

The contrast is the lesson: reach for shared preferences for a handful of simple settings, and for a relational database such as SQLite when you have many structured records you need to query. We build the shared preferences part first because it extends the settings screen you already know, then move on to the database.

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
  sqlite3: "3.5.2"
```

Run `flutter pub get` in your terminal to download the packages:

```bash
flutter pub get
```

## Remembering customer profile settings with shared preferences

We start with the lighter kind of persistence. The settings screen from Worksheet 5 already has three text fields and a switch toggle. We make the app remember the user's profile choices and pre-fill the form with them next time the screen opens.

Shared preferences stores values under string keys. You read a value with a typed getter such as `getBool` or `getString`, and write one with `setBool` or `setString`. Reading and writing touch the device, so the methods are asynchronous and return a `Future` (the pattern from Worksheet 4).

### Define the preference keys

Open `lib/screens/settings_screen.dart`. First import the package, then define constant keys at the top of the file so we never mistype a key name:

```dart
import 'package:shared_preferences/shared_preferences.dart';

const String prefName = 'user_name';
const String prefAddress = 'user_address';
const String prefEmail = 'user_email';
const String prefNewsletter = 'user_newsletter';
```

Each key is a plain `const String`. Using named constants rather than typing `'user_name'` in several places means the compiler, not you, keeps the names consistent. Add this import alongside the existing imports at the top of the file, and the four keys just below them.

### Load saved settings when the screen opens

We load the saved profile settings as soon as the screen appears. Add a loader method to `_SettingsScreenState`, and call it from `initState`.

First, read the saved values asynchronously from `SharedPreferences`:

```dart
  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedName = prefs.getString(prefName);
    final String? savedAddress = prefs.getString(prefAddress);
    final String? savedEmail = prefs.getString(prefEmail);
    final bool? savedNewsletter = prefs.getBool(prefNewsletter);
```

`SharedPreferences.getInstance()` hands back the shared store asynchronously. Then `prefs.getString` and `prefs.getBool` read the saved values using our constant keys. The first time the app runs, nothing is stored yet, so these calls return nullable types (`String?` or `bool?`).

Next, assign fallback defaults using `if` checks:

```dart
    String name = '';
    if (savedName != null) {
      name = savedName;
    }

    String address = '';
    if (savedAddress != null) {
      address = savedAddress;
    }

    String email = '';
    if (savedEmail != null) {
      email = savedEmail;
    }

    bool newsletter = false;
    if (savedNewsletter != null) {
      newsletter = savedNewsletter;
    }
```

We check each nullable result. If a value was found, we keep it; otherwise we default strings to empty text and the newsletter boolean to `false`.

Finally, guard with a `mounted` check and update state:

```dart
    if (!mounted) {
      return;
    }
    setState(() {
      _nameController.text = name;
      _addressController.text = address;
      _emailController.text = email;
      _receiveNewsletter = newsletter;
    });
  }
```

The `if (!mounted) return;` check ensures that after an `await`, calling `setState` only occurs if the widget is still active in the widget tree. We then copy the resolved values into the controllers and newsletter flag.

Now call the loader from `initState`:

```dart
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _loadSettings();
  }
```

### Save settings when the user submits

Next update the save method in `_SettingsScreenState` to write the values back to the store.

First, read the trimmed text and persist the values:

```dart
  Future<void> _saveSettings() async {
    final String name = _nameController.text.trim();
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefName, name);
    await prefs.setString(prefAddress, address);
    await prefs.setString(prefEmail, email);
    await prefs.setBool(prefNewsletter, _receiveNewsletter);
```

We read each controller using `.text.trim()` to strip surrounding whitespace. We obtain the preferences instance and save each setting with `setString` or `setBool`, overwriting any previously stored value.

Next, build the `UserSettings` model and update screen feedback:

```dart
    final UserSettings settings = UserSettings(
      name: name,
      address: address,
      email: email,
      receiveNewsletter: _receiveNewsletter,
    );

    if (!mounted) {
      return;
    }
    setState(() {
      _confirmationMessage = 'Settings saved for ${settings.name}';
    });
  }
```

We construct a `UserSettings` instance, verify that the widget remains `mounted`, and update `_confirmationMessage` inside `setState()` so the confirmation line appears below the button.

Each `set` call stores one value under its key, overwriting what was there. Update the **Save Settings** button in the `build` method to invoke `_saveSettings`:

```dart
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Save Settings',
                onPressed: _saveSettings,
              ),
            ),
```

## Storing orders in SQLite

Now for the heavier kind of persistence. We store each completed order as a row in a SQLite database so the orders survive restarts and can be listed and queried.

SQLite is a small relational database engine. It needs no separate server; the whole database is a single file on disk, or kept in memory for tests. We store orders in a table of rows and columns, give each row a unique id, and read them back sorted by order number.

### Define the order record model

Create a new file named `lib/models/order_record.dart`.

First, define the class and declare its fields:

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
```

The `id` field has the nullable type `int?` and is not `required`. A record we have just built in memory has no `id` yet: SQLite assigns one when the row is inserted. So `id` is `null` before saving and holds a number afterwards. Note that `toasted` and `vegan` are stored as `int` here, not `bool`: SQLite has no boolean type, so we use `1` for true and `0` for false.

Now add the `const` constructor:

```dart
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
```

This model converts to and from a database row, just as `Sandwich` converted to and from JSON earlier in this worksheet. The database equivalent of `toJson` and `fromJson` is a pair named `toMap` and `fromMap`, which produce and read the `Map<String, Object?>` of column names to values that the database methods expect. Add `toMap` first, inside the class:

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

Now add the `fromMap` factory constructor, which reads a row map back into an `OrderRecord`. Start by extracting and casting the fields from the map:

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
```

As in the earlier JSON serialisation section, we read each value out of the map and use `as` to assert its type, reading the total as a `num` and calling `.toDouble()`.

Finally, return the newly instantiated `OrderRecord`:

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
  }
}
```

The `id` might be missing from an unpersisted map, so we read it as the nullable `int?`.

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

Now seed a few past orders so the orders screen has something to show the first time a student opens it. Still inside `_createDB`, insert the first order:

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

The `db.insert` method adds one row to a named table from a `Map<String, Object?>` whose keys match the column names.

Now insert the remaining two seed orders and close the method:

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

Because `_createDB` runs only when the database is first created, this seeding happens once. The coursework asks you to seed your own account history in the same way.

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

## Adding an orders button to every screen

Now that orders are saved, the user needs a way to reach them from anywhere in the app. In Worksheet 5 you built the reusable `BasketButton` as an app bar action shown on every screen. We follow the same pattern here with an orders button, so a single widget carries the behaviour and every screen simply lists it.

### Create the orders button

Create a new file named `lib/widgets/orders_button.dart`, mirroring `basket_button.dart`.

Start with the widget shell and icon button:

```dart
import 'package:flutter/material.dart';

class OrdersButton extends StatelessWidget {
  const OrdersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.receipt_long),
      onPressed: () {
```

`OrdersButton` is a `StatelessWidget` that displays a receipt icon (`Icons.receipt_long`) inside an `IconButton`.

Now add the route inspection and navigation logic inside `onPressed`:

```dart
        ModalRoute<dynamic>? modalRoute = ModalRoute.of(context);
        String currentRoute = '';

        if (modalRoute != null) {
          RouteSettings settings = modalRoute.settings;
          String? routeName = settings.name;
          if (routeName != null) {
            currentRoute = routeName;
          }
        }

        if (currentRoute != '/orders') {
          Navigator.pushNamed(context, '/orders');
        }
      },
    );
  }
}
```

The `onPressed` callback reads the current route name and pushes `'/orders'` unless the user is already on the orders screen. We register the `'/orders'` route and build the screen it opens later in this worksheet.

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

## Saving an order at checkout

The basket screen already has a Checkout button that clears the basket. We now make it save the order to SQLite first, then take the user to a screen listing their orders.

### Build the order record from the basket

Open `lib/screens/basket_screen.dart`. First add the three imports we need at the top, alongside the existing ones. Two give us the database and the record model, and the third is the orders button we add to the app bar shortly:

```dart
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/widgets/orders_button.dart';
```

A basket can hold several items, but an order is one record, so we need a helper that folds the basket down into the summary string our table stores. Add this inside `_BasketScreenState`:

```dart
  String _buildSummary(List<CartItem> items) {
    final List<String> parts = [];
    for (final CartItem item in items) {
      parts.add('${item.quantity} x ${item.sandwich.name}');
    }
    return parts.join(', ');
  }
```

`_buildSummary` gathers each line into a short string such as `2 x Footlong Sub, 1 x Six-Inch Sub`.

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

Add the method that runs when the user checks out. It is `async` because saving to the database takes time.

First, set initial feedback to inform the user that saving has begun:

```dart
  Future<void> _checkout(CartRepository cart, List<CartItem> items) async {
    setState(() {
      _confirmationMessage = 'Saving your order...';
    });
```

Now, inside a `try` block, fetch the order number, build the record, and insert it into SQLite:

```dart
    try {
      final SandwichDatabase database = SandwichDatabase.instance;
      final int orderNumber = await database.getNextOrderNumber();
      final OrderRecord record = OrderRecord(
        orderNumber: orderNumber,
        summary: _buildSummary(items),
        total: cart.getTotalDue(),
        date: _formatDate(DateTime.now()),
      );
      await database.insertOrder(record);
      cart.clear();
```

Inside `try`, it asks the database for the next order number, builds an `OrderRecord` from the basket using the helper, saves it with `insertOrder`, and clears the in-memory cart.

Finally, handle success navigation and catch errors:

```dart
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

The `if (!mounted) return;` guard ensures that after the `await`, we only touch the screen if it is still on display. On success it updates the confirmation message and navigates to the registered `'/orders'` route. If an error occurs, the `catch` block displays the error message so database issues are clearly visible.

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

Next add a helper that turns one order's options into a short line of text, so the toggles and note show beneath the summary.

First, check which options apply and collect them into a list:

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
```

Because the table stores `toasted` and `vegan` as `1` or `0`, we check each against `1`.

Now return an empty box if no options apply, or join the parts with a bullet separator:

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
  }
```

This mirrors the options line you built on the basket screen in Worksheet 5.

Now add the helper that builds one card per order. Start with the `Card` wrapper and header row showing the order number and total:

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
```

A `Card` is Flutter's lightly raised panel. Inside it, `MainAxisAlignment.spaceBetween` places the order number on the left and the total on the right.

Now append the summary, options line, and date:

```dart
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

There is no `Divider` and no coloured quantity circle, so the orders list reads as cleanly as the basket.

Finally, implement the `build` method. Start by choosing the `body` widget between loading, empty, and populated states:

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
```

While `_loading` is `true` the body is an empty `SizedBox.shrink()`, which takes no space. Once loading finishes, an empty table shows the "No orders yet" message, and a filled one shows a `ListView.builder` of order cards.

Now return the `Scaffold` shell with the standard app bar actions:

```dart
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

The `AppBar` carries the same `const [BasketButton(), OrdersButton()]` pair as every other screen.

Your orders screen, showing the seeded orders and any you place, should look like this:

![The orders screen listing past orders as cards](images/6/orders_screen.png)

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

## Running the app on a mobile emulator

Every earlier worksheet ran the app in a web browser on Chrome or Edge, and it still runs there exactly as before. The browser is fine for most of what we do, but it hides one thing this worksheet is about: the on-disk SQLite file. In the browser the database lives in storage the browser manages for us, so you cannot watch a real file survive a full close and reopen the way it would on a phone.

A mobile emulator is a virtual Android phone that runs on your computer, and a simulator is the same idea for iOS on a Mac. Running the app on one of these lets you place an order, close the app completely, reopen it, and see the saved orders still there, because the SQLite database is a genuine file in the device's private folder. The emulator is not a hard requirement; the app runs on the web just as it did before, and the emulator is only there to show native persistence.

There are three routes to the same outcome, and you only need one. On a university lab machine, use the emulator beta bundle. On your own Windows or Mac laptop, install Android Studio. On a Mac, you can instead use the iOS simulator. Pick the route that matches your machine and follow it.

### Lab machines: the Android emulator beta bundle

Earlier worksheets set up the lab machines with a portable Flutter and VS Code bundle. That standard bundle does not include the Android SDK, so it cannot run an emulator. A separate experimental build of the bundle adds everything an emulator needs. You can find it in the Experimental section of the bundle README at [the flutter_vscode_package repository](https://github.com/manighahrmani/flutter_vscode_package), listed as the Android emulator beta release.

On top of the normal portable environment, the beta bundle ships a JDK, a command-line Android SDK, and a pre-made virtual device, an AVD named `flutter_emulator`. Like the main script, it finishes by opening VS Code on your cloned project, so you land in the same place as before with the extra tooling in place. The beta is experimental and needs hardware acceleration enabled on the machine, which the lab machines already have.

This Android bundle is a separate, larger installer that takes significantly longer to run than the normal bundle, and you only need it from Worksheet 6 onwards, because this is the first worksheet whose app uses a SQLite database; for Worksheets 1 to 5 the normal bundle plus Edge is enough.

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

You can run the app from VS Code instead of the terminal. With the emulator booted, pick it as the target device in the status bar device selector in the bottom-right (or through the Command Palette entry **Flutter: Select Device**), then start the app with **F5** or Run, as shown below:

![The VS Code status bar device selector listing the booted emulator](images/6/device_selector.png)

Choose the emulator as your run device, or Edge if you want the web version. Do not choose the `Windows` device: Windows desktop builds need Developer Mode and fail with a `Building with plugins requires symlink support` error. If you see that error, switch the device back to the emulator or Edge.

The first emulator build is slow, because it downloads `Gradle` and the build-tools and compiles the app, so give it time. During the build you may also see warnings that certain `Gradle`, `AGP`, or `Kotlin` versions will soon be dropped. These are harmless, the app still builds and runs, and no action is needed.

The emulator shows its home screen once booting has finished, as shown below:

![The Android emulator showing its home screen](images/6/emulator_home_screen.png)

Either way, the app launches inside the emulator, as shown below:

![The Sandwich Shop app running inside the Android emulator](images/6/app_running_on_emulator.png)

Now place an order, check out, and confirm it appears on the orders page. Then fully close the app and reopen it: the order is still there, because SQLite saved it to a real file in the emulator's private folder, as shown below:

![The orders page on the emulator showing the persisted order](images/6/orders_page_on_emulator.png)

### Inspecting the database

The database file lives inside the emulator, in the app's own private folder, under the package `com.example.sandwich_shop` as the file `databases/sandwich_data.db`. Because that folder belongs to the app, you cannot open the file in place; you copy it out of the emulator and onto your computer, then open the copy with the SQLite Viewer extension the beta bundle ships. Do this only after you have run the app at least once, so that the database file has actually been created.

Copy the database out with the two commands below, run in order in your terminal. The first uses `run-as` to read the file from inside the app's private sandbox and write it to a temporary location the next command can reach, and the second pulls that copy onto your computer as `sandwich_shop.db`:

```bash
adb shell "run-as com.example.sandwich_shop cat databases/sandwich_data.db > /data/local/tmp/s.db"
adb pull /data/local/tmp/s.db sandwich_shop.db
```

Once the pull finishes, open the resulting `sandwich_shop.db` in VS Code by clicking it in the Explorer. The SQLite Viewer extension opens the file and shows the `orders` table and its rows, the seeded past orders together with any orders you have placed yourself, as shown below:

![The SQLite Viewer showing the orders table rows](images/6/sqlite_viewer_orders_table.png)

This is an optional way to confirm the data is really stored, since the orders screen already shows it in the app.

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

### Test the shared preferences settings flow

Create a new file named `test/settings_screen_test.dart`. Shared preferences offers `setMockInitialValues`, which fills the store with test data (or clears it) so a test runs without a real device.

Start with the imports, `main` function, and `setUp`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });
```

The `setUp` callback calls `SharedPreferences.setMockInitialValues(<String, Object>{})` to clear the mock store before each test.

Now add a test verifying that the form fields and switch appear:

```dart
  testWidgets('SettingsScreen displays form fields and switches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));

    expect(find.text('Customer Profile'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
  });
```

This test confirms that the `Customer Profile` title, three `TextField` inputs, one `Switch` toggle, and the **Save Settings** button appear on screen.

Next, add a test verifying that saved settings pre-fill the form on open:

```dart
  testWidgets('SettingsScreen pre-fills saved settings on open', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      prefName: 'Jordan Lee',
      prefAddress: '15 High Street, Portsmouth',
      prefEmail: 'jordan@example.com',
      prefNewsletter: true,
    });

    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Jordan Lee'), findsOneWidget);
    expect(find.text('15 High Street, Portsmouth'), findsOneWidget);
    expect(find.text('jordan@example.com'), findsOneWidget);
    final Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
    expect(switchWidget.value, isTrue);
  });
```

This test seeds the store with customer details before the screen opens. `tester.pumpAndSettle()` waits for the asynchronous `_loadSettings()` call to finish and confirms that the fields and switch are pre-filled.

Finally, add a test verifying that submitting the form persists the updated settings:

```dart
  testWidgets('Toggling switch and saving settings updates SharedPreferences', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));

    final Finder nameField = find.widgetWithText(TextField, 'Full name');
    final Finder addressField =
        find.widgetWithText(TextField, 'Delivery address');
    final Finder emailField = find.widgetWithText(TextField, 'Email address');

    await tester.enterText(nameField, 'Alex Smith');
    await tester.enterText(addressField, '10 Elm Road, Portsmouth');
    await tester.enterText(emailField, 'alex@example.com');

    final Finder switchFinder = find.byType(Switch);
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.tap(find.text('Save Settings'));
    await tester.pump();

    expect(find.text('Settings saved for Alex Smith'), findsOneWidget);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(prefName), 'Alex Smith');
    expect(prefs.getString(prefAddress), '10 Elm Road, Portsmouth');
    expect(prefs.getString(prefEmail), 'alex@example.com');
    expect(prefs.getBool(prefNewsletter), isTrue);
  });
}
```

This test enters new customer details, flips the newsletter switch, taps **Save Settings**, and asserts that the updated profile is written to `SharedPreferences`.

### Set up an in-memory database

The database tests use two setup functions. `setUpAll` runs its callback once, before all the tests in the file, which suits one-off initialisation. That contrasts with `setUp`, which runs before each test. In `setUpAll` we call `sqfliteFfiInit()` and set `databaseFactory = databaseFactoryFfi` once to prepare the engine. In `setUp` we open a fresh in-memory database and hand it to the helper with `setDatabase`, so each test starts clean. A `tearDown` closes it afterwards.

### Test inserting and reading orders

Create a new file named `test/sandwich_db_test.dart`.

Start by importing test packages, models, and initializing the FFI database factory:

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
```

We call `sqfliteFfiInit()` and set `databaseFactory = databaseFactoryFfi` in `setUpAll` to prepare the SQLite engine once before running tests.

Now configure database creation in `setUp` and closing the connection in `tearDown`:

```dart
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
```

In `setUp` we open an in-memory SQLite database, run the create-table query, and inject it into `SandwichDatabase.instance` using `setDatabase`. The `tearDown` callback closes the database and resets the instance so tests do not interfere with each other.

Next, add a helper function to construct test order records:

```dart
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
```

The `buildRecord` helper creates sample `OrderRecord` instances with default values for tests.

Now add a test verifying that inserting an order stores its fields and generates an id:

```dart
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
```

This test checks that `insertOrder` adds a row, gives back a positive integer id, and returns matching values when read back with `getAllOrders`.

Next, add a test verifying descending order sort:

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

This test inserts orders out of sequence and verifies that `getAllOrders` returns them sorted newest first by order number.

Finally, add a test checking auto-incrementing order numbers:

```dart
  test('getNextOrderNumber increments the current maximum', () async {
    expect(await SandwichDatabase.instance.getNextOrderNumber(), 1001);
    await SandwichDatabase.instance.insertOrder(
      buildRecord(1005, 'Order', 5.0),
    );
    expect(await SandwichDatabase.instance.getNextOrderNumber(), 1006);
  });
}
```

This test verifies that an empty database starts numbering at `1001`, and returns one higher than the largest existing order number once records exist.

### Update the basket screen tests

In Worksheet 5, `test/basket_screen_test.dart` tested the old checkout behaviour that cleared the basket and printed an inline confirmation. In this worksheet, checkout inserts the order into the SQLite database and navigates to the orders screen.

Update `test/basket_screen_test.dart` to initialise the in-memory SQLite database and test that checkout stores the order record and navigates to `OrdersScreen`.

Start by updating the imports and declaring the sample sandwich fixture:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const Sandwich testSandwich = Sandwich(
  id: 'footlong',
  name: 'Footlong Sub',
  description: 'Classic freshly baked sub.',
  price: 10.0,
  imagePath: 'assets/images/footlong.jpeg',
);
```

Next, define `main` and initialise SQLite FFI in `setUpAll`:

```dart
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });
```

We initialise the SQLite FFI engine once before running tests.

Now add `setUp` and `tearDown` to manage the in-memory database lifecycle:

```dart
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
```

In `setUp` we reset the in-memory cart, create a fresh in-memory database with the `orders` table, and inject it into `SandwichDatabase.instance`. In `tearDown`, we close the database and clear the singleton reference.

Now add the `buildApp` navigation wrapper helper:

```dart
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
```

The `buildApp` helper wraps `BasketScreen` in a `MaterialApp` with the `'/orders'` route registered so the screen can navigate on checkout.

Now add the test checking the empty basket state:

```dart
  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Checkout'), findsNothing);
  });
```

This test confirms that when the cart is empty, the empty message is displayed and the Checkout button is hidden.

Next, add the test verifying line item display and item deletion:

```dart
  testWidgets(
    'BasketScreen renders items and removes item when delete pressed',
    (WidgetTester tester) async {
      const CartItem item = CartItem(
        sandwich: testSandwich,
        quantity: 2,
      );
      CartRepository.instance.addItem(item);

      await tester.pumpWidget(buildApp());

      expect(find.text('Your basket'), findsOneWidget);
      expect(find.text('2 x Footlong Sub'), findsOneWidget);
      expect(find.text('£20.00'), findsWidgets);
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    },
  );
```

This test verifies that items in the basket display their quantities and prices, and that tapping delete empties the cart.

Finally, add the test verifying that checking out inserts an order row into SQLite and navigates:

```dart
  testWidgets(
    'BasketScreen checkout stores the order and navigates to orders',
    (WidgetTester tester) async {
      const CartItem item = CartItem(
        sandwich: testSandwich,
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
      expect(rows.first['summary'], '1 x Footlong Sub');
      expect(find.byType(SnackBar), findsNothing);
    },
  );
}
```

This test runs the asynchronous database insert inside `tester.runAsync`, asserts that an order row was written to the `orders` table, verifies that the in-memory cart cleared, and confirms navigation to `OrdersScreen`.

### Test the orders screen

Create a new file named `test/orders_screen_test.dart` to verify that `OrdersScreen` displays past orders newest first and shows an empty state when no orders have been placed.

Start with the imports, `main` setup, and engine initialisation:

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
```

We import the testing tools and initialise the SQLite FFI database factory in `setUpAll`.

Now add the database helper that prepares an in-memory test database:

```dart
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
```

The `openDatabaseForTest` helper creates an in-memory database with the `orders` table and injects it into `SandwichDatabase.instance`.

Now add a test verifying that orders display newest first:

```dart
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
```

This test seeds order #1001 and order #1002, pumps `OrdersScreen`, and confirms that order #1002 appears first.

Finally, add a test checking the empty state when no orders exist:

```dart
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

This test opens `OrdersScreen` with an empty table and verifies that the "No orders yet" placeholder message is rendered.

### Test the app bar navigation actions

Create a new file named `test/widgets/app_bar_actions_test.dart` to verify that both app bar buttons appear across the screens and that tapping the orders action navigates to the orders screen.

Start with the imports and sample sandwich fixture:

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
```

Now define `main`, initialise the test engine, and reset test state:

```dart
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    CartRepository.instance.clear();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });
```

We initialise the database engine in `setUpAll`, and clear both the cart repository and mock shared preferences in `setUp` before each test.

Now add the database helper that prepares an in-memory test database:

```dart
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
```

The `openDatabaseForTest` helper creates an in-memory database with the `orders` table and injects it into `SandwichDatabase.instance`.

Next, add the test harness wrapper helper:

```dart
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
```

The `wrap` helper wraps any screen in `MaterialApp` with the `'/orders'` route registered so app bar actions can be tested uniformly.

Now verify that both action icons appear on the menu screen:

```dart
  testWidgets('Menu screen shows both basket and orders actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const MenuScreen()));

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });
```

This test verifies that `Icons.shopping_basket` and `Icons.receipt_long` both render on `MenuScreen`.

Now add tests verifying the actions on the order and basket screens:

```dart
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
```

These tests verify that both action buttons also render on `OrderScreen` and `BasketScreen`.

Now test the orders screen with an active database connection:

```dart
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
```

This test confirms that `OrdersScreen` renders both app bar action icons once loaded from the database.

Finally, add a test verifying navigation when tapping the receipt action:

```dart
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

This test simulates tapping the orders receipt button on `MenuScreen` and confirms that the navigator transitions to `OrdersScreen`.

Run your test suite with `flutter test` to confirm everything passes:

```bash
flutter test
```

## Exercises

The exercises below apply the concepts from this worksheet to the Southsea Cinema coursework application. They prepare you for Demo 3 of your coursework. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Remember to commit your changes to Git after each exercise.

1. Following [Loading the menu from JSON](#loading-the-menu-from-json), move your film listings into a JSON asset file, register it in `pubspec.yaml`, and implement `fromJson` and `toJson` methods on your cinema models.

2. Following [Adding the dependencies](#adding-the-dependencies), add `shared_preferences`, `sqflite`, `path`, `sqflite_common_ffi`, and `sqflite_common_ffi_web` to your Southsea Cinema fork's `pubspec.yaml`, and run `flutter pub get`.

3. Following [Remembering customer profile settings with shared preferences](#remembering-customer-profile-settings-with-shared-preferences), make your settings or booking screen remember the patron's details or option choices with shared preferences, loading them in `initState` and saving them when they change. Decide which patron settings are worth remembering.

4. Following [Define the order record model](#define-the-order-record-model), add a `TicketTransaction` model in `lib/models/ticket_transaction.dart` with `toMap` and `fromMap`. Decide which fields a cinema ticket sale needs to record, remembering that SQLite stores booleans as `1` or `0`.

5. Following [Create the database helper](#create-the-database-helper), create `lib/database/cinema_db.dart` with a `CinemaDatabase` helper that opens the database, creates a `bookings` table, and seeds a few past bookings matching your own account history.

6. Following [Saving an order at checkout](#saving-an-order-at-checkout), make confirming a purchase save a `TicketTransaction` to `CinemaDatabase.instance`, clear the basket, and take the patron to a bookings screen. Then, following [Showing past orders](#showing-past-orders), build that bookings screen so it reads and lists the stored bookings newest first.

7. Following [Testing persistence](#testing-persistence), write a shared preferences test using `SharedPreferences.setMockInitialValues` for your remembered options, and an in-memory SQLite test using `sqfliteFfiInit`, `databaseFactoryFfi`, and `inMemoryDatabasePath` for your bookings.

8. Decide what matters most about your Demo 3 experience and prove it works: cover the behaviour you care about with automated tests, and make sure `dart analyze` and `flutter test` both pass cleanly. **Show your running application with live SQLite booking persistence to a member of staff** for your Demo 3 sign-off.

9. (Advanced challenge — Focus management and input controls) Following the [Flutter user-input tutorial](https://docs.flutter.dev/learn/pathway/tutorial/user-input), enrich your cinema settings or booking form with programmatic focus management and user controls. Use a `FocusNode` to focus the primary input field automatically when entering edit mode with `focusNode.requestFocus()`, add an `IconButton` inside the input decoration to clear text using `controller.clear()`, and clean up your `FocusNode` in `dispose`.

10. (Advanced challenge — Test directory mirroring and coverage) Prepare ahead for Demo 4 requirements by restructuring your `test/` directory to strictly mirror the organisation of `lib/` (for example `test/models/`, `test/views/`, `test/repositories/`, `test/database/`, `test/widgets/`). Install the Flutter Coverage extension in VS Code and run `flutter test --coverage` in the terminal to inspect line-by-line coverage and identify untested branches across your models and repositories.
