# Worksheet 5 — Navigation Drawer, Basket Management, and Forms

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 4](#continue-from-worksheet-4)
  - [Clone the Sandwich Shop repository](#clone-the-sandwich-shop-repository)
  - [Switch to branch 4](#switch-to-branch-4)
- [The need for multi-screen architecture](#the-need-for-multi-screen-architecture)
  - [Application navigation drawer](#application-navigation-drawer)
  - [Named routes in MaterialApp](#named-routes-in-materialapp)
- [Building the navigation drawer](#building-the-navigation-drawer)
  - [Define shared app constants](#define-shared-app-constants)
  - [Create the NavDrawer widget](#create-the-navdrawer-widget)
  - [Configure named routes and theme](#configure-named-routes-and-theme)
  - [Connect the drawer across screens](#connect-the-drawer-across-screens)
  - [Commit your changes (1)](#commit-your-changes-1)
- [Loading menu data from JSON](#loading-menu-data-from-json)
  - [Create the JSON asset file](#create-the-json-asset-file)
  - [Register the asset in pubspec](#register-the-asset-in-pubspec)
  - [Add JSON serialisation to Sandwich model](#add-json-serialisation-to-sandwich-model)
  - [Load JSON data in SandwichRepository](#load-json-data-in-sandwichrepository)
  - [Commit your changes (2)](#commit-your-changes-2)
- [Managing an order basket](#managing-an-order-basket)
  - [Define the CartItem model](#define-the-cartitem-model)
  - [Create the CartRepository singleton](#create-the-cartrepository-singleton)
  - [Add items from the order screen](#add-items-from-the-order-screen)
  - [Choose a quantity with a DropdownMenu](#choose-a-quantity-with-a-dropdownmenu)
  - [Commit your changes (3)](#commit-your-changes-3)
- [Building the basket screen](#building-the-basket-screen)
  - [Create the CartScreen widget](#create-the-cartscreen-widget)
  - [Commit your changes (4)](#commit-your-changes-4)
- [Handling user input and forms](#handling-user-input-and-forms)
  - [Understand forms and text controllers](#understand-forms-and-text-controllers)
  - [Define the UserSettings model](#define-the-usersettings-model)
  - [Build the SettingsScreen widget](#build-the-settingsscreen-widget)
  - [Commit your changes (5)](#commit-your-changes-5)
- [Testing the basket and settings screens](#testing-the-basket-and-settings-screens)
  - [Unit test JSON serialisation](#unit-test-json-serialisation)
  - [Unit test the CartRepository](#unit-test-the-cartrepository)
  - [Widget test the CartScreen](#widget-test-the-cartscreen)
  - [Widget test the SettingsScreen](#widget-test-the-settingsscreen)
  - [Commit your changes (6)](#commit-your-changes-6)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 4

You can continue directly with the Sandwich Shop project you had at the end of Worksheet 4. Open the project folder in VS Code with **File > Open Folder**. You do not need to clone the repository again if your working copy is clean.

### Clone the Sandwich Shop repository

If you need a fresh clone, run the following in your terminal:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
```

### Switch to branch 4

Switch to branch `4` to ensure your code matches the Worksheet 4 state:

```bash
git checkout 4
```

Run `flutter test` to ensure that all automated tests pass before continuing.

## The need for multi-screen architecture

In [Worksheet 3](./worksheet-3.md) we introduced stack-based navigation using `Navigator.push`. By default in Flutter, pushing a new route places it on top of a history stack and displays a back arrow (`<-`) in the app bar.

While a back button makes sense for simple linear flows, it can cause problems when users want to switch between main areas of an application, such as viewing their basket or editing their settings. Stacking screens indefinitely clutters history and causes inconsistencies across headers.

A consistent multi-screen architecture solves this by providing:

1. A unified top app bar displaying the application title across every view.
2. A sliding navigation drawer accessible from any primary screen.
3. Centralised named routes registered in `MaterialApp` using `Navigator.pushReplacementNamed`, keeping each section at the top level without unwanted back arrows.

### Application navigation drawer

A drawer is a panel that slides in horizontally from the edge of a `Scaffold` to show navigation links. Flutter provides the `Drawer` widget, which works directly with the `drawer` property of `Scaffold`.

When a `Scaffold` contains a `Drawer`, Flutter automatically provides a hamburger menu button (`☰`) in the `AppBar`. Tapping this button slides the drawer into view.

### Named routes in MaterialApp

Instead of writing `MaterialPageRoute` every time you navigate, you can assign unique string paths to screens, such as `'/'`, `'/cart'`, and `'/settings'`.

You register these paths inside the `routes` map of `MaterialApp`. Once registered, any widget can navigate to a destination using `Navigator.pushReplacementNamed(context, '/cart')`.

## Building the navigation drawer

Let us build a reusable navigation drawer widget and a consistent app bar that can be attached to any screen in the application.

### Define shared app constants

Create a new file named `lib/constants.dart`. This centralises the title and styling across all views:

```dart
import 'package:flutter/material.dart';

const String appTitle = 'Sandwich Shop';
const Color shopBrand = Colors.brown;
const Color shopWhite = Colors.white;
const TextStyle shopHeaderStyle = TextStyle(
  fontWeight: FontWeight.bold,
  letterSpacing: 1.1,
);
```

### Create the NavDrawer widget

Create a new file named `lib/widgets/nav_drawer.dart`. We will build the drawer a few lines at a time so that each new widget has a chance to be explained before the next one appears.

Start with the imports and the shell of the widget. `NavDrawer` is a `StatelessWidget`, which you first built in Worksheet 2, so it has only a `build` method:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // header and tiles go here
          ],
        ),
      ),
    );
  }
}
```

The `Drawer` is the sliding panel introduced above. Its child is a `SafeArea`, a widget that keeps its content clear of the notches, rounded corners, and system bars at the edges of a phone screen. Inside that sits a `ListView`, the scrolling list you met in Worksheet 3. Setting `padding: EdgeInsets.zero` removes the default space `ListView` would otherwise add at the top, so our coloured header can sit flush against the top edge.

Now replace the `// header and tiles go here` comment with a coloured header. The header is a `Container` holding a `Row` with the title on the left and a close button on the right:

```dart
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: shopBrand,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      appTitle,
                      style: TextStyle(
                        color: shopWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: shopWhite),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
```

The title `Text` is wrapped in an `Expanded` so it takes all the horizontal space left over by the close button, which you first used in Worksheet 3. The `overflow: TextOverflow.ellipsis` property tells the `Text` to truncate a long title with a trailing ellipsis (…) instead of overflowing the row.

The close button is an `IconButton`, a tappable, circular button whose child is a single `Icon` and which runs the function you give its `onPressed` callback when the user taps it. The `Icon` widget displays one icon from `Icons`, the catalogue of built-in Material icons, so `Icons.close` shows the standard cross. Here `onPressed` calls `Navigator.pop(context)` (from Worksheet 3) to close the drawer.

Next, below the header `Container` and still inside the `ListView` children, add the three navigation entries. Each is a `DrawerTile`, a small widget we define next:

```dart
            const DrawerTile(title: 'Menu', route: '/'),
            const DrawerTile(title: 'My Basket', route: '/cart'),
            const DrawerTile(title: 'My Settings', route: '/settings'),
```

Finally, add the `DrawerTile` class below `NavDrawer` in the same file. It takes a `title` to show and a `route` to navigate to, both `final` fields passed through its constructor:

```dart
class DrawerTile extends StatelessWidget {
  final String title;
  final String route;

  const DrawerTile({
    super.key,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        // navigation logic goes here
      },
    );
  }
}
```

The `DrawerTile` builds a `ListTile`, a ready-made row widget designed for lists and drawers. It arranges a `title` neatly and provides an `onTap` callback that runs when the user taps the row.

Now fill in the `onTap` logic by replacing the `// navigation logic goes here` comment:

```dart
        Navigator.pop(context);
        final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
        if (currentRoute != route) {
          Navigator.pushReplacementNamed(context, route);
        }
```

First we call `Navigator.pop(context)` to close the drawer. Then we work out which screen is already showing. `ModalRoute.of(context)` reads the route the current screen was opened with, and `?.settings.name` reads that route's name using the null-aware access operator from Worksheet 4. If no route is found, `ModalRoute.of(context)` is `null`, so the `??` null-coalescing operator supplies the fallback value on its right-hand side: `?? ''` means "use the empty string when the left-hand value is null". The `??` operator always evaluates to the right-hand value when the left-hand value is null, and to the left-hand value otherwise.

Finally, we only navigate when the tapped `route` is different from the current one. We navigate with `Navigator.pushReplacementNamed(context, route)` rather than the `Navigator.push` you used in Worksheet 3. `Navigator.push` stacks a new screen on top of the old one and shows a back arrow, which is right for a detail screen you expect to return from. `pushReplacementNamed` swaps the current screen for the new one instead, so the primary sections never stack up and no back arrow appears. The hamburger menu then stays consistent across the whole application.

### Configure named routes and theme

Open `lib/main.dart`. We register the routes in `MaterialApp` and configure a theme that applies our brand colour to the app bar:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/screens/cart_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: shopBrand,
          primary: shopBrand,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: shopBrand,
          foregroundColor: shopWhite,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return const MenuScreen();
        },
        '/cart': (BuildContext context) {
          return const CartScreen();
        },
        '/settings': (BuildContext context) {
          return const SettingsScreen();
        },
      },
    );
  }
}
```

### Connect the drawer across screens

Open `lib/screens/menu_screen.dart`. Update it to use `appTitle` and include `drawer: const NavDrawer()`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';
import 'package:sandwich_shop/widgets/sandwich_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SandwichRepository repository = SandwichRepository();
    final List<Sandwich> sandwiches = repository.getSandwiches();

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        backgroundColor: shopBrand,
        foregroundColor: shopWhite,
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Sandwich Menu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sandwiches.length,
              itemBuilder: (BuildContext context, int index) {
                return SandwichCard(sandwich: sandwiches[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### Commit your changes (1)

Stage your new files and commit your changes before moving on.

With the drawer connected, tap the hamburger menu to slide it open. Your drawer should look like this:

<!-- TODO screenshot: images/5/nav_drawer_open.png — show the open navigation drawer with the brown header and the Menu, My Basket, and My Settings tiles -->

## Loading menu data from JSON

Hardcoding items inside Dart files means every menu update requires recompiling source code. In production applications, catalogues are stored in external data files such as JSON.

### Create the JSON asset file

Create a new folder named `assets/data/`. Inside it, create `sandwiches.json`:

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

### Register the asset in pubspec

Open `pubspec.yaml`. Under `flutter:` and `assets:`, add `- assets/data/`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/data/
```

### Add JSON serialisation to Sandwich model

Open `lib/models/sandwich.dart`. The class already has its five `final` fields, its `const` constructor, and the `formattedPrice` getter you added in Worksheet 4:

```dart
class Sandwich {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;

  const Sandwich({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });

  String get formattedPrice {
    return '£${price.toStringAsFixed(2)}';
  }
}
```

We now add two things to this class: a `fromJson` constructor that builds a `Sandwich` from decoded JSON, and a `toJson` method that produces the reverse. Add `fromJson` inside the class, below the `formattedPrice` getter:

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

This is a `factory` constructor, which you have not met before. An ordinary constructor only assigns the arguments to the fields. A `factory` constructor can run code first and then decide which instance to return, which is exactly what we need here: it reads values out of a map and then builds a `Sandwich` from them.

The argument type is `Map<String, dynamic>`. A `Map` stores key-and-value pairs; `Map<String, dynamic>` means the keys are strings (such as `'name'`) and the values can be of any type (a string, a number, and so on), which is what a decoded JSON object looks like. Because each value is `dynamic`, Dart does not know its exact type, so we use the `as` keyword to assert it: `json['id'] as String` tells Dart to treat that value as a `String`. The price arrives as a `num`, the common supertype of `int` and `double`, so we read it as a `num` and then call `.toDouble()` to be sure we store a `double`.

Now add the `toJson` method below `fromJson`. It walks the fields in the opposite direction, building a map from the current `Sandwich`:

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

Each field becomes one entry in the returned `Map<String, dynamic>`, so `fromJson` and `toJson` are mirror images of each other.

### Load JSON data in SandwichRepository

Open `lib/repositories/sandwich_repository.dart`. We will add a method that reads the JSON asset file and turns it into a list of `Sandwich` objects. We build it one step at a time.

Start by adding the two imports we need at the top of the file, and a field to cache the result:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sandwich_shop/models/sandwich.dart';

class SandwichRepository {
  List<Sandwich>? _cachedSandwiches;
}
```

The `dart:convert` library gives us `jsonDecode`, which we use below to parse JSON text, and `package:flutter/services.dart` gives us `rootBundle`, which reads bundled asset files. The field `_cachedSandwiches` has the nullable type `List<Sandwich>?` (the `?` from Worksheet 4) so it starts as `null` and holds the list once we have loaded it.

Now add the loading method inside the class. Begin with its signature and the step that reads the file into a string:

```dart
  Future<List<Sandwich>> loadSandwichesFromAsset({
    String assetPath = 'assets/data/sandwiches.json',
  }) async {
    final String jsonString = await rootBundle.loadString(assetPath);
```

The method is marked `async` and returns a `Future<List<Sandwich>>`, the asynchronous pattern you met in Worksheet 4. `rootBundle.loadString(assetPath)` reads the contents of a bundled asset file into a single `String` at runtime; because reading a file takes time, it returns a `Future`, so we `await` it.

Next, parse that string into Dart data and cast it to a list:

```dart
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
```

`jsonDecode` turns a JSON string into ordinary Dart values: a JSON array becomes a `List`, and each JSON object inside becomes a `Map<String, dynamic>`. Its return type is `dynamic` because the shape depends on the file, so we use `as List<dynamic>` to assert that our file holds a list.

Now loop over the list, converting each map into a `Sandwich` with the `fromJson` constructor you just wrote. This is the same `for-in` loop pattern from Worksheet 4:

```dart
    final List<Sandwich> loadedSandwiches = [];
    for (final dynamic item in jsonList) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Sandwich sandwich = Sandwich.fromJson(itemMap);
      loadedSandwiches.add(sandwich);
    }
```

Finally, cache the list in the field and return it, then close the method:

```dart
    _cachedSandwiches = loadedSandwiches;
    return loadedSandwiches;
  }
```

We keep the original `getSandwiches()` method so existing screens stay simple. Add it below `loadSandwichesFromAsset`. It returns the cached list once it has loaded, and otherwise falls back to the two sandwiches defined directly in code:

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

Keep the `getSandwichById` method from Worksheet 4 unchanged at the end of the class:

```dart
  Sandwich? getSandwichById(String id) {
    for (final sandwich in getSandwiches()) {
      if (sandwich.id == id) {
        return sandwich;
      }
    }
    return null;
  }
```

Returning the fallback list synchronously keeps the existing views simple and responsive while the asynchronous `loadSandwichesFromAsset` is available for when you want to read the live menu from the asset file.

### Commit your changes (2)

Stage your JSON assets, model, and repository, then commit your changes.

## Managing an order basket

Now that users can navigate between screens and view menu items, we need a mechanism to hold sandwiches added to an order.

### Define the CartItem model

Create a new file named `lib/models/cart_item.dart`:

```dart
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get totalPrice {
    return price * quantity;
  }
}
```

### Create the CartRepository singleton

A singleton is a class that only ever has one instance. We use the singleton pattern here so that every screen accesses the exact same in-memory basket: when the order screen adds an item, the basket screen sees the same list. If each screen created its own `CartRepository`, items added on one screen would be invisible on another.

This is the plain-Dart singleton pattern, built from two language features and nothing else. There is a package named `singleton` on pub.dev, but it is deprecated and we do not use it; you never add a package for this. We build the class in small stages.

Create a new file named `lib/repositories/cart_repository.dart`. Start with the import and the class with its private constructor:

```dart
import 'package:sandwich_shop/models/cart_item.dart';

class CartRepository {
  CartRepository._internal();
}
```

The constructor `CartRepository._internal()` is private: the leading underscore means it cannot be called from outside this file. That is the whole point of a singleton. Because no other code can call the constructor, no other code can create a second `CartRepository`.

Next, add the one shared instance as a `static final` field:

```dart
  static final CartRepository instance = CartRepository._internal();
```

A `static` field belongs to the class itself rather than to any object, so there is exactly one of it. It is `final`, so it is created once and never reassigned. This line builds the single `CartRepository` the first time the class is used and exposes it as `CartRepository.instance`, which is how every screen reaches the shared basket.

Now add the private list that holds the basket items, and the three methods that read and change it:

```dart
  final List<CartItem> _items = [];

  List<CartItem> getItems() {
    return List<CartItem>.unmodifiable(_items);
  }

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }
```

The `_items` list is private so callers cannot reach in and change it directly. `getItems` returns `List<CartItem>.unmodifiable(_items)`, a read-only view of the list: a caller can read the items but cannot add to or remove from it, which keeps all changes going through `addItem` and `removeItem`. `removeItem` checks the index is in range before removing, to avoid an error.

Now add the methods that total the basket up. Add these three together:

```dart
  int getTotalItems() {
    int total = 0;
    for (final CartItem item in _items) {
      total += item.quantity;
    }
    return total;
  }

  double getSubtotal() {
    double sum = 0.0;
    for (final CartItem item in _items) {
      sum += item.totalPrice;
    }
    return sum;
  }

  double getDeliveryFee() {
    if (_items.isEmpty) {
      return 0.0;
    }
    return 1.50;
  }
```

`getTotalItems` and `getSubtotal` each use a `for-in` loop (from Worksheet 4) to add up the quantities and the line totals. `getDeliveryFee` charges a flat fee of 1.50 once the basket has at least one item, and nothing when it is empty.

Finally, add a method that combines the subtotal and delivery fee, and one that empties the basket:

```dart
  double getTotalDue() {
    return getSubtotal() + getDeliveryFee();
  }

  void clear() {
    _items.clear();
  }
```

`getTotalDue` adds the delivery fee to the subtotal, and `clear` empties the basket after a successful checkout.

### Add items from the order screen

Open `lib/screens/order_screen.dart`. We update the screen to use the consistent top bar with hamburger menu and to add sandwiches directly to `CartRepository.instance`. We build it a piece at a time.

Start with the imports and the `StatefulWidget` shell. This is the same `StatefulWidget`/`State` split you built in Worksheet 2, so the widget holds the fields and creates its state:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';

class OrderScreen extends StatefulWidget {
  final Sandwich sandwich;
  final int maxQuantity;

  const OrderScreen({
    super.key,
    required this.sandwich,
    this.maxQuantity = 10,
  });

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}
```

Now add the state class with the two pieces of state and the handlers that change the quantity. These use `setState` from Worksheet 2 to rebuild the screen after each change:

```dart
class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  String _confirmationMessage = '';

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }
}
```

Next, add the `_addToBasket` method inside the state class. It builds a `CartItem` from the sandwich and the chosen quantity, hands it to the shared repository, then sets a confirmation message:

```dart
  void _addToBasket() {
    if (_quantity > 0) {
      final CartItem item = CartItem(
        id: widget.sandwich.id,
        name: widget.sandwich.name,
        price: widget.sandwich.price,
        quantity: _quantity,
      );
      CartRepository.instance.addItem(item);
      setState(() {
        _confirmationMessage =
            'Added $_quantity ${widget.sandwich.name} to basket';
      });
    } else {
      setState(() {
        _confirmationMessage = 'Please select at least 1 sandwich';
      });
    }
  }
```

Because it calls `CartRepository.instance.addItem(item)`, the item lands in the one shared basket, so the basket screen will see it immediately.

Now add the `build` method inside the state class. Begin with the `Scaffold` and its `AppBar`, giving the app bar a hamburger menu button:

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        backgroundColor: shopBrand,
        foregroundColor: shopWhite,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const NavDrawer(),
```

The `leading` property places a widget at the start of the app bar. We want it to open the drawer by calling `Scaffold.of(context).openDrawer()`, which finds the nearest enclosing `Scaffold` and slides its drawer into view. The catch is that `Scaffold.of(context)` only works with a `context` that sits below the `Scaffold`, and the `context` passed into `build` sits above the `Scaffold` we are creating. The `Builder` widget solves this: it does nothing visible but gives its `builder` function a fresh `BuildContext` located below the `Scaffold`, so `Scaffold.of(context)` can find it. The button itself is an `IconButton` showing `Icons.menu`, the hamburger icon.

Now add the body, with the sandwich name, the current quantity display, the Add and Remove buttons, the confirmation message, and the closing brackets:

```dart
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Order ${widget.sandwich.name}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              OrderItemDisplay(
                _quantity,
                widget.sandwich.name,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _decreaseQuantity,
                    child: const Text('Remove'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _increaseQuantity,
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addToBasket,
                child: const Text('Add to Basket'),
              ),
              const SizedBox(height: 12),
              Text(
                _confirmationMessage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Finally, keep the `OrderItemDisplay` widget from Worksheet 2 at the end of the file. It has moved into this file but is otherwise unchanged:

```dart
class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
  }
}
```

### Choose a quantity with a DropdownMenu

So far the order screen changes the quantity with the Add and Remove buttons. A `DropdownMenu<int>` gives the same result in a single tap, and it is the pattern the Southsea Cinema listing screen uses to pick a number of tickets. You first met `DropdownMenu` in [Worksheet 2](./worksheet-2.md), where exercise 3 asked you to add one to the coursework. Here we re-show it in the sandwich shop so that selecting a quantity and then adding to the basket has a worked example.

Add the following helper method to `_OrderScreenState`. It returns the list of entries the dropdown displays:

```dart
  List<DropdownMenuEntry<int>> _buildQuantityEntries() {
    final List<DropdownMenuEntry<int>> entries = [];
    for (int value = 0; value <= widget.maxQuantity; value++) {
      final DropdownMenuEntry<int> entry = DropdownMenuEntry<int>(
        value: value,
        label: value.toString(),
      );
      entries.add(entry);
    }
    return entries;
  }
```

In the `build` method, you can offer the dropdown alongside the Add and Remove buttons. The `onSelected` callback stores the chosen number in `_quantity` with `setState`:

```dart
              DropdownMenu<int>(
                initialSelection: _quantity,
                onSelected: (int? value) {
                  if (value != null) {
                    setState(() {
                      _quantity = value;
                    });
                  }
                },
                dropdownMenuEntries: _buildQuantityEntries(),
              ),
```

Your order screen with the quantity dropdown should look like this:

<!-- TODO screenshot: images/5/order_screen_quantity_dropdown.png — show the OrderScreen with the DropdownMenu quantity picker open above the Add to Basket button -->

### Commit your changes (3)

Stage your model, repository, and updated order screen, then commit your changes.

## Building the basket screen

Now let us build `CartScreen` to display items in the basket, allow removing items, show totals, and handle the empty state.

### Create the CartScreen widget

Create a new file named `lib/screens/cart_screen.dart`. We build the screen with explicit helper methods, one at a time.

Start with the imports and the `StatefulWidget` shell:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}
```

Now open the state class and add a small helper that shows a message when the basket is empty:

```dart
class _CartScreenState extends State<CartScreen> {
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Your basket is empty',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
```

When the basket has items, we build the list of widgets procedurally rather than with a widget-literal list. Add a `_buildCartList` method inside the state class. We grow it in stages. Begin with the method signature, an empty `List<Widget>`, and the heading:

```dart
  Widget _buildCartList(CartRepository cart, List<CartItem> items) {
    final List<Widget> children = [];

    children.add(
      const Text(
        'Your Order',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
    children.add(const SizedBox(height: 16));
```

We create an empty `List<Widget>` and then call `children.add(...)` to append each widget in order. Building the list this way, instead of writing all the children inside one big `[...]`, keeps every step visible and lets us add widgets inside a loop next.

Now add the loop that appends one row per basket item. This is the same C-style `for` loop from Worksheet 4:

```dart
    for (int index = 0; index < items.length; index++) {
      final CartItem item = items[index];
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                '${item.quantity}x ${item.name}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '£${item.totalPrice.toStringAsFixed(2)}',
                textAlign: TextAlign.right,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                setState(() {
                  cart.removeItem(index);
                });
              },
            ),
          ],
        ),
      );
      children.add(const SizedBox(height: 8));
    }
```

Each row has two `Expanded` children and a delete button. You met `Expanded` in Worksheet 3, where it filled the leftover space. When a `Row` holds more than one `Expanded`, the `flex` property decides how that leftover space is shared out: each child's `flex` is its relative share. Here the name has `flex: 4` and the price has `flex: 2`, so the free space is divided in a 4-to-2 ratio, giving the name twice as much room as the price. The delete button is the `IconButton` you met in the drawer section, this time showing `Icons.delete_outline`; its `onPressed` removes the item at `index` and calls `setState` to rebuild the list.

Next, add the totals rows below the loop. Each is a `Row` with a label on the left and an amount on the right:

```dart
    children.add(const SizedBox(height: 16));

    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Subtotal'),
          Text('£${cart.getSubtotal().toStringAsFixed(2)}'),
        ],
      ),
    );
    children.add(const SizedBox(height: 8));

    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Delivery Fee'),
          Text('£${cart.getDeliveryFee().toStringAsFixed(2)}'),
        ],
      ),
    );
    children.add(const SizedBox(height: 8));

    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Due',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            '£${cart.getTotalDue().toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
    children.add(const SizedBox(height: 24));
```

Now add the checkout button, then return the assembled `Column`:

```dart
    children.add(
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              cart.clear();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully')),
            );
          },
          child: const Text('Checkout'),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
```

The button is wrapped in a `SizedBox` with `width: double.infinity`, which stretches it to the full available width. When tapped, it clears the basket and then shows a `SnackBar`, a short message that slides up from the bottom of the screen. You show one with `ScaffoldMessenger.of(context).showSnackBar(...)`, which finds the nearest `ScaffoldMessenger` and asks it to display the message.

Finally, add the `build` method. It reads the shared basket, chooses between the empty state and the list, and wraps the result so it can scroll:

```dart
  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    final Widget content;
    if (items.isEmpty) {
      content = _buildEmptyState();
    } else {
      content = _buildCartList(cart, items);
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
        child: content,
      ),
    );
  }
}
```

The body is a `SingleChildScrollView`. It takes a single child and makes it scrollable when the content is taller than the screen, which stops a long basket from overflowing the bottom edge. We will reuse it for the settings screen later.

Your basket screen with a few items added should look like this:

<!-- TODO screenshot: images/5/cart_screen_with_items.png — show the CartScreen listing basket items with the subtotal, delivery fee, total due, and checkout button -->

### Commit your changes (4)

Stage and commit `cart_screen.dart`.

## Handling user input and forms

Next, we build a settings screen where users configure contact details and preferences using `TextField` and `Switch`.

### Understand forms and text controllers

A `TextField` is Flutter's single-line (or multi-line) text input box. To read what the user has typed, and to set the text yourself, you attach a `TextEditingController` to it. A `TextEditingController` is an object that holds the current string value of a field: you can read `controller.text` at any time and assign to it to change what the field shows.

A controller is a resource that must be created and later released, so it fits naturally into the lifecycle of a `StatefulWidget`. Three `State` features manage that lifecycle, and each is new here.

The first is `initState`. It is a `State` lifecycle method that Flutter calls exactly once, when the `State` object is first created and before the first `build`. It is the right place to create controllers, because it runs before the field is ever drawn. You always call `super.initState()` first inside it.

The second is the `late` keyword. A controller is created in `initState`, not on the line where the field is declared, but the field is still non-nullable. The `late` keyword promises Dart that a non-nullable field will be given a value before it is first read, which lets you declare `late TextEditingController _addressController;` and assign it later in `initState`.

The third is `dispose`. It is the `State` lifecycle method Flutter calls once, when the `State` is permanently removed from the screen. Controllers hold resources that are not cleaned up automatically, so you call `controller.dispose()` here to release them and prevent a memory leak, then call `super.dispose()` last.

The Flutter team covers this same pattern in their [user input pathway tutorial](https://docs.flutter.dev/learn/pathway/tutorial/user-input), which walks through building a `TextField`, managing its text with a `TextEditingController`, and responding to the value the user types. Read it alongside this section if you would like a second worked example.

### Define the UserSettings model

Create a new file named `lib/models/user_settings.dart`. Alongside the name, address, and email we store a `customerId`, a short string that identifies the account. It follows the exact same pattern as the other text fields, so adding it now gives you a worked example of a form with three text fields.

Start with the fields and the `const` constructor. The fields follow the same pattern as the `Sandwich` model from Worksheet 3:

```dart
class UserSettings {
  final String name;
  final String address;
  final String email;
  final String customerId;
  final bool receiveNewsEmail;

  const UserSettings({
    required this.name,
    required this.address,
    required this.email,
    required this.customerId,
    required this.receiveNewsEmail,
  });
}
```

Every field is `final`, so once a `UserSettings` is created, none of its fields can change. That keeps the model safe to pass around, but it means we cannot edit one field in place when the user changes their address. The usual answer is a `copyWith` method: it returns a brand-new `UserSettings` that reuses all the current values except the ones you pass in.

Add `copyWith` inside the class:

```dart
  UserSettings copyWith({
    String? name,
    String? address,
    String? email,
    String? customerId,
    bool? receiveNewsEmail,
  }) {
    return UserSettings(
      name: name ?? this.name,
      address: address ?? this.address,
      email: email ?? this.email,
      customerId: customerId ?? this.customerId,
      receiveNewsEmail: receiveNewsEmail ?? this.receiveNewsEmail,
    );
  }
```

Every parameter is nullable (for example `String? name`) and has no value by default, so a caller passes only the fields they want to change. Each line then uses the `??` null-coalescing operator you met in the drawer section: `name ?? this.name` means "use the `name` that was passed in, or, when it is null, keep the current `this.name`". The settings screen will call this to change one field, such as the address, while keeping the rest unchanged.

### Build the SettingsScreen widget

Create a new file named `lib/screens/settings_screen.dart`. The screen has two modes, a display mode and an edit mode, and we build it a piece at a time.

Start with the imports and the `StatefulWidget` shell:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/user_settings.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}
```

Now open the state class and add its fields. There is a flag for the current mode, the current `UserSettings`, the three controllers from the previous section, and a boolean for the news toggle:

```dart
class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEditing = false;
  UserSettings _settings = const UserSettings(
    name: 'Student User',
    address: 'University of Portsmouth\nPortsmouth\nPO1 2UP',
    email: 'student@port.ac.uk',
    customerId: 'SS-1024',
    receiveNewsEmail: true,
  );

  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _customerIdController;
  bool _receiveNewsEmail = true;
}
```

Each controller is declared `late`, as explained above, because we create it in `initState` rather than here.

Next, add `initState` to create the controllers, filling each with the matching value from `_settings`:

```dart
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: _settings.address);
    _emailController = TextEditingController(text: _settings.email);
    _customerIdController = TextEditingController(text: _settings.customerId);
    _receiveNewsEmail = _settings.receiveNewsEmail;
  }
```

Then add `dispose` to release the three controllers when the screen is removed:

```dart
  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _customerIdController.dispose();
    super.dispose();
  }
```

Now add the two handlers for the edit-mode buttons. `_saveSettings` builds an updated `UserSettings` with `copyWith` from the controller text and leaves edit mode; `_cancelEditing` puts the original values back and leaves edit mode:

```dart
  void _saveSettings() {
    setState(() {
      _settings = _settings.copyWith(
        address: _addressController.text.trim(),
        email: _emailController.text.trim(),
        customerId: _customerIdController.text.trim(),
        receiveNewsEmail: _receiveNewsEmail,
      );
      _isEditing = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _addressController.text = _settings.address;
      _emailController.text = _settings.email;
      _customerIdController.text = _settings.customerId;
      _receiveNewsEmail = _settings.receiveNewsEmail;
      _isEditing = false;
    });
  }
```

Both read and write `controller.text`, which is how you get and set the current contents of a `TextField` through its controller.

Now add the display-mode subtree. It shows the stored details as plain `Text` and offers an Edit button:

```dart
  Widget _buildDisplayMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(_settings.address, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text(
          'Email Address',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(_settings.email, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text(
          'Customer ID',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(_settings.customerId, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text(
          'Preferences',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text('Receive news by email: '),
            Text(
              _settings.receiveNewsEmail ? 'Yes' : 'No',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          child: const Text('Edit Settings'),
        ),
      ],
    );
  }
```

The display mode ends with an Edit button that sets `_isEditing` to `true` and calls `setState`, which swaps the screen into edit mode.

Now add the edit-mode subtree. This is where the `TextField` and `Switch` inputs appear:

```dart
  Widget _buildEditMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _addressController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter address',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Email Address',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter email address',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Customer ID',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _customerIdController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter customer ID',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Receive news by email'),
            Switch(
              value: _receiveNewsEmail,
              onChanged: (bool value) {
                setState(() {
                  _receiveNewsEmail = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            ElevatedButton(
              onPressed: _cancelEditing,
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ],
    );
  }
```

Each editable field here is a `TextField`, Flutter's text input box. Its `controller` property wires the field to one of the `TextEditingController` objects you created in `initState`, so what the user types flows into that controller and `_saveSettings` can read it back. The address field sets `maxLines: 3` so it grows to three lines for a multi-line address, and the email field sets `keyboardType: TextInputType.emailAddress` so the on-screen keyboard shows the keys suited to typing an email.

Each field's `decoration` is an `InputDecoration`, which styles the box. We give it `border: OutlineInputBorder()` to draw a rectangular outline around the field, and a `hintText` that shows faint placeholder text while the field is empty.

The news preference uses a `Switch`, an on/off toggle. Its `value` is the current boolean, and its `onChanged` callback receives the new boolean each time the user flips it, which we store with `setState`.

Finally, add the `build` method. It picks the display or edit subtree based on `_isEditing`, then puts it inside the scaffold:

```dart
  @override
  Widget build(BuildContext context) {
    final Widget formContent;
    if (_isEditing) {
      formContent = _buildEditMode();
    } else {
      formContent = _buildDisplayMode();
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
              'My Settings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            formContent,
          ],
        ),
      ),
    );
  }
}
```

The body reuses the `SingleChildScrollView` from the basket screen so a tall form can scroll on a small screen.

Your settings screen in display mode, and again after tapping **Edit Settings**, should look like this:

<!-- TODO screenshot: images/5/settings_display_mode.png — show the SettingsScreen in display mode listing the delivery address, email, and customer ID -->
<!-- TODO screenshot: images/5/settings_edit_mode.png — show the SettingsScreen in edit mode with the three text fields and the news-by-email switch -->

### Commit your changes (5)

Stage and commit `user_settings.dart` and `settings_screen.dart`.

## Testing the basket and settings screens

In Worksheet 4 you wrote automated tests for models and repository classes. Now we add tests verifying our JSON serialisation, basket calculations, and screens.

### Unit test JSON serialisation

Open `test/sandwich_model_test.dart` and add tests for `fromJson` and `toJson`:

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

### Unit test the CartRepository

Because the `CartRepository` is a singleton, every test shares the same basket, so we must empty it before each test runs. The `setUp` function (a sibling of the `group` and `test` functions from Worksheet 4) runs its callback before each test, which is the right place to clear the basket.

Create a new file named `test/cart_repository_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  group('CartRepository tests', () {
    test('starts with empty basket and zero totals', () {
      final CartRepository cart = CartRepository.instance;
      expect(cart.getItems().length, 0);
      expect(cart.getTotalItems(), 0);
      expect(cart.getSubtotal(), 0.0);
      expect(cart.getDeliveryFee(), 0.0);
      expect(cart.getTotalDue(), 0.0);
    });

    test('adds items and calculates subtotal and delivery fee correctly', () {
      final CartRepository cart = CartRepository.instance;
      const CartItem item1 = CartItem(
        id: 'footlong',
        name: 'Footlong',
        price: 10.0,
        quantity: 2,
      );
      const CartItem item2 = CartItem(
        id: 'six_inch',
        name: 'Six-inch',
        price: 6.0,
        quantity: 1,
      );

      cart.addItem(item1);
      cart.addItem(item2);

      expect(cart.getItems().length, 2);
      expect(cart.getTotalItems(), 3);
      expect(cart.getSubtotal(), 26.0);
      expect(cart.getDeliveryFee(), 1.50);
      expect(cart.getTotalDue(), 27.50);
    });

    test('removes items correctly', () {
      final CartRepository cart = CartRepository.instance;
      const CartItem item = CartItem(
        id: 'footlong',
        name: 'Footlong',
        price: 10.0,
        quantity: 1,
      );
      cart.addItem(item);
      expect(cart.getItems().length, 1);

      cart.removeItem(0);
      expect(cart.getItems().length, 0);
      expect(cart.getTotalDue(), 0.0);
    });
  });
}
```

### Widget test the CartScreen

Create a new file named `test/cart_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/cart_screen.dart';

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets('CartScreen displays empty message when basket has no items',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CartScreen(),
      ),
    );

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Checkout'), findsNothing);
  });

  testWidgets('CartScreen renders items and removes item when delete pressed',
      (WidgetTester tester) async {
    const CartItem item = CartItem(
      id: 'footlong',
      name: 'Footlong',
      price: 10.0,
      quantity: 2,
    );
    CartRepository.instance.addItem(item);

    await tester.pumpWidget(
      const MaterialApp(
        home: CartScreen(),
      ),
    );

    expect(find.text('Your Order'), findsOneWidget);
    expect(find.text('2x Footlong'), findsOneWidget);
    expect(find.text('£20.00'), findsWidgets);
    expect(find.text('Checkout'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Your basket is empty'), findsOneWidget);
  });
}
```

### Widget test the SettingsScreen

Create a new file named `test/settings_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen toggles between display and edit modes',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );

    expect(find.text('My Settings'), findsWidgets);
    expect(find.text('Delivery Address'), findsOneWidget);
    expect(find.text('Edit Settings'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.text('Edit Settings'));
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(find.text('Edit Settings'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });
}
```

Run `flutter test` in your terminal to ensure all tests pass:

```bash
flutter test
```

### Commit your changes (6)

Stage and commit your tests.

## Exercises

The exercises below apply the concepts from this worksheet to the Southsea Cinema coursework application. They prepare you for Demo 3 of your coursework. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Remember to commit your changes to Git after each exercise.

1. Open your Southsea Cinema fork. Following [Define shared app constants](#define-shared-app-constants) and [Create the NavDrawer widget](#create-the-navdrawer-widget), create `lib/constants.dart` and `lib/widgets/nav_drawer.dart`. Ensure every primary screen uses the consistent `appTitle` ('Southsea Cinema') in its app bar and attaches `drawer: const NavDrawer()`. Use `Navigator.pushReplacementNamed` in the drawer navigation tiles so switching sections does not stack screens or display a default back arrow.

2. Create `assets/data/movies.json` with your film listings, matching [Create the JSON asset file](#create-the-json-asset-file), and register `- assets/data/` under `flutter:` in `pubspec.yaml`. Add `Movie.fromJson` and `Movie.toJson` to `lib/models/movie.dart`, then add a `loadMoviesFromAsset()` method to `lib/repositories/movie_repository.dart` that reads and parses the file, following [Loading menu data from JSON](#loading-menu-data-from-json).

3. In `lib/models/basket_item.dart`, define a `BasketItem` model containing `movieId`, `movieTitle`, `ageRating`, `screeningTime`, `ticketPrice`, and `quantity`, with a `totalPrice` getter. Build a `BasketRepository` singleton in `lib/repositories/basket_repository.dart` that stores basket items, calculates the service charge, and calculates the total due, matching [Create the CartRepository singleton](#create-the-cartrepository-singleton).

4. On your movie listing screen, let the user pick how many tickets they want with a `DropdownMenu<int>`, as re-shown in [Choose a quantity with a DropdownMenu](#choose-a-quantity-with-a-dropdownmenu), and add the chosen quantity to the basket through `BasketRepository.instance.addItem()`. If you have not yet built the ticket-quantity dropdown from Worksheet 2 exercise 3, complete it first.

5. Build a basket view that presents each order with its film title, screening time, ticket quantity, and line total, lets the user remove items, and shows a message when the basket is empty. Southsea Cinema buttons are squared rather than rounded, so give each button `shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)`. Use [Building the basket screen](#building-the-basket-screen) as your reference.

6. Add a settings view with display and edit modes where the user can review and change their contact details and email newsletter preference. Decide which details Southsea Cinema should store for a patron and how to lay the form out, drawing on [Handling user input and forms](#handling-user-input-and-forms). Remember to create and dispose a controller for every text field.

7. Design and test your Demo 3 experience end to end: decide how a patron moves between the listings, basket, and settings, and cover the behaviour you care about with unit and widget tests. Run `dart analyze` and `flutter test` and resolve every warning and failure. **Show your running drawer, basket, and settings views to a member of staff** for your Demo 3 practical checkpoint.
