# Worksheet 5 — Navigation, state and forms

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 4](#continue-from-worksheet-4)
  - [Clone the Sandwich Shop repository](#clone-the-sandwich-shop-repository)
  - [Switch to branch 4](#switch-to-branch-4)
- [What this worksheet builds](#what-this-worksheet-builds)
- [Shared constants and the Subway theme](#shared-constants-and-the-subway-theme)
  - [Define the shared constants](#define-the-shared-constants)
  - [Apply the theme in main](#apply-the-theme-in-main)
  - [Hide the debug banner](#hide-the-debug-banner)
  - [Commit your changes (1)](#commit-your-changes-1)
- [Reusable widgets and navigation](#reusable-widgets-and-navigation)
  - [Build the primary button](#build-the-primary-button)
  - [Widget test the primary button](#widget-test-the-primary-button)
  - [Extract a reusable basket button](#extract-a-reusable-basket-button)
  - [Widget test the basket button](#widget-test-the-basket-button)
  - [Register named routes](#register-named-routes)
  - [Add the basket button to the menu app bar](#add-the-basket-button-to-the-menu-app-bar)
  - [Widget test the menu screen](#widget-test-the-menu-screen)
  - [Commit your changes (2)](#commit-your-changes-2)
- [Building the order form](#building-the-order-form)
  - [Recap the quantity controls](#recap-the-quantity-controls)
  - [Add the toasted and vegan switches](#add-the-toasted-and-vegan-switches)
  - [Add the note field with a text controller](#add-the-note-field-with-a-text-controller)
  - [Add items to the basket](#add-items-to-the-basket)
  - [Lay out the order screen](#lay-out-the-order-screen)
  - [Widget test the order form](#widget-test-the-order-form)
  - [Commit your changes (3)](#commit-your-changes-3)
- [Holding an order in a basket](#holding-an-order-in-a-basket)
  - [Define the cart item model](#define-the-cart-item-model)
  - [Create the cart repository singleton](#create-the-cart-repository-singleton)
  - [Unit test the cart repository](#unit-test-the-cart-repository)
  - [Build the basket screen widget](#build-the-basket-screen-widget)
  - [Widget test the basket screen](#widget-test-the-basket-screen)
  - [Commit your changes (4)](#commit-your-changes-4)
- [Loading the menu from JSON](#loading-the-menu-from-json)
  - [Create the JSON asset file](#create-the-json-asset-file)
  - [Register the asset in pubspec](#register-the-asset-in-pubspec)
  - [Add JSON serialisation to the sandwich model](#add-json-serialisation-to-the-sandwich-model)
  - [Load JSON data in the repository](#load-json-data-in-the-repository)
  - [Unit test JSON serialisation](#unit-test-json-serialisation)
  - [Commit your changes (5)](#commit-your-changes-5)
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

Switch to branch `4` so your code matches the Worksheet 4 end state:

```bash
git checkout 4
```

Run `flutter test` to confirm that all tests pass before continuing.

## What this worksheet builds

So far the app shows a menu and lets you add and remove sandwiches on a single order screen. In this worksheet we turn it into a small multi-screen shop.

We start with the look and feel. We pull the shared colours and text styles into one file, give the app a tidy Subway-inspired green theme, and build the reusable buttons and the navigation that let the user move between a menu screen, an order screen and a basket screen. We build this user interface first, with its screens wired together, before any of the shopping behaviour is in place. Only once the screens exist do we add the order form, then the shared basket behind it, and finally move the menu into a JSON data file.

We write the tests alongside the code they check, section by section, rather than leaving them to the end.

Placing an order does nothing yet beyond clearing the basket and showing a message. Saving orders so they survive a restart is the job of [Worksheet 6](./worksheet-6.md).

## Shared constants and the Subway theme

Values such as the app title and the brand colour are used on every screen. Rather than repeat them, we keep them in one file and import it where we need it. This also makes the theme easy to change in a single place.

### Define the shared constants

Create a new file named `lib/constants.dart`. Start with the import and the app title:

```dart
import 'package:flutter/material.dart';

const String appTitle = 'Sandwich Shop';
```

The `import` gives us the `Color` and `TextStyle` types used below. The `appTitle` is a top-level `const` string, so any screen can read `appTitle` after importing this file.

Next, add the colour palette. These four colours give the shop a minimal Subway-inspired look, built around their familiar green:

```dart
// Subway-inspired palette, kept minimal.
const Color shopBrand = Color(0xFF008C15);
const Color shopWhite = Colors.white;
const Color shopBackground = Color(0xFFF5F5F0);
const Color shopText = Color(0xFF1B2B1B);
```

Each colour is a `const Color`. The `Color(0xFF008C15)` form builds a colour from a hexadecimal value: the first two digits (`FF`) are the opacity and the remaining six are the red, green, and blue parts. `shopBrand` is the Subway green used for the app bar and buttons, `shopBackground` is the soft off-white behind every screen, and `shopText` is the dark green used for body text.

Finally, add two shared text styles. A `TextStyle` describes how text looks, such as its weight and size:

```dart
const TextStyle shopHeaderStyle = TextStyle(
  fontWeight: FontWeight.bold,
  letterSpacing: 1.1,
);

const TextStyle shopSectionTitleStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: shopText,
);
```

The `fontWeight: FontWeight.bold` property makes the text bold, `letterSpacing` spreads the letters slightly apart, and `fontSize` sets the height of the text in logical pixels. We use `shopHeaderStyle` for the app bar title and `shopSectionTitleStyle` for the heading at the top of a screen, so every screen reads consistently.

### Apply the theme in main

Open `lib/main.dart`. We give `MaterialApp` a theme built from these constants so the colours apply everywhere. Replace the file contents with the following, which we will walk through:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: shopBrand,
          primary: shopBrand,
        ),
        scaffoldBackgroundColor: shopBackground,
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
        '/basket': (BuildContext context) {
          return const BasketScreen();
        },
      },
    );
  }
}
```

The `theme` property takes a `ThemeData`, the object that holds the app's default colours and styles. `ColorScheme.fromSeed` builds a full set of matching colours from one seed colour, here our `shopBrand` green. `scaffoldBackgroundColor: shopBackground` paints every screen's background with the off-white. The `appBarTheme` sets the app bar's `backgroundColor` to green and its `foregroundColor` (the colour of the title and icons on it) to white, with `elevation: 0` to remove its drop shadow for a flat look.

The `initialRoute` and `routes` parts are covered in the next section. The two imports for `basket_screen.dart` and `menu_screen.dart` refer to files we update shortly; the app will not compile cleanly until then, which is expected.

### Hide the debug banner

Notice the `debugShowCheckedModeBanner: false` line in the `MaterialApp` above. The debug banner is the small grey "DEBUG" ribbon that Flutter draws across the top-right corner when you run a debug build. The ribbon is only a reminder that the build is not optimised for release, and it never appears in a release build. We set it to `false` here, directly on `MaterialApp`, so the app looks clean while you develop, and it is a one-line change in this one place.

With the theme and this one line in place, the app bar is a flat Subway green with white text and no debug ribbon, as shown below.

<!-- TODO screenshot: images/5/themed_app_bar.png — show the app bar in flat Subway green with white title text and no debug ribbon in the corner -->

### Commit your changes (1)

Stage your new `constants.dart` and the updated `main.dart`, then commit your changes with a short, descriptive message of your own.

## Reusable widgets and navigation

Before we add any shopping behaviour, we build the look and the movement of the app: the buttons we reuse everywhere and the navigation between the menu, order and basket screens. We are deliberately building the user interface first. The buttons will not do much yet, and the basket screen will be close to empty, because the data behind them comes in later sections. Building the shells first means we can see the app take shape and navigate around it before we wire in the logic.

### Build the primary button

Several screens show a wide green action button. Rather than repeat the same styled `ElevatedButton` in each place, we pull it into one small widget. This is how common widgets are shared across a project: define once, reuse everywhere, and restyle in one file.

Create a new file named `lib/widgets/primary_button.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: shopBrand,
        foregroundColor: shopWhite,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
```

`PrimaryButton` is a `StatelessWidget` (from Worksheet 2) with two fields: the `label` to show and an `onPressed` callback to run when tapped. Its type `VoidCallback` is Dart's name for a function that takes no arguments and returns nothing, which is exactly the shape `onPressed` needs. The `build` method returns a styled `ElevatedButton`: `ElevatedButton.styleFrom` sets the Subway green `backgroundColor` and white `foregroundColor` from our constants, so every primary button in the app matches without repeating the style. We use it for the Add to Basket and Checkout buttons when we build those screens.

### Widget test the primary button

A reusable widget deserves its own test. Create a new file named `test/widgets/primary_button_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';

void main() {
  testWidgets('PrimaryButton renders its label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Order',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Order'), findsOneWidget);
  });

  testWidgets('PrimaryButton invokes onPressed when tapped',
      (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Order',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Order'));
    await tester.pump();

    expect(wasPressed, isTrue);
  });
}
```

The first test checks that the label is drawn. The second passes an `onPressed` that flips a local `wasPressed` boolean, taps the button, and checks the flag turned true, proving the callback fired.

### Extract a reusable basket button

Every screen in the app wants the same basket button in its app bar, so rather than repeat the same `IconButton` on each screen we build it once as its own widget. This keeps the navigation behaviour in one place.

Create a new file named `lib/widgets/basket_button.dart`:

```dart
import 'package:flutter/material.dart';

class BasketButton extends StatelessWidget {
  const BasketButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_basket),
      onPressed: () {
        final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
        if (currentRoute != '/basket') {
          Navigator.pushNamed(context, '/basket');
        }
      },
    );
  }
}
```

`BasketButton` is a `StatelessWidget` (from Worksheet 2). Its `build` method returns an `IconButton`, a tappable button whose child is one `Icon` and which runs its `onPressed` function when tapped. The `Icon` widget draws one icon from `Icons`, the catalogue of built-in Material icons, so `Icons.shopping_basket` shows a basket.

The `onPressed` first reads the name of the current route. `ModalRoute.of(context)` returns the route the button is on, and `?.settings.name` reads its registered name, falling back to the empty string with `?? ''` when there is none. If the current route is not already `'/basket'`, it calls `Navigator.pushNamed(context, '/basket')` to open the basket by its registered name. The check means tapping the basket button while already on the basket screen does nothing, so we never stack the basket on top of itself.

### Widget test the basket button

The reusable `BasketButton` also deserves a test, so we check it draws the basket icon and that tapping it navigates to the basket route. Create a new file named `test/widgets/basket_button_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';

void main() {
  testWidgets('BasketButton shows the basket icon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BasketButton(),
        ),
      ),
    );

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
  });

  testWidgets('Tapping BasketButton navigates to the basket', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return const Scaffold(body: BasketButton());
          },
          '/basket': (BuildContext context) {
            return const BasketScreen();
          },
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.shopping_basket));
    await tester.pumpAndSettle();

    expect(find.byType(BasketScreen), findsOneWidget);
  });
}
```

The first test pumps a `BasketButton` on its own and checks the basket icon is drawn. The second registers the menu and basket routes, taps the button, and checks the app has navigated to the `BasketScreen`. The `BasketScreen` is the shell we build later in this worksheet; the test compiles against it once that file exists.

### Register named routes

The app has two main screens reached by name: the menu and the basket. We let the user move between them without stacking an endless history, using named routes.

In Worksheet 3 you navigated with `Navigator.push`, which stacks a new screen on top of the old one and shows a back arrow. That is right for a detail screen you expect to return from, such as the order screen opened from a menu card. For top-level destinations such as the basket, it is tidier to give each screen a name.

A named route is a short string path, such as `'/'` for the menu and `'/basket'` for the basket. You register these names in the `routes` map of `MaterialApp`, which you already added when applying the theme. Each entry maps a path to a function that builds the screen for it. The `initialRoute: '/'` property tells the app which route to show first.

Once a route is registered, any widget can navigate to it by name with `Navigator.pushNamed(context, '/basket')`, without repeating the builder each time. That is exactly what `BasketButton` does.

### Add the basket button to the menu app bar

Open `lib/screens/menu_screen.dart`. We put the reusable `BasketButton` in the app bar so the menu can open the basket. Replace the file contents with the following:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
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
        actions: const [BasketButton()],
      ),
      body: ListView.builder(
        itemCount: sandwiches.length,
        itemBuilder: (BuildContext context, int index) {
          return SandwichCard(sandwich: sandwiches[index]);
        },
      ),
    );
  }
}
```

The `actions` property of an `AppBar` holds a list of widgets shown at its end, after the title. Here it holds a single `BasketButton`. Because `BasketButton` carries all its own behaviour, every screen that wants the basket button simply lists `const BasketButton()` in its `actions`, and we add it to the order and basket screens as we build them.

With the basket button in place, the menu's app bar should look like this, with the basket icon at its right-hand end:

<!-- TODO screenshot: images/5/menu_app_bar_basket_button.png — show the menu screen app bar with the title and the basket icon button at its right-hand end, and the themed menu list below -->

### Widget test the menu screen

Create a new file named `test/menu_screen_test.dart` to check the menu draws its title and the basket button:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';

void main() {
  testWidgets('MenuScreen shows the title and the basket button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MenuScreen(),
      ),
    );

    expect(find.text('Sandwich Shop'), findsOneWidget);
    expect(find.byType(BasketButton), findsOneWidget);
  });
}
```

The test pumps the `MenuScreen` and checks that the app title and the reusable `BasketButton` are both on screen.

### Commit your changes (2)

Stage your new `primary_button.dart`, `basket_button.dart`, their test files, the updated `menu_screen.dart`, and the menu screen test, then commit your changes with a short message of your own.

## Building the order form

With the screens wired together, we now give the order screen its form. The order screen already lets the user pick a quantity. We turn it into a short form: two on/off switches for toasted and vegan, and a note field for the kitchen. The whole form is wrapped in a scrolling view so it fits on a small screen.

The Flutter team covers this same ground in their [user input pathway tutorial](https://docs.flutter.dev/learn/pathway/tutorial/user-input), which walks through handling what a user types and toggles. Read it alongside this section for a second worked example.

### Recap the quantity controls

Open `lib/screens/order_screen.dart`. The screen is a `StatefulWidget` (from Worksheet 2) because it holds state that changes as the user interacts. Replace the file contents and we will build it up section by section. Start with the imports and the widget shell:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';

class OrderScreen extends StatefulWidget {
  final Sandwich sandwich;
  final int maxQuantity;

  const OrderScreen({super.key, required this.sandwich, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}
```

The widget takes the `sandwich` to order and a `maxQuantity` with a default of `10`. The imports of `cart_item.dart` and `cart_repository.dart` refer to the basket model and repository we build in the next section, so the file will not compile cleanly until then; that is expected, because we are building the form before the basket behind it.

Now begin the state class with the state it holds. The quantity and the two switch values carry over as fields, and we will add the note controller in a moment:

```dart
class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  bool _toasted = false;
  bool _vegan = false;
  late TextEditingController _noteController;
  String _confirmationMessage = '';
}
```

The quantity handlers are unchanged from the earlier order screen. Add them inside the state class. Each uses `setState` (from Worksheet 2) to rebuild the screen after changing `_quantity`:

```dart
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
```

The Add and Remove buttons are the only quantity control on the screen, so a user raises the count one tap at a time and lowers it the same way. This keeps the order screen simple and leaves the form to focus on the toasted and vegan choices and the kitchen note.

### Add the toasted and vegan switches

The two toggles each use a `Switch`, Flutter's on/off control. A `Switch` has a boolean `value` that says whether it is on, and an `onChanged` callback that receives the new boolean each time the user flips it. We store that boolean in state with `setState` so the screen reflects the change.

We lay out each switch inside a `Row` with a label on the left. The label is wrapped in an `Expanded`. You met `Expanded` in Worksheet 3, where it filled the leftover space in a row; here it pushes the label to the left and the switch to the right by taking all the free space between them.

You do not type these rows on their own; they go inside the `build` method we assemble shortly. For now, note how one switch row is written so it is familiar when it appears:

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
                  },
                ),
              ],
            ),
```

### Add the note field with a text controller

The note is a `TextField`, Flutter's text input box. To read what the user types, you attach a `TextEditingController` to it. A `TextEditingController` is an object that holds the current string value of a field: you can read `controller.text` at any time, and set it to change what the field shows.

A controller is a resource that must be created and later released, which fits the lifecycle of a `StatefulWidget`. Three `State` features manage that lifecycle, and each is new here.

The first is `initState`. It is a `State` lifecycle method Flutter calls exactly once, when the `State` is first created and before the first `build`. It is the right place to create a controller, because it runs before the field is ever drawn. You always call `super.initState()` first inside it.

The second is the `late` keyword. We create the controller in `initState`, not on the line where the field is declared, yet the field is still non-nullable. The `late` keyword promises Dart that a non-nullable field will be given a value before it is first read, which lets us declare `late TextEditingController _noteController;` and assign it later. That is why the field above was written with `late`.

The third is `dispose`. It is the `State` lifecycle method Flutter calls once, when the `State` is permanently removed from the screen. Controllers hold resources that are not cleaned up automatically, so you call `controller.dispose()` here to release them and prevent a memory leak, then call `super.dispose()` last.

Add `initState` and `dispose` inside the state class, just below the fields:

```dart
  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
```

### Add items to the basket

Now add the `_addToBasket` method. It reads the note from the controller, builds a `CartItem` carrying the quantity, the two toggles, and the note, hands it to the shared repository, then sets a confirmation message:

```dart
  void _addToBasket() {
    if (_quantity > 0) {
      final String note = _noteController.text.trim();
      final CartItem item = CartItem(
        id: widget.sandwich.id,
        name: widget.sandwich.name,
        price: widget.sandwich.price,
        quantity: _quantity,
        toasted: _toasted,
        vegan: _vegan,
        note: note,
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

This method refers to `CartItem` and `CartRepository`, which we create in the next section. For now, read it as the plan for how the form hands an order over: it builds one `CartItem` from the form state and hands it to `CartRepository.instance.addItem(item)` so the item lands in the one shared basket. The call `_noteController.text.trim()` reads the current text from the controller and trims any spaces at its ends. When the quantity is still zero, we show a short prompt instead.

### Lay out the order screen

Finally, add the `build` method. It wraps everything in a `SingleChildScrollView`, a widget that takes one child and makes it scrollable when the content is taller than the screen, so a long form never overflows the bottom edge:

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ${widget.sandwich.name}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            OrderItemDisplay(_quantity, widget.sandwich.name),
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
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Text('Toasted')),
                Switch(
                  value: _toasted,
                  onChanged: (bool value) {
                    setState(() {
                      _toasted = value;
                    });
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
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Note for the kitchen',
                hintText: 'Add any notes for this order',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Add to Basket',
                onPressed: _addToBasket,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
```

The heading `Text` sets its own `fontSize` to `22` and `fontWeight` to bold for a clear title. The quantity `Row` keeps the Add and Remove buttons from before. Then come the two switch rows, the note `TextField`, and the Add to Basket button built from the `PrimaryButton` widget. The app bar lists `const BasketButton()` in its `actions`, so the reusable basket button appears here just as it does on the menu.

The `TextField` wires its `controller` to `_noteController`, sets `maxLines: 3` so it grows to three lines, and gives a `decoration`. The `decoration` is an `InputDecoration`, which styles the box: `border: OutlineInputBorder()` draws a rectangular outline, `labelText` is the caption that floats above the field, and `hintText` is the faint placeholder shown while the field is empty. The button is wrapped in a `SizedBox` with `width: double.infinity` to stretch it to the full width.

Keep the `OrderItemDisplay` widget from Worksheet 2 at the end of the file. It is unchanged:

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

Your order screen with the switches and note field should look like this:

<!-- TODO screenshot: images/5/order_screen_form.png — show the order screen with the quantity controls, the toasted and vegan switches, the note field, and the Add to Basket button -->

### Widget test the order form

Create a new file named `test/order_screen_test.dart`. We match the note field by its label so the finder stays clear about which field it means:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/order_screen.dart';

const Sandwich testSandwich = Sandwich(
  id: 'test',
  name: 'Test Sub',
  description: 'Test description',
  price: 5.0,
  imagePath: 'assets/images/footlong.jpeg',
);

// Match the note field by its label so the finder is unambiguous.
final Finder noteFieldFinder = find.byWidgetPredicate((Widget widget) {
  return widget is TextField &&
      widget.decoration?.labelText == 'Note for the kitchen';
});

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets('OrderScreen shows two switches and one note field', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );

    expect(find.byType(Switch), findsNWidgets(2));
    expect(noteFieldFinder, findsOneWidget);
  });

  testWidgets('Toggling the toasted switch flips its value', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );

    final Finder toastedSwitch = find.byType(Switch).first;
    Switch switchWidget = tester.widget<Switch>(toastedSwitch);
    expect(switchWidget.value, isFalse);

    await tester.tap(toastedSwitch);
    await tester.pump();

    switchWidget = tester.widget<Switch>(toastedSwitch);
    expect(switchWidget.value, isTrue);
  });

  testWidgets('Adding to basket records quantity, toggles and note', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );

    await tester.enterText(noteFieldFinder, 'No pickles');

    await tester.tap(find.byType(Switch).first);
    await tester.pump();

    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pump();

    await tester.tap(find.text('Add to Basket'));
    await tester.pump();

    final List<CartItem> items = CartRepository.instance.getItems();
    expect(items.length, 1);

    final CartItem added = items.first;
    expect(added.quantity, 2);
    expect(added.toasted, isTrue);
    expect(added.vegan, isFalse);
    expect(added.note, 'No pickles');
  });
}
```

The first test checks the form shows two switches and the note field. The second taps the first switch and checks its value flips from false to true. The third types a note, flips the toasted switch, raises the quantity to two with the Add button, taps Add to Basket, and then checks the one item in the shared basket carries the right quantity, toggles, and note. These last two refer to the `CartItem` and `CartRepository` you build in the next section, so run this test after that section is in place.

### Commit your changes (3)

Stage your updated `order_screen.dart` and its test file, then commit your changes with a message of your own.

## Holding an order in a basket

We built the form in the previous section, but its Add to Basket button has nowhere to put an order yet. Now we add the logic behind the user interface: a model for one basket line, a shared repository to hold the basket, and the basket screen that shows it. This is the behaviour that makes the buttons we built earlier actually do something.

### Define the cart item model

Create a new file named `lib/models/cart_item.dart`:

```dart
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final bool toasted;
  final bool vegan;
  final String note;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.toasted = false,
    this.vegan = false,
    this.note = '',
  });

  double get totalPrice {
    return price * quantity;
  }
}
```

The first four fields describe the sandwich and how many were ordered. The last three capture the choices from the order form we built in the previous section: `toasted` and `vegan` are booleans, and `note` is a free-text message for the kitchen. These three have default values in the constructor (`this.toasted = false`, and so on), so a caller may leave them out. The `totalPrice` getter multiplies the price by the quantity, following the same getter pattern as `formattedPrice` from Worksheet 4.

### Create the cart repository singleton

A singleton is a class that only ever has one instance. We use that pattern here so every screen shares the exact same in-memory basket: when the order screen adds an item, the basket screen sees it. If each screen created its own repository, items added on one screen would be invisible on another.

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

The `_items` list is private, so callers cannot change it directly. `getItems` returns `List<CartItem>.unmodifiable(_items)`, a read-only view: a caller can read the items but cannot add to or remove from it, which keeps every change going through `addItem` and `removeItem`. `removeItem` checks the index is in range before removing, to avoid an error.

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

`getTotalDue` adds the delivery fee to the subtotal, and `clear` empties the basket after a checkout. With this in place, the order form's `_addToBasket` method from the previous section now compiles and adds real items.

### Unit test the cart repository

Because `CartRepository` is a singleton, every test shares the same basket, so we must empty it before each test runs. The `setUp` function (a sibling of the `group` and `test` functions from Worksheet 4) runs its callback before each test, which is the right place to clear the basket.

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

The first test checks a fresh basket is empty with zero totals, the second adds two items and checks the counts and money add up, and the third removes an item and checks the basket empties.

### Build the basket screen widget

Now we fill in the basket screen shell. It lists the items in the shared basket, lets the user remove one, shows the totals, handles the empty case, and offers a checkout that, for now, just clears the basket and thanks the user.

Create (or replace) the file `lib/screens/basket_screen.dart`. It is a `StatefulWidget` because tapping delete or checkout changes what it shows. Start with the imports, the widget shell, and the one piece of state:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  String _confirmationMessage = '';
}
```

Now add a small helper that shows a message when the basket is empty:

```dart
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
```

Each basket line can carry options, so add a helper that turns the toggles and note of one item into a short line of text. It builds a list of the parts that apply, then joins them:

```dart
  Widget _buildOptionsText(CartItem item) {
    final List<String> parts = [];
    if (item.toasted) {
      parts.add('Toasted');
    }
    if (item.vegan) {
      parts.add('Vegan');
    }
    if (item.note.isNotEmpty) {
      parts.add('Note: ${item.note}');
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

When no option applies, the helper returns `const SizedBox.shrink()`, an empty box that takes no space. Otherwise it joins the parts with a bullet separator in a small grey `Text`.

Now add the helper that builds one basket line. It keeps the layout plain: the quantity and name on the left, the line total, and a delete button, with no card or decoration around it:

```dart
  Widget _buildLineItem(CartRepository cart, CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.quantity} x ${item.name}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                _buildOptionsText(item),
              ],
            ),
          ),
          Text('£${item.totalPrice.toStringAsFixed(2)}'),
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
  }
```

Each line is a simple `Padding` around a `Row`. The quantity and name read as `2 x Footlong Sub`, and the name and options are wrapped in an `Expanded` so they take the space left before the price, pushing the price and delete button to the right. The delete button is the `IconButton` you met on the menu, this time showing `Icons.delete_outline`; its `onPressed` removes the item at `index` and calls `setState` to rebuild.

Now add a helper for one totals row, a label on the left and an amount on the right, with an option to emphasise the final line:

```dart
  Widget _buildTotalRow(String label, String value, {bool emphasise = false}) {
    final TextStyle style;
    if (emphasise) {
      style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    } else {
      style = const TextStyle(color: shopText);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
```

Now assemble the full basket view. We build the children in a `List<Widget>` procedurally, adding the heading, one line per item, the totals, and the checkout button:

```dart
  Widget _buildBasketList(CartRepository cart, List<CartItem> items) {
    final List<Widget> children = [];

    children.add(const Text('Your basket', style: shopSectionTitleStyle));
    children.add(const SizedBox(height: 16));

    for (int index = 0; index < items.length; index++) {
      final CartItem item = items[index];
      children.add(_buildLineItem(cart, item, index));
    }

    children.add(const SizedBox(height: 24));
    children.add(
      _buildTotalRow(
        'Items subtotal',
        '£${cart.getSubtotal().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Delivery',
        '£${cart.getDeliveryFee().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Total to pay',
        '£${cart.getTotalDue().toStringAsFixed(2)}',
        emphasise: true,
      ),
    );
    children.add(const SizedBox(height: 24));

    children.add(
      SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          label: 'Checkout',
          onPressed: () {
            setState(() {
              cart.clear();
              _confirmationMessage = 'Thanks, your order is on its way';
            });
          },
        ),
      ),
    );

    if (_confirmationMessage.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(
        Text(
          _confirmationMessage,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
```

We create an empty `List<Widget>` and call `children.add(...)` to append each widget in order, which lets us add one line inside the `for` loop (the C-style loop from Worksheet 4). A `SizedBox` adds a little vertical space between the items and the totals. The checkout button clears the basket and sets a confirmation message, both inside `setState` so the screen rebuilds into its empty state with the message shown. Placing an order does nothing more than this for now.

Finally, add the `build` method. It reads the shared basket, chooses between the empty state and the list, and wraps the result in a `SingleChildScrollView`:

```dart
  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    final Widget content;
    if (items.isEmpty) {
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmptyState(),
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = _buildBasketList(cart, items);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }
}
```

When the basket is empty we show the empty-state message, with the confirmation line beneath it just after a checkout. When it has items we show the full list. The body reuses the `SingleChildScrollView` so a long basket can scroll, and the app bar carries the same `const BasketButton()` as every other screen.

Your basket screen with a couple of items should look like this:

<!-- TODO screenshot: images/5/basket_screen_with_items.png — show the basket screen listing items with their options, the subtotal, delivery, total to pay, and the Checkout button -->

### Widget test the basket screen

Create a new file named `test/basket_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets('BasketScreen displays empty message when basket has no items',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BasketScreen(),
      ),
    );

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Checkout'), findsNothing);
  });

  testWidgets('BasketScreen renders items and removes item when delete pressed',
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
        home: BasketScreen(),
      ),
    );

    expect(find.text('Your basket'), findsOneWidget);
    expect(find.text('Footlong'), findsOneWidget);
    expect(find.text('£20.00'), findsWidgets);
    expect(find.text('Checkout'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Your basket is empty'), findsOneWidget);
  });

  testWidgets('BasketScreen checkout clears basket and shows inline '
      'confirmation', (WidgetTester tester) async {
    const CartItem item = CartItem(
      id: 'footlong',
      name: 'Footlong',
      price: 10.0,
      quantity: 1,
    );
    CartRepository.instance.addItem(item);

    await tester.pumpWidget(
      const MaterialApp(
        home: BasketScreen(),
      ),
    );

    await tester.tap(find.text('Checkout'));
    await tester.pump();

    expect(find.text('Thanks, your order is on its way'), findsOneWidget);
    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });
}
```

The first test checks the empty basket shows its message and no checkout button. The second adds an item, checks it renders with its line total, deletes it, and checks the basket empties. The third adds an item, taps Checkout, and checks the basket clears and the confirmation message appears.

### Commit your changes (4)

Stage your new `cart_item.dart`, `cart_repository.dart`, `basket_screen.dart`, and their test files, then commit your changes with a message of your own.

## Loading the menu from JSON

The last and hardest step moves the menu out of Dart and into a data file. Hardcoding the menu inside Dart means every change needs a code edit and a recompile. Real apps keep catalogues in data files. JSON (JavaScript Object Notation) is a plain-text format for structured data: a list of objects, each a set of key-and-value pairs. We move the menu into a JSON file and teach the app to read it.

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

The file holds a JSON array (the square brackets) of two objects (the curly brackets). Each object has the same keys as the fields of our `Sandwich` model, which is what lets us turn one into the other.

### Register the asset in pubspec

Open `pubspec.yaml`. Under `flutter:` and `assets:`, add `- assets/data/` so the file ships with the app:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/data/
```

### Add JSON serialisation to the sandwich model

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

We now add two things: a `fromJson` constructor that builds a `Sandwich` from decoded JSON, and a `toJson` method that produces the reverse. Add `fromJson` inside the class, below the `formattedPrice` getter:

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

This is a `factory` constructor, which you have not met before. An ordinary constructor only assigns its arguments to fields. A `factory` constructor can run code first and then decide which instance to return, which is what we need here: it reads values out of a map and then builds a `Sandwich` from them.

Its argument type is `Map<String, dynamic>`. A `Map` stores key-and-value pairs; `Map<String, dynamic>` means the keys are strings (such as `'name'`) and the values can be of any type, which is what a decoded JSON object looks like. Because each value is `dynamic`, Dart does not know its exact type, so we use the `as` keyword to assert it: `json['id'] as String` tells Dart to treat that value as a `String`. The price arrives as a `num`, the common supertype of `int` and `double`, so we read it as a `num` and call `.toDouble()` to be sure we store a `double`.

Now add the `toJson` method below `fromJson`. It walks the fields the opposite way, building a map from the current `Sandwich`:

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

Each field becomes one entry in the returned map, so `fromJson` and `toJson` are mirror images of each other.

### Load JSON data in the repository

Open `lib/repositories/sandwich_repository.dart`. We add a method that reads the JSON asset and turns it into a list of `Sandwich` objects, one step at a time.

Start by adding the two imports we need at the top of the file, and a field to cache the result:

```dart
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sandwich_shop/models/sandwich.dart';

class SandwichRepository {
  List<Sandwich>? _cachedSandwiches;
}
```

The `dart:convert` library gives us `jsonDecode`, which parses JSON text, and `package:flutter/services.dart` gives us `rootBundle`, which reads bundled asset files. The field `_cachedSandwiches` has the nullable type `List<Sandwich>?` (the `?` from Worksheet 4), so it starts as `null` and holds the list once we have loaded it.

Now add the loading method inside the class. Begin with its signature and the line that reads the file into a string:

```dart
  Future<List<Sandwich>> loadSandwichesFromAsset({
    String assetPath = 'assets/data/sandwiches.json',
  }) async {
    final String jsonString = await rootBundle.loadString(assetPath);
```

The method is marked `async` and returns a `Future<List<Sandwich>>`, the asynchronous pattern from Worksheet 4. `rootBundle.loadString(assetPath)` reads the contents of a bundled asset file into a single `String` at runtime; because reading a file takes time it returns a `Future`, so we `await` it.

Next, parse that string into Dart data and cast it to a list:

```dart
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
```

`jsonDecode` turns a JSON string into ordinary Dart values: a JSON array becomes a `List`, and each JSON object inside becomes a `Map<String, dynamic>`. Its return type is `dynamic` because the shape depends on the file, so we use `as List<dynamic>` to assert that our file holds a list.

Now loop over the list, converting each map into a `Sandwich` with the `fromJson` constructor you just wrote. This is the same `for-in` loop from Worksheet 4:

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

Returning the fallback list synchronously keeps the existing views simple and responsive, while the asynchronous `loadSandwichesFromAsset` is ready for when you want to read the live menu from the asset file.

With the JSON asset in place, the menu now reads its items from data rather than hardcoded Dart, as shown below.

<!-- TODO screenshot: images/5/menu_from_json.png — show the menu list rendering the two sandwiches loaded from the sandwiches.json asset -->

### Unit test JSON serialisation

Open `test/sandwich_model_test.dart` and add tests for `fromJson` and `toJson` inside the existing `group`:

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

Each test exercises one direction: `fromJson` builds a `Sandwich` from a map and checks the fields, and `toJson` builds a map from a `Sandwich` and checks the entries.

Run `flutter test` in your terminal to confirm every test across the worksheet passes:

```bash
flutter test
```

### Commit your changes (5)

Stage your JSON asset, the updated `pubspec.yaml`, `sandwich.dart`, `sandwich_repository.dart`, and the model test, then commit your changes with a message of your own.

## Exercises

The exercises below apply the concepts from this worksheet to the Southsea Cinema coursework application. They prepare you for Demo 3 of your coursework. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Remember to commit your changes to Git after each exercise.

1. Open your Southsea Cinema fork. Following [Shared constants and the Subway theme](#shared-constants-and-the-subway-theme), create `lib/constants.dart` holding the app title, a small colour palette, and the shared text styles for the cinema, then apply the theme in `main.dart`. Choose colours that suit the cinema rather than copying the sandwich shop's greens.

2. Following [Reusable widgets and navigation](#reusable-widgets-and-navigation), register named routes in `MaterialApp` for your listings screen and a basket screen, and add a basket `IconButton` to the listings app bar that opens the basket with `Navigator.pushNamed`.

3. Following [Building the order form](#building-the-order-form), build a booking screen for a selected film where the patron picks a number of tickets, toggles at least one option with a `Switch`, and leaves a note in a `TextField`. Create and dispose the controller for the note field. Southsea Cinema buttons are squared rather than rounded, so give each button `shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)`.

4. Following [Holding an order in a basket](#holding-an-order-in-a-basket), define a `BasketItem` model in `lib/models/basket_item.dart` with the fields a ticket order needs and a `totalPrice` getter, build a `BasketRepository` singleton in `lib/repositories/basket_repository.dart` that stores items and totals the order up, then build a basket view that lists each booking with its options and line total, lets the patron remove an item, shows the totals and an empty state, and offers a checkout that clears the basket and thanks the patron.

5. Following [Loading the menu from JSON](#loading-the-menu-from-json), create `assets/data/movies.json` with your film listings and register `- assets/data/` in `pubspec.yaml`. Add `Movie.fromJson` and `Movie.toJson` to `lib/models/movie.dart`, and add a `loadMoviesFromAsset()` method to `lib/repositories/movie_repository.dart`.

6. Design and test your Demo 3 experience end to end: decide how a patron moves between the listings, booking, and basket screens, and cover the behaviour you care about with unit and widget tests. Run `dart analyze` and `flutter test` and resolve every warning and failure. **Show your running listings, booking, and basket screens to a member of staff** for your Demo 3 practical checkpoint.
