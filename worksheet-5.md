# Worksheet 5 — Navigation Drawer, Basket Management, and Forms

## Table of contents

- [What you need to know beforehand](#what-you-need-to-know-beforehand)
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

## What you need to know beforehand

Ensure that you have completed [Worksheet 1 — Dart, Git, GitHub and Flutter](./worksheet-1.md), [Worksheet 2 — Stateless and Stateful Widgets](./worksheet-2.md), [Worksheet 3 — Data Models, Repositories, Assets and In-Page Navigation](./worksheet-3.md), and [Worksheet 4 — Unit and Widget Testing](./worksheet-4.md). You should be comfortable building stateful widgets, writing model and repository classes, and writing automated unit and widget tests.

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

In Worksheet 3 we introduced stack-based navigation using `Navigator.push`. By default in Flutter, pushing a new route places it on top of a history stack and displays a back arrow (`<-`) in the app bar.

While a back button makes sense for simple linear flows, it can cause problems when users want to switch between main areas of an application, such as viewing their basket or editing their settings. Stacking screens indefinitely clutters history and causes inconsistencies across headers.

A consistent multi-screen architecture solves this by providing:

1. A unified top app bar displaying the application title across every view.
2. A sliding navigation drawer accessible from any primary screen.
3. Centralized named routes registered in `MaterialApp` using `Navigator.pushReplacementNamed`, keeping each section at the top level without unwanted back arrows.

### Application navigation drawer

A drawer is a panel that slides in horizontally from the edge of a `Scaffold` to show navigation links. Flutter provides the `Drawer` widget, which works directly with the `drawer` property of `Scaffold`.

When a `Scaffold` contains a `Drawer`, Flutter automatically provides a hamburger menu button (`☰`) in the `AppBar`. Tapping this button slides the drawer into view.

### Named routes in MaterialApp

Instead of writing `MaterialPageRoute` every time you navigate, you can assign unique string paths to screens, such as `'/'`, `'/cart'`, and `'/settings'`.

You register these paths inside the `routes` map of `MaterialApp`. Once registered, any widget can navigate to a destination using `Navigator.pushReplacementNamed(context, '/cart')`.

## Building the navigation drawer

Let us build a reusable navigation drawer widget and a consistent app bar that can be attached to any screen in the application.

### Define shared app constants

Create a new file named `lib/constants.dart`. This centralizes the title and styling across all views:

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

Create a new file named `lib/widgets/nav_drawer.dart`. Add the following code:

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
            const DrawerTile(title: 'Menu', route: '/'),
            const DrawerTile(title: 'My Basket', route: '/cart'),
            const DrawerTile(title: 'My Settings', route: '/settings'),
          ],
        ),
      ),
    );
  }
}

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
        Navigator.pop(context);
        final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
        if (currentRoute != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
```

Notice the call `Navigator.pushReplacementNamed(context, route)`. By replacing the current route rather than pushing on top, the app never stacks pages or displays a back button when switching between primary sections. The hamburger menu remains consistent across the whole application.

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

Stage your new files and commit your changes:

```bash
git add lib/constants.dart lib/widgets/nav_drawer.dart lib/main.dart lib/screens/menu_screen.dart
git commit -m "Add shared constants, navigation drawer, and route configuration"
```

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

Open `lib/models/sandwich.dart`. We add a factory constructor named `fromJson` and a `toJson` method:

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
}
```

### Load JSON data in SandwichRepository

Open `lib/repositories/sandwich_repository.dart`. We add a `loadSandwichesFromAsset()` method that reads the file string using `rootBundle.loadString()` and parses it with `jsonDecode()`:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sandwich_shop/models/sandwich.dart';

class SandwichRepository {
  List<Sandwich>? _cachedSandwiches;

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

  Sandwich? getSandwichById(String id) {
    for (final sandwich in getSandwiches()) {
      if (sandwich.id == id) {
        return sandwich;
      }
    }
    return null;
  }
}
```

Notice that `getSandwiches()` returns `_cachedSandwiches` if loaded, falling back to mock sandwiches synchronously so existing views remain simple and responsive.

### Commit your changes (2)

Stage your JSON assets, model, and repository:

```bash
git add assets/data/sandwiches.json pubspec.yaml lib/models/sandwich.dart lib/repositories/sandwich_repository.dart
git commit -m "Add JSON menu asset and parsing methods"
```

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

A singleton ensures that every screen accesses the exact same in-memory repository instance. Create a new file named `lib/repositories/cart_repository.dart`:

```dart
import 'package:sandwich_shop/models/cart_item.dart';

class CartRepository {
  CartRepository._internal();

  static final CartRepository instance = CartRepository._internal();

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

  double getTotalDue() {
    return getSubtotal() + getDeliveryFee();
  }

  void clear() {
    _items.clear();
  }
}
```

### Add items from the order screen

Open `lib/screens/order_screen.dart`. We will update the screen to use the consistent top bar with hamburger menu, and add sandwiches directly to `CartRepository.instance`:

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

Notice the `leading` property in `AppBar`: by providing a `Builder` that calls `Scaffold.of(context).openDrawer()`, the top bar maintains the exact same hamburger menu appearance on `OrderScreen`.

### Commit your changes (3)

Stage your model, repository, and updated order screen:

```bash
git add lib/models/cart_item.dart lib/repositories/cart_repository.dart lib/screens/order_screen.dart
git commit -m "Implement cart item model and repository with order screen integration"
```

## Building the basket screen

Now let us build `CartScreen` to display items in the basket, allow removing items, show totals, and handle the empty state.

### Create the CartScreen widget

Create a new file named `lib/screens/cart_screen.dart`. We implement it with explicit helper methods:

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

  Widget _buildCartList(CartRepository cart, List<CartItem> items) {
    final List<Widget> children = [];

    children.add(
      const Text(
        'Your Order',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
    children.add(const SizedBox(height: 16));

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

Notice how `_buildCartList` builds a `List<Widget>` procedurally using `children.add()`. This avoids spread operators and keeps every layout step transparent.

### Commit your changes (4)

Stage and commit `cart_screen.dart`:

```bash
git add lib/screens/cart_screen.dart
git commit -m "Build cart screen with order summary and remove functionality"
```

## Handling user input and forms

Next, we build a settings screen where users configure contact details and preferences using `TextField` and `Switch`.

### Understand forms and text controllers

In Flutter, you manage the content of a `TextField` using a `TextEditingController`.

A `TextEditingController` holds the current string value of an input field. You create the controller inside `initState`, pass it to `TextField`, and dispose of it inside `dispose` to prevent memory leaks.

### Define the UserSettings model

Create a new file named `lib/models/user_settings.dart`:

```dart
class UserSettings {
  final String name;
  final String address;
  final String email;
  final bool receiveNewsEmail;

  const UserSettings({
    required this.name,
    required this.address,
    required this.email,
    required this.receiveNewsEmail,
  });

  UserSettings copyWith({
    String? name,
    String? address,
    String? email,
    bool? receiveNewsEmail,
  }) {
    return UserSettings(
      name: name ?? this.name,
      address: address ?? this.address,
      email: email ?? this.email,
      receiveNewsEmail: receiveNewsEmail ?? this.receiveNewsEmail,
    );
  }
}
```

### Build the SettingsScreen widget

Create a new file named `lib/screens/settings_screen.dart`. We provide two distinct states: display mode and edit mode:

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

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEditing = false;
  UserSettings _settings = const UserSettings(
    name: 'Student User',
    address: 'University of Portsmouth\nPortsmouth\nPO1 2UP',
    email: 'student@port.ac.uk',
    receiveNewsEmail: true,
  );

  late TextEditingController _addressController;
  late TextEditingController _emailController;
  bool _receiveNewsEmail = true;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: _settings.address);
    _emailController = TextEditingController(text: _settings.email);
    _receiveNewsEmail = _settings.receiveNewsEmail;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    setState(() {
      _settings = _settings.copyWith(
        address: _addressController.text.trim(),
        email: _emailController.text.trim(),
        receiveNewsEmail: _receiveNewsEmail,
      );
      _isEditing = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _addressController.text = _settings.address;
      _emailController.text = _settings.email;
      _receiveNewsEmail = _settings.receiveNewsEmail;
      _isEditing = false;
    });
  }

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

### Commit your changes (5)

Stage and commit `user_settings.dart` and `settings_screen.dart`:

```bash
git add lib/models/user_settings.dart lib/screens/settings_screen.dart
git commit -m "Implement user settings screen with view and edit form modes"
```

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

    expect(find.byType(TextField), findsNWidgets(2));
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

Stage and commit your tests:

```bash
git add test/sandwich_model_test.dart test/cart_repository_test.dart test/cart_screen_test.dart test/settings_screen_test.dart
git commit -m "Add unit and widget tests for cart repository, cart screen, and settings screen"
```

## Exercises

The exercises below apply the concepts from this worksheet to the Southsea Cinema coursework application. They prepare you for Demo 3 of your coursework. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Remember to commit your changes to Git after each exercise.

1. Open your Southsea Cinema fork. Following [Define shared app constants](#define-shared-app-constants) and [Create the NavDrawer widget](#create-the-navdrawer-widget), create `lib/constants.dart` and `lib/widgets/nav_drawer.dart`. Ensure every primary screen uses the consistent `appTitle` ('Southsea Cinema') in its app bar and attaches `drawer: const NavDrawer()`. Use `Navigator.pushReplacementNamed` in drawer navigation tiles to avoid stacking screens or displaying default back arrows.

2. In `assets/data/movies.json`, create a JSON file with film listings, matching [Create the JSON asset file](#create-the-json-asset-file). Register `- assets/data/` in `pubspec.yaml`. Add `Movie.fromJson` and `Movie.toJson` to `lib/models/movie.dart`, and add `loadMoviesFromAsset()` in `lib/repositories/movie_repository.dart`.

3. In `lib/models/basket_item.dart`, define a `BasketItem` model containing `movieId`, `movieTitle`, `ageRating`, `screeningTime`, `ticketPrice`, and `quantity`, with a `totalPrice` getter. Build a `BasketRepository` singleton in `lib/repositories/basket_repository.dart` that stores basket items, calculates the service charge, and calculates the total due, matching [Create the CartRepository singleton](#create-the-cartrepository-singleton).

4. Update your movie listing screen so that choosing ticket quantities adds the item to `BasketRepository.instance.addItem()`.

5. Build `BasketView` in `lib/views/basket_view.dart`, following [Building the basket screen](#building-the-basket-screen). Present order items with film titles, screening times, ticket quantities, and line totals. Include buttons to remove items and display an empty message when the basket is empty. Ensure all buttons use squared corners with `shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)`.

6. Build `SettingsView` in `lib/views/settings_view.dart`, following [Handling user input and forms](#handling-user-input-and-forms). Include address and email text fields with `TextEditingController`, and a `Switch` widget for email newsletter preferences. Provide display and edit modes.

7. Write unit tests for `BasketRepository` and widget tests for `BasketView` and `SettingsView`. Run `dart analyze` and `flutter test` to verify zero analyser warnings and passing tests. **Show your running drawer, basket, and settings views to a member of staff** for your Demo 3 practical checkpoint.
