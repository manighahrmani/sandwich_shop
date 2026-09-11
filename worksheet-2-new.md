# Worksheet 2 — Stateless and Stateful Widgets

## Table of contents

- [What you need to know beforehand](#what-you-need-to-know-beforehand)
- [Getting help](#getting-help)
- [App skeleton overview](#app-skeleton-overview)
  - [Starting from Worksheet 1](#starting-from-worksheet-1)
  - [Understanding the main entry point and runApp](#understanding-the-main-entry-point-and-runapp)
  - [Cleaning the default template code](#cleaning-the-default-template-code)
  - [Defining the App widget](#defining-the-app-widget)
- [Custom Stateless widgets](#custom-stateless-widgets)
  - [What is a StatelessWidget](#what-is-a-statelesswidget)
  - [Creating the OrderItemDisplay widget](#creating-the-orderitemdisplay-widget)
  - [Rendering dynamic text and emojis](#rendering-dynamic-text-and-emojis)
  - [Displaying OrderItemDisplay inside App](#displaying-orderitemdisplay-inside-app)
- [Layout and styling](#layout-and-styling)
  - [Arranging widgets with Column and Row](#arranging-widgets-with-column-and-row)
  - [Alignment and spacing](#alignment-and-spacing)
  - [Styling text with TextStyle](#styling-text-with-textstyle)
  - [Inspecting the widget tree with Flutter DevTools](#inspecting-the-widget-tree-with-flutter-devtools)
- [Stateful widgets and interactivity](#stateful-widgets-and-interactivity)
  - [Understanding ephemeral state](#understanding-ephemeral-state)
  - [Anatomy of a StatefulWidget and State class](#anatomy-of-a-statefulwidget-and-state-class)
  - [Creating the OrderScreen widget](#creating-the-orderscreen-widget)
  - [Adding interactive buttons with ElevatedButton](#adding-interactive-buttons-with-elevatedbutton)
  - [Mutating state with setState](#mutating-state-with-setstate)
  - [Testing the complete counter in Sandwich Shop](#testing-the-complete-counter-in-sandwich-shop)
- [Exercises](#exercises)
  - [1 - Explore the Southsea Cinema app skeleton](#1---explore-the-southsea-cinema-app-skeleton)
  - [2 - Create a custom Stateless ticket information card](#2---create-a-custom-stateless-ticket-information-card)
  - [3 - Build a Stateful ticket quantity selector with interactive buttons](#3---build-a-stateful-ticket-quantity-selector-with-interactive-buttons)
  - [4 - Inspect and debug your coursework app in mobile view](#4---inspect-and-debug-your-coursework-app-in-mobile-view)
  - [5 - Commit and push your coursework progress](#5---commit-and-push-your-coursework-progress)

## What you need to know beforehand

Ensure that you have already completed [Worksheet 1 — Dart, Git, GitHub and Flutter](./worksheet-1.md). You should have:

- A working development environment with Flutter and Visual Studio Code (VS Code).
- Your own `sandwich_shop` repository from Worksheet 1 (matching branch 1).
- A forked and cloned `southsea_cinema` coursework repository.
- Familiarity with opening the terminal, running `flutter run`, and using hot reload.

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and ask your questions in the module channel. You can also ask questions during your timetabled practical sessions.

## App skeleton overview

In Worksheet 1, you ran the default Flutter counter application. In this section, you will dissect the core User Interface (UI) skeleton and replace the starter boilerplate with the initial architecture for the Sandwich Shop application.

### Starting from Worksheet 1

Open your `sandwich_shop` project in VS Code. The code in `lib/main.dart` should match the starter counter code from the end of Worksheet 1 (equivalent to branch 1 in the course repository).

Ensure that your app runs by opening a terminal (**Ctrl + \`** on Windows or **⌘ + \`** on macOS) and running:

```bash
flutter run -d chrome
```

![Placeholder: Screenshot of the default Flutter counter application running in Chrome](images/placeholder_default_counter_running.png)

### Understanding the main entry point and runApp

Every Flutter application starts execution at the top-level `main()` function in `lib/main.dart`. The `runApp()` function binds the widget tree to the screen:

```dart
void main() {
  runApp(const App());
}
```

Flutter builds user interfaces by composing widgets hierarchically into a **widget tree**. At the root sits `MaterialApp`, which provides the core styling, routing, and localization defined by Google's Material Design system. Inside `MaterialApp`, a `Scaffold` widget provides standard visual layout structures including an `AppBar` at the top and a `body` for content.

### Cleaning the default template code

Let's clear out the default counter classes (`MyApp`, `MyHomePage`, and `_MyHomePageState`) to build our own clean interface from scratch.

Open `lib/main.dart` and delete everything below the `import 'package:flutter/material.dart';` statement. Replace the contents with an empty `main()` function:

```dart
import 'package:flutter/material.dart';

void main() {}
```

Save the file (**Ctrl + S** on Windows or **⌘ + S** on macOS).

### Defining the App widget

Now create the root widget for our application. Add the following `App` class below `main()`:

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sandwich Counter'),
        ),
        body: const Center(
          child: Text('Welcome to the Sandwich Shop!'),
        ),
      ),
    );
  }
}
```

Update `main()` to pass `App` into `runApp()`:

```dart
void main() {
  runApp(const App());
}
```

Trigger hot restart by pressing **Shift + F5** or pressing **R** in your terminal. You should see a clean dark or light bar with the title "Sandwich Counter" and a centred welcome message.

![Placeholder: Screenshot of the cleaned App widget running with a basic Scaffold AppBar](images/placeholder_clean_app_scaffold.png)

Commit your changes in VS Code or via the terminal:

```bash
git add lib/main.dart
git commit -m "feat: set up basic App skeleton with Scaffold"
```

## Custom Stateless widgets

### What is a StatelessWidget

A `StatelessWidget` represents a part of the UI that depends solely on its own configuration parameters and does not change dynamically over time.

- Its properties are marked `final` and set once when the constructor runs.
- Flutter calls its `build(BuildContext context)` method whenever the widget needs to be displayed or when its parent rebuilds with new inputs.
- Stateless widgets are lightweight, predictable, and simple to test.

### Creating the OrderItemDisplay widget

We will build a custom, reusable stateless widget to display a single sandwich order item. Add the following class at the bottom of `lib/main.dart`:

```dart
class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es)');
  }
}
```

Key aspects of this widget:

- `quantity` (an integer) and `itemType` (a string) are declared as `final` fields.
- The constructor accepts positional arguments for both fields, plus an optional named `super.key` parameter to preserve widget state across tree movements.
- The `build` method returns a `Text` widget displaying the passed data.

### Rendering dynamic text and emojis

We can use Dart's string multiplication to display an emoji for every sandwich in the order. Update the `build` method of `OrderItemDisplay`:

```dart
@override
Widget build(BuildContext context) {
  return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
}
```

If `quantity` is 3, `${'🥪' * quantity}` produces `🥪🥪🥪`. If `quantity` is 0, it renders an empty string.

### Displaying OrderItemDisplay inside App

Now let's replace the placeholder text in `App` with our new custom widget. Update the `body` property inside `App.build`:

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sandwich Counter'),
        ),
        body: const Center(
          child: OrderItemDisplay(5, 'Footlong'),
        ),
      ),
    );
  }
}
```

Save the file and check your browser. The screen now displays:

```text
5 Footlong sandwich(es): 🥪🥪🥪🥪🥪
```

![Placeholder: Screenshot of OrderItemDisplay rendering 5 Footlong sandwiches with emojis](images/placeholder_order_item_display.png)

Commit your changes:

```bash
git add lib/main.dart
git commit -m "feat: create custom OrderItemDisplay stateless widget"
```

## Layout and styling

### Arranging widgets with Column and Row

Flutter provides specialized layout widgets to position multiple children:

- `Column`: arranges children vertically (from top to bottom).
- `Row`: arranges children horizontally (from left to right).

Both widgets take a `children: <Widget>[]` list.

### Alignment and spacing

You can control alignment along the main axis (vertical for `Column`, horizontal for `Row`) using `mainAxisAlignment`:

- `MainAxisAlignment.center`: centers children in the middle of the available space.
- `MainAxisAlignment.spaceBetween`: places free space evenly between the children.
- `MainAxisAlignment.spaceEvenly`: distributes space evenly before, between, and after children.

Cross-axis alignment (horizontal for `Column`, vertical for `Row`) is controlled using `crossAxisAlignment`:

- `CrossAxisAlignment.center`: centers children perpendicularly.
- `CrossAxisAlignment.stretch`: forces children to fill the cross axis.

To introduce fixed spacing between widgets, use `const SizedBox(height: 16)` or `const SizedBox(width: 8)`.

### Styling text with TextStyle

You can customize typography using the `style` property of a `Text` widget. Update `OrderItemDisplay` to make the text larger and bold:

```dart
class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
```

### Inspecting the widget tree with Flutter DevTools

Flutter provides Developer Tools (DevTools) directly inside VS Code for inspecting widget trees, measuring performance, and troubleshooting layout constraints.

1. While your app is running, open the VS Code Command Palette (**Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS).
2. Type `Flutter: Open DevTools` and select **Open DevTools in Web Browser** or **Open DevTools in VS Code**.
3. Click the **Widget Inspector** tab.
4. Click on elements in the visual tree to view their rendered dimensions, padding, and layout constraints.

![Placeholder: Screenshot of Flutter DevTools Widget Inspector showing the widget tree and layout properties](images/placeholder_flutter_devtools_inspector.png)

## Stateful widgets and interactivity

While `StatelessWidget` is suitable for fixed views, interactive applications require data that changes dynamically in response to user actions.

### Understanding ephemeral state

**Ephemeral state** (sometimes called UI state or local state) is state that you can neatly contain within a single widget. Examples include:

- The current value of a counter.
- The currently selected tab.
- The text entered into a search box.

In the Sandwich Shop app, the quantity of sandwiches ordered is ephemeral state.

### Anatomy of a StatefulWidget and State class

Unlike a `StatelessWidget`, a `StatefulWidget` is split into two classes:

1. **The `StatefulWidget` class:** An immutable configuration class that extends `StatefulWidget` and overrides `createState()`.
2. **The `State` class:** A companion object that persists across widget rebuilds. It holds mutable variables and contains the `build()` method.

```dart
class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    // UI that depends on _quantity
  }
}
```

Notice the `widget` property accessible inside `_OrderScreenState`: it allows the state class to access fields defined on its parent `OrderScreen` widget (such as `widget.maxQuantity`).

### Creating the OrderScreen widget

We will now create the interactive `OrderScreen` widget. Add the following code below `App` in `lib/main.dart`:

```dart
class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              _quantity,
              'Footlong',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _increaseQuantity,
                  child: const Text('Add'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _decreaseQuantity,
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Adding interactive buttons with ElevatedButton

Notice how the buttons are defined inside the `Row`:

- `ElevatedButton(onPressed: _increaseQuantity, child: const Text('Add'))`
- `ElevatedButton(onPressed: _decreaseQuantity, child: const Text('Remove'))`

`ElevatedButton` provides a prominent Material Design button that responds to hover and clicks. The `onPressed` property takes a function callback. When the user clicks "Add", Flutter executes `_increaseQuantity`.

### Mutating state with setState

Inside `_increaseQuantity()` and `_decreaseQuantity()`, state is updated using `setState()`:

```dart
void _increaseQuantity() {
  if (_quantity < widget.maxQuantity) {
    setState(() => _quantity++);
  }
}
```

Calling `setState()` notifies the Flutter framework that internal state has changed. Flutter then schedules a call to the widget's `build()` method, re-rendering the subtree with the updated value of `_quantity`.

If you mutate `_quantity++` without calling `setState()`, the variable changes in memory, but Flutter will not rebuild the UI to show the new value.

### Testing the complete counter in Sandwich Shop

Finally, update `App` so that its `home` points to `OrderScreen`:

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}
```

Save the file and test the app in your browser:

1. The counter starts at `0 Footlong sandwich(es):`.
2. Click **Add**: the counter increments, and sandwich emojis appear one by one.
3. Click **Remove**: the counter decrements until it reaches 0.
4. Click **Add** past 5: the quantity will not exceed `maxQuantity: 5`.

![Placeholder: Screenshot of the interactive OrderScreen with Add and Remove buttons running](images/placeholder_order_screen_interactive.png)

Commit your changes:

```bash
git add lib/main.dart
git commit -m "feat: implement OrderScreen stateful counter with Add and Remove buttons"
```

Your code now matches branch 2 in the sandwich shop repository.

---

## Exercises

From this point onwards, the exercises direct you to apply what you have learned to your **Southsea Cinema** coursework repository (`southsea_cinema`).

These exercises prepare you for **Demo 1** (deadline: Friday 2 October 2026). In Demo 1, building a custom stateless widget qualifies for stretch credit (3/4 functionality), and implementing an interactive stateful widget qualifies for full functionality marks (4/4).

### 1 - Explore the Southsea Cinema app skeleton

Open your cloned `southsea_cinema` project in VS Code. Run the project in Chrome or Edge in mobile device mode:

```bash
flutter run -d chrome
```

Open and examine the starter files:

- `lib/main.dart`: Contains `SouthseaCinemaApp`, setting the dark theme, routes, and `HomeView` as home.
- `lib/constants.dart`: Defines cinema brand colors (`cinemaBrand`, `cinemaSurface`, `cinemaBackground`, `cinemaFontWhite`, `cinemaFontMuted`).
- `lib/views/home_view.dart`: The starter home screen with an `AppBar`, `NavDrawer`, and placeholder text.
- `lib/widgets/nav_drawer.dart`: A minimal navigation drawer with drawer tiles.

![Placeholder: Screenshot of the Southsea Cinema starter app in Chrome DevTools mobile view](images/placeholder_southsea_cinema_starter.png)

### 2 - Create a custom Stateless ticket information card

Create a new file `lib/widgets/ticket_info_card.dart` in your `southsea_cinema` project.

Implement a `StatelessWidget` called `TicketInfoCard` that displays information about cinema admission:

```dart
import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';

class TicketInfoCard extends StatelessWidget {
  final String category;
  final String price;
  final String description;

  const TicketInfoCard({
    super.key,
    required this.category,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cinemaSurface,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: cinemaFontWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: cinemaBrand,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: cinemaFontMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Add an instance of `TicketInfoCard` to `lib/views/home_view.dart` inside the body `Column`.

![Placeholder: Screenshot of TicketInfoCard rendered inside Southsea Cinema HomeView](images/placeholder_ticket_info_card.png)

### 3 - Build a Stateful ticket quantity selector with interactive buttons

Create a new file `lib/widgets/ticket_selector.dart` in your `southsea_cinema` project.

Build an interactive `StatefulWidget` called `TicketSelector` that allows customers to select the number of tickets they want to purchase:

- Declare an integer state variable `int _ticketCount = 0;`.
- Add an `_incrementTickets()` method that increases `_ticketCount` inside `setState()`. Set a reasonable upper bound (for example, maximum 10 tickets per order).
- Add a `_decrementTickets()` method that decreases `_ticketCount` inside `setState()`, ensuring it cannot go below 0.
- Create two `ElevatedButton` or `IconButton` widgets for adding and removing tickets.
- Display the current count dynamically, with clear labels and styled buttons using colors from `constants.dart`.

```dart
import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';

class TicketSelector extends StatefulWidget {
  final int maxTickets;

  const TicketSelector({super.key, this.maxTickets = 10});

  @override
  State<TicketSelector> createState() => _TicketSelectorState();
}

class _TicketSelectorState extends State<TicketSelector> {
  int _ticketCount = 0;

  void _incrementTickets() {
    if (_ticketCount < widget.maxTickets) {
      setState(() {
        _ticketCount++;
      });
    }
  }

  void _decrementTickets() {
    if (_ticketCount > 0) {
      setState(() {
        _ticketCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cinemaSurface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tickets: $_ticketCount',
            style: const TextStyle(
              color: cinemaFontWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cinemaBrand,
                  foregroundColor: cinemaFontWhite,
                ),
                onPressed: _decrementTickets,
                child: const Text('-'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cinemaBrand,
                  foregroundColor: cinemaFontWhite,
                ),
                onPressed: _incrementTickets,
                child: const Text('+'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

Add `TicketSelector` to `lib/views/home_view.dart` underneath the `TicketInfoCard`.

![Placeholder: Screenshot of the interactive TicketSelector running in Southsea Cinema](images/placeholder_southsea_cinema_ticket_selector.png)

### 4 - Inspect and debug your coursework app in mobile view

1. Run your `southsea_cinema` app on Chrome or Edge with the device toolbar active (set to iPhone or Pixel).
2. Open the Flutter Widget Inspector. Verify the structure of `HomeView -> Column -> [TicketInfoCard, TicketSelector]`.
3. Tap the `+` and `-` buttons in the browser. Confirm that the quantity updates immediately and does not decrease below zero or exceed the maximum limit.

### 5 - Commit and push your coursework progress

Review your changes in the VS Code Source Control view. Stage and commit your changes with a descriptive message:

```bash
git add lib/widgets/ticket_info_card.dart lib/widgets/ticket_selector.dart lib/views/home_view.dart
git commit -m "feat: add ticket info card and interactive ticket quantity selector"
git push
```

Verify on your GitHub account that the commit appears on your public fork repository. You are now prepared to demonstrate both stateless and stateful widget functionality for Demo 1.
