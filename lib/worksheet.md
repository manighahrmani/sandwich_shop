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

**Ephemeral state** This is the state that is contained within a single widget. For example, the quantity of items in a cart is an ephemeral state of the cart widget. Other parts of the app don't need to access this state. It's local. For this kind of state, a `StatefulWidget` is often the perfect tool.

**App state** is state that you need to share across different parts of your app and potentially keep between user sessions. A simple example is the login information in a social media app. We will cover app state and persistence (saving data) in a later worksheet.

For this worksheet, we will focus on ephemeral state. In our sandwich counter, the number of sandwiches the user has added to their cart (the `State`) doesn't need to be known by any other widget. If the user closes the app, we don't mind if the `State` resets. This makes it a perfect candidate for a `StatefulWidget`.

## From Stateless to Stateful

We are starting with [the code that we ended Worksheet 2 with](https://github.com/manighahrmani/sandwich_shop/blob/2/lib/main.dart). If you have completed some of the exercises and your code looks slightly different, that's okay. Just make sure you understand the changes we're making from this point onward.

So far, our code only uses `StatelessWidget`s. As a reminder, stateless widgets are immutable. This means that once they are built, their properties cannot change. They are like a photograph: a snapshot of the User Interface (UI) at a particular point in time. If you want to find out more about them, watch this [YouTube video on StatelessWidgets](https://youtu.be/wE7khGHVkYY).

To make our sandwich counter interactive, for example to allow the users to add sandwiches to their order, we need to have mutable (changeable) variable(s). This is where we need to add a `StatefulWidget` to our code. What is slightly special about `StatefulWidget`s is that we have to introduce two new classes:

1.  A `StatefulWidget` class.
2.  A `State` class.

In the case of `StatelessWidget`s, there is no separate state class. The widget itself holds all the data/configurations it needs to build its UI element. And since these configurations are immutable, they are marked as `final`. Currently, `quantity` and `itemType` are immutable properties of the `Stateless` widget `OrderItemDisplay`.

The `StatefulWidget` on the other hand separates the widget's configuration from its mutable state. The `StatefulWidget` class itself is responsible for creating the `State` class, while the `State` class holds the mutable state for the widget. There may also be some immutable configurations and the `StatefulWidget` itself can hold these as `final` properties.

In other words, the `StatefulWidget` is the permanent description of a part of your UI (like a blueprint for a house), while the `State` object holds the current, changeable data (like the people and furniture inside the house). When the data in the `State` object changes, Flutter uses the original blueprint (`StatefulWidget`) to rebuild the house with its new contents.

## Creating an `OrderScreen` Widget

We will create a new `StatefulWidget` called `OrderScreen` to manage the state of our sandwich order.

#### Define the `OrderScreen` StatefulWidget

Add the following two classes to your `lib/main.dart` file. You can place them above the `OrderItemDisplay` class.

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
    return const Placeholder();
  }
}
```

You may get a warning stating that value of the field `_quantity` isn't used or that it can be `final`. Ignore it for now.

There are a lot of new concepts here and feel free to use Copilot or your LLM of choice to explain them. But first read our simple description below:

`OrderScreen` is our `StatefulWidget`. It's still immutable and contains a `final` property `maxQuantity`. Its job is to create its associated `State` object via the `createState()` method. All `StatefulWidget`s need to do this (select the `createState()` method with your mouse and comment it out with **Ctrl + /** on Windows or **⌘ + /** on macOS to see what happens).

`_OrderScreenState` is our `State` class. Its name starts with an underscore, indicating that it's private to the file (a convention in Dart). This is where our mutable state lives, like the `_quantity` variable. Notice it's not `final` (unlike the `quantity` instance variable in `OrderItemDisplay`). The `build()` method is also in this class, not in the `StatefulWidget`.

#### Commit Your Changes

Recall that you can open the Command Palette in VS Code with **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS. In there, type `Source Control: Focus on Changes View`.

After reviewing your changes, commit them with a message like `Define OrderScreen stateful widget`. But don't run the app yet.

## Building the UI for `OrderScreen`

Now, let's build the UI inside the `_OrderScreenState` class. We want to display the `OrderItemDisplay` and two buttons to "Add" and "Remove" sandwiches.

#### Implement the `build` Method

Replace the `Placeholder()` in the `_OrderScreenState`'s `build` method with a `Scaffold` containing our UI components.

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
                onPressed: null, // We'll add this later
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: null, // And this one too
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

Notice how we use `_quantity` directly in the `OrderItemDisplay`. The `State` object can access its own private variables. We've also added two `ElevatedButton` widgets, but they don't do anything yet because their `onPressed` handlers are `null`.

#### Update the `App` Widget

Finally, let's update our main `App` widget to use the new `OrderScreen` as its `home`.

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

Recall that `maxQuantity` is a named parameter in the `OrderScreen` constructor (it is placed between curly braces `{}`). Run the app now. You should see the counter displaying "0 Footlong sandwich(es):" and two disabled buttons.

---

#### Commit Your Changes

Commit your changes with a message like `Build UI for OrderScreen`.

## Adding Interactivity with `setState()`

The final step is to make the buttons work. We need to create methods that change the `_quantity` and then tell Flutter to rebuild the widget to reflect that change.

#### Create Helper Methods

Inside the `_OrderScreenState` class, add two new methods to handle increasing and decreasing the quantity.

```dart
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
```

Let's look at these methods closely:

  - `widget.maxQuantity`: The `State` object has a property called `widget`, which gives it access to the associated `StatefulWidget` (`OrderScreen` in this case). This is how we access the immutable `maxQuantity` property from the `State` class.
  - `setState()`: This is the most important part. You **must** call `setState()` to notify Flutter that a state variable has changed. Calling `setState()` tells the framework that this widget is "dirty" and needs to be rebuilt. Flutter then calls the `build()` method again, and the UI updates with the new `_quantity` value. Simply changing `_quantity = _quantity + 1` without wrapping it in a `setState()` call will not cause the UI to update.

#### Wire Up the Buttons

Now, update the `ElevatedButton`s in your `build` method to call these new functions.

```dart
ElevatedButton(
  onPressed: _increaseQuantity,
  child: const Text('Add'),
),
ElevatedButton(
  onPressed: _decreaseQuantity,
  child: const Text('Remove'),
),
```

Run the app one last time. The buttons should now be enabled, and clicking them will update the sandwich count on the screen.

To learn more about `StatefulWidget`s, watch this excellent [YouTube video from the Flutter team](https://youtu.be/AqCMFXEmf3w).

#### Commit Your Changes

Commit your final changes with a message like `Implement counter functionality with setState`.