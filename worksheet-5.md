# Worksheet 5 — Navigation, state and forms

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 4](#continue-from-worksheet-4)
  - [Clone the Sandwich Shop repository](#clone-the-sandwich-shop-repository)
  - [Switch to branch 4](#switch-to-branch-4)
- [Shared constants and the Subway theme](#shared-constants-and-the-subway-theme)
  - [Define the shared constants](#define-the-shared-constants)
  - [Import constants in the main app](#import-constants-in-the-main-app)
  - [Configure the Subway theme](#configure-the-subway-theme)
  - [Hide the debug banner](#hide-the-debug-banner)
- [Reusable widgets and navigation](#reusable-widgets-and-navigation)
  - [Build the primary button](#build-the-primary-button)
  - [Widget test the primary button](#widget-test-the-primary-button)
  - [Use the primary button in the sandwich card](#use-the-primary-button-in-the-sandwich-card)
  - [Create the basket button](#create-the-basket-button)
  - [Create the placeholder basket screen](#create-the-placeholder-basket-screen)
  - [Register named routes](#register-named-routes)
  - [Add the basket button to the menu app bar](#add-the-basket-button-to-the-menu-app-bar)
  - [Widget test the menu screen](#widget-test-the-menu-screen)
  - [Update the app smoke tests](#update-the-app-smoke-tests)
  - [Commit your changes (2)](#commit-your-changes-2)
- [Holding an order in a basket](#holding-an-order-in-a-basket)
  - [Define the cart item model](#define-the-cart-item-model)
  - [Create the cart repository singleton](#create-the-cart-repository-singleton)
  - [Unit test the cart repository](#unit-test-the-cart-repository)
  - [Commit your changes (3)](#commit-your-changes-3)
- [Building the order form](#building-the-order-form)
  - [Recap the order screen state](#recap-the-order-screen-state)
  - [Update the order screen app bar](#update-the-order-screen-app-bar)
  - [Add the toasted and vegan switches](#add-the-toasted-and-vegan-switches)
  - [Add the note field with a text controller](#add-the-note-field-with-a-text-controller)
  - [Add items to the basket](#add-items-to-the-basket)
  - [Wrap the form in a scroll view](#wrap-the-form-in-a-scroll-view)
  - [Widget test the order form](#widget-test-the-order-form)
  - [Commit your changes (4)](#commit-your-changes-4)
- [Building the basket screen](#building-the-basket-screen)
  - [Convert BasketScreen to a stateful widget](#convert-basketscreen-to-a-stateful-widget)
  - [Build the empty basket state](#build-the-empty-basket-state)
  - [Build the basket item card](#build-the-basket-item-card)
  - [Build the basket items list and checkout button](#build-the-basket-items-list-and-checkout-button)
  - [Assemble the basket screen scaffold](#assemble-the-basket-screen-scaffold)
  - [Widget test the basket screen](#widget-test-the-basket-screen)
  - [Commit your changes (5)](#commit-your-changes-5)
- [Loading the menu from JSON](#loading-the-menu-from-json)
  - [Create the JSON asset file](#create-the-json-asset-file)
  - [Register the asset in pubspec](#register-the-asset-in-pubspec)
  - [Add JSON serialisation to the sandwich model](#add-json-serialisation-to-the-sandwich-model)
  - [Unit test JSON serialisation](#unit-test-json-serialisation)
  - [Load JSON data in the repository](#load-json-data-in-the-repository)
  - [Commit your changes (6)](#commit-your-changes-6)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 4

You can continue directly with the Sandwich Shop project you completed in [Worksheet 4](./worksheet-4.md). Open the project folder in VS Code with **File > Open Folder**. You do not need to clone the repository again if your working tree is clean.

### Clone the Sandwich Shop repository

If you need a fresh copy of the project, open a terminal and move to a folder that is not synchronised to cloud storage, such as your `Downloads` folder, then clone the repository:

```bash
cd ~/Downloads
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
```

Open the cloned folder in VS Code with **File > Open Folder**.

### Switch to branch 4

Switch to branch `4` so your project matches the state after completing Worksheet 4:

```bash
git checkout 4
```

Run `flutter test` in your terminal to confirm that all existing tests pass before continuing.

## Shared constants and the Subway theme

Values such as the app title and brand colours appear across multiple screens. Rather than repeating them in each file, we keep them in a dedicated constants file. This gives us a single source of truth when modifying the theme.

### Define the shared constants

Create a new file named `lib/constants.dart`. Start by importing the Material library and declaring a top-level constant string for the app title:

```dart
import 'package:flutter/material.dart';

const String appTitle = 'Sandwich Shop';
```

Your code should look like this in VS Code:

![Shared constants in VS Code](images/5/shared_constants.png)

The `import 'package:flutter/material.dart';` statement brings in the Material Design types, including `Color` and `TextStyle`. Declaring `appTitle` as a top-level `const String` means any screen in our project can import `constants.dart` and use it.

Next, define the brand colour palette below the title:

```dart
const Color shopBrand = Color(0xFF008C15);
const Color shopWhite = Colors.white;
const Color shopBackground = Color(0xFFF5F5F0);
const Color shopText = Color(0xFF1B2B1B);
```

Each colour is declared as a `const Color`. In Flutter, the `Color(0xFF008C15)` constructor creates a colour from an 8-digit hexadecimal integer. The first two digits (`FF`) set full opacity, and the remaining six digits represent the red, green, and blue colour channels. Here `shopBrand` is a green colour inspired by Subway, `shopBackground` provides a soft off-white background for each screen, and `shopText` gives high-contrast dark green text. For more information on colour constructors, see the [Flutter Color documentation](https://api.flutter.dev/flutter/dart-ui/Color-class.html).

Finally, add two reusable text styles to `lib/constants.dart`:

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

A `TextStyle` describes text formatting such as font size and weight. The `fontWeight: FontWeight.bold` property bolds the text, `letterSpacing` slightly expands spacing between letters, and `fontSize` specifies text height in logical pixels. We will use `shopHeaderStyle` for app bar titles and `shopSectionTitleStyle` for screen section headings. For more information, see the [Flutter TextStyle documentation](https://api.flutter.dev/flutter/painting/TextStyle-class.html).

### Import constants in the main app

Now open `lib/main.dart` and import our new constants file at the top of `lib/main.dart` with `import 'package:sandwich_shop/constants.dart'`.

Then update the `title` property of `MaterialApp` to use `appTitle` instead of the hardcoded string. Because `appTitle` is a top-level constant, `MaterialApp` can read it directly.

See below where we are showing the changes to our `lib/main.dart` file in VS Code:

![Importing constants and using appTitle in VS Code](images/5/import_constants.png)

### Configure the Subway theme

Next, apply our custom brand colours to the whole application using `ThemeData`. Remove the `const` keyword before `MaterialApp` and add the `theme` property:

```dart
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
```

The `theme` property accepts a `ThemeData` object containing global styles and colour tokens. `ColorScheme.fromSeed` generates a palette around a single seed colour, which we set to `shopBrand`. The `scaffoldBackgroundColor` sets the default background colour for every `Scaffold` in the app.

The `appBarTheme` styles all app bars with our brand green background, white foreground text and icons, and removes the drop shadow with `elevation: 0`. For more details, view the [ThemeData documentation](https://api.flutter.dev/flutter/material/ThemeData-class.html) and [ColorScheme documentation](https://api.flutter.dev/flutter/material/ColorScheme-class.html).

Here is a summary of our changes:

![Themed app bar and background in VS Code](images/5/themed_app_bar.png)

Run the application with `flutter run` in your terminal. Your screen should look like this, with the new green app bar and the debug banner in the corner:

![The menu screen styled with the Subway theme and debug ribbon](images/5/themed_menu_debug_ribbon.png)

### Hide the debug banner

Notice the small red or grey ribbon in the top-right corner that reads "DEBUG". Flutter displays this ribbon to indicate that the application is running in an unoptimised debug build. It's harmless but you can hide it during development to preview how the final app looks.

Add `debugShowCheckedModeBanner: false` directly inside `MaterialApp` as shown below:

![The menu screen with the debug ribbon removed](images/5/debug_banner_removed.png)

Save the file and trigger hot reload. The debug ribbon disappears from the top-right corner:

![The menu screen with the debug ribbon removed](images/5/debug_banner_removed_app.png)

## Reusable widgets and navigation

Before adding form inputs or cart state, we construct reusable navigation components and connect our screens. Building interface shells first lets you verify movement through the app before writing business logic.

### Build the primary button

Let's suppose we need a button that gets styled consistently across the app, in multiple screens. Rather than repeating identical `ElevatedButton` styling in multiple files, it's best to extract it into a standalone widget.

Create a new file named `lib/widgets/primary_button.dart` and add the following code inside it:

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

`PrimaryButton` is a `StatelessWidget` with two properties: `label` for the button caption, and `onPressed` for the tap callback. The type `VoidCallback` represents a function that takes no arguments and returns nothing. `ElevatedButton.styleFrom` configures the green background and white text from our constants file.

Here is the documentation page on [ElevatedButton](https://api.flutter.dev/flutter/material/ElevatedButton-class.html). But there are other kinds of buttons in Flutter, such as `TextButton` and `OutlinedButton`. For more information on them, feel free to check out the [Flutter buttons documentation](https://docs.flutter.dev/development/ui/widgets/material#buttons).

We will use `PrimaryButton` in multiple screens later but first we need to write tests for it.

### Widget test the primary button

Every (reusable) widget should be verified with automated tests. Create a new test file named `test/widgets/primary_button_test.dart`. Notice that the name of the subfolder in `test` folder matches the name of the folder in `lib`. This is a common convention for organising widget tests (so here, we have a `test/widgets` folder for testing widgets in `lib/widgets`).

Add the following code to `test/widgets/primary_button_test.dart`:

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

The first test confirms that the button renders the text passed to its label. The second test passes a callback that flips a boolean flag, simulates a user tap with `tester.tap`, and asserts that the callback executed.

Feel free to add a `group` to organise these tests. You are also encouraged to organise the rest of the files in `test` folder in a similar way, for example, you can create a `test/screens` folder for testing screens in `lib/screens` and `test/models` folder for testing models in `lib/models`.

Run this test using the play button in VS Code or the following command in your terminal:

```bash
flutter test test/widgets/primary_button_test.dart
```

### Use the primary button in the sandwich card

Now update `lib/widgets/sandwich_card.dart` so each menu item uses our new button. Import `primary_button.dart` at the top of the file:

```dart
import 'package:sandwich_shop/widgets/primary_button.dart';
```

Then locate the `ElevatedButton` inside the card's `build` method and replace it with `PrimaryButton`. Here what the change should look like:

![The SandwichCard widget using PrimaryButton in VS Code](images/5/sandwich_card_primary_button.png)

Save the file and check your running application. Each menu card now displays the styled green Order button, as shown below:

![The menu screen showing SandwichCard with the styled green Order button](images/5/menu_with_primary_button.png)

### Create the basket button

Let's add another reusable widget for the shopping basket icon button. Every screen in our application needs a shopping basket icon in its app bar that takes the user to their basket.

Create a new file named `lib/widgets/basket_button.dart` and make a `StatelessWidget` that displays a shopping basket icon and navigates to the basket screen when tapped:

```dart
import 'package:flutter/material.dart';

class BasketButton extends StatelessWidget {
  const BasketButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_basket),
      onPressed: () {
        ModalRoute<dynamic>? modalRoute = ModalRoute.of(context);
        String currentRoute = '';

        if (modalRoute != null) {
          RouteSettings settings = modalRoute.settings;
          String? routeName = settings.name;
          if (routeName != null) {
            currentRoute = routeName;
          }
        }

        if (currentRoute != '/basket') {
          Navigator.pushNamed(context, '/basket');
        }
      },
    );
  }
}
```

`IconButton` displays an icon from Flutter's Material icon set (`Icons.shopping_basket`). Feel free to remove `shopping_basket`, put your cursor at the dot, and press **Ctrl + Space** on Windows or **⌘ + Space** on macOS to see a list of available icons. You can check out the [documentation page on Material icons](https://api.flutter.dev/flutter/material/Icons-class.html) for a complete list of icons.

![The list of available Material icons in VS Code](images/5/material_icons.png)

Inside `onPressed`, we check the name of the current route using `ModalRoute.of(context)`. We discussed `context` back in [Worksheet 3](./worksheet-3.md) when we built the `SandwichCard` widget. It is a handle to the location of a widget in the widget tree, and it allows us to access the current route. A route is essentially a screen in the app. So for example if we are on the menu screen, the current route is `'/'`. If we are on the basket screen, the current route is `'/basket'`.

If a modal route exists, we retrieve its `RouteSettings` and extract its route name. If the user is not already on the basket screen, `Navigator.pushNamed(context, '/basket')` opens it. If they are already on the basket screen, nothing happens. This practice prevents unnecessary duplicate screens in the navigation stack.

### Create the placeholder basket screen

Notice that `BasketButton` navigates to `'/basket'`. Before registering this route in `MaterialApp`, we create a minimal basket screen so our code compiles cleanly.

Create a new file named `lib/screens/basket_screen.dart`:

```dart
import 'package:flutter/material.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Basket Screen'),
      ),
    );
  }
}
```

We will build the complete stateful basket screen later in this worksheet. For now, this placeholder enables navigation between screens.

### Register named routes

In [Worksheet 3](./worksheet-3.md), we navigated to screens using `Navigator.push` with a `MaterialPageRoute`. That approach is suitable for detail views, such as selecting a sandwich to open its order page. For top-level screens like the menu and the basket, named routes provide a cleaner structure.

A named route associates an identifier string with a screen builder. Open `lib/main.dart` and import the basket screen:

```dart
import 'package:sandwich_shop/screens/basket_screen.dart';
```

In `App.build`, remove `home: const MenuScreen()` and replace it with `initialRoute` and `routes`:

```dart
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return const MenuScreen();
        },
        '/basket': (BuildContext context) {
          return const BasketScreen();
        },
      },
```

The `initialRoute: '/'` property instructs Flutter to open the menu screen on launch. The `routes` map associates `'/'` with `MenuScreen` and `'/basket'` with `BasketScreen`. Your complete `lib/main.dart` should now look like this:

![The main.dart file with named routes in VS Code](images/5/main_with_named_routes.png)

For more details on routing, see the [Flutter named routes documentation](https://docs.flutter.dev/cookbook/navigation/named-routes).

### Add the basket button to the menu app bar

Now add the reusable `BasketButton` to `lib/screens/menu_screen.dart`. Open the file and import our constants and the button widget:

```dart
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
```

In `MenuScreen.build`, update the `AppBar` to use `appTitle`, `shopHeaderStyle` first. Also add the `BasketButton` to the `actions` list as shown in the screenshot below:

![The menu screen app bar with the styled title and basket button in VS Code](images/5/menu_app_bar_basket_button_code.png)

The `actions` property accepts a list of widgets displayed on the trailing side of the app bar. Save the file. The menu screen app bar now shows the styled title and the basket icon button, as shown below:

![The menu screen app bar with the Subway green styling and basket icon button](images/5/menu_app_bar_basket_button.png)

<!-- TODO: Done till here -->

### Widget test the menu screen

Create a new test file named `test/menu_screen_test.dart` to verify that the menu displays sandwich cards, the basket action button, and responds to taps:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/widgets/sandwich_card.dart';

void main() {
  testWidgets('MenuScreen shows the sandwich list and a basket button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MenuScreen()));

    expect(find.byType(SandwichCard), findsWidgets);
    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
  });

  testWidgets('Tapping the basket button navigates to BasketScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return const MenuScreen();
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

The first test confirms that `SandwichCard` widgets and the basket icon appear. The second test taps the basket icon button, waits for the transition with `tester.pumpAndSettle()`, and asserts that `BasketScreen` appears. Run this test suite:

```bash
flutter test test/menu_screen_test.dart
```

### Update the app smoke tests

In Worksheet 4, our smoke test in `test/widget_test.dart` looked for the text `'Sandwich Menu'`. Because our app bar now displays `'Sandwich Shop'` alongside the basket button, update the test in `test/widget_test.dart` to expect the basket button:

```dart
    testWidgets('App displays MenuScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    });
```

### Commit your changes (2)

Stage your new files (`primary_button.dart`, `basket_button.dart`, `basket_screen.dart`, `primary_button_test.dart`, `menu_screen_test.dart`) and modified files (`main.dart`, `sandwich_card.dart`, `menu_screen.dart`, `widget_test.dart`). Commit your changes with a descriptive message of your own.

## Holding an order in a basket

Before we expand the order screen into an interactive form, we create the model and repository that store selected items. Building the data layer first ensures that form inputs have a concrete destination.

### Define the cart item model

When a customer configures a sandwich, they select a quantity, options such as toasted or vegan, and can add an optional note for the kitchen.

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

  double get lineTotal {
    return price * quantity;
  }
}
```

Each field is marked `final` to ensure instances are immutable. The `toasted` and `vegan` flags default to `false`, and `note` defaults to an empty string. The computed getter `lineTotal` multiplies `price` by `quantity` to calculate the cost for that line item.

### Create the cart repository singleton

In [Worksheet 3](./worksheet-3.md), we introduced the repository pattern to encapsulate data access. For our shopping cart, multiple screens (the order screen and the basket screen) need to read and modify the same list of items. We implement this using the singleton pattern.

Create a new file named `lib/repositories/cart_repository.dart`:

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

  void clear() {
    _items.clear();
  }

  int get totalItemCount {
    int total = 0;
    for (final CartItem item in _items) {
      total += item.quantity;
    }
    return total;
  }

  double getTotalDue() {
    double total = 0.0;
    for (final CartItem item in _items) {
      total += item.lineTotal;
    }
    return total;
  }
}
```

The private constructor `CartRepository._internal()` prevents direct instantiation outside this file. The single shared instance is exposed via `static final CartRepository instance`. The `_items` list is private; calling `getItems()` returns an unmodifiable view using `List.unmodifiable` so external code cannot mutate the list directly. The `totalItemCount` getter and `getTotalDue()` method iterate over the items using standard `for-in` loops to aggregate quantities and prices.

### Unit test the cart repository

Create a new test file named `test/cart_repository_test.dart` to verify repository operations:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';

void main() {
  final CartRepository repository = CartRepository.instance;

  setUp(() {
    repository.clear();
  });

  test('CartRepository starts empty', () {
    expect(repository.getItems(), isEmpty);
    expect(repository.totalItemCount, 0);
    expect(repository.getTotalDue(), 0.0);
  });

  test('addItem adds item and computes totals', () {
    const CartItem item = CartItem(
      id: 'footlong',
      name: 'Footlong Sub',
      price: 7.50,
      quantity: 2,
    );
    repository.addItem(item);

    expect(repository.getItems().length, 1);
    expect(repository.totalItemCount, 2);
    expect(repository.getTotalDue(), 15.0);
  });

  test('removeItem removes item at index', () {
    const CartItem item = CartItem(
      id: 'footlong',
      name: 'Footlong Sub',
      price: 7.50,
      quantity: 1,
    );
    repository.addItem(item);
    repository.removeItem(0);

    expect(repository.getItems(), isEmpty);
  });
}
```

Run your new unit tests:

```bash
flutter test test/cart_repository_test.dart
```

### Commit your changes (3)

Stage `lib/models/cart_item.dart`, `lib/repositories/cart_repository.dart`, and `test/cart_repository_test.dart`. Commit your changes with a message of your own.

## Building the order form

Now that the cart model and repository are ready, we turn `lib/screens/order_screen.dart` into a complete ordering form with switch toggles, a multiline text field, and basket submission.

### Recap the order screen state

In branch 4, `OrderScreen` was a `StatefulWidget` containing a quantity integer and two buttons (Add and Remove) that called `setState`:

```dart
class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;

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

We keep these quantity handlers and build additional controls around them.

### Update the order screen app bar

Open `lib/screens/order_screen.dart`. Import our constants and the basket button:

```dart
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
```

In `OrderScreen.build`, update the `AppBar` to display our themed title and include `BasketButton`:

```dart
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton()],
      ),
```

Your order screen app bar should look like this:

![The order screen app bar with title and basket button](images/5/order_screen_app_bar.png)

### Add the toasted and vegan switches

Customers can choose whether their sandwich should be toasted or vegan. A `Switch` is Flutter's toggle control. It accepts a boolean `value` and an `onChanged` callback.

Add two boolean fields to `_OrderScreenState`:

```dart
  bool _toasted = false;
  bool _vegan = false;
```

Inside the `build` method, below the quantity buttons, add two rows for the switches:

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
```

Wrapping each label in `Expanded` causes the label to occupy all available horizontal space on the left, pushing the `Switch` to the right edge. When the user flips a switch, `onChanged` receives the new boolean and updates state using `setState`. For more details, see the [Switch documentation](https://api.flutter.dev/flutter/material/Switch-class.html).

Your screen should look like this with the switches in place:

![The order screen showing the toasted and vegan switches](images/5/order_screen_switches.png)

### Add the note field with a text controller

Next, add an optional text field where the customer can type special instructions for the kitchen.

To read and manage text input in Flutter, you attach a `TextEditingController` to a `TextField`. Controllers manage native input state and must be disposed when the widget is removed to prevent memory leaks. This lifecycle is managed across three parts:

1. `late TextEditingController _noteController;`: Declares the controller. The `late` keyword informs Dart that the field will be initialised before it is first accessed.
2. `initState()`: Called once when the state object is created. We initialise the controller here.
3. `dispose()`: Called once when the widget is removed from the widget tree. We call `_noteController.dispose()` here.

Add the controller declaration and lifecycle methods to `_OrderScreenState`:

```dart
  late TextEditingController _noteController;

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

Now add the `TextField` below the switches in `build`:

```dart
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Note for the kitchen',
                hintText: 'Add any notes for this order',
              ),
            ),
```

The `maxLines: 3` parameter creates a multiline input box. The `InputDecoration` styles the input with an outline border, a floating label, and placeholder hint text. For further guidance, see the [TextEditingController documentation](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html).

The kitchen note field should look like this in your application:

![The order screen showing the kitchen note text field](images/5/order_screen_note_field.png)

### Add items to the basket

Now wire the form to `CartRepository`. Add imports for the cart model, repository, and primary button at the top of `lib/screens/order_screen.dart`:

```dart
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';
```

Add a string field in `_OrderScreenState` to hold an inline feedback message:

```dart
  String _confirmationMessage = '';
```

Next, add the submission method `_addToBasket`:

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

The method checks that `_quantity > 0`. If valid, it reads the note text from `_noteController.text.trim()`, constructs a `CartItem`, and passes it to `CartRepository.instance.addItem(item)`. It then updates `_confirmationMessage` inside `setState`. If the quantity is zero, it prompts the user to select at least one sandwich.

Add the button and confirmation message below the text field in `build`:

```dart
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
```

The `SizedBox` with `width: double.infinity` expands the button across the width of the screen.

Your order screen should now look like this:

![The completed order screen with switches, note field, and Add to Basket button](images/5/order_screen_complete.png)

### Wrap the form in a scroll view

On mobile devices, tapping a text input causes the virtual keyboard to slide up from the bottom. If the form is in a fixed column, the reduced vertical space causes an "overflow error".

Wrap the entire form column in a `SingleChildScrollView`:

```dart
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
```

Keep the existing `OrderItemDisplay` class unchanged at the bottom of the file. For more details, see the [SingleChildScrollView documentation](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html).

### Widget test the order form

Create a new test file named `test/order_screen_test.dart`:

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

Run your new widget tests:

```bash
flutter test test/order_screen_test.dart
```

### Commit your changes (4)

Stage `lib/screens/order_screen.dart` and `test/order_screen_test.dart`. Commit your changes with a message of your own.

## Building the basket screen

Now we replace the placeholder `lib/screens/basket_screen.dart` with a full screen that displays items in the cart, lets the user remove items, shows the total due, and provides a checkout button.

### Convert BasketScreen to a stateful widget

Open `lib/screens/basket_screen.dart`. Replace the placeholder with a `StatefulWidget`:

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

  void _removeItem(int index) {
    setState(() {
      CartRepository.instance.removeItem(index);
    });
  }

  void _checkout(CartRepository cart) {
    setState(() {
      cart.clear();
      _confirmationMessage = 'Order placed!';
    });
  }
```

The screen holds a `_confirmationMessage` string. Calling `_removeItem` removes the item at that index and triggers a rebuild with `setState`. Calling `_checkout` clears the repository and updates the confirmation message.

### Build the empty basket state

When the cart contains no items, we display a friendly empty state message. Add the `_buildEmptyState` helper inside `_BasketScreenState`:

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

Your empty basket view should look like this in the running app:

![The basket screen showing the empty state message](images/5/basket_screen_empty.png)

### Build the basket item card

Next, add a helper to format each item as a `Card` displaying its quantity, name, calculated line total, selected options, and a delete button:

```dart
  Widget _buildItemCard(CartItem item, int index) {
    final List<String> optionParts = [];
    if (item.toasted) {
      optionParts.add('Toasted');
    }
    if (item.vegan) {
      optionParts.add('Vegan');
    }
    if (item.note.isNotEmpty) {
      optionParts.add('Note: ${item.note}');
    }

    final Widget optionsWidget;
    if (optionParts.isNotEmpty) {
      optionsWidget = Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          optionParts.join(' • '),
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      );
    } else {
      optionsWidget = const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.quantity} x ${item.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('£${item.lineTotal.toStringAsFixed(2)}'),
                  optionsWidget,
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _removeItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }
```

If the customer selected options or added a note, `optionParts.join(' • ')` combines them into a single descriptive subtitle. The `IconButton` with `Icons.delete_outline` calls `_removeItem(index)`.

### Build the basket items list and checkout button

Now create a helper that assembles the section heading, item cards, total due row, and checkout button:

```dart
  Widget _buildBasketList(CartRepository cart, List<CartItem> items) {
    final List<Widget> children = [];
    children.add(
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Your basket', style: shopSectionTitleStyle),
      ),
    );

    for (int i = 0; i < items.length; i++) {
      children.add(_buildItemCard(items[i], i));
    }

    children.add(const SizedBox(height: 16));
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '£${cart.getTotalDue().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    children.add(const SizedBox(height: 16));
    children.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label: 'Checkout',
            onPressed: () {
              _checkout(cart);
            },
          ),
        ),
      ),
    );

    if (_confirmationMessage.isNotEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return ListView(children: children);
  }
```

The loop builds a card for every item, followed by a summary row with `cart.getTotalDue().toStringAsFixed(2)`. The Checkout button uses `PrimaryButton` and runs `_checkout(cart)`.

When items are present, your screen should look like this:

![The basket screen showing items, total due, and checkout button](images/5/basket_screen_with_items.png)

### Assemble the basket screen scaffold

Finally, implement the `build` method to select between the empty state and the basket list:

```dart
  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    final Widget content;
    if (items.isEmpty) {
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          children: [
            _buildEmptyState(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _confirmationMessage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
      body: content,
    );
  }
}
```

Save the file. You can now add items from the order screen and view them in your basket.

### Widget test the basket screen

Create a new test file named `test/basket_screen_test.dart`:

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

  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

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

      await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

      expect(find.text('Your basket'), findsOneWidget);
      expect(find.text('2 x Footlong'), findsOneWidget);
      expect(find.text('£20.00'), findsWidgets);
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    },
  );
}
```

Run the tests:

```bash
flutter test test/basket_screen_test.dart
```

### Commit your changes (5)

Stage `lib/screens/basket_screen.dart` and `test/basket_screen_test.dart`. Commit your changes with a message of your own.

## Loading the menu from JSON

Up to this point, our sandwich menu items were hardcoded in `SandwichRepository`. Hardcoded data is inflexible; adding a new sandwich or altering prices requires modifying Dart code. In this section we move the menu into an external JSON file, register the asset, and load it into our data models.

### Create the JSON asset file

Create a new file named `assets/data/sandwiches.json`:

```json
[
  {
    "id": "footlong",
    "name": "Footlong Sub",
    "description": "Our classic freshly baked 12-inch sub.",
    "price": 7.50,
    "imagePath": "assets/images/footlong.jpeg"
  },
  {
    "id": "six_inch",
    "name": "Six-Inch Sub",
    "description": "A 6-inch sub packed with fresh ingredients.",
    "price": 4.50,
    "imagePath": "assets/images/six_inch.jpeg"
  }
]
```

Your file in VS Code should look like this:

![The sandwiches.json file registered and opened in VS Code](images/5/sandwiches_json_file.png)

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

Open `lib/models/sandwich.dart`. We add a factory constructor `Sandwich.fromJson` to parse a `Map<String, dynamic>` into a `Sandwich`, and a `toJson` method to convert it back to a map:

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

  factory Sandwich.fromJson(Map<String, dynamic> json) {
    final num priceNumber = json['price'] as num;
    final double parsedPrice = priceNumber.toDouble();

    return Sandwich(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: parsedPrice,
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
    };
  }

  String get formattedPrice {
    return '£${price.toStringAsFixed(2)}';
  }
}
```

In Dart, parsing numbers from JSON can yield either an `int` or a `double`. Reading `json['price']` as `num` and calling `.toDouble()` safely handles both integers and floats without runtime casting errors.

### Unit test JSON serialisation

Open `test/sandwich_model_test.dart` and add tests verifying `fromJson` and `toJson`:

```dart
  test('fromJson creates a Sandwich instance from valid JSON map', () {
    final Map<String, dynamic> jsonMap = <String, dynamic>{
      'id': 'veggie',
      'name': 'Veggie Delight',
      'description': 'Crisp garden vegetables',
      'price': 4.25,
      'imagePath': 'assets/images/six_inch.jpeg',
    };

    final Sandwich sandwich = Sandwich.fromJson(jsonMap);

    expect(sandwich.id, 'veggie');
    expect(sandwich.name, 'Veggie Delight');
    expect(sandwich.description, 'Crisp garden vegetables');
    expect(sandwich.price, 4.25);
    expect(sandwich.imagePath, 'assets/images/six_inch.jpeg');
  });

  test('toJson serialises a Sandwich instance into a JSON map', () {
    const Sandwich sandwich = Sandwich(
      id: 'turkey',
      name: 'Turkey Sub',
      description: 'Sliced turkey breast',
      price: 6.00,
      imagePath: 'assets/images/footlong.jpeg',
    );

    final Map<String, dynamic> jsonMap = sandwich.toJson();

    expect(jsonMap['id'], 'turkey');
    expect(jsonMap['name'], 'Turkey Sub');
    expect(jsonMap['description'], 'Sliced turkey breast');
    expect(jsonMap['price'], 6.00);
    expect(jsonMap['imagePath'], 'assets/images/footlong.jpeg');
  });
```

Run your model tests:

```bash
flutter test test/sandwich_model_test.dart
```

### Load JSON data in the repository

Open `lib/repositories/sandwich_repository.dart`. We add a method `loadSandwichesFromAsset` that uses `rootBundle.loadString` from `package:flutter/services.dart` to read the JSON file, decodes it with `jsonDecode` from `dart:convert`, and builds `Sandwich` instances:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sandwich_shop/models/sandwich.dart';

class SandwichRepository {
  List<Sandwich> getSandwiches() {
    return const [
      Sandwich(
        id: 'footlong',
        name: 'Footlong Sub',
        description: 'Our classic freshly baked 12-inch sub.',
        price: 7.50,
        imagePath: 'assets/images/footlong.jpeg',
      ),
      Sandwich(
        id: 'six_inch',
        name: 'Six-Inch Sub',
        description: 'A 6-inch sub packed with fresh ingredients.',
        price: 4.50,
        imagePath: 'assets/images/six_inch.jpeg',
      ),
    ];
  }

  Future<List<Sandwich>> loadSandwichesFromAsset(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    final List<Sandwich> sandwiches = [];
    for (final dynamic item in jsonList) {
      sandwiches.add(Sandwich.fromJson(item as Map<String, dynamic>));
    }
    return sandwiches;
  }

  Sandwich? getSandwichById(String id) {
    for (final Sandwich sandwich in getSandwiches()) {
      if (sandwich.id == id) {
        return sandwich;
      }
    }
    return null;
  }
}
```

The method reads the asset string asynchronously, parses the list, and uses a standard `for-in` loop to deserialize each item with `Sandwich.fromJson`. Run all tests across the repository to verify that existing synchronous calls and new model methods work properly:

```bash
flutter test
```

### Commit your changes (6)

Stage `assets/data/sandwiches.json`, `pubspec.yaml`, `lib/models/sandwich.dart`, `lib/repositories/sandwich_repository.dart`, and `test/sandwich_model_test.dart`. Commit your changes with a message of your own.

## Exercises

The exercises below apply the concepts from this worksheet to the Southsea Cinema coursework application. They prepare you for Demo 3 of your coursework. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Remember to commit your changes to Git after each exercise.

1. Following [Shared constants and the Subway theme](#shared-constants-and-the-subway-theme), create a `constants.dart` file in your Southsea Cinema fork to hold shared brand colours and typography. Configure `ThemeData` on your root `MaterialApp` and remove the debug banner with `debugShowCheckedModeBanner: false`.

2. Following [Reusable widgets and navigation](#reusable-widgets-and-navigation), extract your application's squared action buttons into a reusable widget using `ElevatedButton.styleFrom` and `RoundedRectangleBorder(borderRadius: BorderRadius.zero)`, matching the cinema site design.

3. Following [Register named routes](#register-named-routes), configure named routes (`'/'`, `'/basket'`, etc.) on your cinema application's `MaterialApp` and connect an app bar navigation action button across your screens.

4. Following [Holding an order in a basket](#holding-an-order-in-a-basket), build a `TicketCartItem` model and a `TicketCartRepository` singleton to store selected cinema tickets and refreshments. Write unit tests verifying that tickets can be added, removed, and totals accurately calculated.

5. Following [Building the order form](#building-the-order-form), build a ticket booking screen with interactive switches (for example concessions or member discounts) and a note field managed by a `TextEditingController`. Wrap the form in a `SingleChildScrollView` to prevent keyboard overflow errors.

6. Following [Building the basket screen](#building-the-basket-screen), build a basket screen displaying booked tickets, line totals, a total summary row, and a checkout button. Verify your screen with automated widget tests using `testWidgets`.

7. Following [Loading the menu from JSON](#loading-the-menu-from-json), move your film listings or ticket price tiers into a JSON asset file, register it in `pubspec.yaml`, and implement `fromJson` and `toJson` methods on your cinema models. **Show your running application with active cart navigation to a member of staff** for your progress sign-off.
