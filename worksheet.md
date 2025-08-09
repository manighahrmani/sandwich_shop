# Worksheet 2 — Stateless Widgets

## What You Need To Know Beforehand

Ensure that you have already completed the following:

- [Worksheet 0 — Introduction to Dart, Git and GitHub](https://github.com/manighahrmani/sandwich_shop/blob/0/worksheet.md).
- [Worksheet 1 — Introduction to Flutter](https://github.com/manighahrmani/sandwich_shop/blob/1/worksheet.md).

## Getting Help

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## Set Up the Project

We will start to incrementally build the "Sandwich Counter" application.

Open the Flutter folder containing the project you created in [Worksheet 1](https://github.com/manighahrmani/sandwich_shop/blob/1/worksheet.md) in Visual Studio Code.
This project should already be a repository in your GitHub account.

1.  **Import the Material Design Library**

    Open `lib/main.dart`.
    We need to ensure that we have the correct `import` statement for Material Design components:

    ```dart
    import 'package:flutter/material.dart';
    ```

    **Material Design** is a design system created by Google that provides guidelines for user experience.
    The `package:flutter/material.dart` library gives you access to a collection of pre-built UI components, called **widgets**, that implement these Material Design guidelines.
    We will first use these widgets to build the user interface of our app, and later, we will learn how to create our own custom widgets.

    These widgets include fundamental building blocks, such as:

    - **Structural elements** like `Scaffold` (for page layout), `AppBar` (for the top application bar), and `Drawer` (for navigation menus).
    - **Buttons** like `ElevatedButton`, `TextButton`, and `IconButton`.
    - **Informational widgets** like `Text`, `Image`, and `Icon` (for displaying icons).
    - **Input widgets** like `TextField` (for text entry) and `Checkbox` (for boolean input).
    - **Layout widgets** like `Row`, `Column`, `Stack`, and `Card` that help you arrange other widgets.

    The library also includes utilities like `ThemeData` to define styling (colours, fonts) across your app.

2.  **Clean the Default Code**

    Locate the `main()` function in `lib/main.dart`.
    This is where your app starts. The default app has `runApp(const MyApp());`.
    Comment out or remove this line for now.
    You can comment a line in VS Code by selecting it with your mouse and pressing **Ctrl + /** on Windows or **⌘ + /** on macOS.

    Let's also clear out the default `MyApp` class and other related classes from the app.
    Delete everything except for the import statement and the `main()` function.
    Your `lib/main.dart` file should now look like this:

    ```dart
    import 'package:flutter/material.dart';

    void main() {}
    ```

3.  **Commit Your Changes**

    It is a good time to commit your changes.
    In VS Code, go to the Source Control panel from **View \> Source Control**.
    You can also use the Command Palette (**Ctrl + Shift + P** or **⌘ + Shift + P** on macOS) and enter "Source Control", which will open the Source Control panel.

    You should see `main.dart` listed under changes. In the "Message" box, above the "Commit" button, type a descriptive commit message, something like `Set Up the Project`.

    Click the Commit button to commit the changes.
    After committing, click the "Sync Changes" button to upload your commit to GitHub.

    Note that you could also do all of this using the integrated terminal within VS Code.
    You can open the terminal with **Ctrl + \`** on Windows or **⌘ + \`** on macOS and run the following commands:

    ```bash
    git add lib/main.dart
    git commit -m "Set Up the Project"
    git push
    ```

## Define the Main App Widget: `App`

1.  **Define the `App` Widget**

    Add the following class definition to `lib/main.dart`, below the `import` statement and before the `main()` function:

    ```dart
    class App extends StatelessWidget {
      const App({super.key});

      @override
      Widget build(BuildContext context) {
        return Container();
      }
    }
    ```

    Key points:

    - `App` is the main widget of our app.
    - `StatelessWidget` is a widget that does not change in appearance and behaviour after being built.
    - `App` extends (is a subclass of) `StatelessWidget`.
    - `const App({super.key});` is the constructor for `App`.
      - `const` is optional (for performance).
      - `super.key` is used to pass an optional `key` (a unique identifier for the widget).
    - `Widget build(BuildContext context)` is the `build()` method of `App`.
      - Flutter calls `build`, which returns a `Widget` used to render the UI.
      - `BuildContext context` is the context (e.g., the location) of the widget; it is needed to build the UI.
      - `@override` shows that we are reimplementing the `build` method of `StatelessWidget`; all widgets must do this.
      - For now, `build` returns a placeholder (`Container` is like a `div` in HTML).

2.  **Use the `App` Widget**

    Next, update the `main()` function to look like this:

    ```dart
    void main() {
      runApp(const App());
    }
    ```

    The `runApp()` function takes the given widget (`App` in our case) and makes it the root of the widget tree, effectively displaying it on the screen.

    If you run your app now, it would show a blank screen because our `App` returns an empty `Container`.

3.  **Commit Your Changes**

    Suggested commit message: `Define the Main App Widget: App`

## Define the UI inside `App`

1.  **Redefine the `build` Method**

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

    Key points:

    - **`MaterialApp`** is the root widget that provides theming, navigation, and Material Design.
      - Uses named parameters like `home:` to specify the main screen.
      - `Scaffold` is the child of `MaterialApp` while `AppBar` and `Center` are children of `Scaffold`. This structure is called **the widget tree**.
      - For more details, see the [MaterialApp documentation](https://api.flutter.dev/flutter/material/MaterialApp-class.html).
    - **`Scaffold`** is the blueprint for a typical app screen layout.
      - Provides slots for `appBar`, `body`, `drawer`, `bottomNavigationBar`, `floatingActionButton`, etc.
      - For more details, see the [Scaffold documentation](https://api.flutter.dev/flutter/material/Scaffold-class.html).
    - **`AppBar`** is the top bar of the screen.
      - `title` property shows the screen title.
      - For more details, see the [AppBar documentation](https://api.flutter.dev/flutter/material/AppBar-class.html).
    - **`Center`** is a layout widget that centres its child.
      - It centres our placeholder `Text` widget both horizontally and vertically.

2.  **Run the Application**

    Make sure you have a device selected (e.g., Chrome from the bottom status bar).
    You can also open the Command Palette (`Ctrl + Shift + P` or `⌘ + Shift + P` on macOS) and type "Flutter: Select Device" to choose a device.

    Once a web device is selected, run the app with `F5` or by clicking the "Run" button on top of the `main` function in `lib/main.dart`.

    You should see an application with an app bar titled "Sandwich Counter" and the text "Welcome to the Sandwich Shop\!" centred in the body of the screen.
    ![Welcome to the Sandwich Shop](images/screenshot_welcome_to_sandwich_shop.jpg)
    _Figure: The Sandwich Counter app with a welcome message._

3.  **Commit Your Changes**

    Suggested commit message: `Define the UI inside App`

## Create the Custom `OrderItemDisplay` Widget

1.  **Why Do We Need Custom Widgets?**

    In Flutter, you're not limited to using only the widgets provided by the framework.
    You can create your own widgets by combining existing ones or by defining new behaviour.
    Once a custom widget is defined, you can reuse it.

    Our `OrderItemDisplay` widget will be responsible for displaying a single line of text that describes the quantity and type of a sandwich, complete with a visual representation using emojis.

2.  **Define the `OrderItemDisplay` Widget**

    We'll add the definition for `OrderItemDisplay` in the `lib/main.dart` file, although you can place it in a separate file for better organisation.
    Place the `OrderItemDisplay` class above the `App` class, but below the initial `import` statement:

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

    Key points:

    - `OrderItemDisplay` is our custom widget that extends `StatelessWidget`.
    - `final String itemType` and `final int quantity` are instance variables.
      - Marked `final` because data in a `StatelessWidget` does not change after the widget is built.
    - `const OrderItemDisplay(this.quantity, this.itemType, {super.key});` is the constructor.
      - `this.quantity` and `this.itemType` automatically assign constructor arguments to instance variables.

    Running the app at this stage won't show any visual changes yet, as we haven't actually used the `OrderItemDisplay` widget in our `App`.

3.  **Commit Your Changes**

    Suggested commit message: `Define OrderItemDisplay custom widget`

4.  **Implement the `build` Method of `OrderItemDisplay`**

    Now, let's modify the `build` method of `OrderItemDisplay` so it displays the sandwich type, quantity, and some emojis. We want the output to look something like: "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪".

    Update the `build` method inside your `OrderItemDisplay` so it looks like this:

    ```dart
    @override
    Widget build(BuildContext context) {
      return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
    }
    ```

5.  **Commit Your Changes**

    Suggested commit message: `Implement dynamic text in OrderItemDisplay`

## Use `OrderItemDisplay` in `App`

1.  **Replace the Placeholder in `App`**

    Find the `build` method of the `App` class.
    Locate the `Center` widget within the `Scaffold`'s `body`.
    We will construct an instance of the `OrderItemDisplay` class and provide it to the `child` property.
    See below:

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

2.  **Run the Application**

    You should now see the application displaying an app bar with "Sandwich Counter" as the title.
    In the centre of the screen, the text "5 Footlong sandwich(es): 🥪🥪🥪🥪🥪" should be displayed, rendered by your `OrderItemDisplay` widget.
    ![Sandwich Counter](images/screenshot_sandwich_counter.jpg)
    _Figure: The Sandwich Counter app displaying the sandwich quantity and type._

3.  **Commit Your Changes**

    Suggested commit message: `Use OrderItemDisplay in App`

At this stage, your code should look like our code as shown on [the GitHub repository](https://github.com/manighahrmani/sandwich_shop/blob/2/lib/main.dart).

## Exercises

Complete the exercises below and show your work to a member of staff present at your next practical for **a sign-off**.

1.  The **Flutter Inspector** is a tool that allows you to visualize the widget tree, view properties of widgets, and debug layout issues.
    You can access it via the browser or by using the DevTools in Visual Studio Code. Use `Ctrl + Shift + P` or `⌘ + Shift + P` on macOS to open the command palette and type "Flutter: Open Flutter DevTools" and select the "Widget Inspector" option).

    Familiarise yourself with this tool, by watching this [YouTube video on the Widget Inspector](https://www.youtube.com/watch?v=_EYk-E29edo&t=172s) and review its [official documentation](https://docs.flutter.dev/tools/devtools/inspector).
    As a small exercise, observe the relationship between the widgets in your app and the properties (e.g., width and height) of each widget.
    ![Flutter DevTools](images/screenshot_devtools.jpg)
    _Figure: Flutter DevTools showing the widget tree and properties._

    Your main guide for the rest of the exercises is the [Flutter layout documentation](https://docs.flutter.dev/get-started/fundamentals/layout).
    Remember to commit your changes after each exercise.

2.  Place the `OrderItemDisplay` widgets inside a `Container` widget.
    Check out the [Lay out a single widget](https://docs.flutter.dev/get-started/fundamentals/layout#lay-out-a-single-widget) section of the documentation page or the documentation for the [Container widget](https://api.flutter.dev/flutter/widgets/Container-class.html) to understand how to use it.

    Give the `Container` a fixed `width` and `height` and a `color` to make it visible.
    Colours in Flutter can be specified using the `Colors` class, like `Colors.blue` or `Colors.red` (see the [Colors documentation](https://api.flutter.dev/flutter/material/Colors-class.html)).
    This is what it should look like:
    ![Container](images/screenshot_container.jpg)
    _Figure: The application with a blue Container holding the OrderItemDisplay._

    Update the `width` and `height` properties to see what happens if the `OrderItemDisplay`'s text is too big for the `Container`.

3.  Read about **layout widgets** by visiting the [Layout widgets documentation](https://docs.flutter.dev/get-started/fundamentals/layout#layout-widgets).
    Next, use a `Column` or a `Row` widget to display three `OrderItemDisplay` widgets in the `App`'s `body`.
    Make sure to read about [main and cross axes alignment in the documentation page](https://docs.flutter.dev/get-started/fundamentals/layout#align-widgets-within-rows-and-columns) to see how to align widgets within these layout widgets.
    ![Layout](images/screenshot_layout.jpg)
    _Figure: The application with three OrderItemDisplay widgets arranged in a Row._

    Resize the browser window.
    What happens if the content of the `Row` is too wide for the screen?
    Feel free to use an LLM or read the documentation page about the concept of "Constraints".

4.  Use a column and display 20 `OrderItemDisplay` widgets this time.
    You will most likely see an overflow error because the content is taller than the screen.
    (At this point, you may want to read the [Debugging layouts](https://docs.flutter.dev/get-started/fundamentals/layout#devtools-and-debugging-layout) section on the documentation page).

    ![Overflow](images/screenshot_overflow.jpg)
    _Figure: The application with an overflow error due to too many OrderItemDisplay widgets in a Column._

    There are a couple of ways to fix this issue:

    - Wrap the `Column` in a `SingleChildScrollView` widget, which allows the content to scroll vertically.
      Read about the [SingleChildScrollView documentation](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html) for more details.
    - Alternatively, you can use a `ListView` widget, which is also designed for displaying a scrollable list of widgets.
      Read about the [ListView documentation](https://api.flutter.dev/flutter/widgets/ListView-class.html) to understand how it works and how it differs from `SingleChildScrollView`.

5.  Read the [Adaptive layouts](https://docs.flutter.dev/get-started/fundamentals/layout#adaptive-layouts) section of the Flutter layout documentation.

    Wrap the part of your UI that displays `OrderItemDisplay`(s) with a `LayoutBuilder`.  
    Inside the `builder` function of `LayoutBuilder`, you receive `BoxConstraints`.
    Use `constraints.maxWidth` to determine the available width and based on that, decide how to display your `OrderItemDisplay`(s).

    Similar to the example in the documentation, make sure that if the available width is less than or equal to 600 pixels, you display the `OrderItemDisplay`(s) in a `Column`, otherwise, a `Row`.
    Make sure to check out the final example in this page as it shows how you can define local variables inside the `builder` function.
    Observe these changes by resizing the browser window.