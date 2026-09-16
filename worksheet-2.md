# Worksheet 2 — Stateless and Stateful Widgets

## Table of contents

- [What you need to know beforehand](#what-you-need-to-know-beforehand)
- [Getting help](#getting-help)
- [Getting started](#getting-started)
- [Import the Material Design library](#import-the-material-design-library)
  - [Clean the default code](#clean-the-default-code)
  - [Commit your changes (1)](#commit-your-changes-1)
- [Define the main app widget: App](#define-the-main-app-widget-app)
  - [Use the App widget](#use-the-app-widget)
  - [Commit your changes (2)](#commit-your-changes-2)
- [Define the UI inside App](#define-the-ui-inside-app)
  - [Redefine the build method](#redefine-the-build-method)
  - [Run the application](#run-the-application)
  - [Commit your changes (3)](#commit-your-changes-3)
- [Create the custom OrderItemDisplay widget](#create-the-custom-orderitemdisplay-widget)
  - [Define the OrderItemDisplay widget](#define-the-orderitemdisplay-widget)
  - [Commit your changes (4)](#commit-your-changes-4)
  - [Implement the build method of OrderItemDisplay](#implement-the-build-method-of-orderitemdisplay)
  - [Commit your changes (5)](#commit-your-changes-5)
- [Use OrderItemDisplay in App](#use-orderitemdisplay-in-app)
  - [Replace the placeholder in App to use OrderItemDisplay](#replace-the-placeholder-in-app-to-use-orderitemdisplay)
  - [Run the application again to see OrderItemDisplay in action](#run-the-application-again-to-see-orderitemdisplay-in-action)
  - [Commit your changes (6)](#commit-your-changes-6)
- [Inspecting the Scaffold with the Widget Inspector](#inspecting-the-scaffold-with-the-widget-inspector)
  - [Open the Widget Inspector](#open-the-widget-inspector)
  - [Read the widget tree of your app](#read-the-widget-tree-of-your-app)
  - [Experiment with the parts of the Scaffold](#experiment-with-the-parts-of-the-scaffold)
  - [Commit your changes (7)](#commit-your-changes-7)
- [Making the app interactive with Stateful widgets](#making-the-app-interactive-with-stateful-widgets)
  - [Stateless versus Stateful](#stateless-versus-stateful)
  - [Add Add and Remove buttons](#add-add-and-remove-buttons)
  - [Commit your changes (8)](#commit-your-changes-8)
  - [Define the OrderScreen stateful widget](#define-the-orderscreen-stateful-widget)
  - [Commit your changes (9)](#commit-your-changes-9)
  - [Build the UI for OrderScreen](#build-the-ui-for-orderscreen)
  - [Use OrderScreen inside App](#use-orderscreen-inside-app)
  - [Commit your changes (10)](#commit-your-changes-10)
  - [Add and remove emojis with setState](#add-and-remove-emojis-with-setstate)
  - [Commit your changes (11)](#commit-your-changes-11)
- [Exercises](#exercises)

## What you need to know beforehand

Ensure that you have already completed [Worksheet 1 — Dart, Git, GitHub and Flutter](./worksheet-1.md).

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## Getting started

For this worksheet, you can start with the code from branch 1 of our [GitHub repository](https://github.com/manighahrmani/sandwich_shop/tree/1) which should be similar to what you'd have at the end of Worksheet 1. You can either clone the repository and checkout branch 1 by running the following in the terminal (the `checkout` command switches to the specified branch, in this case branch 1):

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git checkout 1
```

Alternatively, you can continue with the Flutter project you created in Worksheet 1. You should already have a repository in your GitHub account for this project (e.g., `github.com/your-username/sandwich_shop`).

## Import the Material Design library

Open `lib/main.dart` and ensure that you have the correct `import` statement for Material Design components:

```dart
import 'package:flutter/material.dart';
```

The top of your file should look like this:

![Import Material Design library](images/2/import_material_design.png)

**Material Design** is a design system from Google. The `package:flutter/material.dart` library gives you access to its pre-built User Interface (UI) components, called **widgets**. We will use these widgets to build our user interface.

Use Copilot to explore this library further. For example, you can ask it: "What kind of widgets are available in the material.dart library? List a few examples and explain them briefly."

For completeness, below are some general categories of fundamental building blocks in Flutter:

- Structural elements like `Scaffold` (for page layout), `AppBar` (for the top application bar), and `Drawer` (for navigation menus).
- Buttons like `ElevatedButton`, `TextButton`, and `IconButton`.
- Informational widgets like `Text`, `Image`, and `Icon` (for displaying icons).
- Input widgets like `TextField` (for text entry) and `Checkbox` (for boolean input).
- Layout widgets like `Row`, `Column`, `Stack`, and `Card` that help you arrange other widgets.

### Clean the default code

Locate the `main()` function in `lib/main.dart`, which is the entry point of your app. You can do this with the "Go to Symbol" feature in VS Code by pressing **Ctrl + Shift + O** on Windows or **⌘ + Shift + O** on macOS and selecting `main`. Let's clear out the default `MyApp` class and other related classes from the app.

Comment out or remove this line for now. You can comment a line in VS Code by selecting it with your mouse and pressing **Ctrl + /** on Windows or **⌘ + /** on macOS. The (uncommented) code in your `lib/main.dart` file should now look like this:

```dart
import 'package:flutter/material.dart';

void main() {}
```

Make sure your file looks like this now:

![Cleaned main.dart file](images/2/cleaned_main_dart.png)

### Commit your changes (1)

Now is a good time to commit your changes. In VS Code, go to the Source Control panel. You can open this from `View > Source Control`. Alternatively, you can open the Command Palette by pressing **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS and enter `Source Control`, which will open the Source Control panel.
You should see `main.dart` listed under changes. Type a descriptive commit message, such as `Set Up the Project`, and click the `Commit` button, followed by `Sync Changes`.

Alternatively, open the terminal using **Ctrl + \`** on Windows or **⌘ + \`** on macOS and run these commands:

```bash
git add lib/main.dart
git commit -m "Set Up the Project"
git push
```

## Define the main app widget: App

We will now define the main widget for our application.

Add the following class definition to `lib/main.dart`, below the `main()` function, on a new line after the closing curly brace (`}`):

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

After you've added the `App` class, optionally fold the rest of the classes and ignore them as shown in this screenshot:

![Folded classes screenshot](images/2/folded_classes.png)

Hopefully you are familiar with the syntax (refer to the Dart worksheets in [Worksheet 1](./worksheet-1.md) for a refresher). We are defining a subclass of `StatelessWidget` class called `App`. `App` is going to be the stateless widget that serves as the main entry point for our application's UI.

If a class extends `StatelessWidget`, it means its state and properties can't change once it's built. All widgets must have a `build` method, which describes the widget's part of the user interface (what it should look like and how it should behave).

For now, the `build` method returns an empty `Container`, which is like a blank `div` tag in HTML. To understand this code better, select the entire class and ask Copilot the following questions by pressing **Ctrl + I** on Windows or **⌘ + I** on macOS:

- Explain what this `StatelessWidget` does.
- Ask it what the build does and why do we need it?
- What does the override keyword do?
- What about the super.key?

### Use the App widget

Next, update the `main()` function to run our new `App` widget:

```dart
void main() {
  runApp(const App());
}
```

Check that your `main()` function now looks like this:

![Main function screenshot](images/2/main_function.png)

The `runApp()` function takes our `App` widget and makes it the root of the widget tree, displaying it on the screen. If you run the app now, you will just see a blank screen.

### Commit your changes (2)

Commit your work with a meaningful message, such as `Define the Main App Widget: App`.

## Define the UI inside App

Let's give our `App` widget some structure and content.

### Redefine the build method

Modify the `build` method within the `App` class as follows:

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Sandwich Shop App',
    home: Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter')),
      body: const Center(
        child: Text('Welcome to the Sandwich Shop!'),
      ),
    ),
  );
}
```

Your `App` widget should now look like this:

![App widget screenshot](images/2/app_widget.png)

Here, we've created a "widget tree". `MaterialApp` is the root (parent), providing core app functionality. `Scaffold` provides the basic screen layout, including an `AppBar` (the top bar) and a `body`. The body contains a `Center` widget, which in turn holds our `Text` widget.

As before, for a deeper understanding of this structure, use Copilot to explain each widget's role.

### Run the application

Make sure you have a device selected (e.g., Chrome or Edge from the bottom status bar). You can also open the Command Palette by pressing **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS and type "Flutter: Select Device" to choose a device.

With a device selected run the app by pressing **F5** (depending on your keyboard, you may have to press **Fn + F5**). You should see an application with an app bar titled "Sandwich Counter" and "Welcome to the Sandwich Shop\!" centred on the screen.

![Welcome to the Sandwich Shop](images/2/screenshot_welcome_to_sandwich_shop.jpg)

### Commit your changes (3)

Commit your work with a message like `Define the UI inside App`.

## Create the custom OrderItemDisplay widget

You can create your own reusable widgets by combining existing ones. We will create a custom widget to display a single sandwich order.

### Define the OrderItemDisplay widget

Add the definition for `OrderItemDisplay` in `lib/main.dart`, placing it below the `App` class:

```dart
class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('This is a placeholder for OrderItemDisplay');
  }
}
```

You may need to auto-fix any warnings by hovering over the squiggly lines and clicking on the lightbulb icon or pressing **Ctrl + .** on Windows or **⌘ + .** on macOS. See the screenshot below:

![Auto-fix warnings screenshot](images/2/auto_fix_warnings.png)

This `StatelessWidget` has two `final` instance variables, `itemType` and `quantity`, which are set by its constructor (whenever an instance of `OrderItemDisplay` is created, the value for `itemType` and `quantity` must be provided but `key` is optional hence it is written in curly braces). `final` means they cannot be changed after the widget is created.

Running the app at this stage won't show any visual changes yet, as we haven't actually used the `OrderItemDisplay` widget in our `App`.

### Commit your changes (4)

Commit your new widget with the message `Define OrderItemDisplay custom widget`.

### Implement the build method of OrderItemDisplay

Now, let's update the `build` method of `OrderItemDisplay` to show the sandwich type and quantity with emojis. We want it to display something like: "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪". (Hopefully you are familiar with the syntax used for string interpolation in Dart, if not, refer to the worksheet on Strings in Dart linked in [Worksheet 1](./worksheet-1.md).)

Update the `build` method inside your `OrderItemDisplay` so it looks like this:

```dart
@override
Widget build(BuildContext context) {
  return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
}
```

### Commit your changes (5)

Commit this update with a message like `Implement dynamic text in OrderItemDisplay`.

## Use OrderItemDisplay in App

Now we can use our new custom widget inside the main `App`.

### Replace the placeholder in App to use OrderItemDisplay

Find the `build` method of the `App` class with the shortcut (**Ctrl + Shift + F** on Windows or **⌘ + Shift + F** on macOS) as shown below:

![Find build method screenshot](images/2/find_build_method.png)

Inside there, locate the `Center` widget within the `Scaffold`'s `body`. Select the `Center` widget's child (the `Text` widget) as shown below:

![Select Center widget screenshot](images/2/select_center_widget.png)

Then replace the placeholder `Text` widget in the `body` of the `Scaffold` with an instance of our new `OrderItemDisplay` widget. Your code must match the one shown below:

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Sandwich Shop App',
    home: Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter')),
      body: const Center(
        child: OrderItemDisplay(5, 'Footlong'),
      ),
    ),
  );
}
```

### Run the application again to see OrderItemDisplay in action

Run the app. You should now see "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪" displayed in the centre of the screen.

![Sandwich Counter](images/2/screenshot_sandwich_counter.jpg)

### Commit your changes (6)

Commit your final changes for this section with the message `Use OrderItemDisplay in App`.

At this stage, your code should look like our code as shown on [the GitHub repository](https://github.com/manighahrmani/sandwich_shop/blob/2/lib/main.dart).

## Inspecting the Scaffold with the Widget Inspector

The Widget Inspector is a tool that comes with the Flutter SDK and lets you examine the widget tree of your running app, see the properties of each widget, and understand how your UI is structured.

### Open the Widget Inspector

Make sure your app is still running (if not, press **F5** to start it). Open the Command Palette with **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS, type `Flutter: Open DevTools` and press **Enter**. It will then ask you where you want to open DevTools. Choose either your web browser or inside VS Code (in its Widget Inspector page) as shown below:

![Open DevTools in VS Code](images/2/screenshot_open_devtools_in_vscode.png)

For a short walkthrough of this tool, watch this [YouTube video on the Widget Inspector](https://www.youtube.com/watch?v=_EYk-E29edo&t=172s) and skim its [official documentation](https://docs.flutter.dev/tools/devtools/inspector). Make sure you watch the whole video and try using the Widget Inspector yourself on your running app.

![The Flutter Widget Inspector open in VS Code](images/2/screenshot_devtools.jpg)

### Read the widget tree of your app

In the Widget Inspector, enable "Select Widget Mode" (the mouse pointer icon at the top of the inspector) and then click on the sandwich emojis in your running app. The inspector highlights that widget and expands the tree to show it. You should see something similar to this:

![The widget tree with the sandwich text selected](images/2/screenshot_inspector_tree_sandwich_text.png)

Take a moment to trace the tree from the top down. At the root you have the `MaterialApp` which provides the overall app, then the `Scaffold` which provides the page layout, then the `AppBar` holding the `Text` title "Sandwich Counter", then the `Center` which centres its child, and finally your own `OrderItemDisplay` which contains a `Text`. Click on each of these in turn and watch the browser running the app to see how each widget is placed on the screen. When a widget is selected, the panels on the right show its size, padding and constraints. Notice how the `Center` takes up the whole body but its child only takes the space it needs.

![The widget tree with the app bar selected](images/2/screenshot_inspector_tree_app_bar.png)

As you explore, keep the [Scaffold documentation](https://api.flutter.dev/flutter/material/Scaffold-class.html) and the [AppBar documentation](https://api.flutter.dev/flutter/material/AppBar-class.html) open so you can connect what you see in the inspector to the properties in your code.

### Experiment with the parts of the Scaffold

Now let's change a few parts of the `Scaffold` and use the inspector to see the effect. Keep hot reload enabled (the lightning bolt icon while the app runs, or press **r** in the terminal) so your changes appear instantly. Make one change at a time in your `App` widget's `build` method.

Start with the `AppBar`. Change its title from `'Sandwich Counter'` to something else, such as `'My Sandwich Shop'`, and give it a background colour at the same time:

```dart
appBar: AppBar(
  title: const Text('My Sandwich Shop'),
  backgroundColor: Colors.orange,
),
```

Save the file (**Ctrl + S** on Windows or **⌘ + S** on macOS), then select the `AppBar` in the inspector and confirm the new title and colour appear in the running app and in the tree.

Both `title` and `backgroundColor` are properties of the `AppBar` widget. You can view all the properties of a widget in VS Code by hovering your mouse over its name in the code. In the popup below, scroll down to find `Color? backgroundColor`, which shows that `backgroundColor` accepts a nullable `Color` value:

![The AppBar properties shown on hover in VS Code](images/2/screenshot_app_bar_properties.png)

Next, add a `floatingActionButton` to the `Scaffold`. Put your cursor just after the `body` property, add a comma, then start typing `floating`. You should get an autocomplete suggestion for `floatingActionButton`. Select it and press **Enter** to add it to your code:

![The floatingActionButton autocomplete suggestion](images/2/screenshot_floating_action_button.png)

As the value of the `floatingActionButton` property, start typing `Floating` and select `FloatingActionButton` from the suggestions. Leave its `onPressed` property as an empty function (`() {}`). The `onPressed` property specifies the callback function that runs when the button is pressed, and `() {}` is a function that takes no parameters (`()`) and has an empty body (`{}`), so pressing the button does nothing for now. Your code should look like this:

![The FloatingActionButton with an empty onPressed callback](images/2/screenshot_floating_action_button_onpressed.png)

Lastly, add a `child` property inside the `FloatingActionButton`. Type `Icons` followed by a dot (`.`) to see the list of available icons, then find the `add` icon and press **Enter** to select it:

![Selecting the add icon for the FloatingActionButton child](images/2/screenshot_floating_action_button_child_icon.png)

Your completed `Scaffold` should now include the `floatingActionButton`:

```dart
body: const Center(
  child: OrderItemDisplay(5, 'Footlong'),
),
floatingActionButton: FloatingActionButton(
  onPressed: () {},
  child: const Icon(Icons.add),
),
```

A round button now appears in the bottom right corner. Select it in the inspector and notice that it sits in the tree separately from the `body`.

As a final test, temporarily delete the `Center` so the `body` is just the `OrderItemDisplay`, and observe how the text jumps to the top left of the body:

![The OrderItemDisplay positioned at the top left with no Center](images/2/screenshot_order_item_display_top_left.png)

Put the `Center` back afterwards (you can undo with **Ctrl + Z** on Windows or **⌘ + Z** on macOS). Once you are done, return your `App` widget to the version at the end of [Use OrderItemDisplay in App](#use-orderitemdisplay-in-app), with a plain `AppBar`, a `Center` and no floating action button.

### Commit your changes (7)

Commit any tidy-up with a message like `Restore Center after inspecting the Scaffold`.

## Making the app interactive with Stateful widgets

So far every widget we have written has been a `StatelessWidget`. That is fine for a fixed display, but a real app needs to respond to the user. In this section we will let the user add and remove sandwiches by pressing buttons, so the number of 🥪 emojis on the screen goes up and down.

### Stateless versus Stateful

State is simply data that can change while the app is running. A `StatelessWidget` is immutable, which means that once it is built its properties cannot change. It is like a photograph: a snapshot of the user interface at one moment. Our `OrderItemDisplay` is stateless because it only ever shows the values passed into its constructor. A `StatefulWidget`, on the other hand, can hold data that changes over time and rebuilds itself to show the new data.

The kind of state we use here is called ephemeral state, which is data that lives inside a single widget, such as the current number of sandwiches in the order. In a later worksheet we will meet app state, which is shared across many widgets, such as the login information of a user.

If you would like a short explanation before coding, read the [StatelessWidget documentation](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html) and the [StatefulWidget documentation](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html), and watch the Flutter team's short videos on [StatelessWidget](https://youtu.be/wE7khGHVkYY) and [StatefulWidget](https://youtu.be/AqCMFXEmf3w). Optionally, check out Flutter's [guide to adding interactivity](https://docs.flutter.dev/ui/interactivity).

<!-- TODO done till here -->

### Add Add and Remove buttons

First, let's add two buttons below the sandwich display. Update the `body` of the `Scaffold` in your `App` widget to use a `Column` containing the `OrderItemDisplay` and a `Row` of two buttons. You met `Column` and `Row` in the exercises: a `Column` stacks its children vertically and a `Row` lays them out horizontally.

```dart
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const OrderItemDisplay(5, 'Footlong'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => print('Add button pressed!'),
            child: const Text('Add'),
          ),
          ElevatedButton(
            onPressed: () => print('Remove button pressed!'),
            child: const Text('Remove'),
          ),
        ],
      ),
    ],
  ),
),
```

You may see a warning about calling `print` in production code; ignore it for now. To fix any indentation, open the Command Palette and run `Format Document`.

The important property of an [`ElevatedButton`](https://api.flutter.dev/flutter/material/ElevatedButton-class.html) is `onPressed`. It takes a function that runs when the button is tapped, which is called an event handler or a callback. For now our callbacks are arrow functions that just print a message to the terminal rather than the UI. Run the app with `flutter run` and click the buttons; the messages should appear in the terminal.

![Button presses placeholder: Screenshot of Add and Remove buttons with print output in the terminal](images/2/placeholder_button_presses.png)

### Commit your changes (8)

Commit your work with a message like `Add Add and Remove buttons`.

### Define the OrderScreen stateful widget

The quantity in `OrderItemDisplay(5, 'Footlong')` is hardcoded, so it can never change. To make it interactive we need a widget that can hold a changing value. That is what a `StatefulWidget` is for.

We will create a new `StatefulWidget` called `OrderScreen`. Add the following two classes to `lib/main.dart`, below the `App` class and above `OrderItemDisplay`:

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

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

You may see a warning that `_quantity` is unused or could be `final`. Ignore it for now.

This looks unusual because we have two classes for one widget, but this is how Flutter separates the immutable configuration from the mutable state. The `OrderScreen` class is the `StatefulWidget` and holds the configuration that does not change, such as `maxQuantity`, and it has a `createState()` method. The `_OrderScreenState` class is the `State` and holds the data that does change (`_quantity`) along with the `build` method. The underscore in `_OrderScreenState` and `_quantity` makes them private to the file.

To understand this structure, select it in your editor and ask Copilot (**Ctrl + I** on Windows or **⌘ + I** on macOS) questions such as what the difference is between a `StatefulWidget` and a `State` object, why the `build` method lives inside the `State` class rather than the `StatefulWidget` class, and what the underscore prefix on `_OrderScreenState` and `_quantity` means in Dart.

### Commit your changes (9)

Commit your work with a message like `Define OrderScreen stateful widget`.

### Build the UI for OrderScreen

Now let's move the UI into `_OrderScreenState`. Replace the `Placeholder()` in its `build` method with the `Scaffold` we built earlier. This should look familiar:

```dart
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => print('Add button pressed!'),
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: () => print('Remove button pressed!'),
                child: const Text('Remove'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
```

Notice that we now pass `_quantity` (which starts at `0`) into `OrderItemDisplay` instead of the hardcoded `5`. The `State` object can read its own variables directly.

### Use OrderScreen inside App

Update the `App` widget to use `OrderScreen` as its `home`. `App` no longer needs its own `Scaffold`, so it becomes very short:

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

`maxQuantity` is a named parameter with a default of `10`, so we could also write `OrderScreen()`. Here we set it to `5`.

Run the app. You should see "0 Footlong sandwich(es):" with no emojis yet, and two buttons that print to the terminal but do not change the display. That is the problem we fix next.

![OrderScreen placeholder: Screenshot of OrderScreen showing zero sandwiches and the two buttons](images/2/placeholder_order_screen_zero.png)

### Commit your changes (10)

Commit your work with a message like `Use OrderScreen in App`.

### Add and remove emojis with setState

The last step is to make the buttons actually change `_quantity`. Add these two methods inside `_OrderScreenState`, above the `build` method and below `_quantity`:

```dart
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
```

There are two things to notice here. The first is `widget.maxQuantity`, which lets the `State` read the `maxQuantity` from its `OrderScreen`. The `State` reaches its widget through the built-in `widget` property (see the [State.widget documentation](https://api.flutter.dev/flutter/widgets/State/widget.html)). The second, and the most important, is `setState()`. You call it to tell Flutter that a value has changed, and Flutter then runs `build()` again and redraws the UI with the new `_quantity`. If you wrote `_quantity++` without wrapping it in `setState()`, the number would change in memory but the screen would not update.

Now connect the buttons to these methods. Replace the two `onPressed` callbacks in your `build` method so they call the new functions instead of printing:

```dart
ElevatedButton(
  onPressed: _increaseQuantity,
  child: const Text('Add'),
),
ElevatedButton(
  onPressed: _decreaseQuantity,
  child: const Text('Remove'),
),
```

Run the app and try it. It starts at "0 Footlong sandwich(es):" with no emojis. Each time you press Add the count goes up and a 🥪 appears, and each time you press Remove the count goes down and a 🥪 disappears, stopping at 0. If you keep pressing Add past 5 nothing happens, because we set `maxQuantity` to 5.

![Interactive counter placeholder: Screenshot of OrderScreen after pressing Add several times, showing emojis](images/2/placeholder_order_screen_interactive.png)

As a small challenge, can you explain why the buttons stop working at 0 and at 5? Trace the `if` conditions in `_increaseQuantity` and `_decreaseQuantity`. In VS Code you can jump to a method by holding **Ctrl** on Windows or **⌘** on macOS and clicking its name.

At this stage, your code should match branch 3 in the [sandwich shop repository](https://github.com/manighahrmani/sandwich_shop/blob/3/lib/main.dart).

### Commit your changes (11)

Commit your final changes with a message like `Add interactivity with setState`.

<!-- TODO: Done till here -->

## **Exercises**

Complete the exercises below and show your work to a member of staff present at your next practical for **a sign-off**.
Your main guide for the rest of the exercises is the [Flutter layout documentation](https://docs.flutter.dev/get-started/fundamentals/layout). Remember to commit your changes after each exercise.

1. The `Flutter Inspector` is a tool for visualising the widget tree and debugging layout issues. Access it from the VS Code Command Palette (**Ctrl + Shift + P** or **⌘ + Shift + P**) by typing `Flutter: Open Flutter DevTools` and selecting the "Widget Inspector" option.

    Familiarise yourself with this tool by watching this [YouTube video on the Widget Inspector](https://www.youtube.com/watch?v=_EYk-E29edo&t=172s) and reviewing its [official documentation](https://docs.flutter.dev/tools/devtools/inspector). Use it to observe the relationship between the widgets in your app.

    ![Flutter DevTools](images/2/screenshot_devtools.jpg)

    **Show your running app and the widget inspector to a member of staff** for a sign-off. We need to make sure you can work your way around the widget inspector.

2. Wrap your `OrderItemDisplay` widget inside a `Container` widget. Use the documentation for the [Container widget](https://api.flutter.dev/flutter/widgets/Container-class.html) to learn how to use it.

    Give the `Container` a fixed `width` and `height` and a `color` (e.g., `Colors.blue`) to make it visible. See what happens when the `OrderItemDisplay`'s text is too big for the `Container`.

    This is what it should look like:

    ![Container](images/2/screenshot_container.jpg)

    Update the `width` and `height` properties to see what happens if the `OrderItemDisplay`'s text is too big for the `Container`.

    **Show your running app with the coloured container to a member of staff** for a sign-off.

3. Read about [layout widgets](https://docs.flutter.dev/get-started/fundamentals/layout#layout-widgets) in the documentation pages.

    Your task is to use a `Column` or a `Row` to display three `OrderItemDisplay` widgets in instead of one in the `Container` where the current `OrderItemDisplay` is. Experiment with the `mainAxisAlignment` and `crossAxisAlignment` properties to align them.

    The image below shows an example of a `Row` with three `OrderItemDisplay` widgets. (Note that we have skipped the previous exercise, your implementation should still have the coloured container from the last exercise.)

    ![Layout](images/2/screenshot_layout.jpg)

    Resize the browser window. What happens if the `Row` is too wide for the screen? Use an LLM or the documentation to learn about layout "Constraints".

    **Show your running app with the three widgets in a row or column to a member of staff** for a sign-off.

4. We've already seen some of the Flutter styling options in the last worksheet. Go back to your `OrderItemDisplay` widget and apply a style to the `Text` widget.

    Inside the `build` method of `OrderItemDisplay`, use the `style` property of the `Text` widget, which accepts a `TextStyle`. Use this to make the text green, bold and larger.

    At any moment, you can hover your mouse over the `TextStyle` class to see what properties it accepts. Once you have found the properties you want to change, write them inside the `TextStyle` constructor (e.g., `TextStyle(property: value)`).

    If you get stuck, try the shortcut **Ctrl + Space** on Windows or **⌘ + Space** on macOS to see suggestions for properties you can use. Below, we have for example found out that `color` is a property of `TextStyle` that accepts an instance of the `Color` class. Try not to use an AI assistant to complete this task.

    ![TextStyle Properties](images/2/screenshot_suggestion.jpg)

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

    Refer to the [official documentation on text and typography](https://docs.flutter.dev/ui/design/text) to learn more about external (Google) fonts.

5. (Advanced) Use a `Column` to display 20 `OrderItemDisplay` widgets this time. You will likely see an overflow error because the content is taller than the screen.

    To fix this, wrap the `Column` in a `SingleChildScrollView` widget, or replace the `Column` with a `ListView` widget. Use the documentation for [SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html) and [ListView](https://api.flutter.dev/flutter/widgets/ListView-class.html) to understand how they work.

    Refer to the [debugging layout](https://docs.flutter.dev/get-started/fundamentals/layout#devtools-and-debugging-layout) documentation if needed.

    ![Overflow](images/2/screenshot_overflow.jpg)

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

6. (Advanced) Read the documentation on creating [adaptive layouts](https://docs.flutter.dev/get-started/fundamentals/layout#adaptive-layouts). Wrap your UI in a `LayoutBuilder`. Inside its `builder` function, check the `constraints.maxWidth`.

    If the width is less than or equal to 600 pixels, display your `OrderItemDisplay` widgets in a `Column`. Otherwise, display them in a `Row`. Observe the changes by resizing your browser window.

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

7. (Advanced) You may have already thought about a way not to create a separate `OrderItemDisplay` class. This could equally be achieved by defining a helper method in the `App` class, like this:

    ```dart
    Widget _buildOrderItemDisplay(int quantity, String itemType) {
      return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}')
    }
    ```

    You would then call this method in the `body` of the `Scaffold` of the `App` widget like this:

    ```dart
    body: const Center(
      child: _buildOrderItemDisplay(5, 'Footlong'),
    ),
    ```

    Watch this [YouTube video](https://youtu.be/IOyq-eTRhvo) to learn more about this approach and why it is not recommended albeit sounding like a simpler solution.

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.
