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

For this worksheet, you need to start with the code that we have provided in the branch 4 of our [GitHub repository](https://github.com/manighahrmani/sandwich_shop/tree/4). You can either clone the repository and checkout the branch 4 with the following commands:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git checkout 4
```

Or you can manually make sure your `main.dart` file matches [ours](https://github.com/manighahrmani/sandwich_shop/blob/4/lib/main.dart). And create a new file called `app_styles.dart` in the `lib` folder and copy the contents from [here](https://github.com/manighahrmani/sandwich_shop/blob/4/lib/app_styles.dart). Run the app to make sure everything is working as expected and note that we have already completed the exercises from the previous worksheets.

Take a moment to familiarise yourself with the code and feel free to ask you AI assistant if you have any questions about the new widgets.

#### **Styles**

The new `app_styles.dart` file is a simple example of refactoring styles out of the main UI code. This file contains the styles used in our app much like a CSS file in web development. You can add more styles to this file as needed. Open your `main.dart` and check to see where these styles are used (use the search functionality in VS Code **Shift + Ctrl + F** on Windows or **Shift + ⌘ + F** on macOS and search for variables like `normalText`).

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

First, import the `OrderRepository` class at the top of your `main.dart` file. You may also need to move the `BreadType` enum from `main.dart` to the new `order_repository.dart` file to keep all your data model definitions in one place.

```dart
import 'package:sandwich_shop/repositories/order_repository.dart';
```

Next, replace the entire `_OrderScreenState` class in your `main.dart` file with the following updated code.

```dart
class _OrderScreenState extends State<OrderScreen> {
  late final OrderRepository _orderRepository;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;

  @override
  void initState() {
    super.initState();
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
      return () => setState(_orderRepository.increment);
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_orderRepository.canDecrement) {
      return () => setState(_orderRepository.decrement);
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
              quantity: _orderRepository.quantity,
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
```

We no longer manage the `_quantity` in this class as it is the responsibility of our repository object `_orderRepository`. We use the `late` keyword for this instance variable, which is a promise that we will initialise this variable before we use it. In our `initState` method, we create an instance of `OrderRepository` and assign it to `_orderRepository` and provide the `maxQuantity` from the stateful widget.

The `_getIncreaseCallback` and `_getDecreaseCallback` methods are now simpler. They use the `canIncrement` and `canDecrement` getters from the repository to decide whether the button should be enabled. So in future if we change the logic for incrementing or decrementing, we only need to update it in the repository.

## **Unit testing**

Writing tests help you ensure that your code works as expected and helps prevent bugs from creeping in as you make changes and add new features. There are three main types of tests in Flutter:

  - **Unit tests**: These tests verify the smallest testable parts of an application, called "units", in isolation. In our case, the `OrderRepository` class is a perfect example of a unit.
  - **Widget tests**: These tests verify the UI and interactions of individual widgets. They can simulate user interactions and verify that the widget behaves as expected.
  - **Integration tests**: These tests verify the integration of multiple widgets and services. They can simulate user interactions and verify that the app behaves as expected.

For more information, you can read the official Flutter documentation on [testing](https://docs.flutter.dev/cookbook/testing). In this worksheet, we will focus on unit tests and widget tests.

You should already have a `test` folder in your project (this is created automatically when you create a new Flutter project) and inside this folder there should be a `widget_test.dart` file.

You should add subfolders to the `test` folder for unit testing and widget testing. For our new repository, create a `repositories` folder inside the `test` folder.

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

Add the following code to `order_repository_test.dart`. We are importing the `flutter_test` package which comes pre-installed with Flutter and provides the necessary tools for writing tests. We are also importing the `OrderRepository` class that we want to test.

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

The tests in this file are grouped using the `group` function, which helps organise related tests together. Each individual test is defined using the `test` function.
`test` takes a description of the test and a callback function that contains the actual test code. The `expect` function used within the callbacks assert that a value matches an expected value. Read the test descriptions and comments to understand what each test is doing (and feel free to ask your AI assistant if you have any questions).

### **What to expect when you run tests**

Run these tests while the `order_repository_test.dart` is open in VS Code and click on the `Run` link above the `main` function. You should see the test results in the terminal panel at the bottom of VS Code as shown below:

![Running tests in VS Code](images/screenshot_running_tests.png)

Each green tick means that the test passed, in other words, the `expect` function received the value it was waiting for. A red cross (❌) would mean the test failed, and you will see a detailed error message explaining what went wrong—for example, `Expected: <1>, Actual: <0>`. This instant feedback is crucial for understanding what has gone wrong in your code.

## **Widget testing**

We have already provided you with example of widget testing in the `widget_test.dart` file. It is currently in the `test` folder. Create a new folder called `views` inside the `test` folder and move the `widget_test.dart` file into this new folder. This is what your folder structure should look like now:

```
lib/
  ├── views/
  │   ├── app_styles.dart
  │   └── main.dart
  ├── view_models/
  └── repositories/
  │   └── order_repository.dart
test/
  ├── repositories/
  │   └── order_repository_test.dart
  └── views/
      └── widget_test.dart
```

Next open the `widget_test.dart` file and update the import statements at the top of the file to match the new folder structure. It should be changed to the following:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/main.dart';
```

Look at the rest of the file now. You'll see that once again we have grouped our tests using the `group` function. This time, you'll notice that in each `test` function, the callback function is marked as `async` and takes a `WidgetTester` parameter named `tester`. This is because widget tests often involve asynchronous operations (they may need to wait for the UI to update or for animations to complete). 

`WidgetTester` class (defined within `flutter_test`) is a core utility class that allows developers to programmatically test widgets. This class provides the following types of methods:

  - **Building widgets**: Methods to construct and render widgets in a test environment such as `pumpWidget()`, `pump()`, and `pumpAndSettle()`.
  - **Simulating user interactions**: Methods to simulate user gestures like `tap()`, `drag()`, and `enterText()`.
  - **Finding widgets**: Methods to locate widgets in the widget tree using `Finder` objects, such as `find.byType()`, `find.byKey()`, and `find.text()`. 

For more information on widget testing, you can read the official Flutter documentation on [tapping and dragging widgets](https://docs.flutter.dev/cookbook/testing/widget/tap-drag) and [handling scrolling](https://docs.flutter.dev/cookbook/testing/widget/scrolling).
http://googleusercontent.com/youtube_content/1 http://googleusercontent.com/youtube_content/2 http://googleusercontent.com/youtube_content/3

Our example of widget testing does not cover all types of interactions and widget finding methods. To learn more about simulating user interactions, refer to this [documentation page](https://docs.flutter.dev/cookbook/testing/widget/tap-drag). And for more information on the `Finder` objects, check out this [documentation page](https://docs.flutter.dev/cookbook/testing/widget/finders).