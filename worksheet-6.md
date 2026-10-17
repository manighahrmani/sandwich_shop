# Worksheet 6 — JSON assets and saved preferences

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 5](#continue-from-worksheet-5)
  - [Clone the Sandwich Shop repository](#clone-the-sandwich-shop-repository)
  - [Switch to branch 5](#switch-to-branch-5)
- [Understanding JSON](#understanding-json)
  - [Objects and arrays](#objects-and-arrays)
  - [Why we use a bundled asset](#why-we-use-a-bundled-asset)
- [Loading the menu from a JSON asset](#loading-the-menu-from-a-json-asset)
  - [Create and register the JSON asset](#create-and-register-the-json-asset)
  - [Convert a JSON map into a sandwich](#convert-a-json-map-into-a-sandwich)
  - [Convert a sandwich back into a map](#convert-a-sandwich-back-into-a-map)
  - [Test both sandwich conversions](#test-both-sandwich-conversions)
  - [Read the asset in the repository](#read-the-asset-in-the-repository)
  - [Test the asset loader](#test-the-asset-loader)
  - [Load the menu when the screen opens](#load-the-menu-when-the-screen-opens)
  - [Display loading and error states](#display-loading-and-error-states)
  - [Update the menu and app tests](#update-the-menu-and-app-tests)
- [Adding shared preferences](#adding-shared-preferences)
- [Remembering the customer profile with shared preferences](#remembering-the-customer-profile-with-shared-preferences)
  - [Define the preference keys](#define-the-preference-keys)
  - [Read saved values when settings opens](#read-saved-values-when-settings-opens)
  - [Fill the form after loading](#fill-the-form-after-loading)
  - [Save the profile before showing confirmation](#save-the-profile-before-showing-confirmation)
  - [Test loading and saving preferences](#test-loading-and-saving-preferences)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 5

Open the Sandwich Shop project you completed in [Worksheet 5](worksheet-5.md). We keep its basket, customer profile form, shared theme and navigation, then add local storage.

### Clone the Sandwich Shop repository

If you need a fresh copy of the project, clone the [Sandwich Shop repository](https://github.com/manighahrmani/sandwich_shop). Open a terminal and move to a folder that is not synchronised to cloud storage, such as your `Downloads` folder:

```bash
cd ~/Downloads
git clone https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
```

Open the cloned folder in VS Code with **File > Open Folder**.

### Switch to branch 5

If you cloned a fresh copy, switch to branch `5` so your project matches the state after completing Worksheet 5. If you are continuing your own project, stay on the branch containing your completed work instead:

```bash
git checkout 5
```

Run `flutter pub get` to install the project dependencies, then run `flutter test` to confirm that all existing tests pass before continuing.

Do not switch branches over unfinished work. Branch `6` contains the completed Sandwich Shop application for this worksheet; use it to compare your finished work, not as your starting point.

## Understanding JSON

JSON stands for JavaScript Object Notation. It is a plain-text format for storing and exchanging structured data, not a programming language. Despite its name, you can use it with Dart and many other languages without writing JavaScript. JSON files use the `.json` extension.

Apps commonly use JSON for product catalogues, configuration and data sent between an app and a server. Both people and programs can read its structure. The [MDN JSON introduction](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/JSON) explains the format with further examples.

### Objects and arrays

A JSON object groups related values inside curly braces, `{}` (similar to a dictionary in Python). Each value has a name, called a key, followed by a colon and the value. For example, this object describes a sandwich's name and price:

```json
{
  "name": "Footlong Sub",
  "price": 7.50
}
```

The key `"name"` holds the text value `"Footlong Sub"`, while `"price"` holds the number `7.50`. Keys and text values need double quotes; numbers do not. JSON also supports the Boolean values `true` and `false`, and `null` to represent no value.

A JSON array holds an ordered collection of values inside square brackets, `[]`. Our catalogue needs several sandwiches, so we can put objects into an array. This shortened example contains two sandwiches:

```json
[
  {
    "name": "Footlong Sub",
    "price": 7.50
  },
  {
    "name": "Six-Inch Sub",
    "price": 4.50
  }
]
```

Commas separate the fields in an object and the items in an array. Do not put a trailing comma after the final field or item, and do not add comments inside JSON. These examples show only two fields; the catalogue you create below will include all the fields required by `Sandwich`.

JSON is text, not a Dart `Sandwich` instance. Decoding turns that text into Dart collections and values; we then use those values to construct our model objects. Encoding works in the other direction, turning Dart collections and values into JSON text. We will write the model conversion ourselves rather than use generated code, following the [Flutter manual JSON guide](https://docs.flutter.dev/data-and-backend/serialization/json#manual-encoding).

### Why we use a bundled asset

At present, changing a sandwich's name or price means editing Dart code in `SandwichRepository`. A separate data file keeps the catalogue apart from the program's behaviour, making menu maintenance easier. Someone who does not write Dart can edit the JSON in a text editor, provided they follow its structure, without changing how the app works.

The same loading code can read the updated catalogue each time the app starts, without a server or an internet connection. The hard-coded list also survives restarts; the benefit of JSON here is separating data from code.

You already registered image assets in [Worksheet 3](worksheet-3.md#register-assets-in-pubspec). A JSON file can be an asset too: it is a supporting file that the app reads, rather than Dart source code. It is called a bundled asset because Flutter packages the registered file with the app during the build, in an asset bundle. See the [Flutter assets guide](https://docs.flutter.dev/ui/assets/assets-and-images).

The running app reads this packaged copy; it does not overwrite it when a customer changes settings. To distribute a changed bundled catalogue, you must rebuild and redistribute the app. This makes it suitable for fixed/static data, in our case our starting menu, but not for saving customer edits or keeping a live shop's prices up to date without an app update.

## Loading the menu from a JSON asset

We add a JSON loader to `SandwichRepository` and use its result on the menu screen. The repository keeps its original (synchronous) methods for the existing lookup tests, but the running menu will use the asset.

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

The array now contains two objects matching the [Sandwich fields from Worksheet 3](worksheet-3.md#add-the-fields). Here is what your JSON file should look like:

![The sandwiches.json file with two sandwich objects](images/6/sandwiches_json.png)

With `sandwiches.json` open, open the Command Palette with **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS. Run **Format Document With...**, select **Configure Default Formatter...**, then choose **JSON Language Features** or **Prettier - Code formatter** (you may be prompted to install extensions if you don't have them). This sets the default formatter for JSON files, without changing your Dart formatter.

Run **Format Document** from the Command Palette to tidy the indentation. You can also use **Shift + Alt + F** on Windows or **Shift + Option + F** on macOS. If formatting fails, check for missing commas or brackets first; formatting does not repair invalid JSON.

Similar to [asset registration in Worksheet 3](worksheet-3.md#register-assets-in-pubspec), we add `assets/data/` alongside `assets/images/` in `pubspec.yaml`:

```yaml
  assets:
    - assets/images/
    - assets/data/
```

See below the changes we made in `pubspec.yaml`:

![The changes made in pubspec.yaml to include assets/data/](images/6/pubspec_changes.png)

Make sure to place this under the existing `flutter:` entry and run `flutter pub get`.

### Convert a JSON map into a sandwich

Open `lib/models/sandwich.dart`. We will add a named constructor, `Sandwich.fromJson`, to convert the map representing each JSON object into a `Sandwich`:

A `Map` stores values under keys. `Map<String, dynamic>` means that its keys are strings and its values can have different types. Inside `Sandwich`, after its existing constructor, add this factory constructor outline. It will show an error until you add its return statement:

```dart
  factory Sandwich.fromJson(Map<String, dynamic> json) {
  }
```

The `Sandwich` constructor you wrote in Worksheet 3 needs every value to be passed in separately. Here we have a single map instead, so we write a second constructor that takes the map, picks out each value and builds the `Sandwich` for us. The `factory` keyword lets a constructor run some code first and then `return` the new `Sandwich`. The way you can use this constructor is to call `Sandwich.fromJson(someMap)`. See [factory constructors](https://dart.dev/language/constructors#factory-constructors) for more detail.

<!-- TODO: Done till here -->

Inside its braces, read the fields:

```dart
    final String id = json['id'] as String;
    final String name = json['name'] as String;
    final String description = json['description'] as String;
    final num priceNumber = json['price'] as num;
    final double price = priceNumber.toDouble();
    final String imagePath = json['imagePath'] as String;
```

Because the map's values are `dynamic`, Dart does not know that `json['name']` holds a `String`. The `as` operator checks that a value has the stated type, so `json['name'] as String` gives us a `String` we can store in a typed variable; it throws an error if the data is wrong. `num` accepts either an integer or a decimal number, and `toDouble()` gives our model a `double` in both cases. See [Dart type tests](https://dart.dev/language/operators#type-test-operators).

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

Your `fromJson` constructor should look like this:

![The Sandwich.fromJson factory constructor in lib/models/sandwich.dart](images/6/sandwich_from_json_code.png)

### Convert a sandwich back into a map

The menu only needs to read JSON, but we also practise the reverse conversion so you can export a sandwich's data when needed. Inside `Sandwich`, add a `toJson` method:

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

Inside that test, after the map declaration, convert it into a `Sandwich`, check each field, and compare the map returned by `toJson` with the original:

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

All of the model tests should pass, as shown below:

![The terminal showing all sandwich model tests passing](images/6/sandwich_model_tests_passing.png)

### Read the asset in the repository

Open `lib/repositories/sandwich_repository.dart` and add these imports:

```dart
import 'dart:convert';

import 'package:flutter/services.dart';
```

`dart:convert` provides `jsonDecode`, which turns JSON text into Dart lists and maps: a JSON array becomes a `List` and each JSON object becomes a `Map<String, dynamic>`. `package:flutter/services.dart` provides `rootBundle`, an object that reads the files listed under `assets:` in `pubspec.yaml`; see [loading text assets](https://docs.flutter.dev/ui/assets/assets-and-images#loading-text-assets).

Inside `SandwichRepository`, add `_cachedSandwiches` to hold the most recently loaded list, followed by the loader's outline. Complete the method in the steps below:

```dart
  List<Sandwich>? _cachedSandwiches;

  Future<List<Sandwich>> loadSandwichesFromAsset({
    String assetPath = 'assets/data/sandwiches.json',
  }) async {
  }
```

`List<Sandwich>?` means the cache is either a list or `null`; it starts as `null` because nothing has been loaded yet. For nullable types, revisit [Worksheet 4](worksheet-4.md#add-getsandwichbyid-to-sandwichrepository).

Apply the `Future`, `async` and `await` pattern from [Worksheet 4's widget tests](worksheet-4.md#test-orderitemdisplay-in-isolation) to the file read. Here, `Future<List<Sandwich>>` means the operation completes with a sandwich list or an error, rather than handing back a list immediately.

Like `maxQuantity` in [Worksheet 2](worksheet-2.md#use-orderscreen-inside-app), `assetPath` is an optional named parameter with a default value. Calling `loadSandwichesFromAsset()` reads `assets/data/sandwiches.json`, while a test could pass a different path.

Inside the loader, read and decode the text:

```dart
    final String jsonString = await rootBundle.loadString(assetPath);
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
    final List<Sandwich> loadedSandwiches = [];
```

`rootBundle.loadString` returns a `Future<String>`, so `await` waits for the file text. `jsonDecode` returns `dynamic`, because it cannot know in advance whether the text holds a list, a map or a single value. Our file contains an array, so `decodedData as List<dynamic>` checks that the decoded value is a list; it throws an error if the file contains a different kind of value. The empty `loadedSandwiches` list will collect the converted sandwiches.

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

Each `item` is `dynamic`, so `item as Map<String, dynamic>` checks that it is a JSON object before we pass it to `Sandwich.fromJson`. After the loop, we store the list in the cache and return it. Because the method is `async`, returning a `List<Sandwich>` completes the `Future`.

At the beginning of the existing `getSandwiches` method, before its original `return const [...]`, add:

```dart
    final List<Sandwich>? cachedSandwiches = _cachedSandwiches;
    if (cachedSandwiches != null) {
      return cachedSandwiches;
    }
```

We copy the field into a local variable first. After the `!= null` check, Dart knows the local variable cannot be `null` inside the `if`, so it can be returned as a `List<Sandwich>`. Dart cannot make that guarantee for our mutable `_cachedSandwiches` field directly, which is why we use the local copy.

Keep the existing fixed list and `getSandwichById` method so the earlier synchronous lookup tests still work without loading an asset. For each repository instance, `getSandwiches` returns the fixed list until a successful load, then returns the cached list. The menu will await the loader directly and display an error if it fails, rather than fall back to the fixed list.

Your repository should look like this:

![The SandwichRepository with the asset loader and the cache check in getSandwiches](images/6/sandwich_repository_asset_loader.png)

### Test the asset loader

Open `test/sandwich_repository_test.dart`. Reading an asset with `rootBundle` needs Flutter's test binding, which connects the test to Flutter services. Plain `test` calls do not initialise it automatically. At the top of `main()`, before the group, add:

```dart
  TestWidgetsFlutterBinding.ensureInitialized();
```

`testWidgets` initialises the binding for you, but our repository tests use `test`. The existing `flutter_test` import provides `TestWidgetsFlutterBinding`. Inside the group, add a test that loads the real file:

```dart
    test('loadSandwichesFromAsset reads the bundled JSON menu', () async {
      final SandwichRepository repository = SandwichRepository();
      final List<Sandwich> sandwiches =
          await repository.loadSandwichesFromAsset();

      expect(sandwiches.length, 2);
      expect(sandwiches[0].id, 'footlong');
      expect(sandwiches[1].id, 'six-inch');
      expect(repository.getSandwiches(), sandwiches);
    });
```

The callback is `async` so that it can `await` the loader. The last line checks that `getSandwiches` now returns the cached list. Run `flutter test test/sandwich_repository_test.dart`.

The new test should pass alongside the existing repository tests, as shown below:

![The terminal showing the repository tests, including the asset loader test, passing](images/6/sandwich_repository_tests_passing.png)

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

`Future<void>` means the asynchronous method completes without returning a value; it updates the screen's state instead. Keep `initState` synchronous: it starts `_loadSandwiches`, and that separate method awaits the file read.

`try` runs an operation that might fail; if any statement inside it throws an error, Dart jumps to `catch`, and `error` holds what was thrown. Here we display the failure rather than leave a permanent loading indicator. See [Dart error handling](https://dart.dev/language/error-handling#catch).

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

`final Widget body;` declares a variable without giving it a value yet. Each branch of the `if` statement assigns it exactly once, and Dart reports an error if any branch forgets. [`CircularProgressIndicator`](https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html) shows that work is in progress. Keep the existing `Scaffold` and its app bar, but replace its `body` value with `body`. The list now comes from the asset.

When you run the app, the menu should look like this:

![The menu screen showing the two sandwiches loaded from the JSON asset](images/6/menu_loaded_from_json.png)

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

`setUp` runs before each test, as in [Worksheet 5's repository tests](worksheet-5.md#unit-test-the-cart-repository). Flutter widget tests control time so that asynchronous behaviour can be tested predictably. `rootBundle.clear()` clears cached asset reads so a later widget test does not reuse an unfinished read from an earlier test.

In every test that opens the menu or app, add `await tester.pumpAndSettle();` after `pumpWidget`, before checking catalogue text or tapping its buttons. The [frame-settling pattern from Worksheet 4](worksheet-4.md#test-initial-menu-screen-rendering) now also allows the asset load to finish.

To verify the actual data source, temporarily change a sandwich name in the JSON asset, fully restart the app, and check that the menu changes. Restore the name afterwards. A hot reload alone does not reliably refresh a bundled asset.

During that check, before restoring the name, the menu should look similar to this:

![The menu screen showing a sandwich name changed in the JSON asset](images/6/menu_with_changed_json_name.png)

## Adding shared preferences

The menu now reads its catalogue from a bundled JSON file. Next, we address a different need: remembering entries in the customer profile form when the app closes. The bundled catalogue is read-only, so it is not where we save those changes.

For these few editable values, we use shared preferences, which stores values under named keys on the device. It does not require JSON conversion: we save text and Boolean values directly, following the [Flutter key-value recipe](https://docs.flutter.dev/cookbook/persistence/key-value). Both approaches keep data available between launches, but the JSON asset supplies the menu while preferences remembers the customer's choices.

Shared preferences suits small, non-critical values, such as whether you want email news. It does not encrypt stored values, so never use it for passwords or payment details, and use fictional profile details when testing. The [package documentation](https://pub.dev/packages/shared_preferences) also warns that a completed save does not guarantee the data has reached permanent storage. Losing a recent preference is inconvenient, but losing a paid order would be unacceptable.

We only add storage for the catalogue and profile in this worksheet. The basket keeps its existing in-memory behaviour: closing the app loses its contents, and checkout shows a temporary confirmation rather than saving a purchase record.

From the project root, add the preference package:

```bash
flutter pub add shared_preferences
```

This command updates `pubspec.yaml` and fetches a compatible package version. Stop and restart the app after adding the plugin rather than only hot reloading. You can continue using your browser for this worksheet; an Android emulator is not required.

The terminal output should look similar to this:

![The terminal output after adding the shared_preferences package](images/6/flutter_pub_add_shared_preferences.png)

## Remembering the customer profile with shared preferences

We extend the [profile form from Worksheet 5](worksheet-5.md#building-the-customer-profile-settings-form). Keep its controllers, `dispose`, fields and switch; only loading and saving change.

We use the package's `SharedPreferences` class, matching the [Flutter key-value recipe](https://docs.flutter.dev/cookbook/persistence/key-value). The [package documentation](https://pub.dev/packages/shared_preferences) calls this the legacy API, meaning an older interface retained for compatibility, and recommends newer APIs for new apps. We use it here to follow the recipe and learn its getters, setters and test support together.

### Define the preference keys

In `lib/screens/settings_screen.dart`, add the package import alongside the existing imports:

```dart
import 'package:shared_preferences/shared_preferences.dart';
```

Each saved value needs a stable key so we can find it again. Below the imports, define these keys using the [constants pattern from Worksheet 5](worksheet-5.md#define-the-shared-constants):

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

Obtaining the store is asynchronous. `getString` reads a text value and `getBool` reads a Boolean value under the supplied key. These getters read cached values synchronously; they return `null` when a key has not been saved.

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

Your `_loadSettings` method and `initState` should look like this:

![The _loadSettings method and the initState method in lib/screens/settings_screen.dart](images/6/load_settings_method.png)

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

Your `_saveSettings` method should look like this:

![The asynchronous _saveSettings method writing the profile to shared preferences](images/6/save_settings_method.png)

Save a profile in the running app, then stop the app and run it again. When you open the settings screen, the form should be filled with your saved details, as shown below:

![The settings form filled with saved profile details after restarting the app](images/6/settings_form_after_restart.png)

### Test loading and saving preferences

Open the existing `test/settings_screen_test.dart` from [Worksheet 5](worksheet-5.md#widget-test-the-settings-screen); do not replace its earlier tests. Add the same package import used in the settings screen:

```dart
import 'package:shared_preferences/shared_preferences.dart';
```

Inside `main`, add this setup, or add its statement to an existing `setUp`:

```dart
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });
```

This resets an in-memory test store using the same `setUp` pattern as [Worksheet 5's cart tests](worksheet-5.md#unit-test-the-cart-repository), so tests do not read or change your real profile. `<String, Object>{}` is an empty map whose keys are strings and whose values can be any non-null object, such as a `String` or a `bool`. See the [recipe's testing support](https://docs.flutter.dev/cookbook/persistence/key-value#testing-support).

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

`find.byType(Switch)` locates the switch, and `tester.widget<Switch>(...)` returns that widget as a `Switch` so we can read its `value` property.

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
    final Switch reopenedSwitch = tester.widget<Switch>(find.byType(Switch));
    expect(reopenedSwitch.value, isTrue);
```

Pumping `const SizedBox.shrink()`, an empty widget, removes the settings screen from the test, so the next `pumpWidget` creates a fresh screen that must load the saved values again.

The menu navigation test also opens `SettingsScreen`. Add the package import to `test/menu_screen_test.dart` and add `SharedPreferences.setMockInitialValues(<String, Object>{});` to the `setUp` that already clears `rootBundle`. Keep both setup statements, otherwise the test may reuse an earlier asset read or try to call the real preferences plugin. Use the same mock setup in any other test file that opens the settings screen.

Run the two affected files together:

```bash
flutter test test/settings_screen_test.dart test/menu_screen_test.dart
```

All of the tests in both files should pass, as shown below:

![The terminal showing the settings and menu screen tests passing](images/6/settings_tests_passing.png)

Finish by running `dart analyze` and `flutter test` from the project root to check that the full application still passes static analysis and all tests.

## Exercises

The exercises below apply these concepts to your Southsea Cinema coursework. Together with [Worksheet 5's exercises](worksheet-5.md#exercises), they prepare you for Demo 3. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw).

Continue your cinema work from Worksheet 5, which started from cinema branch `2`. The completed Demo 3 state is cinema branch `3`. Keep the shared app bars, drawer routes, squared buttons, ticket basket and scrollable profile form you already built.

1. Following [Loading the menu from a JSON asset](#loading-the-menu-from-a-json-asset), move the films into `assets/data/movies.json` and register the asset. Add `Movie.fromJson` and `Movie.toJson`, with tests for all fields and whole-number prices.

2. In the state class for `HomeView`, start an asynchronous loading method from `initState`, following the menu screen example. Await the repository's asset loader inside that method, not inside `initState`; the displayed film cards must come from its result, not a hard-coded list. Include loading and error feedback, check `mounted` before updating the page after an `await`, and update the home-page and app tests.

3. Add `shared_preferences`. Following [Remembering the customer profile](#remembering-the-customer-profile-with-shared-preferences), persist the editable cinema profile fields and email-news preference under named keys. Load them when the settings page opens and save them when the patron submits. Use fictional details. Keep the existing controller lifecycle and scrollable form.

4. Test loading saved preferences, saving edited values and reopening the settings form with mock preferences. Fully close and reopen the running app to check that profile values remain. Keep `dart analyze` and `flutter test` passing; mock preferences alone do not prove that a real device or browser retains the values.

5. Retain Worksheet 5's basket calculations, removal and temporary checkout confirmation. Checkout clears the in-memory basket, but does not create a saved booking history at this stage. For Demo 3, be ready to explain where film JSON is read, how map conversion works, why asynchronous page updates check `mounted`, and how profile values survive reopening the app. **Show your completed Demo 3 application to a member of staff.**

6. As an advanced challenge, follow the [Flutter user-input tutorial](https://docs.flutter.dev/learn/pathway/tutorial/user-input) to add focus management to the profile form. A `FocusNode` tracks whether an input has keyboard focus. Create one for the name field, attach it through the field's `focusNode` parameter, and add a button that calls its `requestFocus()` method. Dispose of the node alongside the controllers. Add a clear `IconButton` that calls the name controller's `clear()` method. Build and test one control at a time.
