# Worksheet 2 — Stateless Widgets

## What You Need To Know Beforehand

Ensure that you have already completed the following:

  - [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
  - [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).

## Getting Help

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## Set Up the Project

We will start to incrementally build the "Sandwich Counter" application.

Open the Flutter folder containing the project you created in Worksheet 1 in Visual Studio Code. This project should already be a repository in your GitHub account.

#### Import the Material Design Library

Open `lib/main.dart` and ensure that you have the correct `import` statement for Material Design components:

```dart
import 'package:flutter/material.dart';
```

`Material Design` is a design system from Google. The `package:flutter/material.dart` library gives you access to its pre-built UI components, called `widgets`. We will use these widgets to build our user interface.

Use Copilot to explore this library further. For example, you can ask it: "What kind of widgets are available in the material.dart library? List a few examples and explain them briefly."

For completeness, below are some general categories of fundamental building blocks in Flutter:

- Structural elements like `Scaffold` (for page layout), `AppBar` (for the top application bar), and `Drawer` (for navigation menus).
- Buttons like `ElevatedButton`, `TextButton`, and `IconButton`.
- Informational widgets like `Text`, `Image`, and `Icon` (for displaying icons).
- Input widgets like `TextField` (for text entry) and `Checkbox` (for boolean input).
- Layout widgets like `Row`, `Column`, `Stack`, and `Card` that help you arrange other widgets.

#### Clean the Default Code

Locate the `main()` function in `lib/main.dart`, which is the entry point of your app. Let's clear out the default `MyApp` class and other related classes from the app.

Comment out or remove this line for now. You can comment a line in VS Code by selecting it with your mouse and pressing **Ctrl + /** on Windows or **⌘ + /** on macOS.
The (uncommented) code in your `lib/main.dart` file should now look like this:

```dart
import 'package:flutter/material.dart';

void main() {}
```

#### Commit Your Changes

Now is a good time to commit your changes. In VS Code, go to the Source Control panel. You can open this from `View \> Source Control`. Alternatively, you can use the Command Palette (**Ctrl + Shift + P** or **⌘ + Shift + P** on macOS) and enter `Source Control`, which will open the Source Control panel.
You should see `main.dart` listed under changes. Type a descriptive commit message, such as `Set Up the Project`, and click the `Commit` button, followed by `Sync Changes`.

Alternatively, open the terminal (**Ctrl + \`** or **⌘ + \`**) and run these commands:

```bash
git add lib/main.dart
git commit -m "Set Up the Project"
git push
```

## Define the Main App Widget: `App`

We will now define the main widget for our application.

#### Define the `App` Widget

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

This `App` class is a `StatelessWidget`, meaning its state and properties can't change once it's built. All widgets must have a `build` method, which describes the widget's part of the user interface.

For now, it returns an empty `Container`, which is like a blank `div` in HTML. To understand this code better, select the entire class and ask Copilot (**Ctrl + I** or **⌘ + I**): "Explain what this `StatelessWidget` does, line by line. What is build and why do we need it? What does the override do? What about the super.key?"

#### Use the `App` Widget

Next, update the `main()` function to run our new `App` widget:

```dart
void main() {
  runApp(const App());
}
```

The `runApp()` function takes our `App` widget and makes it the root of the widget tree, displaying it on the screen. If you run the app now, you will just see a blank screen.

#### Commit Your Changes

Commit your work with a meaningful message, such as `Define the Main App Widget: App`.

## Define the UI inside `App`

Let's give our `App` widget some structure and content.

#### Redefine the `build` Method

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

Here, we've created a `widget tree`. `MaterialApp` is the root (parent), providing core app functionality. `Scaffold` provides the basic screen layout, including an `AppBar` (the top bar) and a `body`. The body contains a `Center` widget, which in turn holds our `Text` widget.

As before, for a deeper understanding of this structure, use Copilot to explain each widget's role.

#### Run the Application

Make sure you have a device selected (e.g., Chrome or Edge from the bottom status bar). You can also open the Command Palette (`Ctrl + Shift + P` or `⌘ + Shift + P` on macOS) and type "Flutter: Select Device" to choose a device.

With a device selected run the app by pressing F5. You should see an application with an app bar titled "Sandwich Counter" and "Welcome to the Sandwich Shop\!" centred on the screen.

![Welcome to the Sandwich Shop](images/screenshot_welcome_to_sandwich_shop.jpg)

#### Commit Your Changes

Commit your work with a message like `Define the UI inside App`.

## Create the Custom `OrderItemDisplay` Widget

You can create your own reusable widgets by combining existing ones. We will create a custom widget to display a single sandwich order.

#### Define the `OrderItemDisplay` Widget

Add the definition for `OrderItemDisplay` in `lib/main.dart`, placing it below the `App` class:

```dart
class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('This is a placeholder for OrderItemDisplay');
  }
}
```

This `StatelessWidget` has two `final` instance variables, `itemType` and `quantity`, which are set by its constructor. `final` means they cannot be changed after the widget is created.

Running the app at this stage won't show any visual changes yet, as we haven't actually used the `OrderItemDisplay` widget in our `App`.

#### Commit Your Changes

Commit your new widget with the message `Define OrderItemDisplay custom widget`.

#### Implement the `build` Method of `OrderItemDisplay`

Now, let's update the `build` method of `OrderItemDisplay` to show the sandwich type and quantity with emojis. We want it to display something like: "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪".

Update the `build` method inside your `OrderItemDisplay` so it looks like this:

```dart
@override
Widget build(BuildContext context) {
  return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
}
```

#### Commit Your Changes

Commit this update with a message like `Implement dynamic text in OrderItemDisplay`.

## Use `OrderItemDisplay` in `App`

Now we can use our new custom widget inside the main `App`.

#### Replace the Placeholder in `App`

Find the `build` method of the `App` class and locate the `Center` widget within the `Scaffold`'s `body`. Then replace the placeholder `Text` widget in the `body` of the `Scaffold` with an instance of our new `OrderItemDisplay` widget as shown below:

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

#### Run the Application

Run the app. You should now see "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪" displayed in the centre of the screen.


![Sandwich Counter](images/screenshot_sandwich_counter.jpg)

#### Commit Your Changes

Commit your final changes for this section with the message `Use OrderItemDisplay in App`.

At this stage, your code should look like our code as shown on [the GitHub repository](https://github.com/manighahrmani/sandwich_shop/blob/2/lib/main.dart).

## Exercises

Complete the exercises below and show your work to a member of staff present at your next practical for **a sign-off**.
Your main guide for the rest of the exercises is the [Flutter layout documentation](https://docs.flutter.dev/get-started/fundamentals/layout). Remember to commit your changes after each exercise.

1.  The `Flutter Inspector` is a tool for visualising the widget tree and debugging layout issues. Access it from the VS Code Command Palette (**Ctrl + Shift + P** or **⌘ + Shift + P**) by typing `Flutter: Open Flutter DevTools` and selecting the "Widget Inspector" option.

    Familiarise yourself with this tool by watching this [YouTube video on the Widget Inspector](https://www.youtube.com/watch?v=_EYk-E29edo&t=172s) and reviewing its [official documentation](https://docs.flutter.dev/tools/devtools/inspector). Use it to observe the relationship between the widgets in your app.

    ![Flutter DevTools](images/screenshot_devtools.jpg)

    ⚠️ **Show your running app and the widget inspector to a member of staff** for a sign-off. We need to make sure you can work your way around the widget inspector.

2.  Wrap your `OrderItemDisplay` widget inside a `Container` widget. Use the documentation for the [Container widget](https://api.flutter.dev/flutter/widgets/Container-class.html) to learn how to use it.

    Give the `Container` a fixed `width` and `height` and a `color` (e.g., `Colors.blue`) to make it visible. See what happens when the `OrderItemDisplay`'s text is too big for the `Container`.

    This is what it should look like:
    
    ![Container](images/screenshot_container.jpg)

    Update the `width` and `height` properties to see what happens if the `OrderItemDisplay`'s text is too big for the `Container`.

    ⚠️ **Show your running app with the coloured container to a member of staff** for a sign-off.

3.  Read about [layout widgets](https://docs.flutter.dev/get-started/fundamentals/layout#layout-widgets) in the documentation. Use a `Column` or a `Row` to display three `OrderItemDisplay` widgets in the `App`'s `body`. Experiment with the `mainAxisAlignment` and `crossAxisAlignment` properties to align them.

    ![Layout](images/screenshot_layout.jpg)

    Resize the browser window. What happens if the `Row` is too wide for the screen? Use an LLM or the documentation to learn about layout "Constraints".

    ⚠️ **Show your running app with the three widgets in a row or column to a member of staff** for a sign-off.

4.  Flutter offers rich options for styling text. Go back to your `OrderItemDisplay` widget and apply a style to the `Text` widget.

    Inside the `build` method of `OrderItemDisplay`, use the `style` property of the `Text` widget, which accepts a `TextStyle`. Use this to make the text green, bold and larger.

    At any moment, you can hover your mouse over the `TextStyle` class to see what properties it accepts. Once you have found the properties you want to change, write them inside the `TextStyle` constructor (e.g., `TextStyle(property: value)`).
    
    If you get stuck, try the shortcut **Ctrl + Space** on Windows or **⌘ + Space** on macOS to see suggestions for properties you can use. Below, we have for example found out that color is a property of `TextStyle` that accepts an instance of `Color` class:

    ![TextStyle Properties](images/screenshot_suggestion.jpg)

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

    Refer to the [official documentation on text and typography](https://docs.flutter.dev/ui/design/text) to learn more about external (Google) fonts.

5.  (Advanced) Use a `Column` to display 20 `OrderItemDisplay` widgets this time. You will likely see an overflow error because the content is taller than the screen. Refer to the [debugging layout](https://docs.flutter.dev/get-started/fundamentals/layout#devtools-and-debugging-layout) documentation if needed.

    To fix this, wrap the `Column` in a `SingleChildScrollView` widget, or replace the `Column` with a `ListView` widget. Use the documentation for [SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html) and [ListView](https://api.flutter.dev/flutter/widgets/ListView-class.html) to understand how they work.

    ![Overflow](images/screenshot_overflow.jpg)

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

6.  (Advanced) Read the documentation on creating [adaptive layouts](https://docs.flutter.dev/get-started/fundamentals/layout#adaptive-layouts). Wrap your UI in a `LayoutBuilder`. Inside its `builder` function, check the `constraints.maxWidth`.

    If the width is less than or equal to 600 pixels, display your `OrderItemDisplay` widgets in a `Column`. Otherwise, display them in a `Row`. Observe the changes by resizing your browser window.
    
    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

