# Worksheet 2 — Stateless Widgets

In this worksheet, we create a simple Flutter application using Stateless Widgets to create a “Sandwich Counter”.
It covers the basic structure of a Flutter app and the creation of custom widgets.

## Prerequisites

Ensure that you have already completed the following worksheets first:

- Introduction to Git and GitHub.
- Introduction to the Dart language.
- Installation of Flutter SDK.
- Installation of Git and Visual Studio Code.
- Creating and running your first Flutter app.

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

1. **Import the Material Design Library**

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
The library also includes utilities like `ThemeData` to define styling (colors, fonts) across your app.

If your `lib/main.dart` file (from the default counter app) has other imports that are not `package:flutter/material.dart` at this stage, you can leave them for now, but we'll be removing most of the default counter app's code.

2.  **Clean the Default Code**

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
After committing, click the "Sync Changes" button to upload your commit to GitHub.

Alternatively, open the integrated terminal within VS Code (you can use `` Ctrl + `  `` or `` ⌘ + `  `` on macOS) and run the following commands:

```bash
git add lib/main.dart
git commit -m "Initial setup for SandwichShopApp structure"
git push
```

### Creating the Main Application Widget: `SandwichShopApp`

1. **Define the `SandwichShopApp` Widget**

In Flutter, user interfaces are built from **widgets**.
Everything is a widget: a button is a widget, text is a widget, the screen layout is a widget, even the entire application is a widget.
We'll now define the main widget for our application, which we'll call `SandwichShopApp`.

This widget will be a **`StatelessWidget`**.
A `StatelessWidget` is a widget whose state cannot change once it's built.
This means its appearance and behavior are determined by the configuration information provided by its parent widget and stored in its `final` instance variables.
It doesn't have any internal state that changes over its lifetime.
`StatelessWidget`s are good for UI parts that only depend on their initial configuration.

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

Below is a breakdown of the code:

`class SandwichShopApp extends StatelessWidget`: This declares a new class named `SandwichShopApp` that inherits from `StatelessWidget` class which is defined in the Flutter framework.
This means our `SandwichShopApp` will behave like a stateless widget.

`const SandwichShopApp({super.key});`: This is the constructor for our class.
`const`: This signifies that instances of `SandwichShopApp` can be compile-time constants if all their inputs are constants.
This is an optional performance optimization in Flutter (you can remove the keyword `const`).

`{super.key}`: Flutter widgets can have a `Key`.
Keys are used by Flutter's framework to uniquely identify and differentiate widgets, especially when widgets move around in the widget tree or are added/removed.
`super.key` is an optional parameter of the constructor used to pass the optional `key` parameter to the constructor of the parent class (`StatelessWidget`).

`@override`: This keyword indicates that the `build` method is intentionally overriding a method from the `StatelessWidget` base class (all widgets must implement this method and in this case, the superclass has already defined it but we are providing our own implementation).

`Widget build(BuildContext context)`: Flutter calls the `build` method when it needs to render the widget to an element on the screen of the target device.
To do so, Flutter takes a `BuildContext` object as an argument.

**`BuildContext`** describes the widget's location within the tree of widgets that make up the user interface.
You don't need to worry about the details of `BuildContext` for now, but it is essential for accessing inherited widgets and the current state of the widget tree.

The `build` method must return a `Widget` as signified by the return type `Widget`.
For now, we are returning an empty `Container()` as a placeholder.

**`Container`** is essentially a box that can contain other widgets similar to a `div` tag in HTML.
A `Container` can be used for styling (like adding colors, borders, padding) of the widgets placed within it.

2. **Use the `SandwichShopApp` in the `main()` Function**

Next, we need to use our `SandwichShopApp` widget in the `main()` function to make it the root of our application.
Update the `main()` function to look like this:

```dart
void main() {
  runApp(const SandwichShopApp());
}
```

The `runApp()` function takes the given widget (`SandwichShopApp` in our case) and makes it the root of the widget tree, effectively displaying it on the screen.

3. **Commit Your Changes**

As before, let's commit these changes to our Git repository.
Suggested commit message: `Define SandwichShopApp as a StatelessWidget`

Commit your changes through the VS Code Source Control panel or using the terminal:

```bash
git add lib/main.dart
git commit -m "feat: Define SandwichShopApp as a StatelessWidget"
git push
```

At this point, your app would run, but it would just show a blank screen because our `SandwichShopApp` currently returns an empty `Container`.

### **Building the UI inside `SandwichShopApp`**

1. **Redefine the `build` Method**

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

**`MaterialApp`**: This widget, which is returned by the `build` method, is typically the root of a Flutter application that uses Material Design.
It provides a lot of essential app-level functionality, such as theming, navigation, and localization which we will explore in more detail later.

Recall that functions can have named parameters in Dart.
Take for example the `greet` function below:

```dart
void greet({String name = 'Guest'}) {
  print('Hello, $name!');
}
```

To call this function, you need to name the parameter like this:

```dart
greet(name: 'Alice');
```

In our case, `MaterialApp`'s constructor (which is a function) has a ["few"](https://github.com/flutter/flutter/blob/99159bdcfa6e67d508139ba45618125971ea3f4a/packages/flutter/lib/src/material/app.dart#L272) named parameters.
One of them is `home`, which we will use to specify the main screen of our app.
The `home` property of `MaterialApp` (passed as the `home` parameter) is where we define the widget that will be the main screen of our app.
We are providing a `Scaffold` widget in our case to be the main screen.

You can learn more from the [MaterialApp documentation](https://api.flutter.dev/flutter/material/MaterialApp-class.html).

**`Scaffold`**: This widget implements the basic Material Design visual layout structure. Think of it as a blueprint for a typical app screen.
It provides slots for common UI elements such as:

- `appBar`: For displaying an `AppBar`, which is a horizontal bar at the top of the screen.
- `body`: The primary content area of the screen.
- `drawer`: For a slide-out navigation menu.
- `bottomNavigationBar`: For a navigation bar at the bottom.
- `floatingActionButton`: For a prominent action button.

Using `Scaffold` is not necessary but it makes it easy to arrange all these elements correctly according to Material Design guidelines.
More details are in the [Scaffold documentation](https://api.flutter.dev/flutter/material/Scaffold-class.html).

**`AppBar`**: This widget represents the application bar that typically appears at the top of the screen.

- The `title` property of `AppBar` is commonly used to display a `Text` widget showing the current screen's title.
  Here, we use `const Text('Sandwich Counter')`.
  Again, using `const` here is an optimization if the text content doesn't change.
  `AppBar` can also contain action buttons, a leading icon (like a menu button), and more.
  See [AppBar documentation](https://api.flutter.dev/flutter/material/AppBar-class.html) for more details.

**`Center`**: This is a layout widget. Its purpose is simple: it centers its child widget both horizontally and vertically within itself.
The `body` property of our `Scaffold` is where we place the main content of this screen. We're using `Center` to position all the children of `Scaffold` in the middle of the available body space.

`child: const Text('Welcome to the Sandwich Shop!')`: The `child` property of the `Center` widget takes the widget that should be centered.
For now, we're using a simple `Text` widget as a placeholder.
We will replace this with our own custom widget later.

2. **Run the Application**

Now is a good time to run your application to see these changes.
First, ensure you have a device selected (e.g., Chrome from the bottom status bar).
You can also open the Command Palette (`Ctrl + Shift + P` or `⌘ + Shift + P` on macOS) and type "Flutter: Select Device" to choose a device.
Once Web is selected, you can run the app with `F5` or by clicking the "Run" button on top of the `main` function in `lib/main.dart`.

You should see an application with an app bar titled "Sandwich Counter" and the text "Welcome to the Sandwich Shop!" centered in the body of the screen.

3. **Commit Your Changes**

Let's commit this progress.
Suggested commit message: `Implement basic MaterialApp and Scaffold structure for SandwichShopApp`

Alternatively commit via the terminal:

```bash
git add lib/main.dart
git commit -m "Implement basic MaterialApp and Scaffold structure for SandwichShopApp"
git push
```

Okay, I understand. I will focus on guiding the students to build the `SandwichCounter` widget and integrate it, strictly adhering to the style and level of detail you've established, and avoiding any discussion of styling features like margins or themes that are not part of the core task leading to the specified final code.

### Creating the Custom `SandwichCounter` Widget

1.  **Introduce the `SandwichCounter` Widget**

Currently, our `SandwichShopApp` only uses generic widgets and displays a generic welcome message
To make it a real "Sandwich Counter," we need a way to show specific sandwich information, like its type and how many there are.
We'll achieve this by creating a new, custom widget called `SandwichCounter`.

In Flutter, you're not limited to using only the widgets provided by the framework.
You can, and often will, create your own widgets by combining existing ones or by defining entirely new behavior.
Instead of writing the same combination of widgets multiple times, you can define it once as a custom widget and then reuse that new widget wherever you need that specific piece of UI.

Our `SandwichCounter` widget will be responsible for displaying a single line of text that describes the count and type of a sandwich, complete with a visual representation using emojis.

2.  **Defining the `SandwichCounter` Widget**

Similar to how we defined `SandwichShopApp`, our `SandwichCounter` will also be a `StatelessWidget`.
This is appropriate because the information it displays (the type and count of sandwiches) will be given to it when it's created and won't change internally within the `SandwichCounter` widget itself.

We'll add the class definition for `SandwichCounter` in our `lib/main.dart` file.
It's a common convention to define widgets before they are used by other widgets in the same file, or to place them in separate files for better organization (though for this small example, one file is fine).
Let's place the `SandwichCounter` class definition above the `SandwichShopApp` class, but below the initial `import` statement.

Add the following code for the `SandwichCounter` class:

```dart
// Our custom StatelessWidget to display the sandwich count
class SandwichCounter extends StatelessWidget {
    // These 'final' fields will hold the data passed to this widget when it's created.
    // 'final' means their values are set once and cannot be changed afterwards.
    final String sandwichType;
    final int count;

    // This is the constructor for the SandwichCounter widget.
    // It takes 'count' and 'sandwichType' as parameters and an optional 'key'.
    const SandwichCounter(this.count, this.sandwichType, {super.key});

    @override
    Widget build(BuildContext context) {
    // This method describes how the widget should look.
    // For now, we'll return a placeholder Text widget.
    return Text('This is a placeholder for SandwichCounter');
    }
}
```

Let's review this new class:

`class SandwichCounter extends StatelessWidget`: This line declares our new widget class named `SandwichCounter`, indicating it is a type of `StatelessWidget`.

`final String sandwichType;` and `final int count;`: These lines declare two instance variables.
They are marked `final` because, in a `StatelessWidget`, the data a widget displays is provided when the widget is created and does not change throughout that widget's lifetime.
`sandwichType` will store the name of the sandwich (like "Footlong"), and `count` will store how many there are.

`const SandwichCounter(this.count, this.sandwichType, {super.key});`: This is the constructor.
When we create an instance of `SandwichCounter`, we'll need to provide values for `count` (an integer) and `sandwichType` (a string).

Recall that in Dart constructors can be either written like this:

```dart
class Dog {
  final String name;
  final int age;

  Dog(String inputName, int inputAge) {
    name = inputName;
    age = inputAge;
  }
}
```

Or more concisely using the constructor shorthand:

```dart
class Dog {
  final String name;
  final int age;

  Dog(this.name, this.age);
}
```

In our case, `this.count` and `this.sandwichType` automatically assigns the first two positional arguments passed to the constructor to the instance variables of the same names.

The `{super.key}` part handles the optional `key` parameter, just as in `SandwichShopApp` (again, this is not strictly necessary for our example but is a good practice).
The `const` keyword, another optional part, indicates that this constructor can be used to create compile-time constants.

`@override Widget build(BuildContext context)`: This is the essential `build` method that describes the widget's appearance. Currently, it's returning a simple `Text` widget as a placeholder. We'll update this shortly to display the actual sandwich data.

3.  **Commit Your Changes**

Go ahead and commit your changes to the `lib/main.dart` file.
We suggest a commit message like `Define SandwichCounter custom widget`.
Below are the commands to commit your changes in the terminal:

```bash
git add lib/main.dart
git commit -m "Define SandwichCounter custom widget"
git push
```

Running the app at this stage won't show any visual changes yet, as we haven't actually used the `SandwichCounter` widget in our `SandwichShopApp`.

4.  **Implementing the `build` Method of `SandwichCounter`**

Now, let's modify the `build` method of `SandwichCounter` so it displays the sandwich type, count, and some emojis. We want the output to look something like: "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪".

Update the `build` method inside your `SandwichCounter` class as follows:

```dart
@override
Widget build(BuildContext context) {
    // The Text widget is used to display a piece of string.
    // We use Dart's string interpolation to build the display string dynamically.
    // '$variableName' inserts the value of a variable.
    // '${expression}' inserts the result of an expression.
    return Text('$count $sandwichType sandwich(es): ${'🥪' * count}');
}
```

The core of this is the string passed to the `Text` widget: `'$count $sandwichType sandwich(es): ${'🥪' * count}'`.
Hopefully you remember this from the Dart worksheet on Strings but here is a quick example that illustrates how string interpolation works in Dart:

```dart
void main() {
  String name = 'Aisha';
  int currentAge = 25;

  print('My name is $name and I will be ${currentAge + 1} next year.');
  // Output: My name is Aisha and I will be 26 next year.
}
```

In Dart, you can multiply a string by an integer to repeat that string. For example, `'Hi' * 3` evaluates to the string `'HiHiHi'`.
So, `'🥪' * count` will take the sandwich emoji string `🥪` and repeat it `count` times. If `count` is `5`, this expression becomes `'🥪🥪🥪🥪🥪'`.

5.  **Commit Your Changes**

With the `build` method of `SandwichCounter` now correctly implemented to display the dynamic text, let's commit this update.
Suggested commit message: `Implement dynamic text display in SandwichCounter`

```bash
git add lib/main.dart
git commit -m "Implement dynamic text display in SandwichCounter"
git push
```

### Using the `SandwichCounter` Widget in `SandwichShopApp`

1.  **Replacing the Placeholder in `SandwichShopApp`**

Now that our `SandwichCounter` widget is complete and knows how to display sandwich data, we need to use it within our main application screen, `SandwichShopApp`.
We will replace the placeholder `Text('Welcome to the Sandwich Shop!')` with an instance of our new `SandwichCounter`.

Find the `build` method of the `SandwichShopApp` class.
Locate the `Center` widget within the `Scaffold`'s `body`.
We need to change its `child` property.
This is what your `SandwichShopApp`'s `build` method should look like now:

```dart
@override
Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
        appBar: AppBar(title: const Text('Sandwich Counter')),
        // Update the body to use our SandwichCounter widget
        body: const Center(
        // Create an instance of SandwichCounter, providing the count and type.
        child: SandwichCounter(5, 'Footlong'),
        ),
    ),
    );
}
```

In the line `child: const SandwichCounter(5, 'Footlong')`, we are creating an instance of our `SandwichCounter`.

2.  **Run the Application**

This is the moment to see your custom widget fully integrated and working. Run your Flutter application from VS Code (using `F5` or the "Run" option above `main`).

You should now see the application displaying an app bar with "Sandwich Counter" as the title. In the center of the screen, the text "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪" should be displayed, rendered by your `SandwichCounter` widget.

3.  **Commit Your Changes**

Let's do a final commit before moving to the exercises.
Suggested commit message: `Integrate SandwichCounter into SandwichShopApp`

```bash
git add lib/main.dart
git commit -m "Integrate SandwichCounter into SandwichShopApp"
git push
```

At this stage, your code should look like our code as shown on [the GitHub repository](https://github.com/manighahrmani/sandwich_shop/blob/2/lib/main.dart).
You've learned how to define `StatelessWidget`s, pass data to them via constructors, and compose them to build a user interface.
The exercises will guide you to explore layouts, aligning widgets, sizing, scrolling widgets and adaptive layouts.
