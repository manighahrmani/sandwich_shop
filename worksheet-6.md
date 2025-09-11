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

### **Requirements-First Development**

Instead of jumping straight into coding, let's start by using AI to help us write proper requirements for a new feature.

Run the app and add a few sandwiches to your cart. You should see a snack bar confirming the addition. Now, navigate to the cart page with the "View Cart" button. You should see the items you added along with their prices and the total price.

Let's say we want to enhance our cart functionality. Instead of immediately asking for code, we'll first ask our AI assistant to create a requirements document. Here's a sample prompt you can use with your AI assistant:

```
I'm building a sandwich shop app in Flutter. I have two pages: an order screen where users can select sandwiches and add them to their cart, and a cart screen where users can see the items in their cart and the total price.

Write a `requirements.md` document for me as I want to enable the users to modify the items in their cart. There are different ways a user might want to modify their cart like changing quantity or removing items entirely. 

For each of these features, include a clear description of the feature and what should happen when the user performs an action

Format this as a proper requirements document that could be used by a development team.
```

This initial prompt can be improved by adding more specific details about the current app structure. You could for example include:
```
The app currently has these models:
- Sandwich (with type, size, bread type)
- Cart (with add/remove/clear methods and total price calculation)
It also has one repository:
- Pricing (calculates prices based on quantity and size, the price of a sandwich has nothing to do with its type or bread)
```
You can also talk about the UI requirements or edge cases you want the code to handle for example, if the user tries to reduce the quantity of an item below 1, it should remove the item entirely from the cart.

Save the output as `requirements.md` in your project directory. Review the document and manually edit it if needed.

#### **From Requirements to Implementation**

Once you have solid requirements, you can use AI to help implement features systematically. Here's how you might approach implementing the cart modification feature:

```
Based on the requirements document we created, please help me implement the cart quantity modification feature.

Current Cart class structure:
[Include your current cart.dart code here]

Requirements to implement:
- Users should be able to increase/decrease quantities of items already in the cart
- Minimum quantity is 1 (removing all quantities should remove the item entirely)
- UI should show current quantity with + and - buttons
- Changes should update the total price immediately

Please provide:
1. Updated Cart class methods (if needed)
2. UI components for the cart view with quantity controls
3. Explanation of how the state management should work

Focus on clean, maintainable code that follows Flutter best practices.
```

#### **Commit your changes**

Before moving on to navigation, commit any requirements documents or code improvements you've made with AI assistance.

## **Navigation in Flutter**

Navigation is how users move between different screens (called **routes** in Flutter) in your app. Understanding navigation is crucial for creating multi-screen applications.

### **Key Navigation Concepts**

- **Route**: In Flutter, a route is simply a widget that represents a screen or page. This is equivalent to an Activity in Android or a ViewController in iOS.
- **Navigator**: A widget that manages a stack of routes. It handles pushing new routes onto the stack and popping them off.
- **Navigation Stack**: Think of navigation as a stack of cards. When you navigate to a new screen, you place a new card on top of the stack. When you go back, you remove the top card, revealing the previous screen underneath.

For our sandwich shop app, basic navigation using `Navigator.push()` and `Navigator.pop()` is sufficient. More complex apps might benefit from packages like [go_router](https://pub.dev/packages/go_router), but we'll stick to the basics for now.

### **Basic Navigation Patterns**

The most common navigation pattern is pushing a new route and then popping back:

```dart
// Navigate to a new screen
Navigator.push(
  context,
  MaterialPageRoute<void>(
    builder: (context) => NewScreen(),
  ),
);

// Go back to the previous screen
Navigator.pop(context);
```

In your current app, you already have navigation between the order screen and cart screen. Let's examine how this works:

```dart
// In order_screen_view.dart - navigating TO the cart
void _navigateToCartView() {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => CartViewScreen(cart: _cart),
    ),
  );
}

// In cart_view_screen.dart - navigating BACK to the order screen
void _goBack() {
  Navigator.pop(context);
}
```

### **Showing Messages Across Navigation**

Notice in your current code that we use `ScaffoldMessenger` to show snack bars:

```dart
ScaffoldMessenger.of(context).showSnackBar(snackBar);
```

This is important because `ScaffoldMessenger` ensures the message persists even if the user navigates to a different screen. Try this: add a sandwich to your cart, then immediately navigate to the cart view. You'll see the confirmation message appears on the cart screen, not just the order screen.

#### **Commit your changes**

Before implementing new navigation features, commit your current working state.

## **Passing Data Between Screens**

Often, you need to send data to a new screen or receive data back from it. Let's explore both scenarios.

### **Sending Data to a New Screen**

You're already doing this in your app! When navigating to the cart screen, you pass the cart object:

```dart
CartViewScreen(cart: _cart)
```

The `CartViewScreen` receives this data through its constructor:

```dart
class CartViewScreen extends StatefulWidget {
  final Cart cart;
  
  const CartViewScreen({super.key, required this.cart});
  // ...
}
```

This is the standard way to pass data to a new screen in Flutter. The receiving widget declares the data it needs in its constructor, and the sending widget provides it during navigation.

### **Returning Data from a Screen**

Sometimes you want to get data back from a screen. For example, you might want to return a confirmation when an order is placed. Here's how you can modify navigation to handle returned data:

```dart
// Sending screen - wait for a result
Future<void> _navigateAndWaitForResult() async {
  final result = await Navigator.push<String>(
    context,
    MaterialPageRoute<String>(
      builder: (context) => SomeScreen(),
    ),
  );
  
  if (result != null) {
    // Do something with the returned data
    print('Received: $result');
  }
}

// Receiving screen - return data when popping
void _returnWithData() {
  Navigator.pop(context, 'Some return value');
}
```

The key points are:
- Use `await` when calling `Navigator.push()` to wait for the result
- Specify the return type in the `MaterialPageRoute<String>` generic
- Use `Navigator.pop(context, returnValue)` to return data

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
    final name = _nameController.text.trim();
    final location = _locationController.text.trim();
    
    if (name.isNotEmpty && location.isNotEmpty) {
      // Return the profile data to the previous screen
      Navigator.pop(context, {
        'name': name,
        'location': location,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
  final result = await Navigator.push<Map<String, String>>(
    context,
    MaterialPageRoute<Map<String, String>>(
      builder: (context) => const ProfileScreen(),
    ),
  );
  
  if (result != null && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome, ${result['name']}! Ordering from ${result['location']}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
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

This demonstrates:
- Navigation to a new screen
- Passing data back from a screen
- Using the returned data to show a message
- Proper handling of the `mounted` property for async operations

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
// Update quantity of an existing item
void updateQuantity(Sandwich sandwich, int newQuantity) {
  // Implementation here
}

// Remove an item completely
void removeItem(Sandwich sandwich) {
  // Implementation here
}

// Get all items for display
List<CartItem> get items {
  // Implementation here
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

2. **Enhanced Cart Functionality**: Complete the cart quantity modification feature we started in this worksheet.

   Use AI to help you add +/- buttons next to each item in the cart view that allow users to:
   - Increase item quantities
   - Decrease item quantities (removing items when quantity reaches 0)
   - See updated totals immediately
   - Handle edge cases gracefully

   Make sure to update both the UI and the underlying Cart model as needed. Write tests to verify the functionality works correctly.

   ⚠️ **Show your enhanced cart with quantity modification working correctly to a member of staff** for a sign-off.

3. **Order Confirmation Flow**: Create an order confirmation screen that users reach after reviewing their cart.

   The flow should be: Order Screen → Cart View → Order Confirmation → Back to Order Screen (with cleared cart).

   The confirmation screen should:
   - Display order summary with total price
   - Show estimated preparation time (you can make this up, like "15-20 minutes")
   - Have a "Confirm Order" button that returns to the main screen
   - Clear the cart when the order is confirmed
   - Show a success message on the main screen

   Use proper navigation with data passing to implement this flow. Ask your AI assistant to help you design the user experience and implement the screens.

   ⚠️ **Show your complete order confirmation flow working end-to-end to a member of staff** for a sign-off.

4. (Advanced) **Settings Screen**: Create a settings screen where users can configure app preferences like default sandwich size and preferred bread type.

   The settings screen should:
   - Allow users to set default sandwich size (six-inch or footlong)
   - Allow users to set default bread type
   - Save these preferences (for now, just store them in the app's state)
   - Use the saved preferences as defaults in the order screen

   Use your AI assistant to help design the UI and implement the functionality. Consider how the settings should be structured and how they integrate with the existing app.

   This task is **optional** and there's no need to show it to a member of staff for a sign-off.

5. (Advanced) **Order History**: Implement a simple order history feature that keeps track of previous orders.

   Create a new screen that shows:
   - List of previous orders with date/time
   - Order details (items, quantities, total price)
   - Ability to "reorder" (add all items from a previous order to the current cart)

   For now, just store the order history in memory (it will be lost when the app restarts). Use your AI assistant to help design the data structure and implement the functionality.

   This task is **optional** and there's no need to show it to a member of staff for a sign-off.