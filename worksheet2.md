# Worksheet 2 — Stateless Widgets

In this worksheet, we create a simple Flutter application using Stateless Widgets to create a “Sandwich Counter”.
It covers the basic structure of a Flutter app and the creation of custom widgets.

## Prerequisites

Ensure that you have already completed the following worksheets first:

  * Introduction to Git and GitHub.
  * Introduction to the Dart language.
  * Installation of Flutter SDK.
  * Installation of Git and Visual Studio Code.
  * Creating and running your first Flutter app.

## Developing the Sandwich Counter Application

We will incrementally build the "Sandwich Counter" application.
The goal for this first part is to set up the main application structure.

### Project Setup and Initial Modifications

First, open the Flutter folder containing the project you created in Worksheet 1 in Visual Studio Code.
This project should already be a repository in your GitHub account.

We will modify the `lib/main.dart` file. This file is the entry point for your Flutter application.

Open `lib/main.dart`. At the top of the file, you'll usually find an `import` statement.
We need to ensure we have the correct one for Material Design components:

```dart
import 'package:flutter/material.dart';
```

1. **Understanding the Import Statement**

This line imports the `material.dart` library from the Flutter framework.
**Material Design** is a comprehensive design system created by Google that provides guidelines for visual, motion, and interaction design to create user experiences.
The `package:flutter/material.dart` library gives you access to a collection of pre-built UI components, called **widgets**, that implement these Material Design guidelines.

These widgets include fundamental building blocks for your app's UI, such as:
- Structural elements like `Scaffold` (for basic page layout), `AppBar` (for the top application bar), and `Drawer` (for navigation menus).
- **Buttons** like `ElevatedButton`, `TextButton`, and `IconButton`.
- **Informational widgets** like `Text` (for displaying strings), `Icon` (for displaying icons), and `Image`.
- **Input widgets** like `TextField` (for text entry) and `Checkbox` (for boolean input).
- **Layout widgets** like `Row`, `Column`, `Stack`, and `Card` that help you arrange other widgets.

By using these Material widgets, you can quickly build a user interface that looks and feels professional and consistent with platform conventions.
The library also includes utilities like `ThemeData` to define consistent styling (colors, fonts) across your app.

If your `lib/main.dart` file (from the default counter app) has other imports that are not `package:flutter/material.dart` at this stage, you can leave them for now, but we'll be removing most of the default counter app's code.

2.  **Cleaning the `main()` function**

Locate the `main()` function in `lib/main.dart`.
This is where your app starts.
The default app has `runApp(const MyApp());`.
Comment out or remove this line for now.
You can comment a line in VS Code by selecting it with your mouse and pressing `Ctrl + /` on Windows or `⌘ + /` on macOS.

Let's also clear out the default `MyApp` class and other related classes from the app.
Delete everything aside from the import statement and the `main()` function.
Your `lib/main.dart` file should now look like this:

```dart
import 'package:flutter/material.dart';

void main() {
    // We will add our app here shortly
}
```

3.  **Commit Your Changes**

Now is a good time to make your first commit for this stage.
In VS Code, go to the Source Control panel (usually an icon on the left sidebar that looks like a branching path).
You can also use the Command Palette (`Ctrl + Shift + P` or `⌘ + Shift + P` on macOS) and enter "Source Control" which will open the Source Control panel. 

You should see `main.dart` listed under changes.
In the "Message" box at the top of the Source Control panel (above the Commit button), type a descriptive commit message.
We suggest a message like `Initial setup for SandwichShopApp structure`.

Click Commit button to commit the changes.
After committing, click the "Synchronize Changes" button (often a cloud icon with arrows, or you might need to click the ellipsis (...) and choose "Push") to upload your commit to GitHub.

    Alternatively, using the terminal:

    ```bash
    git add lib/main.dart
    git commit -m "feat: Initial setup for SandwichShopApp structure"
    git push
    ```

### **Creating the Main Application Widget: `SandwichShopApp`**

In Flutter, user interfaces are built from **widgets**. Everything is a widget: a button is a widget, text is a widget, the screen layout is a widget, even the entire application is a widget. We'll now define the main widget for our application, which we'll call `SandwichShopApp`.

This widget will be a `StatelessWidget`. A `StatelessWidget` is a widget whose state cannot change once it's built. This means its appearance and behavior are determined by the configuration information provided by its parent widget and stored in its `final` instance variables. It doesn't have any internal state that changes over its lifetime. It's good for UI parts that only depend on their initial configuration and the `BuildContext`.

Add the following class definition to your `lib/main.dart` file, below the `import` statement and before the `main()` function:

```dart
// Root widget of our application
class SandwichShopApp extends StatelessWidget {
  // Constructor
  const SandwichShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We will build the UI here in the next step
    return Container(); // Placeholder: We'll replace this soon
  }
}
```

Let's break this down:

  * `class SandwichShopApp extends StatelessWidget`: This declares a new class named `SandwichShopApp` that inherits from `StatelessWidget`. This means our `SandwichShopApp` will behave like a stateless widget.
  * `const SandwichShopApp({super.key});`: This is the constructor for our class.
      * `const`: This signifies that instances of `SandwichShopApp` can be compile-time constants if all their inputs are constants. This is a performance optimization in Flutter.
      * `{super.key}`: Flutter widgets can have a `Key`. Keys are used by Flutter's framework to uniquely identify and differentiate widgets, especially when widgets move around in the widget tree or are added/removed. `super.key` passes the optional `key` parameter to the constructor of the parent class (`StatelessWidget`).
  * `@override`: This keyword indicates that the `build` method is intentionally overriding a method from the `StatelessWidget` base class.
  * `Widget build(BuildContext context)`: This is the most important method in any widget. Flutter calls the `build` method when it needs to render the widget on the screen (or when the widget needs to be rebuilt).
      * It takes a `BuildContext` object as an argument. The `BuildContext` describes the widget's location within the tree of widgets that make up the user interface.
      * It must return a `Widget` (or a tree of widgets). This returned widget describes this part of the user interface.
      * For now, we are returning an empty `Container()` as a placeholder. `Container` is a versatile widget that can be used for styling (like adding colors, borders, padding) or just as a placeholder.

Now, update the `main()` function to use `SandwichShopApp`:

```dart
void main() {
  runApp(const SandwichShopApp());
}
```

The `runApp()` function takes the given widget (`SandwichShopApp` in our case) and makes it the root of the widget tree, effectively displaying it on the screen.

**Commit Your Changes**

It's a good practice to commit after defining a new component.

Suggested commit message: `feat: Define SandwichShopApp basic structure`

Commit your changes through the VS Code Source Control panel or using the terminal:

```bash
git add lib/main.dart
git commit -m "feat: Define SandwichShopApp basic structure"
git push
```

At this point, your app would run, but it would just show a blank screen because our `SandwichShopApp` currently returns an empty `Container`.

### **Building the UI inside `SandwichShopApp`**

Now, let's flesh out the `build` method of `SandwichShopApp` to create a basic page structure using Material Design widgets.

Modify the `build` method within the `SandwichShopApp` class as follows:

```dart
  @override
  Widget build(BuildContext context) {
    // MaterialApp is a convenience widget that wraps a number of widgets
    // that are commonly required for Material Design applications
    return MaterialApp(
      // The Scaffold widget implements the basic material design visual layout structure
      home: Scaffold(
        // AppBar is the top application bar
        appBar: AppBar(
          title: const Text('Sandwich Counter'),
        ),
        // Center widget centers its child within itself
        body: const Center(
          // We will place our custom SandwichCounter widget here later
          child: Text('Welcome to the Sandwich Shop!'), // Placeholder
        ),
      ),
    );
  }
```

Let's understand these new widgets:

  * **`MaterialApp`**: This widget is typically the root of a Flutter application that uses Material Design. It provides a lot of essential app-level functionality, such as:

      * **Theming**: It allows you to define a global theme (`ThemeData`) for colors, fonts, and more, ensuring a consistent look and feel.
      * **Navigation and Routing**: It sets up the navigator that manages your app's screens (called routes).
      * **Localization**: It helps with supporting multiple languages.
      * The `home` property of `MaterialApp` takes the widget that will be displayed when the app first starts. We are providing a `Scaffold` widget here.
      * You can learn more from the [MaterialApp documentation](https://api.flutter.dev/flutter/material/MaterialApp-class.html).

  * **`Scaffold`**: This widget implements the basic Material Design visual layout structure. Think of it as a blueprint for a typical app screen. It provides slots for common UI elements:

      * `appBar`: For displaying an `AppBar` at the top of the screen.
      * `body`: The primary content area of the screen.
      * `drawer`: For a slide-out navigation menu.
      * `bottomNavigationBar`: For a navigation bar at the bottom.
      * `floatingActionButton`: For a prominent action button.
      * Using `Scaffold` makes it easy to arrange these elements correctly according to Material Design guidelines. More details are in the [Scaffold documentation](https://api.flutter.dev/flutter/material/Scaffold-class.html).

  * **`AppBar`**: This widget represents the application bar that typically appears at the top of the screen.

      * The `title` property is commonly used to display a `Text` widget showing the current screen's title. Here, we use `const Text('Sandwich Counter')`. Using `const` here is an optimization if the text content doesn't change.
      * `AppBar` can also contain action buttons, a leading icon (like a menu button), and more. See [AppBar documentation](https://api.flutter.dev/flutter/material/AppBar-class.html).

  * **`Center`**: This is a layout widget. Its purpose is simple: it centers its child widget both horizontally and vertically within itself.

      * The `body` property of our `Scaffold` is where we place the main content of this screen. We're using `Center` to position its child in the middle of the available body space.

  * **`child: const Text('Welcome to the Sandwich Shop!')`**: The `child` property of the `Center` widget takes the widget that should be centered. For now, we're using a simple `Text` widget as a placeholder. We will replace this with our custom `SandwichCounter` widget later in this worksheet.

**Run Your App**
Now is a good time to run your application to see these changes.
In VS Code:

1.  Ensure you have a device selected (e.g., Chrome (web-javascript) from the bottom status bar).
2.  Press `F5` or go to "Run" \> "Start Debugging".

You should see an application with an app bar titled "Sandwich Counter" and the text "Welcome to the Sandwich Shop\!" centered in the body of the screen.

**Commit Your Changes**

Let's commit this progress.
Suggested commit message: `feat: Implement basic MaterialApp and Scaffold structure for SandwichShopApp`

Commit via VS Code or terminal:

```bash
git add lib/main.dart
git commit -m "feat: Implement basic MaterialApp and Scaffold structure for SandwichShopApp"
git push
```

-----

This covers the first part of the application setup, focusing on the main app shell. The next steps would involve creating the `SandwichCounter` widget itself, which you can detail in a similar fashion.