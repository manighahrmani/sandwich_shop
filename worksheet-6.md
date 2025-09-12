# **Worksheet 6 — AI-Driven Development and Navigation**

## **What you need to know beforehand**

Ensure that you have already completed the following:

- [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
- [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).
- [Worksheet 2 — Stateless Widgets](./worksheet-2.md).
- [Worksheet 3 — Stateful widgets](./worksheet-3.md).
- [Worksheet 4 — App Architecture and Testing](./worksheet-4.md).
- [Worksheet 5 — Data Models and Assets](./worksheet-5.md).

## **Getting help**

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## **Getting started**

For this worksheet, you need to start with the code from branch 6 of our [GitHub repository](https://github.com/manighahrmani/sandwich_shop/tree/6). You can either clone the repository and checkout branch 6:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git checkout 6
```

Or manually ensure your code matches the repository. Run the app to make sure everything works as expected before proceeding.

## **Introduction to AI-Driven Development**

One of the learning outcomes of this module is AI-driven development. We have been hinting at this in the earlier worksheets but let's formalise things a little. Below are the different ways developers use AI:

- **Vibe Coding**: This refers to the informal and passive approach where developers ask AI for quick solutions without much structure or planning. While this can be useful for simple tasks, it is not sustainable for larger projects and often leads to inconsistent results and technical debt.

- **Prompt Engineering**: The practice of crafting specific, well-structured prompts to get better results from AI models. This involves understanding how to communicate effectively with AI to get the desired output.

- **Prompt-driven Development (PDD)**: A more systematic approach where developers use carefully crafted prompts to guide AI through the entire development process. Prompts often in Markdown format (ending with `.md`, similar to `README.md`) are stored alongside the codebase, modified and refined over time just like code itself. The overall aim is to make AI-driven development a more structured, reproducible and reliable process.

Among some of the advantages of PDD is that well-structured prompts produce more consistent and predictable results. AI can be unpredictable, and predictability is a quality we want in software development. Detailed requirements lead to better code quality and fewer bugs and in case any of the generated code has issues, we can always go back to the prompt and refine it. 

You can learn more about using AI for feature implementation in this video: [AI-Powered App Development with Flutter](https://www.youtube.com/watch?v=fzYN_kgl-OM). The section at 16:58 (Copilot Vision) is particularly relevant for your coursework, as it shows how you can use images and prompts to guide the AI. We will be covering some of these concepts in this worksheet.

### **Prompt-Driven Development**

Instead of jumping straight into coding, let's start by using AI to help us write proper requirements for a new feature.

Run the app and add a few sandwiches to your cart. You should see a snack bar confirming the addition. Now, you can see that we have implemented a second screen "CartViewScreen" in `lib/views/cart_view_screen.dart` that displays the items in the cart. You can navigate to this screen from the order screen in `lib/views/order_screen_view.dart` by pressing the "View Cart" button. When you navigate to the cart page with the "View Cart" button, you should see the items you added along with their prices and the total price. This is what the cart page should look like:

![Initial Cart Page](images/screenshot_initial_cart_page.png)

Let's say we want to enhance our cart functionality. Instead of immediately asking for code, we'll first ask our AI assistant to create a prompt. Here's a sample prompt you can use with your AI assistant (if you are using Copilot, set it to "Ask" mode):

```
I have a sandwich shop app written in Flutter. I need your help writing good prompt I can send to an LLM to help me implement a new feature.

I have two pages: an order screen where users can select sandwiches and add them to their cart, and a cart screen where users can see the items in their cart and the total price.

I want to let the users modify the items in their cart. There are different ways a user might want to modify their cart like changing quantity or removing items entirely.

For each of these features, include a clear description and what should happen when the user performs an action. Output the result in a Markdown code block.
```

This initial prompt can be improved by adding more specific details about the current app structure. You could for example include:
```
The app currently has these models:
- Sandwich (with type, size, bread type)
- Cart (with add/remove/clear methods and total price calculation)
It also has one repository:
- Pricing (calculates prices based on quantity and size, the price of a sandwich has nothing to do with its type or bread)
```

This is what we initially got back from the AI: [prompt.md](https://github.com/manighahrmani/sandwich_shop/blob/2157fc03bb82e63206101518e408f1e02762ec54/prompt.md).

You can also talk about the UI requirements or edge cases you want the code to handle for example, if the user tries to reduce the quantity of an item below 1, it should remove the item entirely from the cart.

Save the output as `prompt.md` in your project directory. Review the document and manually edit it if needed.

In our case, we asked the AI to refine the prompt after providing it with a screenshot of the current cart page, and an overview of the app structure and the functionality of the models and repository. You could also provide the AI with screenshots of other apps such as Deliveroo or Uber Eats to give it a better idea of what you want. 

This is what we ended up with: [prompt.md](https://github.com/manighahrmani/sandwich_shop/blob/5b8512d5a5b2074c3dada7a1de213860f5110433/prompt.md#L65).

#### **Commit your changes**

Before moving on, commit your prompt file with an appropriate commit message (remember in PDD, prompts are part of the codebase).

### **Requirements Document**

Once you have solid prompt, you can use AI to write a requirements document for you. Here's a sample prompt you can use:

```
Write a detailed requirements document for the feature described in my previous prompt. The requirements should include:

1. A clear description of the feature and its purpose
2. User stories that describe how different users will interact with the feature
3. Acceptance criteria that define when the feature is considered complete

Respond in a structured Markdown format with separate subtasks.
```

This is what we got back from Copilot after a few modifications: [requirements.md](https://github.com/manighahrmani/sandwich_shop/blob/75d4eb7e53024b0868c3acd450cb7f028240cbc5/requirement.md#L5).

#### **Commit your changes**

Before implementing the feature, commit your requirements document with an appropriate commit message.

### **From Requirements to Implementation**

Now that you have a clear requirements document, you can use it to guide your implementation. Here's a sample prompt you can use:

```
Let's implement the feature described in my requirements document.

Implement each subtask separately (I want to commit each one individually). For each subtask, explain your changes in detail, let me see what files you are modifying and then we can proceed to the next subtask.
```

Remember when using Copilot, you can set it to "Edit" mode to let it modify your files directly. Additionally, provide it with context by pasting relevant parts of your codebase (you can do this by entering a hash symbol `#` followed by the name of the file, for example `#cart.dart`).

See how we paused after each subtask to review the changes before reading them, accepting them, testing them and separately committing them. This is an important part of the PDD process, as it allows you to ensure that the AI is producing code that meets your requirements and adheres to best practices.

![Using Copilot to implement cart modifications](images/screenshot_pdd_implementation_step.png)

Once you have completed all the subtasks, test your app to ensure everything works as expected and as before update the widget tests for the `cart_view_screen.dart` in `test/widget/cart_view_screen_test.dart` to cover the new functionality.

Here is a screenshot of our cart page after implementing the modifications:

![Updated Cart Page](images/screenshot_final_cart_page.png)

As before, remember to update the widget tests for the `cart_view_screen.dart` in `test/widget/cart_view_screen_test.dart` to cover the new functionality you have added.

#### **Commit your changes**

Once you have implemented the feature, commit your changes with an appropriate commit message.

## **Navigation in Flutter**

In one of [the exercises from last week's worksheet](./worksheet-5.md#exercises), we started you off with creating the cart screen and navigating to it from the order screen. This week's code provides our simple implementation of the cart screen. Let's take a closer look at this and how navigation works in Flutter.

Here are some key terms to understand:

- **Route**: In Flutter, a route is simply a widget that represents a screen or page. This is equivalent to an Activity in Android or a ViewController in iOS. In a web app, this would be an equivalent to a URL path taking you to a different page.
- **Navigator**: A widget that manages a [stack](https://en.wikipedia.org/wiki/Stack_(abstract_data_type)) of routes. It handles pushing new routes onto the stack and popping them off.

Think of navigation as a stack of cards. When you navigate to a new screen, you place (push) a new card on top of the stack. When you go back, you remove (pop) the top card, revealing the previous screen underneath.

For our sandwich shop app, basic navigation using `Navigator.push()` and `Navigator.pop()` is sufficient. More complex apps might benefit from packages like [go_router](https://pub.dev/packages/go_router), but we'll stick to the basics for now.

### **Basic Navigation Patterns**

This is our current navigation pattern which is the most common and simple one.

In `lib/views/order_screen_view.dart`, inside the `_OrderScreenState` class, we have a "View Cart" button that on press calls the `_navigateToCartView()` method shown below:

```dart
void _navigateToCartView() {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => CartViewScreen(cart: _cart),
    ),
  );
}
```

`CartViewScreen` is the constructor of the cart screen widget defined in `lib/views/cart_view_screen.dart`. The `Navigator.push()` method takes the current `context` (which is a reference to the current widget tree) and a `MaterialPageRoute` object that defines the new route to be pushed onto the stack. The `builder` parameter of `MaterialPageRoute` is a function that returns the widget for the new screen.

Basically, all you need to know is that `Navigator.push()` adds a new screen on top of the current one, in this case, `CartViewScreen`:

```dart
class CartViewScreen extends StatefulWidget {
  final Cart cart;

  const CartViewScreen({super.key, required this.cart});

  @override
  State<CartViewScreen> createState() {
    return _CartViewScreenState();
  }
}
```

When the user wants to go back, we have added a "Back to Order" button in the cart screen that calls `Navigator.pop(context)` to return to the previous screen.

### **Showing Messages Across Navigation**

Something small but important to note is that Flutter provides a way to show messages that persist across navigation.

Notice in your current code that we use `ScaffoldMessenger` to show snack bars:

```dart
ScaffoldMessenger.of(context).showSnackBar(snackBar);
```

This is important because `ScaffoldMessenger` ensures the message persists even if the user navigates to a different screen. Try this: add a sandwich to your cart, then immediately navigate to the cart view. You'll see the confirmation message appears on the cart screen, not just the order screen.

## **Passing Data Between Screens**

###  **Passing Data to a Screen**

Often, you need to do more than just showing a message that carries over navigation. You might want to send data to a new screen or receive data back from it. 

In fact, this is already being done in your app. When navigating to the cart screen from the order screen, you pass the cart object (this is how `OrderScreen` constructs a `CartViewScreen`):

```dart
CartViewScreen(cart: _cart)
```

The `CartViewScreen` screen then receives this data through its constructor:

```dart
class CartViewScreen extends StatefulWidget {
  final Cart cart;
  
  const CartViewScreen({super.key, required this.cart});
  // ...
}
```

This is the standard way to pass data to a new screen in Flutter. The receiving widget declares the data it needs in its constructor, and the sending widget provides it during navigation.

### **Returning Data from a Screen**

Things become slightly more complex when you want to get data back from a screen. For example, you might want to return a confirmation when an order is placed.

Let's implement a checkout flow to demonstrate this concept.

We'll create a checkout screen that processes the order and returns confirmation data back to the cart screen. This will demonstrate how to pass data back from a screen using navigation.

First, create a new file `lib/views/checkout_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // A fake delay to simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    final Map orderConfirmation = {
      'orderId': orderId,
      'totalAmount': widget.cart.totalPrice,
      'itemCount': widget.cart.countOfItems,
      'estimatedTime': '15-20 minutes',
    };

    // Check if this State object is being shown in the widget tree
    if (mounted) {
      // Pop the checkout screen and return to the order screen with the confirmation
      Navigator.pop(context, orderConfirmation);
    }
  }

  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    PricingRepository repo = PricingRepository();
    return repo.calculatePrice(
        quantity: quantity, isFootlong: sandwich.isFootlong);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [];

    columnChildren.add(const Text('Order Summary', style: heading2));
    columnChildren.add(const SizedBox(height: 20));

    for (MapEntry<Sandwich, int> entry in widget.cart.items.entries) {
      final Sandwich sandwich = entry.key;
      final int quantity = entry.value;
      final double itemPrice = _calculateItemPrice(sandwich, quantity);

      final Widget itemRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${quantity}x ${sandwich.name}',
            style: normalText,
          ),
          Text(
            '£${itemPrice.toStringAsFixed(2)}',
            style: normalText,
          ),
        ],
      );

      columnChildren.add(itemRow);
      columnChildren.add(const SizedBox(height: 8));
    }

    columnChildren.add(const Divider());
    columnChildren.add(const SizedBox(height: 10));

    final Widget totalRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Total:', style: heading2),
        Text(
          '£${widget.cart.totalPrice.toStringAsFixed(2)}',
          style: heading2,
        ),
      ],
    );
    columnChildren.add(totalRow);
    columnChildren.add(const SizedBox(height: 40));

    columnChildren.add(
      const Text(
        'Payment Method: Card ending in 1234',
        style: normalText,
        textAlign: TextAlign.center,
      ),
    );
    columnChildren.add(const SizedBox(height: 20));

    if (_isProcessing) {
      columnChildren.add(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      columnChildren.add(const SizedBox(height: 20));
      columnChildren.add(
        const Text(
          'Processing payment...',
          style: normalText,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      columnChildren.add(
        ElevatedButton(
          onPressed: _processPayment,
          child: const Text('Confirm Payment', style: normalText),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: columnChildren,
        ),
      ),
    );
  }
}
```

Commit your changes and add widget tests for the new checkout screen in `test/widget/checkout_screen_test.dart`.

Now, update your `cart_view_screen.dart` and add the import for the CheckoutScreen at the top of the file:

```dart
import 'package:sandwich_shop/views/checkout_screen.dart';
```

In the `_CartViewScreenState` class, add this method to navigate to the checkout screen and handle the returned data:

```dart
Future<void> _navigateToCheckout() async {
  if (widget.cart.items.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your cart is empty'),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CheckoutScreen(cart: widget.cart),
    ),
  );

  if (result != null && mounted) {
    setState(() {
      widget.cart.clear();
    });

    final String orderId = result['orderId'] as String;
    final String estimatedTime = result['estimatedTime'] as String;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}
```


Then add a checkout button to your cart screen's UI. In the `build` method of `_CartViewScreenState`, add this button after the total price display. You can add it just before the "Back to Order" button:

```dart
const SizedBox(height: 20),
Builder(
  builder: (BuildContext context) {
    final bool cartHasItems = widget.cart.items.isNotEmpty;
    if (cartHasItems) {
      return StyledButton(
        onPressed: _navigateToCheckout,
        icon: Icons.payment,
        label: 'Checkout',
        backgroundColor: Colors.orange,
      );
    } else {
      return const SizedBox.shrink();
    }
  },
),
const SizedBox(height: 20),
```

You'll also notice that `CartViewScreen` uses the `StyledButton` widget. Add this import to the top of your `cart_view_screen.dart` file for this:

```dart
import 'package:sandwich_shop/views/order_screen_view.dart';
```

The `_navigateToCheckout()` method uses `await` when calling `Navigator.push()`to wait for the checkout screen to return data which we store in `result`. The `MaterialPageRoute` specifies that we expect a result to be returned from the checkout screen. When the payment is processed successfully, the checkout screen returns order confirmation data.

We first check that the result is not null and that the widget is still mounted (i.e., it hasn't been disposed of). If so, we clear the cart and update the UI. We show a success message with the order ID and estimated time to give users feedback about their order.

Run your app and test the checkout flow. Add some sandwiches to your cart, navigate to the cart view, and press the "Checkout" button. Press "Confirm Payment" and observe how the order confirmation data is passed back and the UI responds accordingly.

#### **Commit your changes**

We have not added reminders to commit your changes along the way but hopefully you have been making separate commits after each step of change and after each time you run to verify a change in your code.

## **Exercises**

Complete the exercises below. Remember to commit your changes after each exercise and use your AI assistant to help you think through the problems rather than just asking for the solution.

1. Let's add a simple profile screen where users can enter their details. For now, you can add a link to this screen at the bottom of your order screen (we will fix this in the next exercise).

  As we did earlier in [this worksheet](#prompt-driven-development), use your AI assistant to help you write a prompt for this feature.

  At the end of this exercise you should have created a new screen `lib/views/profile_screen.dart` and with a `ProfileScreen` class. There's no need to perform any actual authentication or data persistence for this exercise. We will do this next week. You can decide how and where the user can access this screen from the existing app.

  Make sure to write widget tests for your profile screen.

   ⚠️ **Show your working profile screen to a member of staff** for a sign-off.

2. Let's enhance our app's navigation by adding a drawer menu that provides easy access to different screens. This is a common pattern in mobile apps that allows users to navigate between major sections.

   A `Drawer` is a panel that slides in from the edge of a `Scaffold` to show the app's main navigation options. You can read more about it in its [documentation page](https://api.flutter.dev/flutter/material/Drawer-class.html). For now, you'll implement a drawer that includes navigation to your profile screen, cart view, and potentially other sections of your app.

   Ask your AI assistant to explain how `Drawer` widgets work and how they integrate with the `AppBar`. Could you have this drawer accessible from all screens in your app?

   Consider how the drawer should behave when navigating between screens. Should it replace the current screen or push a new one onto the navigation stack? Ask your AI assistant about the difference between `Navigator.push()` and `Navigator.pushReplacement()` in this context.

   Test your implementation by navigating between different screens using the drawer and ensure the navigation behaves as expected and as always, update your widget tests to cover the new navigation drawer functionality.

   ⚠️ **Show your working navigation drawer to a member of staff** for a sign-off.

4. (Advanced) Configure your app to handle [deep links](https://docs.flutter.dev/ui/navigation/deep-linking) using GoRouter, which is the recommended approach for URL-based navigation in Flutter.

   Add the `go_router` package to your project by running `flutter pub add go_router`. GoRouter uses the Router API to provide URL-based navigation that works seamlessly across mobile and web platforms, replacing the older named routes approach which is no longer recommended.

   Ask your AI assistant to help you refactor your app to use `MaterialApp.router` with GoRouter instead of the basic MaterialApp. You'll need to define routes for your main screens like `/`, `/cart`, and `/profile`.

   GoRouter automatically handles deep linking on web platforms. For mobile platforms, enable Flutter's deep linking by adding the appropriate metadata to your platform configuration files (see [this documentation page](https://docs.flutter.dev/ui/navigation/deep-linking)).

   Test your implementation by running the app on your browser and typing URLs like `localhost:port/#/cart` in the address bar. The navigation should work correctly with proper browser back button support.

   This task is **optional** and there's no need to show it to a member of staff for a sign-off.

5. (Advanced) Create a settings screen where users can configure app preferences like default sandwich size, preferred bread type, and notification preferences. This exercise introduces you to data persistence concepts that we'll cover more thoroughly in the next worksheet.

   For now, you'll use the `shared_preferences` package to store simple key-value pairs. Add this package to your project by running `flutter pub add shared_preferences` in your terminal. This package allows you to save user preferences that persist between app sessions.

   Ask your AI assistant to help you create a settings screen that allows users to set default preferences for their sandwich orders. The screen should save these preferences using SharedPreferences and load them when the app starts. You'll also need to update your order screen to use these saved preferences as default values.

   Think about what preferences would be most useful for users to set. Consider default sandwich size, preferred bread type, and whether they want notifications enabled. The settings should be applied immediately when the user changes them and should persist when they restart the app.

   Test your implementation by changing settings, closing the app completely, and reopening it to verify that your preferences are remembered. You can also use your AI assistant to help you understand how SharedPreferences works and how to handle loading preferences asynchronously.

   This task is **optional** and there's no need to show it to a member of staff for a sign-off.