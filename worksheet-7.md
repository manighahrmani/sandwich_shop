# Worksheet 7 — SQLite and order history

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 6](#continue-from-worksheet-6)
  - [Clone the Sandwich Shop repository](#clone-the-sandwich-shop-repository)
  - [Switch to branch 6](#switch-to-branch-6)
- [Choosing a database for completed orders](#choosing-a-database-for-completed-orders)
- [Preparing an Android emulator or device](#preparing-an-android-emulator-or-device)
  - [Install the Android bundle on university computers](#install-the-android-bundle-on-university-computers)
  - [Set up an emulator on your own computer](#set-up-an-emulator-on-your-own-computer)
  - [Use a physical Android device](#use-a-physical-android-device)
  - [Select the device and run the app](#select-the-device-and-run-the-app)
- [Adding the SQLite packages](#adding-the-sqlite-packages)
  - [Prevent running on unsupported platforms](#prevent-running-on-unsupported-platforms)
  - [Run on other platforms](#run-on-other-platforms)
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
  - [Test that a failed save keeps the basket](#test-that-a-failed-save-keeps-the-basket)
  - [Test the orders list and its empty state](#test-the-orders-list-and-its-empty-state)
  - [Test supported platforms and run the complete suite](#test-supported-platforms-and-run-the-complete-suite)
- [Organising tests and inspecting coverage](#organising-tests-and-inspecting-coverage)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 6

You can continue directly with the Sandwich Shop project you completed in [Worksheet 6](worksheet-6.md). Open the project folder in VS Code with **File > Open Folder**. You do not need to clone the repository again.

### Clone the Sandwich Shop repository

If you need a fresh copy of the project, clone the [Sandwich Shop repository](https://github.com/manighahrmani/sandwich_shop). Open a terminal and move to a folder that is not synchronised to cloud storage, such as your `Downloads` folder:

```bash
cd ~/Downloads
git clone https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
```

Open the cloned folder in VS Code with **File > Open Folder**.

### Switch to branch 6

If you cloned a fresh copy, switch to branch `6` so your project matches the state after completing Worksheet 6. If you are continuing your own project, stay on the branch containing your completed work instead:

```bash
git checkout 6
```

Run `flutter pub get` to install the project dependencies, then run `flutter test` to confirm that all existing tests pass before continuing.

Do not switch branches over unfinished work. Branch `7` contains the completed Sandwich Shop application for this worksheet; use it to compare your finished work, not as your starting point.

## Choosing a database for completed orders

JSON assets supply the catalogue and shared preferences remembers profile settings. Neither is a suitable store for a growing purchase history. SQLite stores completed orders as rows in a table on the device, without a separate database server.

A table has named columns. Each row holds one order, and its primary key identifies that row. We create the table with `CREATE TABLE`, insert purchases with `insert` and read them with `query`; these helper methods build SQL `INSERT` and `SELECT` statements. Read the [Flutter SQLite recipe](https://docs.flutter.dev/cookbook/persistence/sqlite) alongside this example.

We record completed purchases rather than edit or delete purchase history. Updating and deleting records are not required for this checkout flow. No Provider package, notifier or new state-management layer is needed.

## Preparing an Android emulator or device

For this worksheet, run the app on an Android emulator or a physical Android device, not Edge, Chrome or Windows desktop. An emulator is a virtual Android device running on your computer. The standard `sqflite` plugin works on Android without a separate database server or browser database setup.

Automated tests will use an in-memory database and do not need an emulator. Prepare your emulator now, before adding database code.

### Install the Android bundle on university computers

The browser-only bundle from [Worksheet 1](worksheet-1.md#b---using-the-university-machines-on-campus) does not include the Android tools. Use the [Android emulator release of the portable bundle](https://github.com/manighahrmani/flutter_vscode_package#android-emulator-setup-worksheet-7-onwards) instead. Open PowerShell and run its installer:

```powershell
irm https://raw.githubusercontent.com/manighahrmani/flutter_vscode_package/main/install-android-beta.ps1 | iex
```

This is the Android bundle release, not a request to build your Flutter app in release mode. The installer sets everything up: it installs a JDK, the Android SDK and a virtual device named `flutter_emulator`, boots that emulator once and leaves it running, then opens VS Code on your project. The download is several gigabytes, so the installer takes several minutes to finish. Let it run to the end; the university machines provide the hardware acceleration the emulator needs.

Because the installer already booted the emulator, you do not repeat its setup. If the emulator is not running, launch it with the command below and wait for the Android home screen. The first cold boot can take a few minutes, and a black screen is normal while it boots.

```bash
flutter emulators --launch flutter_emulator
```

Wait for the Android home screen before continuing, as shown below:

![The Android emulator running on the home screen](images/7/android_emulator_home_screen.png)

### Set up an emulator on your own computer

On your own Windows, macOS or Linux computer, install Flutter first by following the [Flutter installation guide](https://docs.flutter.dev/install/quick). Then follow the [Flutter Android setup guide](https://docs.flutter.dev/platform-integration/android/setup) to install Android Studio. You only need this setup or the university bundle, not both.

Open Android Studio and complete its setup wizard, which downloads the Android SDK. From the welcome screen, open **More Actions** and then **SDK Manager**. On the **SDK Tools** tab, tick **Android SDK Command-line Tools** and click **Apply**, because Flutter needs these tools to accept the SDK licences.

Next, open **More Actions** and then **Virtual Device Manager**, and create a virtual device:

1. Choose a phone, such as a Pixel, and click **Next**.
2. Choose a recent system image and download it. Pick an `x86_64` image on an Intel or AMD computer, and an `arm64` image on an Apple silicon Mac or an ARM-based Windows computer.
3. Finish the wizard, then start the device with its play button.

The emulator needs hardware acceleration. If it reports that acceleration is missing, follow the [Android emulator acceleration guide](https://developer.android.com/studio/run/emulator-acceleration). On Windows this usually means turning on **Windows Hypervisor Platform** in **Turn Windows features on or off**, which needs administrator rights.

Check the toolchain and accept the SDK licences:

```bash
flutter doctor
flutter doctor --android-licenses
```

The **Android toolchain** line of `flutter doctor` should show a tick. Next time, you can start the emulator without opening Android Studio. List your emulators, then launch one by its id:

```bash
flutter emulators
flutter emulators --launch <emulator id>
```

### Use a physical Android device

On your own computer, you can run the app on an Android phone or tablet instead of an emulator. This uses the same Android setup as above, apart from the virtual device. University computers may not allow USB devices, so use the emulator there.

1. On the phone, open **Settings**, then **About phone**, and tap **Build number** seven times to turn on developer options. The location of **Build number** varies between manufacturers.
2. Open **Developer options**, usually under **Settings** and **System**, and turn on **USB debugging**.
3. Connect the phone to your computer with a USB cable that supports data, unlock the phone and allow USB debugging when it asks.
4. Run `flutter devices` in the terminal and check that your phone is listed.

If the phone is not listed on Windows, install its USB driver using the [OEM USB drivers page](https://developer.android.com/studio/run/oem-usb). On Android 11 and later, you can connect without a cable by following the [wireless debugging steps](https://developer.android.com/studio/run/device#wireless).

To run on an iPhone or the iOS simulator instead, you need a Mac with Xcode; follow the [Flutter iOS setup guide](https://docs.flutter.dev/platform-integration/ios/setup). The app we build only allows Android until you follow [Run on other platforms](#run-on-other-platforms).

### Select the device and run the app

Once the emulator or phone is running, pick it as the run target in VS Code using the device selector in the bottom-right of the status bar. If a different device is selected, click the status bar item and choose the Android emulator (for example `sdk gphone64 x86 64`) or your phone. You can also open the Command Palette with **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS and run the command **Flutter: Select Device**. Do not pick Edge, Chrome or Windows, as the app is set up for Android only. Then press **F5** to build, install and run the app with hot reload.

To run from the terminal instead, list the devices and target yours by its id:

```bash
flutter devices
flutter run -d emulator-5554
```

Replace `emulator-5554` with the id that `flutter devices` reports for your emulator or phone. The first build downloads Android build dependencies and can take several minutes. If it fails, read the reported error and check `flutter doctor`; do not assume every warning or failure is harmless.

The app should appear inside the emulator, as shown below:

![The Sandwich Shop app running on the Android emulator](images/7/sandwich_shop_on_emulator.png)

## Adding the SQLite packages

From the project root, add the mobile database packages and the separate test dependency:

```bash
flutter pub add sqflite path
flutter pub add --dev sqflite_common_ffi
```

`sqflite` opens SQLite on Android. `path` provides `join` to build a file path, and `sqflite_common_ffi` supplies SQLite for tests on your computer, not the mobile app. Keep the `shared_preferences` dependency from Worksheet 6.

We do not need web database packages or WebAssembly files. Run the app on your emulator. After adding plugins, stop and restart the app rather than only hot reloading.

### Prevent running on unsupported platforms

Up until Worksheet 6, you tested and ran your Flutter applications inside a web browser (**Chrome / Edge**) via Flutter Web.

In Worksheet 7, we introduce local database persistence using the **`sqflite`** package. Here is how persistence and execution differ between the two mechanisms:

- **`shared_preferences` (Worksheet 6)**: Saves lightweight key-value pairs (like user settings and flags). On the web, it stores data in browser `localStorage`, which only survives within that browser session and page reloads, but is cleared whenever debug sessions or lab computer profiles reset. On the Android emulator, it writes to an XML file in internal storage that permanently survives app restarts.
- **`sqflite` (Worksheet 7)**: Stores structured tables and relational data (like full customer order history). It relies on native C bindings to SQLite on the operating system. It runs natively on Android, iOS and macOS. It does not work in a web browser, and Windows or Linux desktop need the extra set-up described in [Run on other platforms](#run-on-other-platforms).

If a student presses **F5** with **Edge** or **Windows** selected in the VS Code device picker and triggers database operations, the application crashes immediately with a runtime `MissingPluginException`:
> `MissingPluginException: No implementation found for method openDatabase on channel com.tekartik.sqflite`

Running on the **Android emulator** gives you the true, full mobile platform experience: both SQLite database tables and shared preferences files are permanently saved to the emulator disk and persist across stopping, restarting, and reinstalling the app.

To prevent accidental crashes on web or desktop and remind you to switch to the mobile emulator, we add a platform check directly in `lib/main.dart`:

1. **`kIsWeb`**: A built-in Flutter constant from `package:flutter/foundation.dart`. It evaluates to `true` whenever the app is compiled to run in a web browser (HTML/CanvasKit/WebAssembly). If `kIsWeb` is true, the check immediately returns `false`.
2. **`defaultTargetPlatform`**: Detects the host operating system. Only `TargetPlatform.android` returns `true`, because this worksheet runs the app on an Android emulator. You can add other platforms later by following [Run on other platforms](#run-on-other-platforms).
3. **`UnsupportedPlatformApp`**: If an unsupported target (such as Edge, Chrome, or Windows) is launched, `main()` starts this lightweight fallback screen instead of crashing. It displays a clear message directing you to stop the app and launch it on your Android emulator or device.

Open `lib/main.dart` and add this import above the existing Material import:

```dart
import 'package:flutter/foundation.dart';
```

Replace the `main` function with:

```dart
// This app saves orders with SQLite (sqflite), which is set up for Android.
bool isSupportedPlatform() {
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
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

At the end of the file, add the fallback widget shown on unsupported platforms:

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
              'This app saves orders with SQLite and is set up to run on '
              'Android only. Stop the app and run it on an Android emulator '
              'or device instead.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
```

If you accidentally run the app on an unsupported browser or desktop target, the fallback screen appears as shown below:

![The fallback screen displayed when running on an unsupported platform](images/7/unsupported_platform_screen.png)

From now on, ensure your Android emulator is selected before running the app, as described in [Preparing an Android emulator or device](#preparing-an-android-emulator-or-device).

### Run on other platforms

This section is optional. Complete the rest of the worksheet on the Android emulator first, and skip this section if you only use the university computers.

On a Mac, `sqflite` also runs on the iOS simulator and on macOS desktop. Install Xcode by following the [Flutter iOS setup guide](https://docs.flutter.dev/platform-integration/ios/setup) or the [Flutter macOS setup guide](https://docs.flutter.dev/platform-integration/macos/setup). Then add a check for each platform you want to `isSupportedPlatform`, below the Android check:

```dart
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return true;
  }
  if (defaultTargetPlatform == TargetPlatform.macOS) {
    return true;
  }
```

On Windows, `sqflite` has no desktop implementation, so we use the same `sqflite_common_ffi` package that the tests use. You need Visual Studio (not VS Code) with the **Desktop development with C++** workload, as described in the [Flutter Windows setup guide](https://docs.flutter.dev/platform-integration/windows/setup). The university computers do not have it. Run `flutter doctor` and check that the **Visual Studio** line has a tick. Building a Windows app with plugins also needs **Developer Mode**; run `start ms-settings:developers` and turn it on, which needs administrator rights.

In the terminal, add Windows support to the project and move `sqflite_common_ffi` from the development dependencies to the app dependencies:

```bash
flutter create --platforms=windows .
flutter pub add sqflite_common_ffi
```

The first command creates a `windows` folder. It also creates a `test/widget_test.dart` template that does not match our app, so delete that file.

In `lib/main.dart`, add this import:

```dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
```

Add a Windows check to `isSupportedPlatform`, below the Android check:

```dart
  if (defaultTargetPlatform == TargetPlatform.windows) {
    return true;
  }
```

At the start of `main`, before the existing `if` statement, point the database code at the FFI implementation when the app runs on Windows:

```dart
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
```

`databaseFactory` decides how `openDatabase` reaches SQLite. Setting it to `databaseFactoryFfi` makes the existing `SandwichDatabase` code work on Windows without other changes. The `!kIsWeb` check matters because `defaultTargetPlatform` reports the computer's operating system even when the app runs in a browser. Select **Windows** in the device selector and run the app. The database file is saved in the project's `.dart_tool/sqflite_common_ffi/databases` folder.

On Linux, install the build tools listed in the [Flutter Linux setup guide](https://docs.flutter.dev/platform-integration/linux/setup), then follow the same steps as for Windows. Use `flutter create --platforms=linux .` and `TargetPlatform.linux` in place of the Windows values, and select **Linux** in the device selector. If the app reports that it cannot load the SQLite library, install it with `sudo apt-get install libsqlite3-dev`.

Whenever you add a platform, update the platform tests in [Test supported platforms and run the complete suite](#test-supported-platforms-and-run-the-complete-suite) so that platform expects `isTrue`.

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

Your `order_record.dart` file should look like this:

![The completed OrderRecord class in lib/models/order_record.dart](images/7/order_record_model.png)

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
      'date': '18/04/2026 12:45',
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
      'date': '02/03/2026 18:10',
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
      'date': '11/01/2026 13:02',
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

`insert` returns the generated row id. Next, add the method that retrieves all saved orders:

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

`query` builds an SQL `SELECT` statement to retrieve rows. Its `orderBy` argument supplies SQL `ORDER BY`, which sorts the result. `DESC` means descending order, so the highest order number appears first. We sort by number, not the displayed date string. The loop converts each returned database row into an `OrderRecord` instance using `fromMap`.

### Find the next order number and close the connection

`rawQuery` runs an SQL `SELECT` statement that you write yourself. `MAX` finds the largest value in a column, and `as max_num` gives the result a column name. Add `getNextOrderNumber` to calculate the next sequence number:

```dart
  Future<int> getNextOrderNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(order_number) as max_num FROM orders',
    );

    if (records.isEmpty) {
      return 1001;
    }
    final Object? maxValue = records[0]['max_num'];
    if (maxValue == null) {
      return 1001;
    }

    final int currentMax = maxValue as int;
    return currentMax + 1;
  }
```

`MAX` returns `null` when the table has no orders. Otherwise, convert the value once and add one. An empty table starts at `1001`; a new app with our seed data starts at `1004`. This numbering is for our single-user teaching app, not a multi-user payment system.

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

Tests close the connection after each test so no data leaks into the next one. Your database helper class in `lib/database/sandwich_db.dart` should look like this:

![The completed SandwichDatabase class in lib/database/sandwich_db.dart](images/7/sandwich_database_helper.png)

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

When there are no saved orders, the screen shows its empty state, as shown below:

![The OrdersScreen showing the empty state](images/7/orders_screen_empty.png)

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

Leave the menu and settings screens unchanged from Worksheet 6. On the emulator, open the basket from the menu, then select the receipt icon. You should see orders `1003`, `1002` and `1001`, in that order, with their summaries, totals, options and dates, as shown below:

![The OrdersScreen displaying saved orders in descending order](images/7/orders_screen_populated.png)

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

Keep the existing `_confirmationMessage` field. Add `_checkout` inside `_BasketScreenState` to persist the purchase before resetting the basket:

```dart
  Future<void> _checkout(CartRepository cart, List<CartItem> items) async {
    final String summary = _buildSummary(items);
    final double total = cart.getTotalDue();
    final String date = _formatDate(DateTime.now());

    try {
      final SandwichDatabase database = SandwichDatabase.instance;
      final int orderNumber = await database.getNextOrderNumber();
      final OrderRecord record = OrderRecord(
        orderNumber: orderNumber,
        summary: summary,
        total: total,
        date: date,
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

`DateTime.now()` gives the current local date and time. We prepare the summary, total and display date before starting the database work. After inserting the record with `database.insertOrder(record)`, the cart is cleared with `cart.clear()` and the app navigates to `/orders`. If insertion fails, the error is caught, the cart is preserved, and an error message is displayed. Never use an empty `catch` around a database write.

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

On the emulator, save fictional profile details, add a sandwich and check out. Checkout saves the order and opens the orders screen, where your new order appears above the seeded history. If you return to the basket screen, the basket is empty and displays the confirmation message, as shown below:

![The basket screen after checkout displaying the confirmation message](images/7/basket_checkout_confirmation.png)

Now fully close the app on the emulator. Terminate it by stopping the debug run and relaunching, or by swiping it away from the emulator's recent-apps list. This is a real cold restart, not a hot reload or hot restart, so do not just save a file and let the app refresh. Reopen the app without uninstalling it or clearing its storage, and confirm both that your past orders are still listed and that the saved profile fields from Worksheet 6 are still populated from the previous session.

Reopening the app must not duplicate the three seed orders. The basket itself is still in memory; only completed orders and the saved profile persist.

### Inspect the database on the emulator

This optional check opens a copy of the actual SQLite file. Stop the app's debug run first so there are no writes in progress, but leave the emulator running.

For the supplied Android project, the debug package is `com.example.sandwich_shop`. Copy the database to a temporary location on the emulator, then pull the copy into your project folder:

```bash
adb shell "run-as com.example.sandwich_shop cat databases/sandwich_data.db > /data/local/tmp/s.db"
adb pull /data/local/tmp/s.db sandwich_shop.db
```

`adb` communicates with the Android device. `run-as` reads the debug app's private files, and `pull` copies a file to your computer. If you changed the Android application id, use that id instead.

Open `sandwich_shop.db` in VS Code using the bundle's **SQLite Viewer** extension. Select the `orders` table and check that it contains the three seed rows and your saved order, as shown below:

![Inspecting the SQLite database in the SQLite Viewer extension](images/7/sqlite_viewer_orders_table.png)

This is a snapshot, not a live connection. Remove the copied file after inspection; it is runtime data, not an application asset.

## Testing SQLite without an emulator

The [sqflite FFI package](https://pub.dev/packages/sqflite_common_ffi) runs SQLite directly on the test computer. FFI means foreign function interface: Dart calls a native library. We use it only in tests, with a fresh in-memory database rather than the user's file.

Organise the tests before adding new ones. Move the existing model tests into `test/models/`, repository tests into `test/repositories/`, and screen tests into `test/screens/`. Keep the button test under `test/widgets/`. Rename `sandwich_model_test.dart` to `sandwich_test.dart` so it matches `lib/models/sandwich.dart`.

Rename `test/widget_test.dart` to `test/main_test.dart` for the app tests. Move its `OrderItemDisplay` group and the two quantity-limit tests into `test/screens/order_screen_test.dart`. Remove the now-unused `Sandwich` import from `main_test.dart`. In `assets/data/sandwiches.json`, remove the temporary `Nonexistent Sandwich` entry so the menu catalogue contains only the three real items. In `test/main_test.dart`, update the smoke test to check the three menu items (Footlong Sub, Six-Inch Sub and Loaded Nachos), removing the temporary check for the non-existent sandwich from Worksheet 6. Keep explicit `Sandwich` types in the moved fixtures and add that type to the `const` declarations in the sandwich model tests too. Your test folder structure in the editor should look like this:

![The mirrored test directory structure in the VS Code explorer](images/7/test_folders_mirrored.png)

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

We pass the application's `createTables` method to `onCreate`, so tests exercise the real table definition without adding seed orders. `setDatabase` supplies this connection to the singleton; `close` also resets its cached connection. Copy this setup and clean-up into each of the database-backed screen test files below, rather than creating another helper layer.

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

### Test that a failed save keeps the basket

The checkout's `catch` block should leave the basket untouched when saving fails. To test it, we need a database write that fails on purpose. The simplest way is to delete the `orders` table before checkout, so every query on it throws an error.

In the same file, add another test inside `main`:

```dart
  testWidgets('Checkout keeps the basket when saving fails', (
    WidgetTester tester,
  ) async {
    CartRepository.instance.addItem(
      const CartItem(sandwich: testSandwich, quantity: 2),
    );
  });
```

After adding the item, delete the table from the test database:

```dart
    await tester.runAsync(() async {
      final Database database = await SandwichDatabase.instance.database;
      await database.execute('DROP TABLE orders');
    });
```

`DROP TABLE` is the SQL command that removes a table and all of its rows. It only affects this test's in-memory database, and `setUp` creates a fresh table before the next test.

Then render the basket and tap **Checkout**, exactly as in the previous test:

```dart
    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));
    await tester.runAsync(() async {
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
    });
    await tester.pumpAndSettle();
```

Finish with assertions that the item is still in the basket and the error is shown:

```dart
    expect(CartRepository.instance.getItems().length, 1);
    expect(find.text('2 x Footlong Sub'), findsOneWidget);
    expect(find.textContaining('Could not save your order'), findsOneWidget);
```

`find.textContaining` matches any `Text` widget whose text includes the given words, which is useful here because the full message also contains the database error.

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
  test('Android is supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = null;
  });
```

```dart
  test('Other platforms are not supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    expect(isSupportedPlatform(), isFalse);
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

All automated tests should pass, as shown below:

![All tests passing in the terminal](images/7/flutter_test_passed.png)

Compare your finished application with branch `7`. Check both the automated tests and the emulator restart behaviour; an in-memory database test cannot prove that a device file survives restarting the app.

## Organising tests and inspecting coverage

From Demo 4 onwards, your test folders must mirror the folders under `lib/`, as we arranged in the preceding section. Keep model, repository, screen, widget and database tests in their matching subfolders under `test/`.

For Sandwich Shop, screen tests belong under `test/screens/` because the application uses `lib/screens/`. The cinema application uses `lib/views/`, so its view tests belong under `test/views/`. Match the actual application structure rather than renaming folders to copy the example.

Tests for the root-level `lib/main.dart` may remain at the root of `test/`; model, repository and screen tests should not remain there.

Run the suite with coverage:

```bash
flutter test --coverage
```

This writes `coverage/lcov.info`. Install the [Flutter Coverage extension](https://marketplace.visualstudio.com/items?itemName=Flutterando.flutter-coverage) in VS Code and use it to inspect which lines the tests execute, as shown below:

![Inspecting test coverage line-by-line with the Flutter Coverage extension](images/7/flutter_coverage_inspection.png)

Review the models, repositories, database helper and checkout screens, then add tests for important paths that are not exercised. Executed lines alone do not prove that the assertions check the correct behaviour.

Be ready to demonstrate the coverage in your editor at Demo 4, alongside passing tests and the mirrored folder structure.

## Exercises

The exercises below apply these concepts to your Southsea Cinema coursework. Together with [Worksheet 8](worksheet-8.md), they prepare you for Demo 4. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw).

Continue from cinema branch `3`, the Demo 3 state after Worksheets 5 and 6. Cinema branch `4` is the Demo 4 checkpoint: the same app, except that checkout saves each booking to SQLite and the basket page lists past orders. Keep the existing JSON film catalogue, saved profile settings, drawer navigation and squared buttons. No notifier, Provider package, app-bar basket button or separate bookings page is required.

1. Start with configuring your runtime environment by following [Preparing an Android emulator or device](#preparing-an-android-emulator-or-device) and [Adding the SQLite packages](#adding-the-sqlite-packages) in your cinema project. Use the university Android bundle on lab machines or install an emulator on your own computer. Do not add web database packages or copy the Sandwich Shop's Android package identifier.

2. Create a `Booking` model in `lib/models/booking.dart` using the structure introduced in [Representing a saved order](#representing-a-saved-order). Include an optional database `id`, a `summary`, a `total` and a `date`, along with `toMap` and `fromMap` methods. Add unit tests for map conversion mirroring [Test order map conversion](#test-order-map-conversion). Use `Booking` consistently for a completed ticket purchase rather than creating a second class for the same record.

3. Build a singleton database manager `CinemaDatabase` in `lib/database/cinema_db.dart` using the patterns demonstrated in [Creating the SQLite database helper](#creating-the-sqlite-database-helper). Open a database file in the application's document folder and define a `bookings` table inside `onCreate`. Provide one method that inserts a booking and one that reads all bookings, newest first. You do not need seed data or booking numbers.

4. Adapt your basket checkout routine as shown in [Saving the basket at checkout](#saving-the-basket-at-checkout). Persist a `Booking` containing the basket summary and total before clearing the basket, and preserve the existing confirmation message on the basket page.

5. Add a past orders section below the current order on the basket page, applying the list-rendering approach from [Displaying saved orders](#displaying-saved-orders). Load the saved bookings when the page opens and refresh them after checkout, presenting the date, summary and total of each purchase. Include a short message when there are no past orders. To check that both stores survive a restart, place an order, then change and save your profile settings. Now fully close and reopen the emulator app: terminate it for a real cold restart, which is not a hot reload or hot restart and is different from an in-memory test. Reopen the app, navigate to the basket page, and verify that both your earlier bookings and your saved profile settings are still present.

6. Test the real table definition with an in-memory database using the test harness from [Testing SQLite without an emulator](#testing-sqlite-without-an-emulator) and [Prepare a fresh database for each test](#prepare-a-fresh-database-for-each-test). Keep the `Booking` `toMap` and `fromMap` round-trip unit tests. For `CinemaDatabase`, verify that an inserted booking returns its generated database id, that the map conversions preserve every field, and that queries return records newest first. Add a widget test modelled on [Update the basket checkout test](#update-the-basket-checkout-test) and [Test the orders list and its empty state](#test-the-orders-list-and-its-empty-state) that checking out writes to SQLite, and cover both states explicitly: the past orders section renders saved bookings when present, and shows the empty-state message when there are none. Add a widget test for the settings flow that saving profile settings stores them and that they are read back and pre-filled when the settings page reopens, following Worksheet 6's in-memory approach in [Test loading and saving preferences](worksheet-6.md#test-loading-and-saving-preferences). Add an end-to-end booking journey widget test where feasible: navigate from the film list through the **BOOK NOW** button to the listing, add tickets to the basket, open the basket, check out, and confirm the past orders list updates. If a single full-journey test is impractical, test each hop instead.

7. Structure your tests in accordance with [Organising tests and inspecting coverage](#organising-tests-and-inspecting-coverage), ensuring that the folders under `test/` mirror the actual application structure in `lib/`. The cinema app keeps its screens under `lib/views/`, so their tests go under `test/views/`. Run `flutter test --coverage` and inspect executed lines using the Flutter Coverage extension. Confirm the coverage shows the `Booking` model, the `CinemaDatabase` database helper and the main screens exercised. Maintain zero warnings from `dart analyze` and ensure all tests pass.

8. Prepare for the oral assessment questions outlined in [Test supported platforms and run the complete suite](#test-supported-platforms-and-run-the-complete-suite) and Demo 4 criteria. Be ready to explain why profile preferences and the bookings table have different roles, how a row maps to a `Booking`, why checkout saves before clearing the basket, and how an emulator restart check differs from an in-memory test.
