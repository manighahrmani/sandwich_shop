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

## **Navigation in Flutter**

In one of [the exercises from last week's worksheet](./worksheet-5.md#exercises), we started you off with creating the cart screen and navigating to it from the order screen. This week's code provides our simple implementation of the cart screen. Let's take a closer look at this and how navigation works in Flutter.

Here are some key terms to understand:

- **Route**: In Flutter, a route is simply a widget that represents a screen or page. This is equivalent to an Activity in Android or a ViewController in iOS. In a web app, this would be an equivalent to a URL path taking you to a different page.
- **Navigator**: A widget that manages a [stack](https://en.wikipedia.org/wiki/Stack_(abstract_data_type)) of routes. It handles pushing new routes onto the stack and popping them off.

Think of navigation as a stack of cards. When you navigate to a new screen, you place (push) a new card on top of the stack. When you go back, you remove (pop) the top card, revealing the previous screen underneath.

For our sandwich shop app, basic navigation using `Navigator.push()` and `Navigator.pop()` is sufficient. More complex apps might benefit from packages like [go_router](https://pub.dev/packages/go_router), but we'll stick to the basics for now.

### **Basic Navigation Patterns**

This is our current navigation pattern which is the most common and simple one.

In `lib/views/order_screen_view.dart`, inside the `_OrderScreenViewState` class, we have a button "View Cart" button that on press calls the `_navigateToCartView()` method shown below:

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

When the user wants to go back, we have added a "Back to Order" button in the cart screen that the following `_goBack()` method in the `_CartViewScreenState` class:

```dart
void _goBack() {
  Navigator.pop(context);
}
```

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

In fact, this is already being done in your app. When navigating to the cart screen from the order screen, you pass the cart object (this is how `OrderScreenView` constructs a `CartViewScreen`):

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

    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';
    
    final Map<String, dynamic> orderConfirmation = {
      'orderId': orderId,
      'totalAmount': widget.cart.totalPrice,
      'itemCount': widget.cart.countOfItems,
      'estimatedTime': '15-20 minutes',
      'status': 'confirmed'
    };

    if (mounted) {
      Navigator.pop(context, orderConfirmation);
    }
  }

  void _cancelOrder() {
    final Map<String, String> cancellationData = {'status': 'cancelled'};
    Navigator.pop(context, cancellationData);
  }

  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    double unitPrice;
    if (sandwich.isFootlong) {
      unitPrice = 11.0;
    } else {
      unitPrice = 7.0;
    }
    return quantity * unitPrice;
  }

  List<Widget> _buildOrderItems() {
    List<Widget> orderItems = [];
    
    for (MapEntry<Sandwich, int> entry in widget.cart.items.entries) {
      final Sandwich sandwich = entry.key;
      final int quantity = entry.value;
      final double itemPrice = _calculateItemPrice(sandwich, quantity);
      
      final Widget itemRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${quantity}x ${sandwich.name}',
              style: normalText,
            ),
          ),
          Text(
            '£${itemPrice.toStringAsFixed(2)}',
            style: normalText,
          ),
        ],
      );
      
      orderItems.add(itemRow);
      orderItems.add(const SizedBox(height: 8));
    }
    
    return orderItems;
  }

  List<Widget> _buildPaymentSection() {
    if (_isProcessing) {
      return [
        const Center(
          child: CircularProgressIndicator(),
        ),
        const SizedBox(height: 20),
        const Text(
          'Processing payment...',
          style: normalText,
          textAlign: TextAlign.center,
        ),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Confirm Payment', style: normalText),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _cancelOrder,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Cancel Order', style: normalText),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> orderItems = _buildOrderItems();
    final List<Widget> paymentSection = _buildPaymentSection();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Order Summary', style: heading2),
            const SizedBox(height: 20),
            
            ...orderItems,
            
            const Divider(),
            const SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: heading2),
                Text(
                  '£${widget.cart.totalPrice.toStringAsFixed(2)}',
                  style: heading2,
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            const Text(
              'Payment Method: Card ending in 1234',
              style: normalText,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 20),
            
            ...paymentSection,
          ],
        ),
      ),
    );
  }
}
```

Now, update your `cart_view_screen.dart` to add a checkout button and handle the returned data. Add this method to the `_CartViewScreenState` class:

```dart
Future<void> _navigateToCheckout() async {
  final bool cartIsEmpty = widget.cart.items.isEmpty;
  
  if (cartIsEmpty) {
    const SnackBar emptyCartSnackBar = SnackBar(
      content: Text('Your cart is empty'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(emptyCartSnackBar);
    return;
  }

  final Map<String, dynamic>? result = await Navigator.push<Map<String, dynamic>>(
    context,
    MaterialPageRoute<Map<String, dynamic>>(
      builder: (BuildContext context) => CheckoutScreen(cart: widget.cart),
    ),
  );

  final bool hasResult = result != null;
  final bool widgetStillMounted = mounted;
  
  if (hasResult && widgetStillMounted) {
    final String status = result['status'] as String;
    
    if (status == 'confirmed') {
      _handleConfirmedOrder(result);
    } else if (status == 'cancelled') {
      _handleCancelledOrder();
    }
  }
}

void _handleConfirmedOrder(Map<String, dynamic> orderData) {
  setState(() {
    widget.cart.clear();
  });

  final String orderId = orderData['orderId'] as String;
  final String estimatedTime = orderData['estimatedTime'] as String;
  
  final String successMessage = 'Order $orderId confirmed! Estimated time: $estimatedTime';
  final SnackBar successSnackBar = SnackBar(
    content: Text(successMessage),
    duration: const Duration(seconds: 4),
    backgroundColor: Colors.green,
  );
  
  ScaffoldMessenger.of(context).showSnackBar(successSnackBar);

  Navigator.pop(context);
}

void _handleCancelledOrder() {
  const SnackBar cancelledSnackBar = SnackBar(
    content: Text('Order cancelled'),
    duration: Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(cancelledSnackBar);
}
```

Add the import for the CheckoutScreen at the top of `cart_view_screen.dart`:

```dart
import 'package:sandwich_shop/views/checkout_screen.dart';
```

Then add a checkout button to your cart screen's UI. In the `build` method, add this button after the total price display:

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
const SizedBox(height: 10),
```

The `_navigateToCheckout()` method uses `await` to wait for the checkout screen to return data. The `MaterialPageRoute<Map<String, dynamic>>` specifies that we expect a Map to be returned from the checkout screen. We check if the result is not null and handle different scenarios like confirmed or cancelled orders.

After a successful order, we clear the cart and update the UI. We show different messages based on the returned data to give users feedback about their actions.

When returning data from screens, use `await` when calling `Navigator.push()` to wait for the result. Specify the return type in the `MaterialPageRoute<T>` generic. Use `Navigator.pop(context, returnValue)` to return data from the receiving screen. Always check if the returned data is not null before using it. Use the `mounted` property to ensure the widget is still active before updating state.

Run your app and test the complete flow. Add some sandwiches to your cart, navigate to the cart view, and press the "Checkout" button. Try both "Confirm Payment" and "Cancel Order" options and observe how data is passed back and the UI responds accordingly.

#### **Commit your changes**

We have not added reminders to commit your changes along the way but hopefully you have been making separate commits after each step of change and after each time you run to verify a change in your code.

## **Implementing a Profile Screen**

Let's add a new screen to demonstrate navigation concepts. We'll create a simple profile screen where users can enter their name and preferred sandwich shop location.

### **Creating the Profile Screen**

First, create a new file `lib/views/profile_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final String name = _nameController.text.trim();
    final String location = _locationController.text.trim();
    
    final bool nameIsNotEmpty = name.isNotEmpty;
    final bool locationIsNotEmpty = location.isNotEmpty;
    final bool bothFieldsFilled = nameIsNotEmpty && locationIsNotEmpty;
    
    if (bothFieldsFilled) {
      _returnProfileData(name, location);
    } else {
      _showValidationError();
    }
  }

  void _returnProfileData(String name, String location) {
    final Map<String, String> profileData = {
      'name': name,
      'location': location,
    };
    Navigator.pop(context, profileData);
  }

  void _showValidationError() {
    const SnackBar validationSnackBar = SnackBar(
      content: Text('Please fill in all fields'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(validationSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter your details:', style: heading2),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Preferred Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### **Adding Navigation to the Profile Screen**

Now, let's add a button to navigate to the profile screen from the order screen. In your `order_screen_view.dart`, add this method:

```dart
Future<void> _navigateToProfile() async {
  final Map<String, String>? result = await Navigator.push<Map<String, String>>(
    context,
    MaterialPageRoute<Map<String, String>>(
      builder: (BuildContext context) => const ProfileScreen(),
    ),
  );
  
  final bool hasResult = result != null;
  final bool widgetStillMounted = mounted;
  
  if (hasResult && widgetStillMounted) {
    _showWelcomeMessage(result);
  }
}

void _showWelcomeMessage(Map<String, String> profileData) {
  final String name = profileData['name']!;
  final String location = profileData['location']!;
  final String welcomeMessage = 'Welcome, $name! Ordering from $location';
  
  final SnackBar welcomeSnackBar = SnackBar(
    content: Text(welcomeMessage),
    duration: const Duration(seconds: 3),
  );
  
  ScaffoldMessenger.of(context).showSnackBar(welcomeSnackBar);
}
```

Add the import for the ProfileScreen at the top of the file:

```dart
import 'package:sandwich_shop/views/profile_screen.dart';
```

Then add a profile button to your order screen's UI. You can add it near the other buttons:

```dart
StyledButton(
  onPressed: _navigateToProfile,
  icon: Icons.person,
  label: 'Profile',
  backgroundColor: Colors.purple,
),
```

This demonstrates navigation to a new screen and passing data back from that screen. We use the returned data to show a welcome message and properly handle the `mounted` property for async operations.

Note that in this simple implementation, the profile data isn't persistent - it's just used to demonstrate navigation concepts. In a real app, you'd save this data to local storage or a database.

#### **Commit your changes**

Commit the new profile screen and navigation implementation.

## **Using AI to Enhance Cart Functionality**

Now let's use AI to help us implement the cart quantity modification feature we discussed in the requirements section.

### **Step 1: Analyze Current Cart Implementation**

First, examine your current `Cart` class in `lib/models/cart.dart`. You should see methods for adding items and calculating totals. Ask your AI assistant to help you understand what modifications are needed:

```
I have a Cart class in my Flutter app that currently allows adding items. I want to add the ability to modify quantities of existing items and remove items entirely.

Current Cart class:
[Paste your cart.dart code here]

Please analyze this code and suggest what methods I need to add to support:
1. Updating the quantity of an existing item
2. Removing an item completely
3. Getting a list of all items with their quantities for display

Explain the logic for each method and any edge cases I should consider.
```

### **Step 2: Implement Cart Modifications**

Based on the AI's suggestions, update your `Cart` class. You'll likely need methods like:

```dart
void updateQuantity(Sandwich sandwich, int newQuantity) {

}

void removeItem(Sandwich sandwich) {

}

List<CartItem> get items {

}
```

### **Step 3: Update the Cart View UI**

Ask your AI assistant to help you create UI components for the cart view:

```
I need to update my cart view screen to show quantity controls for each item. Each cart item should display:
- Sandwich name and details
- Current quantity with + and - buttons
- Individual item total price
- Remove item button

Current CartViewScreen:
[Paste relevant parts of your cart_view_screen.dart]

Please provide the UI code for displaying cart items with quantity controls, following Flutter best practices.
```

### **Step 4: Test Your Implementation**

Write widget tests for your new cart functionality. Ask your AI assistant:

```
I've implemented cart quantity modification features. Please help me write widget tests that verify:
1. Quantity can be increased and decreased
2. Items are removed when quantity reaches 0
3. Total price updates correctly
4. UI displays the correct information

Provide test code that follows the testing patterns we've used in previous worksheets.
```

#### **Commit your changes**

Commit your enhanced cart functionality with proper commit messages describing each change.

## **Exercises**

Complete the exercises below. Remember to commit your changes after each exercise and use your AI assistant to help you think through the problems rather than just asking for the solution.

1. **AI-Assisted Requirements and Implementation**: Use AI to help you implement a "Favorites" feature where users can mark sandwiches as favorites and view them on a separate screen.

   Start by creating a requirements document with AI assistance. Your prompt should include:
   - Current app structure and models
   - Desired functionality (mark/unmark favorites, view favorites list)
   - UI/UX requirements
   - Data persistence needs (for now, just in-memory storage is fine)

   Then use AI to help implement the feature, including:
   - Updates to the Sandwich model or a new Favorites model
   - UI components for marking favorites (like a heart icon)
   - A new favorites screen accessible from the main screen
   - Navigation between screens
   - Proper state management

   ⚠️ **Show your requirements document and working favorites feature to a member of staff** for a sign-off.

2. **Enhanced Checkout Flow**: Extend the checkout screen we implemented in this worksheet to include additional features.

   Add the following enhancements to the checkout process:
   - A customer details form (name, phone number, delivery address)
   - Order notes field for special instructions
   - Multiple payment method options (Card, Cash, Mobile Payment)
   - Order receipt screen that shows after successful payment

   The enhanced flow should be: Order Screen → Cart View → Checkout → Customer Details → Payment → Receipt → Back to Order Screen.

   Use your AI assistant to help you design the additional screens and implement proper data passing between them. Make sure each screen returns appropriate data to the previous screen.

   ⚠️ **Show your enhanced checkout flow with customer details and receipt to a member of staff** for a sign-off.