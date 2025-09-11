This is the code they will start with after completing worksheet-5.
`lib/main.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/order_screen_view.dart';

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
```
`lib/views/order_screen_view.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/cart_view_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart();
  final TextEditingController _notesController = TextEditingController();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

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

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      setState(() {
        _cart.add(sandwich, quantity: _quantity);
      });

      String sizeText;
      if (_isFootlong) {
        sizeText = 'footlong';
      } else {
        sizeText = 'six-inch';
      }
      String confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';

      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
      SnackBar snackBar = SnackBar(
        content: Text(confirmationMessage),
        duration: const Duration(seconds: 2),
      );
      scaffoldMessenger.showSnackBar(snackBar);
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
  }

  void _navigateToCartView() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CartViewScreen(cart: _cart),
      ),
    );
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    List<DropdownMenuEntry<SandwichType>> entries = [];
    for (SandwichType type in SandwichType.values) {
      Sandwich sandwich =
          Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
      DropdownMenuEntry<SandwichType> entry = DropdownMenuEntry<SandwichType>(
        value: type,
        label: sandwich.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> entry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  String _getCurrentImagePath() {
    final Sandwich sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Image not found',
                        style: normalText,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: const Text('Sandwich Type'),
                textStyle: normalText,
                initialSelection: _selectedSandwichType,
                onSelected: (SandwichType? value) {
                  if (value != null) {
                    setState(() => _selectedSandwichType = value);
                  }
                },
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Six-inch', style: normalText),
                  Switch(
                    value: _isFootlong,
                    onChanged: (value) => setState(() => _isFootlong = value),
                  ),
                  const Text('Footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownMenu<BreadType>(
                width: double.infinity,
                label: const Text('Bread Type'),
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: (BreadType? value) {
                  if (value != null) {
                    setState(() => _selectedBreadType = value);
                  }
                },
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: _quantity > 0
                        ? () => setState(() => _quantity--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: heading2),
                  IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _navigateToCartView,
                icon: Icons.shopping_cart,
                label: 'View Cart',
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                'Cart: ${_cart.countOfItems} items - £${_cart.totalPrice.toStringAsFixed(2)}',
                style: normalText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
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
```
`lib/views/cart_view_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen_view.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartViewScreen extends StatefulWidget {
  final Cart cart;

  const CartViewScreen({super.key, required this.cart});

  @override
  State<CartViewScreen> createState() {
    return _CartViewScreenState();
  }
}

class _CartViewScreenState extends State<CartViewScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  String _getSizeText(bool isFootlong) {
    if (isFootlong) {
      return 'Footlong';
    } else {
      return 'Six-inch';
    }
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              for (MapEntry<Sandwich, int> entry in widget.cart.items.entries)
                Column(
                  children: [
                    Text(entry.key.name, style: heading2),
                    Text(
                      '${_getSizeText(entry.key.isFootlong)} on ${entry.key.breadType.name} bread',
                      style: normalText,
                    ),
                    Text(
                      'Qty: ${entry.value} - £${_getItemPrice(entry.key, entry.value).toStringAsFixed(2)}',
                      style: normalText,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Text(
                'Total: £${widget.cart.totalPrice.toStringAsFixed(2)}',
                style: heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _goBack,
                icon: Icons.arrow_back,
                label: 'Back to Order',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
```
`lib/views/app_styles.dart`:
```dart
import 'package:flutter/material.dart';

const TextStyle normalText = TextStyle(
  fontSize: 16,
);

const heading1 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const heading2 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
```
`lib/models/sandwich.dart`:
```dart
enum BreadType { white, wheat, wholemeal }

enum SandwichType {
  veggieDelight,
  chickenTeriyaki,
  tunaMelt,
  meatballMarinara,
}

class Sandwich {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
  });

  String get name {
    switch (type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    String typeString = type.name;
    String sizeString = '';
    if (isFootlong) {
      sizeString = 'footlong';
    } else {
      sizeString = 'six_inch';
    }
    return 'assets/images/${typeString}_$sizeString.png';
  }
}
```
`lib/models/cart.dart`:
```dart
import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart {
  final Map<Sandwich, int> _items = {};

  // Returns a read-only copy of the items and their quantities
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      _items[sandwich] = _items[sandwich]! + quantity;
    } else {
      _items[sandwich] = quantity;
    }
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        _items.remove(sandwich);
      }
    }
  }

  void clear() {
    _items.clear();
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;

    _items.forEach((sandwich, quantity) {
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    });

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    _items.forEach((sandwich, quantity) {
      total += quantity;
    });
    return total;
  }

  int getQuantity(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      return _items[sandwich]!;
    }
    return 0;
  }
}
```
`lib/repositories/pricing_repository.dart`:
```dart
class PricingRepository {
  double calculatePrice({required int quantity, required bool isFootlong}) {
    double price = 0.0;

    if (isFootlong) {
      price = 11.00;
    } else {
      price = 7.00;
    }

    return quantity * price;
  }
}
```

## AI-Driven Development

Start with a definition on these terms:
Vibe Coding Prompt Engineering Prompt-driven Development

Explain why it would be better to use AI in a more reproducible and guided manner.

Add a link to this video: https://www.youtube.com/watch?v=fzYN_kgl-OM
At 16:58 in this video (Copilot Vision chapter) it explains how to use AI to implement features too which can be useful when it comes to the coursework which should already have been released.

Talk about how they can use AI to help them write the specs, use cases, tests, and a requirements document (`requirements.md`) before they start coding. Show some examples. 

Write a simple prompt for them to use with Copilot or ChatGPT to generate a requirements document for features in the cart page.
Then I will add notes on how this initial prompt can be improved iteratively to get better results (e.g., by adding more details, constraints, examples, context, etc.).

Then, talk about how they can use AI to help them implement features based on the requirements document. I will show them screenshots of how I used Copilot to implement features in the cart page. In this case, I will show I will provide my Copilot screenshots of the cart page, provide it with the requirements, and ask it to generate for me features like adding or removing items from the cart.



## Navigation

In the next part of the worksheet, I want to explain navigation in Flutter.
Start with a explanation of routing and navigation in Flutter. Talk about what each of these terms mean. Then explain which would be the best fit for our app.

Below are some of the resources I want to base this worksheet on (see my worked example suggestion at the end of this worksheet):

### Showing a message to the user

In the code provided to them, we already have two screens: the order screen and the cart screen. We also have a button to navigate to the cart screen and a button to navigate back. Explain how this works (what `Navigator.push` and `Navigator.pop` do, what is the stack of screens, etc.).

Note the use of `ScaffoldMessenger` which is a way of showing a message to the user that carries on even if the user navigates to a different screen. We can try this out by navigating to the cart screen after adding a sandwich to the cart. For more information, see the [Flutter documentation of `ScaffoldMessenger`](https://api.flutter.dev/flutter/material/ScaffoldMessenger-class.html).


### Navigating to a new screen and back

In an exercise, in the last worksheet, I have added the link to this documentation page: https://docs.flutter.dev/cookbook/navigation/navigation-basics

I have also added a button to navigate to the cart screen and a button to navigate back. Make sure to explain this to them in a short and simple level.

Here is the content of this documentation page for your info:
```
Navigate to a new screen and back
Cookbook
Navigation
Navigate to a new screen and back
Most apps contain several screens for displaying different types of information. For example, an app might have a screen that displays products. When the user taps the image of a product, a new screen displays details about the product.

Terminology
In Flutter, screens and pages are called routes. The remainder of this recipe refers to routes.

In Android, a route is equivalent to an Activity. In iOS, a route is equivalent to a ViewController. In Flutter, a route is just a widget.

This recipe uses the Navigator to navigate to a new route.

The next few sections show how to navigate between two routes, using these steps:

Create two routes.
Navigate to the second route using Navigator.push().
Return to the first route using Navigator.pop().
1. Create two routes
First, create two routes to work with. Since this is a basic example, each route contains only a single button. Tapping the button on the first route navigates to the second route. Tapping the button on the second route returns to the first route.

First, set up the visual structure:

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Route')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            // Navigate to second route when tapped.
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Route')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
content_copy
2. Navigate to the second route using Navigator.push()
To switch to a new route, use the Navigator.push() method. The push() method adds a Route to the stack of routes managed by the Navigator. Where does the Route come from? You can create your own, or use a platform-specific route such as MaterialPageRoute or CupertinoPageRoute. A platform-specific route is useful because it transitions to the new route using a platform-specific animation.

In the build() method of the FirstRoute widget, update the onPressed() callback:

// Within the `FirstRoute` widget:
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => const SecondRoute(),
    ),
  );
}
content_copy
3. Return to the first route using Navigator.pop()
How do you close the second route and return to the first? By using the Navigator.pop() method. The pop() method removes the current Route from the stack of routes managed by the Navigator.

To implement a return to the original route, update the onPressed() callback in the SecondRoute widget:

// Within the SecondRoute widget
onPressed: () {
  Navigator.pop(context);
}
```

As a worked example show them how modifying the cart page (using the add/remove buttons that they would implement in the #AI-Driven Development section) would work with this navigation system.

Then show them how to send data back and forth between screens. Below are the relevant resources I want to base this on.

### Sending data to a new screen

I want to base this on: https://docs.flutter.dev/cookbook/navigation/passing-data
Here is the content of this documentation page for your info:
```
Send data to a new screen
Cookbook
Navigation
Send data to a new screen
Often, you not only want to navigate to a new screen, but also pass data to the screen as well. For example, you might want to pass information about the item that's been tapped.

Remember: Screens are just widgets. In this example, create a list of todos. When a todo is tapped, navigate to a new screen (widget) that displays information about the todo. This recipe uses the following steps:

Define a todo class.
Display a list of todos.
Create a detail screen that can display information about a todo.
Navigate and pass data to the detail screen.
1. Define a todo class
First, you need a simple way to represent todos. For this example, create a class that contains two pieces of data: the title and description.

class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}
content_copy
2. Create a list of todos
Second, display a list of todos. In this example, generate 20 todos and show them using a ListView. For more information on working with lists, see the Use lists recipe.

Generate the list of todos
final todos = List.generate(
  20,
  (i) => Todo(
    'Todo $i',
    'A description of what needs to be done for Todo $i',
  ),
);
content_copy
Display the list of todos using a ListView
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(todos[index].title));
  },
)
content_copy
So far, so good. This generates 20 todos and displays them in a ListView.

3. Create a Todo screen to display the list
For this, we create a StatelessWidget. We call it TodosScreen. Since the contents of this page won't change during runtime, we'll have to require the list of todos within the scope of this widget.

We pass in our ListView.builder as body of the widget we're returning to build(). This'll render the list on to the screen for you to get going!

class TodosScreen extends StatelessWidget {
  // Requiring the list of todos.
  const TodosScreen({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      //passing in the ListView.builder
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(todos[index].title));
        },
      ),
    );
  }
}
content_copy
With Flutter's default styling, you're good to go without sweating about things that you'd like to do later on!

4. Create a detail screen to display information about a todo
Now, create the second screen. The title of the screen contains the title of the todo, and the body of the screen shows the description.

Since the detail screen is a normal StatelessWidget, require the user to enter a Todo in the UI. Then, build the UI using the given todo.

class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({super.key, required this.todo});

  // Declare a field that holds the Todo.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
content_copy
5. Navigate and pass data to the detail screen
With a DetailScreen in place, you're ready to perform the Navigation. In this example, navigate to the DetailScreen when a user taps a todo in the list. Pass the todo to the DetailScreen.

To capture the user's tap in the TodosScreen, write an onTap() callback for the ListTile widget. Within the onTap() callback, use the Navigator.push() method.

body: ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      // When a user taps the ListTile, navigate to the DetailScreen.
      // Notice that you're not only creating a DetailScreen, you're
      // also passing the current todo through to it.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => DetailScreen(todo: todos[index]),
          ),
        );
      },
    );
  },
),
```

### Returning data from a screen

Next, show them a simple example of returning data from a screen. I want to base this on: https://docs.flutter.dev/cookbook/navigation/returning-data

```
Return data from a screen
Cookbook
Navigation
Return data from a screen
In some cases, you might want to return data from a new screen. For example, say you push a new screen that presents two options to a user. When the user taps an option, you want to inform the first screen of the user's selection so that it can act on that information.

You can do this with the Navigator.pop() method using the following steps:

Define the home screen
Add a button that launches the selection screen
Show the selection screen with two buttons
When a button is tapped, close the selection screen
Show a snackbar on the home screen with the selection
1. Define the home screen
The home screen displays a button. When tapped, it launches the selection screen.

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Returning Data Demo')),
      // Create the SelectionButton widget in the next step.
      body: const Center(child: SelectionButton()),
    );
  }
}
content_copy
2. Add a button that launches the selection screen
Now, create the SelectionButton, which does the following:

Launches the SelectionScreen when it's tapped.
Waits for the SelectionScreen to return a result.
class SelectionButton extends StatefulWidget {
  const SelectionButton({super.key});

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      child: const Text('Pick an option, any option!'),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute<String>(builder: (context) => const SelectionScreen()),
    );
  }
}
content_copy
3. Show the selection screen with two buttons
Now, build a selection screen that contains two buttons. When a user taps a button, that app closes the selection screen and lets the home screen know which button was tapped.

This step defines the UI. The next step adds code to return data.

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick an option')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Pop here with "Yep"...
                },
                child: const Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Pop here with "Nope"...
                },
                child: const Text('Nope.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
content_copy
4. When a button is tapped, close the selection screen
Now, update the onPressed() callback for both of the buttons. To return data to the first screen, use the Navigator.pop() method, which accepts an optional second argument called result. Any result is returned to the Future in the SelectionButton.

Yep button
ElevatedButton(
  onPressed: () {
    // Close the screen and return "Yep!" as the result.
    Navigator.pop(context, 'Yep!');
  },
  child: const Text('Yep!'),
)
content_copy
Nope button
ElevatedButton(
  onPressed: () {
    // Close the screen and return "Nope." as the result.
    Navigator.pop(context, 'Nope.');
  },
  child: const Text('Nope.'),
)
content_copy
5. Show a snackbar on the home screen with the selection
Now that you're launching a selection screen and awaiting the result, you'll want to do something with the information that's returned.

In this case, show a snackbar displaying the result by using the _navigateAndDisplaySelection() method in SelectionButton:

// A method that launches the SelectionScreen and awaits the result from
// Navigator.pop.
Future<void> _navigateAndDisplaySelection(BuildContext context) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  final result = await Navigator.push(
    context,
    MaterialPageRoute<String>(builder: (context) => const SelectionScreen()),
  );

  // When a BuildContext is used from a StatefulWidget, the mounted property
  // must be checked after an asynchronous gap.
  if (!context.mounted) return;

  // After the Selection Screen returns a result, hide any previous snackbars
  // and show the new result.
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$result')));
}
```

I think the resource below may be overkill for this app but I want to mention it briefly:

### Deep linking and packages like go_router

For our simple app, it is enough to use named routes which are simple to configure but will always push a new screen on top of the current one. For more complex navigation, consider using packages like [go_router](https://pub.dev/packages/go_router) or [auto_route](https://pub.dev/packages/auto_route).
For more information on deep linking, see:
https://docs.flutter.dev/ui/navigation/deep-linking

### Implementing a Profile page

As another worked example in this worksheet, I want to show them how to implement a simple profile page. Remember I don't have a server and I ideally want this app to run on multiple platforms (mobile and web). When doing this example, pick the simplest possible solution and suggest them other ways it could have been done (like some of the other methods above).

At the moment I don't want for the profile details to be persistant (i.e., saved to a database or local storage) but I want to show them how they could do this in the future.

### Other

Add links and briefly describe other navigation methods like tabs: https://docs.flutter.dev/cookbook/design/tabs

Add the link to the documentation of configuring URL-based navigation: https://docs.flutter.dev/ui/navigation/url-strategies