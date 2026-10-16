# Worksheet 6 — Local data and persistence

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 5](#continue-from-worksheet-5)
  - [Use branch 5 for a clean starting point](#use-branch-5-for-a-clean-starting-point)
- [Choosing where to store the data](#choosing-where-to-store-the-data)
- [Preparing an Android emulator](#preparing-an-android-emulator)
  - [Install the Android bundle on university computers](#install-the-android-bundle-on-university-computers)
  - [Set up an emulator on your own computer](#set-up-an-emulator-on-your-own-computer)
  - [Select the emulator and run the app](#select-the-emulator-and-run-the-app)
- [Loading the menu from a JSON asset](#loading-the-menu-from-a-json-asset)
  - [Create and register the JSON asset](#create-and-register-the-json-asset)
  - [Convert a JSON map into a sandwich](#convert-a-json-map-into-a-sandwich)
  - [Convert a sandwich back into a map](#convert-a-sandwich-back-into-a-map)
  - [Test both sandwich conversions](#test-both-sandwich-conversions)
  - [Read the asset in the repository](#read-the-asset-in-the-repository)
  - [Load the menu when the screen opens](#load-the-menu-when-the-screen-opens)
  - [Display loading and error states](#display-loading-and-error-states)
  - [Update the menu and app tests](#update-the-menu-and-app-tests)
- [Adding the persistence packages](#adding-the-persistence-packages)
- [Remembering the customer profile with shared preferences](#remembering-the-customer-profile-with-shared-preferences)
  - [Define the preference keys](#define-the-preference-keys)
  - [Read saved values when settings opens](#read-saved-values-when-settings-opens)
  - [Fill the form after loading](#fill-the-form-after-loading)
  - [Save the profile before showing confirmation](#save-the-profile-before-showing-confirmation)
  - [Test loading and saving preferences](#test-loading-and-saving-preferences)
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
  - [Create one in-memory database helper for tests](#create-one-in-memory-database-helper-for-tests)
  - [Test inserting, reading and numbering orders](#test-inserting-reading-and-numbering-orders)
  - [Update the basket checkout test](#update-the-basket-checkout-test)
  - [Test the orders list and its empty state](#test-the-orders-list-and-its-empty-state)
  - [Test navigation and run the complete suite](#test-navigation-and-run-the-complete-suite)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 5

Open the Sandwich Shop project you completed in [Worksheet 5](worksheet-5.md). We keep its basket, customer profile form, shared theme and navigation, then add local storage.

### Use branch 5 for a clean starting point

If you need a fresh copy, follow [cloning the repository in Worksheet 5](worksheet-5.md#clone-the-sandwich-shop-repository). In that copy, select the Worksheet 5 end state:

```bash
git checkout 5
flutter pub get
flutter test
```

Do not switch branches over unfinished work. Branch `6` contains the completed Sandwich Shop application for this worksheet; use it to compare your finished work, not as your starting point.

## Choosing where to store the data

Persistence means keeping data after the app closes. We use three stores for different purposes:

- A bundled JSON asset holds the sandwich catalogue. JSON is a text format for lists, objects and simple values; the app reads this file but does not edit it.
- Shared preferences holds a few customer profile values under named keys.
- SQLite holds completed orders as rows in a table, so we can retrieve them in order.

We use manual JSON conversion, direct preference reads and writes, and one database helper. No code generation, extra state-management package or storage framework is needed. The [Flutter JSON guide](https://docs.flutter.dev/data-and-backend/serialization/json#manual-encoding), [key-value recipe](https://docs.flutter.dev/cookbook/persistence/key-value) and [SQLite recipe](https://docs.flutter.dev/cookbook/persistence/sqlite) describe these approaches.

Shared preferences is not secure storage and does not guarantee that every write reaches disk. Use fictional profile details in this exercise, never passwords or payment details. Orders belong in SQLite rather than preferences.

## Preparing an Android emulator

For the SQLite parts of this worksheet, run the app on an Android emulator, not Edge, Chrome or Windows desktop. An emulator is a virtual Android device running on your computer. The standard `sqflite` plugin works on Android without a separate database server or browser database setup.

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

## Loading the menu from a JSON asset

The catalogue currently comes from the hard-coded list in `SandwichRepository`. We add a JSON loader and use its result on the menu screen. The repository keeps its original synchronous methods for the existing lookup tests, but the running menu will use the asset.

### Create and register the JSON asset

Create `assets/data/sandwiches.json`. Start with an empty JSON array:

```json
[]
```

Inside the square brackets, add the first object:

```json
{
  "id": "footlong",
  "name": "Footlong Sub",
  "description": "A freshly baked 12-inch sandwich filled with savoury ingredients.",
  "price": 7.50,
  "imagePath": "assets/images/footlong.jpeg"
}
```

Add a comma after that object's closing brace, then add the second object:

```json
{
  "id": "six-inch",
  "name": "Six-Inch Sub",
  "description": "A light 6-inch sandwich made with your favourite toppings.",
  "price": 4.50,
  "imagePath": "assets/images/six_inch.jpeg"
}
```

The array now contains two objects matching the [Sandwich fields from Worksheet 3](worksheet-3.md#add-the-fields). JSON uses double quotes around names and string values, and does not allow a trailing comma after the last object.

Follow [asset registration in Worksheet 3](worksheet-3.md#register-assets-in-pubspec) to add `assets/data/` alongside `assets/images/` in `pubspec.yaml`:

```yaml
  assets:
    - assets/images/
    - assets/data/
```

Keep this under the existing `flutter:` entry and run `flutter pub get`.

### Convert a JSON map into a sandwich

Open `lib/models/sandwich.dart`. We convert each JSON object into a `Sandwich` by hand, following the [manual JSON guide](https://docs.flutter.dev/data-and-backend/serialization/json#manual-encoding).

A `Map` stores values under keys. `Map<String, dynamic>` means that its keys are strings and its values can have different types. `dynamic` was introduced with route information in [Worksheet 5](worksheet-5.md#create-the-basket-button). The expression `json['name']` reads the value under the key `'name'`.

Inside `Sandwich`, add an empty factory constructor:

```dart
  factory Sandwich.fromJson(Map<String, dynamic> json) {
  }
```

A factory constructor is a named way to return an instance of a class. Inside its braces, read the fields:

```dart
    final String id = json['id'] as String;
    final String name = json['name'] as String;
    final String description = json['description'] as String;
    final num priceNumber = json['price'] as num;
    final double price = priceNumber.toDouble();
    final String imagePath = json['imagePath'] as String;
```

The `as` operator checks that a value has the stated type; it throws an error if the data is wrong. `num` accepts either an integer or a decimal number, and `toDouble()` gives our model a `double` in both cases. See [Dart type tests](https://dart.dev/language/operators#type-test-operators).

After those declarations, return the instance:

```dart
    return Sandwich(
      id: id,
      name: name,
      description: description,
      price: price,
      imagePath: imagePath,
    );
```

### Convert a sandwich back into a map

Inside `Sandwich`, add a `toJson` method:

```dart
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
```

Replace the empty map `{}` with these entries:

```dart
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
    };
```

`toJson` returns a map, not JSON text. `jsonEncode` from `dart:convert` can turn that map into text when needed; we only need to decode text for the catalogue.

### Test both sandwich conversions

Use the [model testing pattern from Worksheet 4](worksheet-4.md#unit-testing-data-models). Inside the existing group in `test/sandwich_model_test.dart`, add a test with a map:

```dart
    test('JSON conversion preserves every sandwich field', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': 'veggie',
        'name': 'Veggie Sub',
        'description': 'Fresh vegetables.',
        'price': 5.50,
        'imagePath': 'assets/images/six_inch.jpeg',
      };
    });
```

After the map declaration, convert it and check every field by comparing the resulting map:

```dart
      final Sandwich sandwich = Sandwich.fromJson(data);
      expect(sandwich.id, 'veggie');
      expect(sandwich.name, 'Veggie Sub');
      expect(sandwich.description, 'Fresh vegetables.');
      expect(sandwich.price, 5.50);
      expect(sandwich.imagePath, 'assets/images/six_inch.jpeg');
      expect(sandwich.toJson(), data);
```

Add another test using a whole-number price to exercise the `num` conversion:

```dart
    test('fromJson accepts a whole-number price', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': 'test',
        'name': 'Test Sub',
        'description': 'Test sandwich.',
        'price': 5,
        'imagePath': 'assets/images/footlong.jpeg',
      };
      final Sandwich sandwich = Sandwich.fromJson(data);
      expect(sandwich.price, 5.0);
      expect(sandwich.price, isA<double>());
    });
```

Run `flutter test test/sandwich_model_test.dart`.

### Read the asset in the repository

Open `lib/repositories/sandwich_repository.dart` and add these imports:

```dart
import 'dart:convert';

import 'package:flutter/services.dart';
```

`jsonDecode` turns JSON text into Dart lists and maps. `rootBundle` reads the assets bundled with the app; see [loading text assets](https://docs.flutter.dev/ui/assets/assets-and-images#loading-text-assets).

Inside `SandwichRepository`, add a nullable cache and the loader's outline:

```dart
  List<Sandwich>? _cachedSandwiches;

  Future<List<Sandwich>> loadSandwichesFromAsset({
    String assetPath = 'assets/data/sandwiches.json',
  }) async {
  }
```

For nullable types, revisit [Worksheet 4](worksheet-4.md#add-getsandwichbyid-to-sandwichrepository). For `Future`, `async` and `await`, revisit [the first widget test in Worksheet 4](worksheet-4.md#test-orderitemdisplay-in-isolation).

Inside the loader, read and decode the text:

```dart
    final String jsonString = await rootBundle.loadString(assetPath);
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
    final List<Sandwich> loadedSandwiches = [];
```

After those declarations, convert each entry using the [explicit loop from Worksheet 4](worksheet-4.md#add-getsandwichbyid-to-sandwichrepository):

```dart
    for (final dynamic item in jsonList) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Sandwich sandwich = Sandwich.fromJson(itemMap);
      loadedSandwiches.add(sandwich);
    }

    _cachedSandwiches = loadedSandwiches;
    return loadedSandwiches;
```

At the beginning of the existing `getSandwiches` method, before its original `return const [...]`, add:

```dart
    if (_cachedSandwiches != null) {
      return _cachedSandwiches!;
    }
```

The `!` tells Dart that the value is not `null`, after our explicit check. Keep the existing fixed list and `getSandwichById` method. A repository instance returns its loaded list after a successful load; the menu below awaits the loader directly, so a failed asset load is not hidden by the old list.

### Load the menu when the screen opens

Open `lib/screens/menu_screen.dart`. Convert `MenuScreen` to a `StatefulWidget` using **Ctrl + .** on Windows or **⌘ + .** on macOS and **Convert to StatefulWidget**. Keep its constructor, imports, app bar and list layout. The two-class structure is the one from [Worksheet 2](worksheet-2.md#define-the-orderscreen-stateful-widget).

Inside `_MenuScreenState`, declare:

```dart
  List<Sandwich> _sandwiches = [];
  bool _loading = true;
  String _errorMessage = '';
```

Add `initState`, using the [lifecycle pattern from Worksheet 5](worksheet-5.md#text-controllers-and-form-lifecycle):

```dart
  @override
  void initState() {
    super.initState();
    _loadSandwiches();
  }
```

Add the loader shell:

```dart
  Future<void> _loadSandwiches() async {
    try {
    } catch (error) {
    }
  }
```

`try` runs an operation that might fail; `catch` handles the error. Here we display the failure rather than leave a permanent loading indicator. See [Dart error handling](https://dart.dev/language/error-handling#catch).

Inside `try`, load the menu and update state:

```dart
      final SandwichRepository repository = SandwichRepository();
      final List<Sandwich> sandwiches =
          await repository.loadSandwichesFromAsset();
      if (!mounted) {
        return;
      }
      setState(() {
        _sandwiches = sandwiches;
        _loading = false;
      });
```

[`mounted`](https://api.flutter.dev/flutter/widgets/State/mounted.html) is true while this state belongs to the widget tree. After an `await`, the user might have left the screen. The guard prevents updating a disposed state; we use the same guard after later storage operations.

Inside `catch`, add:

```dart
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Could not load the menu: $error';
        _loading = false;
      });
```

### Display loading and error states

In `build`, remove the local repository and `sandwiches` declarations. Start the method with:

```dart
    final Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      body = Center(child: Text(_errorMessage));
    } else {
      body = ListView.builder(
        itemCount: _sandwiches.length,
        itemBuilder: (BuildContext context, int index) {
          return SandwichCard(sandwich: _sandwiches[index]);
        },
      );
    }
```

[`CircularProgressIndicator`](https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html) shows that work is in progress. Keep the existing `Scaffold` and its app bar, but replace its `body` value with `body`. The list now comes from the asset.

### Update the menu and app tests

In `test/menu_screen_test.dart` and `test/widget_test.dart`, import the asset services:

```dart
import 'package:flutter/services.dart';
```

Inside `main`, add this setup, or add its single statement to an existing `setUp`:

```dart
  setUp(() {
    rootBundle.clear();
  });
```

`setUp` runs before each test, as in [Worksheet 5's repository tests](worksheet-5.md#unit-test-the-cart-repository). `rootBundle.clear()` clears cached asset reads so a later widget test does not reuse a `Future` created in an earlier test's simulated clock.

In every test that opens the menu or app, add `await tester.pumpAndSettle();` after `pumpWidget`, before checking catalogue text or tapping its buttons. The [frame-settling pattern from Worksheet 4](worksheet-4.md#test-initial-menu-screen-rendering) now also allows the asset load to finish.

To verify the actual data source, temporarily change a sandwich name in the JSON asset, fully restart the app, and check that the menu changes. Restore the name afterwards. A hot reload alone does not reliably refresh a bundled asset.

## Adding the persistence packages

From the project root, add the mobile storage packages and the separate test dependency:

```bash
flutter pub add shared_preferences sqflite path
flutter pub add --dev sqflite_common_ffi
```

These commands update `pubspec.yaml` and fetch compatible package versions. `shared_preferences` stores simple values; `sqflite` opens SQLite on Android; `path` provides `join` to build a file path. `sqflite_common_ffi` supplies SQLite for tests on your computer, not the mobile app.

We do not need web database packages, WebAssembly files or platform-detection branches. Follow the [SQLite recipe](https://docs.flutter.dev/cookbook/persistence/sqlite) and run the application on your emulator. After adding plugins, stop and restart the app rather than only hot reloading.

## Remembering the customer profile with shared preferences

We extend the [profile form from Worksheet 5](worksheet-5.md#building-the-customer-profile-settings-form). Keep its controllers, `dispose`, fields and switch; only loading and saving change.

We use `SharedPreferences`, matching the [Flutter key-value recipe](https://docs.flutter.dev/cookbook/persistence/key-value). The [package documentation](https://pub.dev/packages/shared_preferences) calls this the legacy API and recommends newer APIs for new production apps. We keep this small, single-screen example on one API so its direct getters, setters and mock store can be learnt together.

### Define the preference keys

In `lib/screens/settings_screen.dart`, add the package import alongside the existing imports:

```dart
import 'package:shared_preferences/shared_preferences.dart';
```

Below the imports, define the keys using the [constants pattern from Worksheet 5](worksheet-5.md#define-the-shared-constants):

```dart
const String prefName = 'user_name';
const String prefAddress = 'user_address';
const String prefEmail = 'user_email';
const String prefNewsletter = 'user_newsletter';
```

### Read saved values when settings opens

Inside `_SettingsScreenState`, create an empty `Future<void> _loadSettings() async {}` method. Within its braces, obtain the store and read its values:

```dart
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedName = prefs.getString(prefName);
    final String? savedAddress = prefs.getString(prefAddress);
    final String? savedEmail = prefs.getString(prefEmail);
    final bool? savedNewsletter = prefs.getBool(prefNewsletter);
```

Obtaining the store is asynchronous. These getters then read cached values synchronously; they return `null` when a key has not been saved.

Below those declarations, resolve each optional string with an explicit check:

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
```

Resolve the switch value in the same way:

```dart
    bool newsletter = false;
    if (savedNewsletter != null) {
      newsletter = savedNewsletter;
    }
```

These are first-use defaults for missing keys, not substitutes for handling a storage error.

### Fill the form after loading

Finish `_loadSettings` with the mounted guard and state update:

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
```

In the existing `initState`, add `_loadSettings();` after creating all three controllers. Do not create a second `initState` or remove `dispose`.

### Save the profile before showing confirmation

Change the existing `_saveSettings` return type from `void` to `Future<void>` and add `async`. Keep its three declarations that read and trim the controller text, as in [Worksheet 5](worksheet-5.md#add-text-fields-and-the-switch-toggle).

After those declarations, before constructing `UserSettings`, write the values:

```dart
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefName, name);
    await prefs.setString(prefAddress, address);
    await prefs.setString(prefEmail, email);
    await prefs.setBool(prefNewsletter, _receiveNewsletter);
```

Keep the existing `UserSettings` construction. Before its confirmation `setState`, insert the guard:

```dart
    if (!mounted) {
      return;
    }
```

The existing **Save Settings** button still uses `onPressed: _saveSettings`. The confirmation now follows the awaited writes, rather than only changing the form's in-memory state.

### Test loading and saving preferences

Open the existing `test/settings_screen_test.dart` from [Worksheet 5](worksheet-5.md#widget-test-the-settings-screen); do not replace its earlier tests. Add the `shared_preferences` import, then add this setup inside `main`:

```dart
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });
```

This creates a mock preference store before each test so tests do not read or change your real profile. `setUp` was introduced in [Worksheet 5](worksheet-5.md#unit-test-the-cart-repository). See the [recipe's testing support](https://docs.flutter.dev/cookbook/persistence/key-value#testing-support).

In each existing settings test, use `await tester.pumpAndSettle();` after opening the screen and after tapping **Save Settings**, before checking the result.

Add a new test inside `main`:

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
  });
```

After setting the mock values, render the form and check the result:

```dart
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Jordan Lee'), findsOneWidget);
    expect(find.text('15 High Street, Portsmouth'), findsOneWidget);
    expect(find.text('jordan@example.com'), findsOneWidget);
    final Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
    expect(switchWidget.value, isTrue);
```

At the end of the existing save test, read the mock store to verify persistence, not just the confirmation:

```dart
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(prefName), 'Alex Smith');
    expect(prefs.getString(prefAddress), '10 Elm Road, Portsmouth');
    expect(prefs.getString(prefEmail), 'alex@example.com');
    expect(prefs.getBool(prefNewsletter), isTrue);
```

Then remove and recreate the screen to verify the saved profile is loaded again:

```dart
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Alex Smith'), findsOneWidget);
    expect(find.text('10 Elm Road, Portsmouth'), findsOneWidget);
    expect(find.text('alex@example.com'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
```

The menu navigation test also opens `SettingsScreen`. Add the package import and the same `setUp` mock to `test/menu_screen_test.dart`, otherwise that test will try to call the real preferences plugin.

Run the two affected files together:

```bash
flutter test test/settings_screen_test.dart test/menu_screen_test.dart
```

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

Inside `OrderRecord`, add an empty `Map<String, Object?> toMap() {}` method. `Object?` accepts a value of any Dart type, including `null`, while keeping static type checking. We only put SQLite-supported values into this map.

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

Add `factory OrderRecord.fromMap(Map<String, Object?> map) {}`. Inside it, read the values using the same conversion pattern as [the sandwich JSON constructor](#convert-a-json-map-into-a-sandwich):

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

Inside the class, reuse the [singleton pattern from Worksheet 5](worksheet-5.md#create-the-cart-repository-singleton):

```dart
  SandwichDatabase._internal();

  static final SandwichDatabase instance = SandwichDatabase._internal();

  static Database? _database;
```

`Database` represents an open SQLite connection. Add a method that lets tests supply their own connection:

```dart
  void setDatabase(Database? db) {
    _database = db;
  }
```

Add the asynchronous getter. Getters were introduced in [Worksheet 4](worksheet-4.md#add-a-formatted-price-getter-to-the-sandwich-model):

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

This reuses the connection after the first call.

### Open the database in the app folder

Inside `SandwichDatabase`, add `_initDB`:

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

`getDatabasesPath` finds the app's writable database folder. `join` combines it with the file name. `openDatabase` opens that file, creating it if necessary. `version` identifies the table structure, and `onCreate` is called only when the database is first created.

We define `_createDB` below. There is no platform switch here: the app uses the Android plugin, and tests supply their own connection through `setDatabase`.

### Create the orders table

Add an empty `Future<void> createTables(Database db, int version) async {}` method. We give it a public name so tests can create the exact same table without duplicating SQL.

Inside it, create the table:

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

SQL is the language used to define and query database tables. `execute` runs this statement without returning rows. `INTEGER`, `TEXT` and `REAL` store whole numbers, strings and decimal numbers. `PRIMARY KEY` uniquely identifies a row; `AUTOINCREMENT` assigns ids without reusing earlier automatically generated ids. `NOT NULL` requires a value.

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

`insert` adds a row using the map's column names. Add a second sample after it:

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

`query` retrieves rows. `DESC` means descending order, so the highest order number appears first. We sort by number, not the displayed date string.

After the query, convert the rows and return the list:

```dart
    final List<OrderRecord> orders = [];
    for (final Map<String, Object?> row in records) {
      orders.add(OrderRecord.fromMap(row));
    }
    return orders;
```

### Find the next order number and close the connection

Add the numbering method:

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

`rawQuery` executes a SQL query that returns rows. `MAX` finds the largest number, and `as max_num` names that result. An empty table starts at `1001`; a new app with our seed data starts at `1004`. This numbering is for our single-user teaching app, not a multi-user payment system.

Finally, add:

```dart
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
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

Add `Future<void> _loadOrders() async {}` with empty `try` and `catch (error)` blocks, as in [the menu loader](#load-the-menu-when-the-screen-opens). Inside `try`, add:

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

Import `orders_button.dart` into the menu, order, basket, settings and orders screens. On the menu, keep the settings button and use:

```dart
        actions: const [SettingsButton(), OrdersButton(), BasketButton()],
```

On the other four screens, use:

```dart
        actions: const [OrdersButton(), BasketButton()],
```

Run the app on the emulator and open the receipt icon. You should see orders `1003`, `1002` and `1001`, in that order, with their summaries, totals, options and dates.

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

This reuses `join` to create a summary such as `2 x Footlong Sub, 1 x Six-Inch Sub`. Add a helper for the display date:

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

Add the checkout shell:

```dart
  Future<void> _checkout(CartRepository cart, List<CartItem> items) async {
    setState(() {
      _confirmationMessage = 'Saving your order...';
    });
    try {
    } catch (error) {
    }
  }
```

Inside `try`, obtain a number and create the record:

```dart
      final SandwichDatabase database = SandwichDatabase.instance;
      final int orderNumber = await database.getNextOrderNumber();
      final OrderRecord record = OrderRecord(
        orderNumber: orderNumber,
        summary: _buildSummary(items),
        total: cart.getTotalDue(),
        date: _formatDate(DateTime.now()),
      );
```

After creating the record, save it before clearing the cart:

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

In `_buildBasketList`, replace the old checkout callback with:

```dart
          onPressed: () async {
            await _checkout(cart, items);
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

### Create one in-memory database helper for tests

Create `test/support/test_database.dart` with these imports:

```dart
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
```

Add an empty `Future<Database> openTestDatabase() async {}` function. Inside it, open the test connection:

```dart
  sqfliteFfiInit();
  final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: SandwichDatabase.instance.createTables,
    ),
  );
```

`sqfliteFfiInit` prepares the native library. `inMemoryDatabasePath` keeps the data out of the app's real file. `databaseFactoryFfiNoIsolate` runs in the test's current isolate, avoiding a background worker and timing delays in widget tests.

After opening it, supply the connection and return it:

```dart
  SandwichDatabase.instance.setDatabase(database);
  return database;
```

Tests reuse the application's table definition but do not seed its example history. We write this helper once rather than copying the SQL into every test file.

### Test inserting, reading and numbering orders

Create `test/sandwich_db_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';

import 'support/test_database.dart';

void main() {}
```

Inside `main`, open a database before each test and close it afterwards:

```dart
  setUp(() async {
    await openTestDatabase();
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });
```

`tearDown` is the cleanup partner to `setUp`, running after each test. See the [Flutter unit test recipe](https://docs.flutter.dev/cookbook/testing/unit/introduction). Closing the singleton also resets its cached connection.

Inside `main`, add a small fixture builder:

```dart
  OrderRecord buildRecord(int number, String summary, double total) {
    return OrderRecord(
      orderNumber: number,
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
    expect(orders.first.id, id);
    expect(orders.first.summary, '1 x Footlong Sub');
    expect(orders.first.total, 7.50);
  });
```

This exercises `toMap`, SQLite insertion and `fromMap` together. Add a test for numbering:

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

### Update the basket checkout test

Keep the two existing tests in `test/basket_screen_test.dart` from [Worksheet 5](worksheet-5.md#widget-test-the-basket-screen). Add imports for the database helper, `OrdersScreen`, the FFI types and our shared test helper:

```dart
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'support/test_database.dart';
```

Inside `main`, declare `late Database database;`. Replace the existing `setUp` with:

```dart
  setUp(() async {
    CartRepository.instance.clear();
    database = await openTestDatabase();
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });
```

Add a navigation wrapper:

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

Use `buildApp()` instead of the bare `MaterialApp` in the existing tests. Add a new test and populate its basket:

```dart
  testWidgets('Checkout saves the order and opens orders', (
    WidgetTester tester,
  ) async {
    const CartItem item = CartItem(
      sandwich: testSandwich,
      quantity: 1,
    );
    CartRepository.instance.addItem(item);
    await tester.pumpWidget(buildApp());
  });
```

After pumping, tap checkout and query the result:

```dart
    late List<Map<String, Object?>> rows;
    await tester.runAsync(() async {
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
      rows = await database.query('orders');
    });
    await tester.pump();
```

[`runAsync`](https://api.flutter.dev/flutter/flutter_test/WidgetTester/runAsync.html) allows real asynchronous work inside a widget test. We use the no-isolate database factory and wait for frames to settle, not arbitrary delays such as sleeping for 50 milliseconds.

Finish the test with:

```dart
    expect(find.byType(OrdersScreen), findsOneWidget);
    expect(CartRepository.instance.getItems(), isEmpty);
    expect(rows.length, 1);
    expect(rows.first['summary'], '1 x Footlong Sub');
    expect(rows.first['total'], 11.50);
```

The existing fixture costs `10.0` and delivery is `1.50`; the saved total must include both.

Add a failure test so the success test is not your only evidence. Start it by adding one `CartItem` to the basket, as above. Inside `tester.runAsync`, create a SQLite trigger that rejects insertion:

```dart
      await database.execute('''
        CREATE TRIGGER reject_order BEFORE INSERT ON orders
        BEGIN
          SELECT RAISE(FAIL, 'Test insert failure');
        END
      ''');
```

Still inside `runAsync`, render `buildApp()`, tap **Checkout** and settle the frames. After it finishes, check the failure state:

```dart
    expect(CartRepository.instance.getItems(), hasLength(1));
    expect(find.textContaining('Could not save your order'), findsOneWidget);
    expect(find.byType(OrdersScreen), findsNothing);
```

Query `orders` inside `runAsync` and check that it is empty. A trigger runs when its specified database operation occurs; this one exercises a genuine failed write without replacing the database helper. The next test receives a fresh database, so the trigger does not affect it.

### Test the orders list and its empty state

Create `test/orders_screen_test.dart` with the material and test imports, `SandwichDatabase`, `OrderRecord`, `OrdersScreen` and `support/test_database.dart`. Start with an empty `main`.

Inside `main`, add the same `tearDown` that closes `SandwichDatabase.instance`. Add a test shell:

```dart
  testWidgets('OrdersScreen lists orders newest first', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await openTestDatabase();
    });
  });
```

Inside `runAsync`, after opening the database, insert the first fixture:

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

Insert a second fixture with `orderNumber: 1002`, `summary: '2 x Footlong Sub'`, `total: 15.00` and `date: '02/01/2026 11:00'`. Then, still inside `runAsync`, render the screen:

```dart
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await tester.pumpAndSettle();
```

After `runAsync` closes, check both presence and position:

```dart
    await tester.pump();
    expect(find.text('Order #1002'), findsOneWidget);
    expect(find.text('Order #1001'), findsOneWidget);
    final double newestY = tester.getTopLeft(find.text('Order #1002')).dy;
    final double oldestY = tester.getTopLeft(find.text('Order #1001')).dy;
    expect(newestY, lessThan(oldestY));
```

[`getTopLeft`](https://api.flutter.dev/flutter/flutter_test/WidgetController/getTopLeft.html) gives a widget's position. A smaller vertical coordinate means the newer order is above the older one; checking that both texts exist would not prove their order.

Add the empty-table test:

```dart
  testWidgets('OrdersScreen shows an empty state', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await openTestDatabase();
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await tester.pumpAndSettle();
    });
    await tester.pump();
    expect(find.text('No orders yet'), findsOneWidget);
  });
```

### Test navigation and run the complete suite

Create `test/widgets/app_bar_actions_test.dart`, following the [navigation test from Worksheet 5](worksheet-5.md#widget-test-the-menu-screen). Import the screens and test tools it needs, and import the shared helper using `../support/test_database.dart` because this test is one folder deeper.

Build a `MaterialApp` with a menu home and `'/orders'` route. Clear the asset cache in `setUp`, as in [the menu tests](#update-the-menu-and-app-tests). In a test, open the test database, render that app, wait for the menu asset, tap `Icons.receipt_long` and settle the frames, all inside `tester.runAsync`. Afterwards, expect one `OrdersScreen`. Close the database in `tearDown`.

Also check that the menu, order, basket, settings and orders screens retain their basket and receipt icons. The menu must still show `Icons.person_outline`. When testing settings, initialise mock preferences as above. Check that tapping the receipt icon again on the named orders route does not add another orders screen.

Use the [formatting, analysis and test workflow from Worksheet 4](worksheet-4.md#running-test-suites-and-static-analysis):

```bash
dart format lib test
dart analyze
flutter test
```

Compare your finished application with branch `6`. Check both the automated tests and the emulator restart behaviour; an in-memory database test cannot prove that a device file survives restarting the app.

## Exercises

The exercises below apply these concepts to your Southsea Cinema coursework. Together with [Worksheet 5's exercises](worksheet-5.md#exercises), they prepare you for Demo 3. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw).

Continue your cinema work from Worksheet 5, which started from cinema branch `2`. The completed Demo 3 state is cinema branch `3`. Keep the shared app bars, drawer routes, squared buttons, ticket basket and scrollable profile form you already built.

1. Following [Loading the menu from a JSON asset](#loading-the-menu-from-a-json-asset), move the films into `assets/data/movies.json` and register the asset. Add `Movie.fromJson` and `Movie.toJson`, with tests for all fields and whole-number prices. Make `HomeView` await the repository's asset loader in `initState`; the displayed film cards must come from that result, not a hard-coded list. Include loading and error feedback.

2. Set up the [Android emulator](#preparing-an-android-emulator) and add the [same persistence packages](#adding-the-persistence-packages) to the cinema app. Use the university Android bundle on lab machines or install an emulator on your own computer. Do not add web database packages or copy the Sandwich Shop's Android package id.

3. Following [Remembering the customer profile](#remembering-the-customer-profile-with-shared-preferences), persist the editable cinema profile fields and email-news preference under named keys. Load them when settings opens and save them when the patron submits. Use fictional details. Keep the existing controller lifecycle and scrollable form, and test loading, saving and reopening with mock preferences. A second SQLite settings table is not needed.

4. Following [Representing a saved order](#representing-a-saved-order), create `Booking` in `lib/models/booking.dart`, with an optional database `id`, `bookingNumber`, `saleSummary`, `saleDate` and `totalPrice`. Add `toMap` and `fromMap` methods and tests. Use a `Booking` consistently for a completed ticket purchase; do not create a second `TicketTransaction` class for the same record.

5. Following [Creating the SQLite database helper](#creating-the-sqlite-database-helper), create `CinemaDatabase` in `lib/database/cinema_db.dart`. Open a file in the app's database folder, create a `bookings` table and seed fictional past bookings once in `onCreate`. Add methods to insert bookings, read them newest first, find the next booking number and close the connection.

6. Following [Displaying saved orders](#displaying-saved-orders) and [Saving the basket at checkout](#saving-the-basket-at-checkout), build a bookings screen and register `'/bookings'`. Make the drawer's **My Tickets** entry open it. Checkout must save a `Booking` with the basket summary and total before clearing the basket or navigating. Show database errors instead of swallowing them. Fully close and reopen the emulator app to verify the purchase remains and seed rows are not duplicated. **Show the running app to a member of staff.**

7. Following [Testing SQLite without an emulator](#testing-sqlite-without-an-emulator), test your actual table definition using an in-memory database. Check the generated id and saved fields, descending booking order, numbering from an empty table and the next number after insertion. Add widget tests for successful checkout, the bookings list and its empty state. Verify that a failed insert leaves the basket intact. Keep `dart analyze` and `flutter test` passing.

8. For Demo 3, be ready to explain where the film JSON is read, how map conversion works, why preferences and SQLite have different jobs, why asynchronous screen updates check `mounted`, how seed data is added only once, and how the emulator restart check differs from an in-memory test. Retain the themed navigation, squared buttons, basket calculations and editable form from Worksheet 5. **Show your completed Demo 3 application to a member of staff.**

9. As an advanced challenge, follow the [Flutter user-input tutorial](https://docs.flutter.dev/learn/pathway/tutorial/user-input) to add focus management. Create a `FocusNode`, attach it to the primary editable field, call `requestFocus()` when entering edit mode, and dispose of it with the controllers. Add a clear `IconButton` that calls the controller's `clear()` method. Build and test one control at a time.

10. As an advanced challenge, prepare for Demo 4 by making `test/` mirror `lib/`, for example with `models`, `views`, `repositories`, `database` and `widgets` subfolders. Update relative test-helper imports after moving files. Run `flutter test --coverage` and inspect the results with the Flutter Coverage extension in VS Code; mirrored folders and demonstrated coverage become requirements from Demo 4.
