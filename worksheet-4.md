# **Worksheet 4 — App Architecture and Testing**

## **What you need to know beforehand**

Ensure that you have already completed the following:

  - [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
  - [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).
  - [Worksheet 2 — Stateless Widgets](./worksheet-2.md).
  - [Worksheet 3 — Stateful widgets](./worksheet-3.md).

## **Getting help**

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

### **Introduction to App Architecture**

As your app grows, it's important to have a clear and organised structure. Generally speaking, we need to organise our code into different layers, each with its own responsibility.

For this worksheet, we will be following the simple Model-View-ViewModel (MVVM) architecture. It recommends separating your app into the following layers:

  - **Views**: These are the widgets that make up your app's user interface (UI).
  - **View Models**: These are the classes that sit between the views and the repositories (not to be confused with GitHub repositories). They are responsible for retrieving data from the repositories and transforming it into a format that can be easily displayed by the views. They also include things like the callbacks that allow the view to interact with the data.
  - **Repositories**: These are the classes that are responsible for providing data to the view models. They typically interact with services to fetch data.
  - **Services**: These are the classes that are responsible for fetching data from external sources, such as cloud services or a database.

Here is a diagram that shows how these layers interact with each other:
![A simple app architecture diagram](images/app-architecture.png)

If you would like to learn more about app architecture, you can read the [official Flutter documentation](https://docs.flutter.dev/app-architecture/guide).

In this worksheet we will focus on the first three layers: views, view models, and repositories. Services wrap API endpoints and expose asynchronous response objects, such as `Future` and `Stream` objects. We will learn more about asynchronous programming in a later worksheet.

### App Architecture

Let's start by refactoring our code into multiple files. First, create a new file called `app_styles.dart` in the `lib` folder and add the following code to it:

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

Next, create the following folders in the `lib` folder: `views`, `view_models`, and `repositories`. Your folder structure should now look like this:

```
lib/
  ├── views/
  ├── view_models/
  ├── repositories/
  ├── app_styles.dart
  └── main.dart
```

Now, let's move the `OrderItemDisplay` and `StyledButton` widgets to their own files in the `views` folder. Create a new file called `order_item_display.dart` in the `views` folder and add the following code to it:

```dart
import 'package:flutter/material.dart';
import '../app_styles.dart';
import '../repositories/order_repository.dart';

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

Create another new file called `styled_button.dart` in the `views` folder and add the following code to it:

```dart
import 'package:flutter/material.dart';
import '../app_styles.dart';

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
```

Now, create a new file called `order_repository.dart` in the `repositories` folder and add the following code to it:

```dart
enum BreadType { white, wheat, wholemeal }
```

Finally, create a new file called `order_view_model.dart` in the `view_models` folder and add the following code to it:

```dart
import 'package:flutter/material.dart';
import '../repositories/order_repository.dart';

class OrderViewModel with ChangeNotifier {
  int _quantity = 0;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  final int maxQuantity;

  OrderViewModel({this.maxQuantity = 10});

  int get quantity => _quantity;
  TextEditingController get notesController => _notesController;
  bool get isFootlong => _isFootlong;
  BreadType get selectedBreadType => _selectedBreadType;

  VoidCallback? getIncreaseCallback() {
    if (_quantity < maxQuantity) {
      return () {
        _quantity++;
        notifyListeners();
      };
    }
    return null;
  }

  VoidCallback? getDecreaseCallback() {
    if (_quantity > 0) {
      return () {
        _quantity--;
        notifyListeners();
      };
    }
    return null;
  }

  void onSandwichTypeChanged(bool value) {
    _isFootlong = value;
    notifyListeners();
  }

  void onBreadTypeSelected(BreadType? value) {
    if (value != null) {
      _selectedBreadType = value;
      notifyListeners();
    }
  }

  List<DropdownMenuEntry<BreadType>> buildDropdownEntries() {
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
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
```

Now update your `main.dart` file to use the new `OrderScreen` and `OrderViewModel`.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_styles.dart';
import 'repositories/order_repository.dart';
import 'view_models/order_view_model.dart';
import 'views/order_item_display.dart';
import 'views/styled_button.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderViewModel(maxQuantity: 5),
      child: const MaterialApp(
        title: 'Sandwich Shop App',
        home: OrderScreen(),
      ),
    );
  }
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrderViewModel>(context);

    String sandwichType = 'footlong';
    if (!viewModel.isFootlong) {
      sandwichType = 'six-inch';
    }

    String noteForDisplay;
    if (viewModel.notesController.text.isEmpty) {
      noteForDisplay = 'No notes added.';
    } else {
      noteForDisplay = viewModel.notesController.text;
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
              quantity: viewModel.quantity,
              itemType: sandwichType,
              breadType: viewModel.selectedBreadType,
              orderNote: noteForDisplay,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('six-inch', style: normalText),
                Switch(
                  value: viewModel.isFootlong,
                  onChanged: viewModel.onSandwichTypeChanged,
                ),
                const Text('footlong', style: normalText),
              ],
            ),
            const SizedBox(height: 10),
            DropdownMenu<BreadType>(
              textStyle: normalText,
              initialSelection: viewModel.selectedBreadType,
              onSelected: viewModel.onBreadTypeSelected,
              dropdownMenuEntries: viewModel.buildDropdownEntries(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                // We need a key to distinguish this TextField from the
                // TextFields that are used in the DropdownMenu (for testing).
                key: const Key('notes_textfield'),
                controller: viewModel.notesController,
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
                  onPressed: viewModel.getIncreaseCallback(),
                  icon: Icons.add,
                  label: 'Add',
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: viewModel.getDecreaseCallback(),
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

## **Unit testing**

How can you ensure that your app continues to work as you add more features or change existing functionality? By writing tests.

You should already have a `test` folder in your project (this is created automatically when you create a new Flutter project) and inside this folder there should be a `widget_test.dart` file.

You should add subfolders here for the unit testing of the view models or repositories and one for widget/screen/views/UI tests.

### **Unit testing example**

Let's write a unit test for our `OrderViewModel`. Create a new file called `order_view_model_test.dart` in the `test/view_models` folder and add the following code to it:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/view_models/order_view_model.dart';

void main() {
  group('OrderViewModel', () {
    test('quantity should be incremented', () {
      final viewModel = OrderViewModel(maxQuantity: 5);
      viewModel.getIncreaseCallback()?.call();
      expect(viewModel.quantity, 1);
    });

    test('quantity should not be incremented beyond maxQuantity', () {
      final viewModel = OrderViewModel(maxQuantity: 1);
      viewModel.getIncreaseCallback()?.call();
      viewModel.getIncreaseCallback()?.call();
      expect(viewModel.quantity, 1);
    });
  });
}
```

You can run these tests by opening the `order_view_model_test.dart` file in VS Code and clicking on the `Run` link above the `main` function.

Now, it's your turn. Use your AI assistant to create test files for the `OrderRepository` and the other methods in `OrderViewModel`.

## **Widget testing**

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