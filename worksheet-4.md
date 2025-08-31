I want to start this worksheet with the finished code from worksheet 3 (after the completion of the exercises). This would be my main.dart file:
```dart
import 'package:flutter/material.dart';
import 'app_styles.dart';

enum BreadType { white, wheat, wholemeal }

void main() {
  runApp(const App());
}

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
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  VoidCallback? _getIncreaseCallback() {
    if (_quantity < widget.maxQuantity) {
      return () {
        setState(() => _quantity++);
      };
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return () {
        setState(() => _quantity--);
      };
    }
    return null;
  }

  void _onSandwichTypeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeSelected(BreadType? value) {
    if (value != null) {
      setState(() => _selectedBreadType = value);
    }
  }

  List<DropdownMenuEntry<BreadType>> _buildDropdownEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> newEntry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(newEntry);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    String sandwichType = 'footlong';
    if (!_isFootlong) {
      sandwichType = 'six-inch';
    }

    String noteForDisplay;
    if (_notesController.text.isEmpty) {
      noteForDisplay = 'No notes added.';
    } else {
      noteForDisplay = _notesController.text;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              quantity: _quantity,
              itemType: sandwichType,
              breadType: _selectedBreadType,
              orderNote: noteForDisplay,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('six-inch', style: normalText),
                Switch(
                  value: _isFootlong,
                  onChanged: _onSandwichTypeChanged,
                ),
                const Text('footlong', style: normalText),
              ],
            ),
            const SizedBox(height: 10),
            DropdownMenu<BreadType>(
              textStyle: normalText,
              initialSelection: _selectedBreadType,
              onSelected: _onBreadTypeSelected,
              dropdownMenuEntries: _buildDropdownEntries(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                // We need a key to distinguish this TextField from the
                // TextFields that are used in the DropdownMenu (for testing).
                key: const Key('notes_textfield'),
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (e.g., no onions)',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: _getIncreaseCallback(),
                  icon: Icons.add,
                  label: 'Add',
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: _getDecreaseCallback(),
                  icon: Icons.remove,
                  label: 'Remove',
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String orderNote;

  const OrderItemDisplay({
    super.key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    required this.orderNote,
  });

  @override
  Widget build(BuildContext context) {
    String displayText =
        '$quantity ${breadType.name} $itemType sandwich(es): ${'🥪' * quantity}';

    return Column(
      children: [
        Text(
          displayText,
          style: normalText,
        ),
        const SizedBox(height: 8),
        Text(
          'Note: $orderNote',
          style: normalText,
        ),
      ],
    );
  }
}
```

This worksheet will start with refactoring this code into multiple files and adding a proper app architecture (Views, ViewModel, Repositories and Services). Then we will talk about unit testing and widget testing.
The emphasis here is to use AI assistants to help them with testing as otherwise there would be too much to cover in one session.
Some examples of AI assistants they may want to check out:
Copilot video, talks about Test Driven Development (TDD) too (but in TS): https://youtu.be/smdBqEu7fx4?feature=shared
Example of unit test for Python: https://docs.github.com/en/copilot/tutorials/write-tests

## App architecture

Start with a very brief intro to app architecture and why we need folders like: Views, ViewModel, Repositories and Services. Talk about how they are going to interact and I will show this screenshot there: 
![A simple app architecture diragram](images/app-architecture.png)
app-architecture.png
Link this webpage if they wanna know more: https://docs.flutter.dev/app-architecture/guide

According to the documentation: The data layer of an app handles your business data and logic. Two pieces of architecture make up the data layer: services and repositories. Repository classes are the source of truth for your model data. They're responsible for polling data from services and Services for example are the underlying platform, like iOS and Android APIs
REST endpoints, Local files, Firebase or SQL services (we'll see examples of this later).
Say a little about Async here as Services wrap API endpoints and expose asynchronous response objects, such as Future and Stream objects.

At this stage, walk them through adding a service/repository layer that does some basic stuff (e.g., storing options/enums, adding items to a cart, calculating total price).
Say that the reason for our separation is because in Flutter, views are the widget classes of your application (the current main.dart file that they have). Views are the primary method of rendering UI, and shouldn't contain any business logic (like the minimum and maximum number of sandwiches in the cart which is currently hardcoded or the type of bread). They should be passed all data they need to render from the view model or maybe as an exception in our case, directly from the repository.

Finally walk them through adding a view model layer. According to the documentation A view model's main responsibilities include:
- Retrieving application data from repositories and transforming it into a format suitable for presentation in the view. For example, it might filter, sort or aggregate data.
- Maintaining the current state needed in the view, so that the view can rebuild without losing data. For example, it might contain boolean flags to conditionally render widgets in the view, or a field that tracks which section of a carousel is active on screen.
- Exposes callbacks (called commands) to the view that can be attached to an event handler, like a button press or form submission.
So talk them through moving some stuff from main.dart to a file in this layer? Maybe the callbacks?

Also start talking about separation of the code in the view layer into multiple files (starting with a separate file for styles).
I have for example created an app_styles.dart file that contains the following:
```dart
import 'package:flutter/material.dart';

const TextStyle normalText = TextStyle(
  fontSize: 16,
);

const heading1 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);
```

Show them a diagram of how their folder structure should look like at this point.

## Unit testing

Start by saying that how can you ensure that your app continues to work as you add more features or change existing functionality? By writing tests.

At this point they should already have a test folder in their project (this is created automatically when you create a new Flutter project) and inside this file there should be a widget_test.dart file that contains widget tests that I have created and updated without mentioning it to them in the worksheets.

Then talk about the test folder and how they should add subfolders here (maybe a one for the unit testing of the view models or repositories and one for widget/screen/views/UI tests).

In the subfolder for view models/repositories, walk them through an example of unit testing.

This section will be based on this documentation page: https://docs.flutter.dev/cookbook/testing/unit/introduction
I have provided you below the content of this page:
```
Unit tests are handy for verifying the behavior of a single function, method, or class. The test package provides the core framework for writing unit tests, and the flutter_test package provides additional utilities for testing widgets.

This recipe demonstrates the core features provided by the test package using the following steps:

Add the test or flutter_test dependency.
Create a test file.
Create a class to test.
Write a test for our class.
Combine multiple tests in a group.
Run the tests.
For more information about the test package, see the test package documentation.

1. Add the test dependency
The test package provides the core functionality for writing tests in Dart. This is the best approach when writing packages consumed by web, server, and Flutter apps.

To add the test package as a dev dependency, run flutter pub add:

flutter pub add dev:test
content_copy
2. Create a test file
In this example, create two files: counter.dart and counter_test.dart.

The counter.dart file contains a class that you want to test and resides in the lib folder. The counter_test.dart file contains the tests themselves and lives inside the test folder.

In general, test files should reside inside a test folder located at the root of your Flutter application or package. Test files should always end with _test.dart, this is the convention used by the test runner when searching for tests.

When you're finished, the folder structure should look like this:

counter_app/
  lib/
    counter.dart
  test/
    counter_test.dart
content_copy
3. Create a class to test
Next, you need a "unit" to test. Remember: "unit" is another name for a function, method, or class. For this example, create a Counter class inside the lib/counter.dart file. It is responsible for incrementing and decrementing a value starting at 0.

class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}
content_copy
Note: For simplicity, this tutorial does not follow the "Test Driven Development" approach. If you're more comfortable with that style of development, you can always go that route.

4. Write a test for our class
Inside the counter_test.dart file, write the first unit test. Tests are defined using the top-level test function, and you can check if the results are correct by using the top-level expect function. Both of these functions come from the test package.

// Import the test package and Counter class
import 'package:counter_app/counter.dart';
import 'package:test/test.dart';

void main() {
  test('Counter value should be incremented', () {
    final counter = Counter();

    counter.increment();

    expect(counter.value, 1);
  });
}
content_copy
5. Combine multiple tests in a group
If you want to run a series of related tests, use the flutter_test package group function to categorize the tests. Once put into a group, you can call flutter test on all tests in that group with one command.

import 'package:counter_app/counter.dart';
import 'package:test/test.dart';

void main() {
  group('Test start, increment, decrement', () {
    test('value should start at 0', () {
      expect(Counter().value, 0);
    });

    test('value should be incremented', () {
      final counter = Counter();

      counter.increment();

      expect(counter.value, 1);
    });

    test('value should be decremented', () {
      final counter = Counter();

      counter.decrement();

      expect(counter.value, -1);
    });
  });
}
content_copy
6. Run the tests
Now that you have a Counter class with tests in place, you can run the tests.

Run tests using IntelliJ or VSCode
The Flutter plugins for IntelliJ and VSCode support running tests. This is often the best option while writing tests because it provides the fastest feedback loop as well as the ability to set breakpoints.

IntelliJ

Open the counter_test.dart file
Go to Run > Run 'tests in counter_test.dart'. You can also press the appropriate keyboard shortcut for your platform.
VSCode

Open the counter_test.dart file
Go to Run > Start Debugging. You can also press the appropriate keyboard shortcut for your platform.
Run tests in a terminal
To run the all tests from the terminal, run the following command from the root of the project:

flutter test test/counter_test.dart
content_copy
To run all tests you put into one group, run the following command from the root of the project:

flutter test --plain-name "Test start, increment, decrement"
content_copy
This example uses the group created in section 5.

To learn more about unit tests, you can execute this command:

flutter test --help
```

Keep this section simple, give a few simple examples, but ask them to use AI assistants to create test files by providing the AI with the code of the class they want to test and ask it to create a test file for it.

## Widget testing

This section will be based on this documentation page: https://docs.flutter.dev/cookbook/testing/widget/introduction
I have provided you below the content of this page:
```
In the introduction to unit testing recipe, you learned how to test Dart classes using the test package. To test widget classes, you need a few additional tools provided by the flutter_test package, which ships with the Flutter SDK.

The flutter_test package provides the following tools for testing widgets:

The WidgetTester allows building and interacting with widgets in a test environment.
The testWidgets() function automatically creates a new WidgetTester for each test case, and is used in place of the normal test() function.
The Finder classes allow searching for widgets in the test environment.
Widget-specific Matcher constants help verify whether a Finder locates a widget or multiple widgets in the test environment.
If this sounds overwhelming, don't worry. Learn how all of these pieces fit together throughout this recipe, which uses the following steps:

Add the flutter_test dependency.
Create a widget to test.
Create a testWidgets test.
Build the widget using the WidgetTester.
Search for the widget using a Finder.
Verify the widget using a Matcher.
1. Add the flutter_test dependency
Before writing tests, include the flutter_test dependency in the dev_dependencies section of the pubspec.yaml file. If creating a new Flutter project with the command line tools or a code editor, this dependency should already be in place.

dev_dependencies:
  flutter_test:
    sdk: flutter
content_copy
2. Create a widget to test
Next, create a widget for testing. For this recipe, create a widget that displays a title and message.

class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text(message)),
      ),
    );
  }
}
content_copy
3. Create a testWidgets test
With a widget to test, begin by writing your first test. Use the testWidgets() function provided by the flutter_test package to define a test. The testWidgets function allows you to define a widget test and creates a WidgetTester to work with.

This test verifies that MyWidget displays a given title and message. It is titled accordingly, and it will be populated in the next section.

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (tester) async {
    // Test code goes here.
  });
}
content_copy
4. Build the widget using the WidgetTester
Next, build MyWidget inside the test environment by using the pumpWidget() method provided by WidgetTester. The pumpWidget method builds and renders the provided widget.

Create a MyWidget instance that displays "T" as the title and "M" as the message.

void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));
  });
}
content_copy
Notes about the pump() methods
After the initial call to pumpWidget(), the WidgetTester provides additional ways to rebuild the same widget. This is useful if you're working with a StatefulWidget or animations.

For example, tapping a button calls setState(), but Flutter won't automatically rebuild your widget in the test environment. Use one of the following methods to ask Flutter to rebuild the widget.

tester.pump(Duration duration)
Schedules a frame and triggers a rebuild of the widget. If a Duration is specified, it advances the clock by that amount and schedules a frame. It does not schedule multiple frames even if the duration is longer than a single frame.
Note
To kick off the animation, you need to call pump() once (with no duration specified) to start the ticker. Without it, the animation does not start.

tester.pumpAndSettle()
Repeatedly calls pump() with the given duration until there are no longer any frames scheduled. This, essentially, waits for all animations to complete.
These methods provide fine-grained control over the build lifecycle, which is particularly useful while testing.

5. Search for our widget using a Finder
With a widget in the test environment, search through the widget tree for the title and message Text widgets using a Finder. This allows verification that the widgets are being displayed correctly.

For this purpose, use the top-level find() method provided by the flutter_test package to create the Finders. Since you know you're looking for Text widgets, use the find.text() method.

For more information about Finder classes, see the Finding widgets in a widget test recipe.

void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));

    // Create the Finders.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');
  });
}
content_copy
6. Verify the widget using a Matcher
Finally, verify the title and message Text widgets appear on screen using the Matcher constants provided by flutter_test. Matcher classes are a core part of the test package, and provide a common way to verify a given value meets expectations.

Ensure that the widgets appear on screen exactly one time. For this purpose, use the findsOneWidget Matcher.

void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}
content_copy
Additional Matchers
In addition to findsOneWidget, flutter_test provides additional matchers for common cases.

findsNothing
Verifies that no widgets are found.
findsWidgets
Verifies that one or more widgets are found.
findsNWidgets
Verifies that a specific number of widgets are found.
matchesGoldenFile
Verifies that a widget's rendering matches a particular bitmap image ("golden file" testing).
Complete example
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));

    // Create the Finders.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text(message)),
      ),
    );
  }
}
```

Start by saying that `WidgetTester` is a core utility class in Flutter's flutter_test package that allows developers to programmatically build and interact with widgets in an isolated test environment. It acts as a controller for widget tests, simulating user interactions and the passage of time to verify that a widget's UI and behavior are correct.

`WidgetTester` is the type of the tester parameter in the following example:
```dart
void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (tester) async {
    // Test code goes here.
  });
}
```

The WidgetTester provides a suite of methods that make it possible to test widgets without running the full application on a device or emulator. Its key responsibilities include: 
## Building widgets
pumpWidget(): This method inflates a single widget and its descendants, rendering them into a test environment. This is the starting point for most widget tests.
pump(): After a widget's state has changed (e.g., after a user interaction), this method rebuilds the widget tree to reflect the new state, and can advance the "fake" clock by a specified duration.
pumpAndSettle(): This repeatedly calls pump() until all animations have completed and the widget tree is stable. It's useful for testing scenarios with animations or asynchronous changes. 
## Simulating user interactions
The WidgetTester has methods for simulating common user gestures. 
tap(): Simulates a tap on a widget found by a Finder.
drag() / dragFrom(): Simulates a drag gesture on a widget.
enterText(): Enters text into a TextField or similar input widget. 
## Finding widgets
While not a method of WidgetTester itself, the find constant from flutter_test is used in conjunction with WidgetTester to locate widgets within the test environment. 
find.byType(): Finds a widget by its type.
find.byKey(): Finds a widget using a unique key.
find.text(): Finds a Text widget containing a specific string. 

- Building widgets: Uses pumpWidget() to build a widget tree and render it for testing. It also has pump() methods to rebuild the UI after a state change or animation.
- Simulating user interactions: Can perform mock user interactions like tapping, dragging, and entering text to test how widgets respond. (give some relevant example that applies to their current app)
- Finding widgets: Works with Finder objects to locate widgets within the test environment for verification. (again give some relevant example that applies to their current app)
- Verifying widget state: Examines the widget tree to verify that a widget's properties, state, and appearance match expectations. (examples)

Give solid examples of user interaction and ask them to check out this documentation page if they want to know more (I have pasted the content of this page for you below): https://docs.flutter.dev/cookbook/testing/widget/tap-drag
```
Many widgets not only display information, but also respond to user interaction. This includes buttons that can be tapped, and TextField for entering text.

To test these interactions, you need a way to simulate them in the test environment. For this purpose, use the WidgetTester library.

The WidgetTester provides methods for entering text, tapping, and dragging.

enterText()
tap()
drag()
In many cases, user interactions update the state of the app. In the test environment, Flutter doesn't automatically rebuild widgets when the state changes. To ensure that the widget tree is rebuilt after simulating a user interaction, call the pump() or pumpAndSettle() methods provided by the WidgetTester. This recipe uses the following steps:

Create a widget to test.
Enter text in the text field.
Ensure tapping a button adds the todo.
Ensure swipe-to-dismiss removes the todo.
1. Create a widget to test
For this example, create a basic todo app that tests three features:

Entering text into a TextField.
Tapping a FloatingActionButton to add the text to a list of todos.
Swiping-to-dismiss to remove the item from the list.
To keep the focus on testing, this recipe won't provide a detailed guide on how to build the todo app. To learn more about how this app is built, see the relevant recipes:

Create and style a text field
Handle taps
Create a basic list
Implement swipe to dismiss
class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  static const _appTitle = 'Todo List';
  final todos = <String>[];
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(_appTitle)),
        body: Column(
          children: [
            TextField(controller: controller),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];

                  return Dismissible(
                    key: Key('$todo$index'),
                    onDismissed: (direction) => todos.removeAt(index),
                    background: Container(color: Colors.red),
                    child: ListTile(title: Text(todo)),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todos.add(controller.text);
              controller.clear();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
content_copy
2. Enter text in the text field
Now that you have a todo app, begin writing the test. Start by entering text into the TextField.

Accomplish this task by:

Building the widget in the test environment.
Using the enterText() method from the WidgetTester.
testWidgets('Add and remove a todo', (tester) async {
  // Build the widget
  await tester.pumpWidget(const TodoList());

  // Enter 'hi' into the TextField.
  await tester.enterText(find.byType(TextField), 'hi');
});
content_copy
Note
This recipe builds upon previous widget testing recipes. To learn the core concepts of widget testing, see the following recipes:

Introduction to widget testing
Finding widgets in a widget test
3. Ensure tapping a button adds the todo
After entering text into the TextField, ensure that tapping the FloatingActionButton adds the item to the list.

This involves three steps:

Tap the add button using the tap() method.
Rebuild the widget after the state has changed using the pump() method.
Ensure that the list item appears on screen.
testWidgets('Add and remove a todo', (tester) async {
  // Enter text code...

  // Tap the add button.
  await tester.tap(find.byType(FloatingActionButton));

  // Rebuild the widget after the state has changed.
  await tester.pump();

  // Expect to find the item on screen.
  expect(find.text('hi'), findsOneWidget);
});
content_copy
4. Ensure swipe-to-dismiss removes the todo
Finally, ensure that performing a swipe-to-dismiss action on the todo item removes it from the list. This involves three steps:

Use the drag() method to perform a swipe-to-dismiss action.
Use the pumpAndSettle() method to continually rebuild the widget tree until the dismiss animation is complete.
Ensure that the item no longer appears on screen.
testWidgets('Add and remove a todo', (tester) async {
  // Enter text and add the item...

  // Swipe the item to dismiss it.
  await tester.drag(find.byType(Dismissible), const Offset(500, 0));

  // Build the widget until the dismiss animation ends.
  await tester.pumpAndSettle();

  // Ensure that the item is no longer on screen.
  expect(find.text('hi'), findsNothing);
});
content_copy
Complete example
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add and remove a todo', (tester) async {
    // Build the widget.
    await tester.pumpWidget(const TodoList());

    // Enter 'hi' into the TextField.
    await tester.enterText(find.byType(TextField), 'hi');

    // Tap the add button.
    await tester.tap(find.byType(FloatingActionButton));

    // Rebuild the widget with the new item.
    await tester.pump();

    // Expect to find the item on screen.
    expect(find.text('hi'), findsOneWidget);

    // Swipe the item to dismiss it.
    await tester.drag(find.byType(Dismissible), const Offset(500, 0));

    // Build the widget until the dismiss animation ends.
    await tester.pumpAndSettle();

    // Ensure that the item is no longer on screen.
    expect(find.text('hi'), findsNothing);
  });
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  static const _appTitle = 'Todo List';
  final todos = <String>[];
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(_appTitle)),
        body: Column(
          children: [
            TextField(controller: controller),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];

                  return Dismissible(
                    key: Key('$todo$index'),
                    onDismissed: (direction) => todos.removeAt(index),
                    background: Container(color: Colors.red),
                    child: ListTile(title: Text(todo)),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todos.add(controller.text);
              controller.clear();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

When it comes to finding, add a note about this (what if we have multiple of one widget type?) that we need to add a key which similar to an id in HTML which some of them have learnt in their first year:
```dart
child: TextField(
  // We need a key to distinguish this TextField from the
  // TextFields that are used in the DropdownMenu (for testing).
  key: const Key('notes_textfield'),
  controller: _notesController,
  decoration: const InputDecoration(
    labelText: 'Add a note (e.g., no onions)',
  ),
),
```

As a small side note, ask them to read the notes on the documentation page on pumping widget (e.g., schedule a pump after a delay to allow for animations or `pumpAndSettle()`)
https://docs.flutter.dev/cookbook/testing/widget/introduction#notes-about-the-pump-methods

As another side note, add links about handling scroll but don't talk about it: https://docs.flutter.dev/cookbook/testing/widget/scrolling
