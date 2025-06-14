# Worksheet 2 — Stateless Widgets

## Prerequisites

Ensure that you have already completed the following:

- Installation of Git and Visual Studio Code
- Installation of Flutter SDK
- Introduction to the Dart language
- Introduction to Git and GitHub
- Introduction to Flutter

## Developing the Sandwich Counter Application

We will incrementally build the "Sandwich Counter" application.

### Setup the Project

Open the Flutter folder containing the project you created in Worksheet 1 - "Introduction to Flutter" - in Visual Studio Code.
This project should already be a repository in your GitHub account.

1.  **Import the Material Design Library**

    Open `lib/main.dart`.
    We need to ensure that we have the correct `import` statement for Material Design components:

    ```dart
    import 'package:flutter/material.dart';
    ```

    **Material Design** is a design system created by Google that provides guidelines for user experience.
    The `package:flutter/material.dart` library gives you access to a collection of pre-built UI components, called **widgets**, that implement these Material Design guidelines.
    We will first use these widgets to build the user interface of our app and later, we will learn how to create our own custom widgets.

    These widgets include fundamental building blocks, such as:

    - **Structural elements** like `Scaffold` (for page layout), `AppBar` (for the top application bar), and `Drawer` (for navigation menus).
    - **Buttons** like `ElevatedButton`, `TextButton`, and `IconButton`.
    - **Informational widgets** like `Text`, `Image` and `Icon` (for displaying icons).
    - **Input widgets** like `TextField` (for text entry) and `Checkbox` (for boolean input).
    - **Layout widgets** like `Row`, `Column`, `Stack`, and `Card` that help you arrange other widgets.

    The library also includes utilities like `ThemeData` to define styling (colours, fonts) across your app.

2.  **Clean the Default Code**

    Locate the `main()` function in `lib/main.dart`.
    This is where your app starts.
    The default app has `runApp(const MyApp());`.
    Comment out or remove this line for now.
    You can comment a line in VS Code by selecting it with your mouse and pressing **Ctrl + /** on Windows or **⌘ + /** on macOS.

    Let's also clear out the default `MyApp` class and other related classes from the app.
    Delete everything aside from the import statement and the `main()` function.
    Your `lib/main.dart` file should now look like this:

    ```dart
    import 'package:flutter/material.dart';

    void main() {}
    ```

3.  **Commit Your Changes**

    It is a good time to commit your changes.
    In VS Code, go to the Source Control panel from **View > Source Control**.
    You can also use the Command Palette **Ctrl + Shift + P** or **⌘ + Shift + P** on macOS and enter "Source Control" which will open the Source Control panel.

    You should see `main.dart` listed under changes.
    In the "Message" box, above the "Commit" button, type a descriptive commit message, something like `Setup the Project`.

    Click the Commit button to commit the changes.
    After committing, click the "Sync Changes" button to upload your commit to GitHub.

    Note that you could also do all of this using integrated terminal within VS Code.
    You can open the terminal with **Ctrl + \`** on Windows or **⌘ + \`** on macOS and run the following commands:

    ```bash
    git add lib/main.dart
    git commit -m "Setup the Project"
    git push
    ```

### Define the Main App Widget: `SandwichShopApp`

1.  **Define the `SandwichShopApp` Widget**

    Add the following class definition to `lib/main.dart`, below the `import` statement and before the `main()` function:

    ```dart
    class SandwichShopApp extends StatelessWidget {
      const SandwichShopApp({super.key});

      @override
      Widget build(BuildContext context) {
        return Container();
      }
    }
    ```

    Key points:

    - `SandwichShopApp` is the main widget of our app
      - `StatelessWidget` is a widget that does not not change in appearance and behaviour after being built
      - `SandwichShopApp` extends (is a subclass of) `StatelessWidget`
    - `const SandwichShopApp({super.key});` is the constructor for `SandwichShopApp`
      - `const` is optional (for performance)
      - `super.key` is used to pass an optional `key` (a unique identifier for the widget)
    - `Widget build(BuildContext context)` is the `build()` method of `SandwichShopApp`
      - Flutter calls `build` which returns a `Widget` used to render the UI
      - `BuildContext context` is the context (e.g., the location) of the widget, it is needed to build the UI
      - `@override` shows that we are reimplementing the `build` method of `StatelessWidget`, all widgets must do this
      - For now, `build` returns a placeholder (`Container` is like a `div` in HTML)

2.  **Use the `SandwichShopApp` Widget**

    Next, update the `main()` function to look like this:

    ```dart
    void main() {
      runApp(const SandwichShopApp());
    }
    ```

    The `runApp()` function takes the given widget (`SandwichShopApp` in our case) and makes it the root of the widget tree, effectively displaying it on the screen.

    If you run your app now, it would show a blank screen because our `SandwichShopApp` returns an empty `Container`.

3.  **Commit Your Changes**

    Commit your changes.
    Our suggested commit message: `Define the Main App Widget: SandwichShopApp`

    The commands to do this in the terminal:

    ```bash
    git add lib/main.dart
    git commit -m "Define the Main App Widget: SandwichShopApp"
    git push
    ```

### Define the UI inside `SandwichShopApp`

1.  **Redefine the `build` Method**

    Modify the `build` method within the `SandwichShopApp` class as follows:

    ```dart
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
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
    ```

    Key points:

    - **`MaterialApp`** is the root widget that provides theming, navigation, and Material Design
      - Uses named parameters like `home:` to specify the main screen
      - For more details, see the [MaterialApp documentation](https://api.flutter.dev/flutter/material/MaterialApp-class.html)
    - **`Scaffold`** is the blueprint for a typical app screen layout
      - Provides slots for `appBar`, `body`, `drawer`, `bottomNavigationBar`, `floatingActionButton`, etc.
      - For more details, see the [Scaffold documentation](https://api.flutter.dev/flutter/material/Scaffold-class.html)
    - **`AppBar`** is the top bar of the screen
      - `title:` property shows the screen title
      - For more details, see the [AppBar documentation](https://api.flutter.dev/flutter/material/AppBar-class.html)
    - **`Center`** is a layout widget that centers
      - It centres our placeholder `Text` widget both horizontally and vertically

2.  **Run the Application**

    Make sure you have a device selected (e.g., Chrome from the bottom status bar).
    You can also open the Command Palette (`Ctrl + Shift + P` or `⌘ + Shift + P` on macOS) and type "Flutter: Select Device" to choose a device.

    Once a web device is selected, run the app with `F5` or by clicking the "Run" button on top of the `main` function in `lib/main.dart`.

    You should see an application with an app bar titled "Sandwich Counter" and the text "Welcome to the Sandwich Shop\!" centred in the body of the screen.

3.  **Commit Your Changes**

    Suggested commit message: `Define the UI inside SandwichShopApp`

    Terminal commands:

    ```bash
    git add lib/main.dart
    git commit -m "Define the UI inside SandwichShopApp"
    git push
    ```

### Create the Custom `SandwichCounter` Widget

1.  **Why Do We Need Custom Widgets?**

    In Flutter, you're not limited to using only the widgets provided by the framework.
    You can create your own widgets by combining existing ones or by defining new behaviour.
    Once a custom widget is defined, you can reuse it.

    Our `SandwichCounter` widget will be responsible for displaying a single line of text that describes the count and type of a sandwich, complete with a visual representation using emojis.

2.  **Defining the `SandwichCounter` Widget**

    We'll add the definition for `SandwichCounter` in `lib/main.dart` file although you can place it in a separate file for better organisation.
    Place the `SandwichCounter` class above the `SandwichShopApp` class, but below the initial `import` statement:

    ```dart
    class SandwichCounter extends StatelessWidget {
        final String sandwichType;
        final int count;

        const SandwichCounter(this.count, this.sandwichType, {super.key});

        @override
        Widget build(BuildContext context) {
            return Text('This is a placeholder for SandwichCounter');
        }
    }
    ```

    Key points:

    - `SandwichCounter` is our custom widget that extends `StatelessWidget`
    - `final String sandwichType` and `final int count` are instance variables
      - Marked `final` because data doesn't change in a `StatelessWidget` in run-time
    - `const SandwichCounter(this.count, this.sandwichType, {super.key});` is the constructor
      - `this.count` and `this.sandwichType` automatically assign constructor arguments to instance variables

    Running the app at this stage won't show any visual changes yet, as we haven't actually used the `SandwichCounter` widget in our `SandwichShopApp`.

3.  **Commit Your Changes**

    Go ahead and commit your changes to the `lib/main.dart` file.
    We suggest a commit message like `Define SandwichCounter custom widget`.
    Below are the commands to commit your changes in the terminal:

    ```bash
    git add lib/main.dart
    git commit -m "Define SandwichCounter custom widget"
    git push
    ```

4.  **Implementing the `build` Method of `SandwichCounter`**

    Now, let's modify the `build` method of `SandwichCounter` so it displays the sandwich type, count, and some emojis. We want the output to look something like: "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪".

    Update the `build` method inside your `SandwichCounter` so it looks like this:

    ```dart
    class SandwichCounter extends StatelessWidget {
        final String sandwichType;
        final int count;

        const SandwichCounter(this.count, this.sandwichType, {super.key});

        @override
        Widget build(BuildContext context) {
            return Text('$count $sandwichType sandwich(es): ${'🥪' * count}');
        }
    }
    ```

5.  **Commit Your Changes**

    Suggested commit message: `Create the Custom SandwichCounter Widget`.

    ```bash
    git add lib/main.dart
    git commit -m "Create the Custom SandwichCounter Widget"
    git push
    ```

### Use `SandwichCounter` in `SandwichShopApp`

1.  **Replacing the Placeholder in `SandwichShopApp`**

    Find the `build` method of the `SandwichShopApp` class.
    Locate the `Center` widget within the `Scaffold`'s `body`.
    We construct an instance of the `SandwichCounter` class as `child` property.
    See below:

    ```dart
    class SandwichShopApp extends StatelessWidget {
        const SandwichShopApp({super.key});

        @override
        Widget build(BuildContext context) {
            return MaterialApp(
                home: Scaffold(
                    appBar: AppBar(title: const Text('Sandwich Counter')),
                    body: const Center(
                        child: SandwichCounter(5, 'Footlong'),
                    ),
                ),
            );
        }
    }
    ```

2.  **Run the Application**

    You should now see the application displaying an app bar with "Sandwich Counter" as the title.
    In the centre of the screen, the text "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪" should be displayed, rendered by your `SandwichCounter` widget.
    Try changing the number and type of sandwich in the `SandwichCounter` constructor to see how it updates.

3.  **Commit Your Changes**

    Suggested commit message: `Use SandwichCounter in SandwichShopApp`.

    ```bash
    git add lib/main.dart
    git commit -m "Use SandwichCounter in SandwichShopApp"
    git push
    ```

At this stage, your code should look like our code as shown on [the GitHub repository](https://github.com/manighahrmani/sandwich_shop/blob/2/lib/main.dart).

## Exercises

Before you begin, familiarise yourself with the **Flutter Inspector**, by watching this [YouTube video on the Widget Inspector](https://www.youtube.com/watch?v=_EYk-E29edo&t=172s) and review its [official documentation](https://docs.flutter.dev/tools/devtools/inspector).

 Your main guide for these exercises is the [Flutter layout documentation](https://docs.flutter.dev/get-started/fundamentals/layout).
 Remember to commit your changes after each exercise.

1.  **Vertical and Horizontal Layouts:**

    - Modify the `SandwichShopApp`'s `body` to display two `SandwichCounter` widgets.
    - First, arrange them vertically using a `Column` widget. Consult the documentation on "Layout multiple widgets vertically or horizontally".
    - To add space between them, you can either use a `SizedBox` widget or explore the `mainAxisAlignment` property of the `Column` (e.g., `MainAxisAlignment.spaceEvenly` as shown in "Align widgets within rows and columns").
    - Next, change the `Column` to a `Row` to arrange them horizontally. Observe how the layout changes.
    - What happens if the content of the `Row` is too wide for the screen (causes an overflow)? How does the concept of "Constraints go down. Sizes go up. Parent sets the position" apply here?
    - _Documentation Focus_: `Column`, `Row`, `MainAxisAlignment`, `CrossAxisAlignment`, `SizedBox`, understanding constraints.

2.  **Aligning Widgets:**

    - Using a `Column`, display three `SandwichCounter` widgets with different sandwich types and counts.
    - Experiment with the `crossAxisAlignment` property of the `Column` to align the `SandwichCounter` widgets. Refer to the diagram showing main and cross axes in the "Align widgets within rows and columns" section.
    - Wrap one of the `SandwichCounter` widgets in an `Align` widget. Experiment with its `alignment` property (e.g., `Alignment.centerLeft`, `Alignment.topRight`). How does this differ from using `CrossAxisAlignment` on the `Column`?
    - _Documentation Focus_: `Align` widget, `Alignment` class, `mainAxisAlignment` and `crossAxisAlignment` in `Column`/`Row`.

3.  **Sizing Widgets:**

    - In your `SandwichShopApp`, place a `SandwichCounter` widget inside a `Container`.
    - Give the `Container` a fixed `width` and `height` and a `color` to make its bounds visible. (Refer to "Lay out a single widget" and the `Container` section for adding padding/margins and understanding how `Container` can try to be a particular size if dimensions are provided).
    - What happens if the `SandwichCounter`'s text is too long for the `Container`'s width, leading to an overflow (yellow and black striped pattern)?
    - Now, use the `Expanded` widget to make a `SandwichCounter` take up available horizontal space within a `Row`. Try placing two `SandwichCounter`s in a `Row`, with one wrapped in `Expanded`. Experiment with the `flex` property of the `Expanded` widget to make one child take up more space than the other, as shown in "Sizing widgets within rows and columns".
    - _Documentation Focus_: `Container` (width, height, color, padding, margin), `Expanded` widget (and its `flex` property). Refer to "Sizing and positioning widgets" and the `Expanded` and `Flexible` Widget of the Week videos.

4.  **Scrolling:**

    - Modify `SandwichShopApp` to display ten `SandwichCounter` widgets. If you use a `Column` directly, you will likely see an overflow error because the content is taller than the screen. This is a common "unbounded constraints" scenario mentioned in "DevTools and debugging layout".
    - Instead of `Column` + `SingleChildScrollView`, use a `ListView` to display these ten `SandwichCounter` widgets. `ListView` automatically provides scrolling.
    - For a more dynamic list, explore `ListView.builder`. Why is `ListView.builder` preferred for long or dynamic lists? (See "Scrolling widgets" and specifically the `ListView.builder` example in the documentation).
    - Try creating a horizontal `ListView` of five `SandwichCounter` widgets. (Hint: `ListView` has a `scrollDirection` property).
    - _Documentation Focus_: `ListView`, `ListView.builder`, `scrollDirection`, understanding how `ListView` handles scrolling and differs from `Column`. Refer to "Scrollable widgets" and the `ListView` Widget of the Week video.

5.  **Basic Adaptive Layouts:**
    - Read the "Adaptive layouts" section of the Flutter layout documentation, paying close attention to the `LayoutBuilder` widget and the "builder pattern".
    - In `SandwichShopApp`, wrap the part of your UI that displays `SandwichCounter`(s) with a `LayoutBuilder`.
    - Inside the `builder` function of `LayoutBuilder`, you receive `BoxConstraints`. Use `constraints.maxWidth` to determine the available width.
    - Implement logic: if `constraints.maxWidth` is less than a certain value (e.g., 600 pixels, as in the documentation example), display your `SandwichCounter`(s) in a `Column`. Otherwise (if it's wider), display them in a `Row` (or a more complex row-based layout if you're feeling adventurous).
    - Observe how the layout changes when you resize your application window (if running on web or desktop).
    - _Documentation Focus_: `LayoutBuilder`, `BoxConstraints` (specifically `constraints.maxWidth`), the builder pattern. Refer to "Adaptive Apps" and the `LayoutBuilder` Widget of the Week video.

Remember to use the Flutter Inspector to examine your widget tree, understand constraints, and debug layout issues.
This will be particularly helpful for identifying and resolving common layout errors like "unbounded constraints".
