# **Worksheet 4 — App Architecture and Testing**

## **What you need to know beforehand**

Ensure that you have already completed the following:

  - [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
  - [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).
  - [Worksheet 2 — Stateless Widgets](./worksheet-2.md).
  - [Worksheet 3 — Stateful widgets](./worksheet-3.md).

## **Getting help**

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## **Introduction to App Architecture**

As your app grows, it's important to have a clear and organised structure. Generally speaking, we need to organise our code into different layers, each with its own responsibility.

For this worksheet, we will be following the simple Model-View-ViewModel (MVVM) architecture. It recommends separating your app into the following layers:

  - **Views**: These are the widgets that make up your app's user interface (UI).
  - **View Models**: These are the classes that sit between the views and the repositories (not to be confused with GitHub repositories). They are responsible for retrieving data from the repositories and transforming it into a format that can be easily displayed by the views. They also include things like the callbacks that allow the view to interact with the data.
  - **Repositories**: These are the classes that are responsible for providing data to the view models. They typically interact with services to fetch data.
  - **Services**: These are the classes that are responsible for fetching data from external sources, such as cloud services or a database.

Here is a diagram that shows how these layers interact with each other:
![A simple app architecture diagram](images/app-architecture.png)

If you would like to learn more about app architecture, you can read the [official Flutter documentation](https://docs.flutter.dev/app-architecture/guide).

In this worksheet we will focus on the first three layers: views, view models, and repositories. Services wrap API endpoints and are typically used for fetching data asynchronously from external sources. We will learn more about them and asynchronous programming in a later worksheet.

### **Refactoring our code**

Refactoring is the process of restructuring existing code to improve its readability, maintainability, or performance, without changing its behaviour.

#### **Styles**

Let's start by refactoring our code into separate layers. As a simple example make a new `app_styles.dart` file in the `lib` folder and add the following code to it:
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

This file should contain the styles used in our app much like a CSS file in web development. You can add more styles to this file as needed. Open your `main.dart` and check to see where you are using styles there (use the search functionality in VS Code **Shift + Ctrl + F** on Windows or **Shift + ⌘ + F** on macOS and search for properties like `fontSize`).

Next replace the style definitions in `main.dart` with references to the styles defined in `app_styles.dart`. For example, replace:
```dart
const Text(
  'six-inch',
  style: TextStyle(
    fontSize: 16,
  ),
),
```
with the following (make sure to **import `app_styles.dart` at the top of `main.dart`**):
```dart
import 'app_styles.dart';

const Text(
  'six-inch',
  style: normalText,
),
```

For the `ElevatedButton` widgets you can add the following in their `styleFrom` method:
```dart
ElevatedButton(
  onPressed: _increaseQuantity,
  style: ElevatedButton.styleFrom(
    textStyle: normalText,
  ),
),
```

Feel free to let Copilot help you refactor the styles in `main.dart` and replace them with references to the styles defined in `app_styles.dart`. Note that you can import and reuse the styles defined in `app_styles.dart` in any other view or widget in your project.

#### **Folder structure**

Next, open the Explorer view in VS Code with **Ctrl + Shift + E** on Windows or **⌘ + Shift + E** on macOS. Right-click on the `lib` folder and select **New Folder**. Name this folder `views`. Similarly, create the following folders in the `lib` folder: `view_models`, and `repositories`. 

Drag and drop the `app_styles.dart` and `main.dart` files into the `views` subfolder of the `lib` folder.

Your folder structure should now look like this:

```
lib/
  ├── views/
  │   ├── app_styles.dart
  │   └── main.dart
  ├── view_models/
  └── repositories/
```

Now, let's create a more meaningful separation by moving the business logic out of our UI code. Business logic refers to custom rules for managing the business, in our case, this is the limit on sandwich quantity. The logic for managing the sandwich quantity (incrementing, decrementing, and checking limits) doesn't need to be inside the `_OrderScreenState` of `main.dart`. We can move it to a dedicated class in the `repositories` folder.

Right-click on the `repositories` folder and select **New File**. Name this file `order_repository.dart`. Open this file and add the following code to it. This class will now be the single source of truth for our order's quantity. Notice the new boolean getter methods `canIncrement` and `canDecrement` which encapsulate the logic for checking the quantity limits.

```dart
class OrderRepository {
  int _quantity = 0;
  final int maxQuantity;

  OrderRepository({required this.maxQuantity});

  int get quantity => _quantity;

  bool get canIncrement => _quantity < maxQuantity;
  bool get canDecrement => _quantity > 0;

  void increment() {
    if (canIncrement) {
      _quantity++;
    }
  }

  void decrement() {
    if (canDecrement) {
      _quantity--;
    }
  }
}
```

With the logic moved, we can now simplify our `_OrderScreenState` class in `main.dart`. Update your `main.dart` file to use this new repository.

First import the `OrderRepository` class at the top of `main.dart`:

```dart
import '../repositories/order_repository.dart';
```

The `..` is used to go up one directory level from `views` to `lib`, and then down into the `repositories` folder.


This is what the updated `main.dart` file should look like (`main`, `App`, `OrderScreen`, `StyledButton` and `OrderItemDisplay` class definitions remain in this file):

```dart
import 'package:flutter/material.dart';
import 'app_styles.dart';
import 'repositories/order_repository.dart';

class _OrderScreenState extends State<OrderScreen> {
  late final OrderRepository _orderRepository;

  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;

  @override
  void initState() {
    super.initState();
    // Initialise the repository with the maxQuantity from the widget
    _orderRepository = OrderRepository(maxQuantity: widget.maxQuantity);

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
    if (_orderRepository.canIncrement) {
      return () {
        setState(() => _orderRepository.increment());
      };
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_orderRepository.canDecrement) {
      return () {
        setState(() => _orderRepository.decrement());
      };
    }
    return null;
  }

  // ... (_onSandwichTypeChanged, _onBreadTypeSelected, _buildDropdownEntries remain the same) ...

  @override
  Widget build(BuildContext context) {
    // ... (sandwichType and noteForDisplay logic remains the same) ...

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
            // Use the quantity from the repository
            OrderItemDisplay(
              quantity: _orderRepository.quantity,
              itemType: sandwichType,
              // ... other properties
            ),
            // ... (rest of the UI code remains the same) ...
          ],
        ),
      ),
    );
  }
}
```

## **Unit testing**

How can you ensure that your app continues to work as you add more features or change existing functionality? By writing tests.

You should already have a `test` folder in your project (this is created automatically when you create a new Flutter project) and inside this folder there should be a `widget_test.dart` file.

You should add subfolders here for the unit testing of the view models or repositories and one for widget/screen/views/UI tests. For our new repository, create a `repositories` folder inside the `test` folder.

Unit tests are designed to verify the smallest testable parts of an application, called "units", in isolation. In our case, the `OrderRepository` class is a perfect example of a unit. By testing it separately from the Flutter UI, we can ensure its logic is correct, reliable, and predictable without the complexity of user interactions or rendering. This makes them extremely fast to run and helps catch bugs in your business logic early. For more information, you can read the official Flutter documentation on [unit testing](https://docs.flutter.dev/cookbook/testing/unit/introduction).

### **Unit testing example**

Now that we have moved our business logic into a pure Dart class (`OrderRepository`), we can write a unit test for it without needing to build any widgets. Unit tests are fast and focus on a single class or function.

Create a new file called `order_repository_test.dart` in the `test/repositories` folder.


This is what your folder structure should look like now:

```
lib/
  ├── views/
  │   ├── app_styles.dart
  │   └── main.dart
  ├── view_models/
  └── repositories/
test/
  └── repositories/
      └── order_repository_test.dart
```


Add the following code to `order_repository_test.dart`. This test verifies the core logic of our repository.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';

void main() {
  group('OrderRepository', () {
    test('initial quantity should be 0', () {
      final repository = OrderRepository(maxQuantity: 5);
      expect(repository.quantity, 0);
    });

    test('increment should increase quantity by 1', () {
      final repository = OrderRepository(maxQuantity: 5);
      repository.increment();
      expect(repository.quantity, 1);
    });

    test('decrement should decrease quantity by 1', () {
      final repository = OrderRepository(maxQuantity: 5);
      repository.increment(); // quantity is now 1
      repository.decrement(); // quantity is now 0
      expect(repository.quantity, 0);
    });

    test('quantity should not exceed maxQuantity', () {
      final repository = OrderRepository(maxQuantity: 2);
      repository.increment(); // quantity is 1
      repository.increment(); // quantity is 2
      repository.increment(); // should not change
      expect(repository.quantity, 2);
    });

    test('quantity should not go below 0', () {
      final repository = OrderRepository(maxQuantity: 5);
      repository.decrement(); // should not change
      expect(repository.quantity, 0);
    });
  });
}
```

### **What to expect when you run tests**

You can run these tests by opening the `order_repository_test.dart` file in VS Code and clicking on the `Run` link above the `main` function.

When you run the tests, a new "Test Results" panel will appear in your terminal area. You will see a list of your tests with icons next to them. A green tick (✅) means the test passed, meaning the `expect` function received the value it was waiting for. A red cross (❌) means the test failed, and you will see a detailed error message explaining what went wrong—for example, `Expected: <1>, Actual: <0>`. This instant feedback is crucial for debugging.


## **Widget testing**

<!-- Make sure to update the import statement as we have moved `main.dart` to the `lib` folder. -->

The `WidgetTester` is a core utility class in Flutter's `flutter_test` package that allows developers to programmatically build and interact with widgets in an isolated test environment. It acts as a controller for widget tests, simulating user interactions and the passage of time to verify that a widget's UI and behavior are correct.

`WidgetTester` is the type of the `tester` parameter in the following example:

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

The `WidgetTester` provides a suite of methods that make it possible to test widgets without running the full application on a device or emulator. Its key responsibilities include:

### **Building widgets**

  - `pumpWidget()`: This method inflates a single widget and its descendants, rendering them into a test environment. This is the starting point for most widget tests.
  - `pump()`: After a widget's state has changed (e.g., after a user interaction), this method rebuilds the widget tree to reflect the new state, and can advance the "fake" clock by a specified duration.
  - `pumpAndSettle()`: This repeatedly calls `pump()` until all animations have completed and the widget tree is stable. It's useful for testing scenarios with animations or asynchronous changes.

### **Simulating user interactions**

The `WidgetTester` has methods for simulating common user gestures.

  - `tap()`: Simulates a tap on a widget found by a `Finder`.
  - `drag()` / `dragFrom()`: Simulates a drag gesture on a widget.
  - `enterText()`: Enters text into a `TextField` or similar input widget.

For example, to test the "Add" button in our app, we can write the following test:

```dart
testWidgets('tapping add button increases quantity', (WidgetTester tester) async {
  await tester.pumpWidget(const App());
  await tester.tap(find.widgetWithText(StyledButton, 'Add'));
  await tester.pump();
  expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
});
```

### **Finding widgets**

While not a method of `WidgetTester` itself, the `find` constant from `flutter_test` is used in conjunction with `WidgetTester` to locate widgets within the test environment.

  - `find.byType()`: Finds a widget by its type.
  - `find.byKey()`: Finds a widget using a unique key.
  - `find.text()`: Finds a `Text` widget containing a specific string.

What if we have multiple widgets of the same type? We can add a `key` to the widget to uniquely identify it. This is similar to an `id` in HTML.

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

Then we can find the widget using its key:

```dart
find.byKey(const Key('notes_textfield'))
```

For more information on widget testing, you can read the official Flutter documentation on [tapping and dragging widgets](https://docs.flutter.dev/cookbook/testing/widget/tap-drag) and [handling scrolling](https://docs.flutter.dev/cookbook/testing/widget/scrolling).
http://googleusercontent.com/youtube_content/1 http://googleusercontent.com/youtube_content/2 http://googleusercontent.com/youtube_content/3