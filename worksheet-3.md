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

## A Reminder On Stateless Widgets

We are starting with [the code that we ended Worksheet 2 with](https://github.com/manighahrmani/sandwich_shop/blob/2/lib/main.dart). If you have completed some of the exercises and your code looks slightly different, that's okay. Just make sure you understand the changes we're making from this point onward.

So far, all of our widgets were stateless. These widgets are immutable. They are like a photograph: a snapshot of the User Interface (UI) at a particular point in time. If you want to find out more about them, watch this [YouTube video on StatelessWidgets](https://youtu.be/wE7khGHVkYY).

#### Adding Interactive Buttons

To make our sandwich counter interactive, we first need to add some buttons. Let's add "Add" and "Remove" buttons below our sandwich display. Update the `body` of the `Scaffold` in your `App` widget to use a `Column` and a `Row`. Hopefully you have already learnt about these from [the exercises in worksheet 2](https://manighahrmani.github.io/sandwich_shop/worksheet-2.html#exercises).

```dart
home: Scaffold(
  appBar: AppBar(title: const Text('Sandwich Counter')),
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const OrderItemDisplay(5, 'Footlong'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print('Add button pressed!');
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Remove button pressed!');
              },
              child: const Text('Remove'),
            ),
          ],
        ),
      ],
    ),
  ),
),
```

Here, we've also used two `ElevatedButton` widgets. The most important property of them is `onPressed`. It takes a function that gets executed when the user taps the button. This is called an **event handler** (some of you may have already covered this in Python last year). For now, our buttons just print a message in the terminal (not on the UI) when they are pressed.

To run the app, open the Command Palette in VS Code with **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS. In there, type `Terminal: Create New Terminal` and hit enter. In the terminal, run the command `flutter run`. You will see the buttons, and when you click them, messages will appear in the Terminal as shown below.

![Output of button presses](images/screenshot_eventhandler.png)

#### Commit Your Changes

First reopen the Command Palette. In there, type `Source Control: Focus on Changes View`. After reviewing your changes, commit them with a message like `Add add and remove buttons`.

## Creating a `StatefulWidget` Widget

We do have some interactivity, but it's limited. We can't change the number `5` in `OrderItemDisplay(5, 'Footlong')` because it's hardcoded. To allow users to change the quantity, we need a mutable (changeable) variable to store this value. This is where we need to add a `StatefulWidget`. What is slightly special about `StatefulWidget`s is that we have to introduce two new classes:

1.  A `StatefulWidget` class.
2.  A `State` class.

The `StatefulWidget` separates the widget's configuration from its mutable state. The `StatefulWidget` class itself is responsible for creating the `State` class, while the `State` class holds the mutable state for the widget.

In other words, the `StatefulWidget` is the permanent description of a part of your UI (like a blueprint for a house), while the `State` object holds the current, changeable data (like the people and furniture inside the house). When the data in the `State` object changes, Flutter uses the original blueprint (`StatefulWidget`) to rebuild the house with its new contents.

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

You may get a warning stating that the value of the `_quantity` isn't used or that it can be `final`. Ignore it for now.

`OrderScreen` is our `StatefulWidget`. It's still immutable and contains a `final` property `maxQuantity`. Its job is to create its associated `State` object via the `createState()` method. All `StatefulWidget`s need to do this.

`_OrderScreenState` is our `State` class. This is where our mutable state lives, like the `_quantity` variable. Notice it's not `final`. The `build()` method is also in this class, not in the `StatefulWidget`.

Ask Copilot (or your LLM of choice) why the name of the class and the name of the mutable variable (`_quantity`) start with an underscore.

#### Commit Your Changes

Remember to commit your changes with a message like `Define OrderScreen stateful widget` before moving on.

## Building the UI for `OrderScreen`

Now, let's build the UI inside the `_OrderScreenState` class. We want to display the `OrderItemDisplay` and the two buttons we created earlier.

#### Implement the `build` Method

Replace the returned `Placeholder()` in the `_OrderScreenState`'s `build` method with a `Scaffold` containing our UI components. This structure should look very familiar.

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

Notice how we use `_quantity` when creating the `OrderItemDisplay`. The `State` object can access its own private variables directly. We've also added the two `ElevatedButton` widgets, but they don't do anything yet because their `onPressed` event handlers are `null`.

#### Update the `App` Widget

Finally, let's update our main `App` widget to use the new `OrderScreen` as its `home`. The `App` widget no longer needs its own `Scaffold`.

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

Recall that `maxQuantity` is a named parameter in the `OrderScreen` constructor. It also has a default value of `10`, so we could omit it here and just use `OrderScreen()`.

Run the app now. You should see the counter displaying "0 Footlong sandwich(es):" and two disabled buttons.

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

Let's look at these methods closely. The `State` object has a property called `widget`, which gives it access to the associated `StatefulWidget` (`OrderScreen` in this case). This is how we access the immutable `maxQuantity` property using `widget.maxQuantity`.

The most important part is `setState()`. You **must** call `setState()` to notify Flutter that a state variable has changed. Calling `setState()` tells the framework that this widget is "dirty" and needs to be rebuilt. Flutter then calls the `build()` method again, and the UI updates with the new `_quantity` value. Simply changing `_quantity = _quantity + 1` without wrapping it in a `setState()` call will not cause the UI to update.

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