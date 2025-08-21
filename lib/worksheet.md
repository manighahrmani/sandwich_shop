# Worksheet 3 — Stateful Widgets

## What You Need To Know Beforehand

Ensure that you have already completed the following:

  - [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
  - [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).
  - [Worksheet 2 — Stateless Widgets](./worksheet-2.md).

## Getting Help

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## Introduction to State

In the last worksheet, all our widgets were `Stateless`. This means their properties, once set, could not be changed. But what happens when we want our app to be interactive? What if we want to press a button and see something on the screen change, like the number of sandwiches in our order? To do this, we need to manage state.

In Flutter, we can think of state in two main categories: Ephemeral state and App state.

Ephemeral state This is the state that is neatly contained within a single widget. For example, the quantity of items in a cart is an ephemeral state of the cart widget. Other parts of the app don't need to access this state. It's local. For this kind of state, a `StatefulWidget` is often the perfect tool.

App state is state that you need to share across different parts of your app and potentially keep between user sessions. A simple example is the login information in a social media app. We will cover app state and persistence (saving data) in a later worksheet.

For this worksheet, we will focus on ephemeral state. In our sandwich counter, the number of sandwiches the user has added to their cart (the `State`) doesn't need to be known by any other widget. If the user closes the app, we don't mind if the `State` rests. This makes it a perfect candidate for a `StatefulWidget`.

## From Stateless to Stateful

We are starting with [the code that we ended Worksheet 2 with](https://github.com/manighahrmani/sandwich_shop/blob/2/lib/main.dart). If you have completed some of the exercises and your code looks slightly different, that's okay! Just make sure you understand the changes we're making from this point onward.

So far, our code only uses `StatelessWidget`s. As a reminder, stateless widgets are immutable. This means that once they are built, their properties cannot change. They are like a photograph: a snapshot of the User Interface (UI) at a particular point in time. If you want to find out more about them, watch this [YouTube video on StatelessWidgets](https://youtu.be/wE7khGHVkYY).

To make our sandwich counter interactive, for example to allow the users to add sandwiches to their order, we need to have mutable (changeable) variable(s). This is where we need to add a `StatefulWidget` to our code. What is slightly special about `StatefulWidget`s is that we have to introduce two new classes:

1.  A `StatefulWidget` class.
2.  A `State` class.

In the case of `StatelessWidget`s, there is no separate state class. The widget itself holds all the data/configurations it needs to build its UI element. And since these configurations are immutable, they are marked as `final`. Currently, `quantity` and `itemType` are immutable properties of the `Stateless` widget `OrderItemDisplay`.

The `StatefulWidget` on the other hand separates the widget's configuration from its mutable state.

The `StatefulWidget` class is responsible for creating the `State` class, while the `State` class holds the mutable state for the widget. There may also be some immutable configurations and the `StatefulWidget` itself can hold these as `final` properties.

## Creating the `OrderScreen` StatefulWidget

First, we will create a new widget called `OrderScreen` which will manage the state of our order.

#### Define the `OrderScreen` Widget and its State

Replace the `Scaffold` in your `App` widget's `build` method with a new `OrderScreen` widget. Then, below the `App` class, add the definitions for `OrderScreen` and its state class, `_OrderScreenState`.

Your `App` widget should now look like this:

```dart
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

Now, add the new `StatefulWidget` and its `State` class below `App`:

```dart
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: OrderItemDisplay(
          _quantity,
          'Footlong',
        ),
      ),
    );
  }
}
```

#### Understanding StatefulWidget and State

You'll notice we now have two new classes. Let's break them down:

1.  **`OrderScreen`**: This class extends `StatefulWidget`. Like a `StatelessWidget`, it can have immutable `final` properties that are passed in via its constructor (e.g., `maxQuantity`). The widget itself is immutable. Its main job is to create its partner `State` object via the `createState()` method.

2.  **`_OrderScreenState`**: This class extends `State`. This is where the magic happens.

      * It holds the **mutable state**, the data that can change over time. In our case, this is the `_quantity` variable. The underscore `_` at the beginning of its name indicates that this variable is *private* to its class.
      * The `build()` method is now inside this `State` class, not the `StatefulWidget`.
      * Inside the `build()` method, we can access the mutable state directly (e.g., `_quantity`).
      * We can also access the properties of the parent `StatefulWidget` using the `widget` property (e.g., `widget.maxQuantity`).

The framework cleverly keeps the `_OrderScreenState` object around, even if the `OrderScreen` widget itself is rebuilt. This ensures that our `_quantity` value is not lost during UI updates.

## Handling User Input with `setState()`

Our screen now displays the quantity, but we have no way to change it. Let's add two buttons, "Add" and "Remove", to modify the `_quantity`.

#### Add Buttons and Interaction Methods

First, let's update the `build` method in `_OrderScreenState` to include the buttons. We will wrap our `OrderItemDisplay` in a `Column` to stack the display and the buttons vertically.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Sandwich Counter'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          OrderItemDisplay(
            _quantity,
            'Footlong',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: null, // We will implement this next
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: null, // We will implement this next
                child: const Text('Remove'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
```

Next, add two methods inside the `_OrderScreenState` class to handle the logic for increasing and decreasing the quantity.

```dart
class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity = _quantity + 1;
      });
    }
  }

  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity = _quantity - 1;
      }
    });
  }

  // ... build method from above
}
```

#### The Power of `setState()`

Notice the call to `setState()` inside our new methods. This is one of the most important methods in Flutter state management.

Calling `setState()` tells the Flutter framework: "Hey, I've changed some of my internal state. Please rebuild my widget so the user can see the changes."

When `setState()` is called, Flutter schedules a rebuild for this widget. During the next frame, it will call the `build()` method again. Because `_quantity` has been updated, the `OrderItemDisplay` widget will be rebuilt with the new value, and the user will see the updated count on the screen.

It is crucial that you only modify state variables inside the function passed to `setState()`. If you change `_quantity` outside of `setState()`, Flutter won't know that it needs to rebuild, and the UI will not update.

For a more detailed explanation, watch this video: [StatefulWidget (Widget of the Week)](https://youtu.be/AqCMFXEmf3w).

#### Connect the Methods to the Buttons

Finally, let's connect our new methods to the `onPressed` property of our `ElevatedButton` widgets.

Update the `Row` in your `build` method:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton(
      onPressed: _increaseQuantity,
      child: const Text('Add'),
    ),
    ElevatedButton(
      onPressed: _decreaseQuantity,
      child: const Text('Remove'),
    ),
  ],
),
```

Now, run the app. You should see a screen with the sandwich count and two buttons. Clicking "Add" increases the count (up to the `maxQuantity`), and clicking "Remove" decreases it. You have successfully created an interactive, stateful widget\!

## Final Code

Here is the complete code for `lib/main.dart` at the end of this worksheet. Check your code against this to ensure everything is correct.

```dart
import 'package:flutter/material.dart';

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

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity = _quantity + 1;
      });
    }
  }

  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity = _quantity - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              _quantity,
              'Footlong',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _increaseQuantity,
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: _decreaseQuantity,
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
  }
}
```