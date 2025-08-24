# Worksheet 3 — Stateful widgets

## What you need to know beforehand

Ensure that you have already completed the following:

  - [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
  - [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).
  - [Worksheet 2 — Stateless Widgets](./worksheet-2.md).

## Getting help

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## Introduction to state

In the last worksheet, our widgets were `Stateless`, meaning their properties couldn't change. To make our app interactive, for example, to change the number of sandwiches with a button press, we need to manage state.

State is just data that can change over time. For this worksheet, we will focus on **ephemeral state**. This is a state (or data) that is local to a single widget, for example the content of a cart which is only relevant to that cart widget. (In a later worksheet we will learn about **app state**, which is shared across multiple widgets, for example login information of a user.)

The number of sandwiches in our order is a perfect example of this. To manage this kind of state, Flutter provides the `StatefulWidget`.

## A reminder on stateless widgets

We are starting with [the code that we ended Worksheet 2 with](https://github.com/manighahrmani/sandwich_shop/blob/2/lib/main.dart). If you have completed some of the exercises and your code looks slightly different, that's okay. Just make sure you understand the changes we're making from this point onward.

So far, all of our widgets were stateless. These widgets are immutable. They are like a photograph: a snapshot of the User Interface (UI) at a particular point in time. If you want to find out more about them, watch this [YouTube video on StatelessWidgets](https://youtu.be/wE7khGHVkYY).

#### Adding interactive buttons

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

Here, we've also used two `ElevatedButton` widgets. The most important property of them is `onPressed`. It takes a function that gets executed when the user taps the button. This is called an event handler or a **callback**. Some of you may remember event handlers from last year, they are functions that are invoked in response to an event, in this case, a button press.

For now, our callback is an anonymous function (a function with no name) that just prints a message in the terminal (not on the UI) when they are pressed.

To run the app, open the Command Palette in VS Code with **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS. In there, type `Terminal: Create New Terminal` and hit enter. In the terminal, run the command `flutter run`. You will see the buttons, and when you click them, messages will appear in the Terminal as shown below.

![Output of button presses](images/screenshot_eventhandler.png)

#### Commit your changes

First reopen the Command Palette. In there, type `Source Control: Focus on Changes View`. After reviewing your changes, commit them with a message like `Add add and remove buttons`.

## Creating a `StatefulWidget`

The hardcoded quantity in `OrderItemDisplay(5, 'Footlong')` is a problem because it's static. To make the quantity interactive, we need to replace our static UI with a widget that can manage a changing value. This is where `StatefulWidget` comes in.

We will create a new `StatefulWidget` called `OrderScreen` to manage the state of our sandwich order.

#### Define the `OrderScreen` stateful widget

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

This might look a bit strange. We have two classes to manage one widget. This is a fundamental concept in Flutter state management.

Take a moment to read this structure. Use your AI assistant to find out the answers to these questions:

  * "What is the difference between a `StatefulWidget` and a `State` object in Flutter?"
  * "In Flutter, why is the `build` method inside the `State` class and not the `StatefulWidget` class?"
  * "What does the underscore prefix on `_OrderScreenState` and `_quantity` mean in Dart?"

Understanding this separation is key to working with interactive widgets in Flutter.

#### Commit your changes

Remember to commit your changes with a message like `Define OrderScreen stateful widget` before moving on.

## Building the UI for `OrderScreen`

Now, let's build the UI inside the `_OrderScreenState` class. We want to display the `OrderItemDisplay` and the two buttons we created earlier.

#### Implement the `build` method

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
  );
}
```

Notice how we use `_quantity` when creating the `OrderItemDisplay`. The `State` object can access its own private variables directly.

#### Commit your changes

Commit your changes with a message like `Build UI for OrderScreen`.

#### Update the `App` widget

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

#### Commit your changes

Commit your changes with a message like `Build UI for OrderScreen`.

## Adding interactivity with `setState()`

The final step is to make the buttons work. We need to create methods that change the `_quantity` and then tell Flutter to rebuild the widget to reflect that change.

#### Create helper methods

Inside the `_OrderScreenState` class, add two new methods to handle increasing and decreasing the quantity. These will be the event handlers for the buttons.

Add the following methods inside the `_OrderScreenState` class above the `build` method and below the definition of `_quantity`:

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

The `State` object has a property called `widget`, which gives it access to the associated `StatefulWidget` (`OrderScreen` in this case). This is how we access the immutable `maxQuantity` property using `widget.maxQuantity`.

The most important part is `setState()`. You must call `setState()` to notify Flutter that a state variable has changed. Calling `setState()` tells the  framework that this widget is "dirty" and needs to be rebuilt. Flutter then calls the `build()` method again, and the UI updates with the new `_quantity` value. Simply changing `_quantity = _quantity + 1` without wrapping it in a `setState()` call will not cause the UI to update.

#### Commit your changes

Commit your changes with a message like `Add helper methods for quantity adjustment`.

#### Link the buttons to their event handlers

Now, update the `ElevatedButton`s in your `build` method to call these new functions when they are pressed:

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

As a small task, can you figure out why the buttons only work within a certain range of quantities? If you are confused by this, try to trace the logic in the `_increaseQuantity` and `_decreaseQuantity` methods. Feel free to ask Copilot for help.

To learn more about `StatefulWidget`s, watch this excellent [YouTube video from the Flutter team](https://youtu.be/AqCMFXEmf3w).

#### Commit your changes

Commit your final changes with a message like `Implement counter functionality with setState`.

## Adding Custom Notes to an Order

Let's add some more interactivity to our app. In software development, we often start with a user story to define a new feature. Here is an example:

```
As a user, I want to add a note to my sandwich order so that I can make special requests (e.g., "no onions", "extra pickles").
I would like this note to be displayed on the screen to confirm it has been added to my order.
```

For the remainder of this worksheet, we will implement this feature using Copilot or the LLM of your choice.

### Implementing the Feature

Start by consulting [the Flutter documentation on user input](https://docs.flutter.dev/get-started/fundamentals/user-input) to understand its basic use. Browse through the features and scroll down until you find the [TextField widget](https://docs.flutter.dev/get-started/fundamentals/user-input#textfield). Read this part to understand its basic use.

With the user story and documentation in hand, it's time to collaborate with your AI assistant. Instead of asking for the final code, guide the AI to help you think through the problem. Start by providing the user story and asking questions like the ones below.

  * "I want to implement this user story, what new information does my `OrderScreen` widget need to keep track of?"
  * "How can I add a text input field to my screen using Flutter?"
  * "How do I get the text from the user as they are typing it in the input box?"
  * "Once I have the user's note, how can I display it on the screen below the sandwich counter?"

Remember that while Copilot can access your codebase, LLMs like ChatGPT require you to provide the code snippet (in this case the `OrderScreen` and `_OrderScreenState` classes) for context.

### Refining Your Code with VS Code

As you add new widgets, your code can become messy. First, ensure your code is well-formatted. Right-click anywhere in the `main.dart` file and select **Format Document** (or use the Command Palette to apply this).

Next, look for any blue or yellow squiggly lines. These are hints from the Flutter analyser. For example, if you added an `InputDecoration` to your `TextField`, you might see a blue squiggly line underneath it. Hover over it with your mouse, and a message will likely suggest adding a `const` modifier. You can click **Quick Fix...** or press **Ctrl + .** on Windows or **Cmd + .** on macOS to apply the suggestion automatically.

### Commit Your Changes

Make sure to have hot reload enabled by hitting the thunder (⚡️) icon in the toolbar or by typing `r` in the terminal if you are running the app there.

After verifying that the feature works as described in the user story, commit your work to source control. A good commit message would be `Add order notes field`.

## Exercises ideas

1. Add styling to the buttons and turn them to a custom StatelessWidget

1. Wrap the buttons in a `SizedBox` to give them a fixed size (use the lightbulb icon in VS Code). Then inspect to see where the width actually adds a space to. Then ask them to insert the SizeBox where it should be. Also touch on relative values (MediaQuery)

1. Add a row with a switch like this before the OrderItemDisplay:
```dart
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('6 inch'),
                Switch(
                    value: _itemType == 'footlong', onChanged: _toggleFootlong),
              ],
            ),
```
And a separate callback like this:
```dart
  void _toggleFootlong(bool value) {
    setState(() {
      if (value) {
        _itemType = 'footlong';
      } else {
        _itemType = 'six-inch';
      }
    });
  }
```

