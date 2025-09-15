This is worksheet 5:
```md
# **Worksheet 5 — Data Models and Assets**

## **What you need to know beforehand**

Ensure that you have already completed the following:

- [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
- [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).
- [Worksheet 2 — Stateless Widgets](./worksheet-2.md).
- [Worksheet 3 — Stateful widgets](./worksheet-3.md).
- [Worksheet 4 — App Architecture and Testing](./worksheet-4.md).

## **Getting help**

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## **Getting started**

For this worksheet, as an exception, start with the code from branch 5 of our [GitHub repository](https://github.com/manighahrmani/sandwich_shop/tree/5). You can either clone the repository and checkout branch 5:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git checkout 5
```

Or manually ensure your code matches the repository. Run the app to make sure everything works as expected before proceeding.

## **Introduction to Data Models**

So far, we've been passing simple data types like `String` and `int` between our widgets. As our app grows in complexity, it's better to group related data into custom data types (classes). We call these **data models**.

If you've worked with databases before, you can think of data models as being similar to **entities**. An entity is a real-world object or concept that can be distinctly identified. In our case, a "Sandwich" is a perfect example of an entity that we can represent with a data model.

### **Business Logic Decisions**

During your development, you as the developer would make certain business decisions about how the app should function. Here is an example of one such decision we have made regarding our app. 

We assume that the price of a sandwich depends only on its size (footlong vs six-inch), not on the type of sandwich or bread type. This keeps our pricing simple and consistent.

This is why our `PricingRepository` only needs to know the quantity and size (`isFootlong`) to calculate the total price. The sandwich type (like "Veggie Delight" or "Turkey Club") and bread type don't affect the price.

### **Creating the `Sandwich` model**

Let's start by defining a `Sandwich` model. This will help us manage all the properties of a sandwich in one place.

Open the Explorer view in VS Code with **Ctrl + Shift + E** on Windows or **⌘ + Shift + E** on macOS. Right-click on the `lib` folder and select **New Folder**. Name this folder `models`. Right-click on the `models` folder and select **New File**. Name this file `sandwich.dart`. This is what your project structure may look like:

```
lib/
├── main.dart
├── views/
│   └── app_styles.dart
├── view_models/
├── models/
│   └── sandwich.dart
└── repositories/
    └── pricing_repository.dart
```

You will notice that we have not listed `lib/repository/order_repository.dart`. You can **delete `order_repository.dart` from your `repositories` folder** as it's no longer needed with our new data model approach (more on this later). Make sure to remove the import statement for this file from `lib/main.dart` as well as the `order_repository_test.dart` unit test from the `test/repositories` folder.

Add the following code to `sandwich.dart`:

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

Here we have defined a `Sandwich` class with properties for the sandwich type, size, and bread type. Notice how we use enums for both `SandwichType` and `BreadType` to ensure users can only select from valid options. This is a preferable approach to using `String`s, as it reduces the risk of typos and values that are not part of the defined set.

The `name` getter converts the enum value into a human-readable string, and the `image` getter automatically constructs the correct image path based on the sandwich type and size. For example, a footlong Veggie Delight would have the image path `assets/images/veggieDelight_footlong.png`.

Use your AI assistant to explain why we use getters here instead of storing the name and image as instance variables received in the constructor.

Before moving on, use your AI assistant to write a unit test for the `Sandwich` model. Remember to create a `models` folder inside the `test` folder to mirror the structure of the `lib` folder. Your test file should be named `sandwich_test.dart`.

#### **Commit your changes**

Here's a reminder to commit your changes (commit them individually, the addition of the model and the test).

### **The `Cart` model**

Now that we can represent a single sandwich, we need a way to manage a collection of them in an order. We need to create a `Cart` class that can hold multiple `Sandwich` objects along with their quantities.

Right-click on the `models` folder and select **New File**. Name this file `cart.dart`. Ask your AI assistant to help you implement a `Cart` class. Take your time writing a prompt that clearly describes the functionality you want. Think about what typical operations a user would perform on a cart of a food delivery app.

Remember that the price calculation should use our existing `PricingRepository` since it's the single source of truth for pricing logic. You'll need to import the `PricingRepository` and use its `calculatePrice` method in the `cart.dart` file.

As before, write unit tests for the `Cart` model in a new file called `cart_test.dart` inside the `test/models` folder.

#### **Commit your changes**

Commit the addition of the `Cart` model and its tests before moving on.

## **Managing Assets**

Our `Sandwich` model automatically generates image paths, but we haven't provided any images yet. In Flutter, static files like images, fonts, and configuration files are called **assets**.

First, create an `assets` folder in the root of your project, at the same level as the `lib` and `test` folders. Inside the `assets` folder, create another folder called `images`.

Next, you need to tell Flutter about these new assets. Open the `pubspec.yaml` file and add an `assets` section like this (**the `uses-material-design: true` line already exists there, just add everything below it**).

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

Make sure the indentation is correct, as `pubspec.yaml` is sensitive to whitespace. The line `assets:` should be at the same indentation level as `uses-material-design:`.

Now you can use images saved in this folder in your app. For more information, you can read the official Flutter documentation on [adding assets and images](https://docs.flutter.dev/ui/assets/assets-and-images).

For your coursework you should **not** to incorporate any videos or audio files, but if you wish to explore this check out [this page](https://docs.flutter.dev/cookbook/plugins/play-video).

#### **Commit your changes**

Commit your new assets before moving on.

### **Adding a simple logo to the app bar**

Before we dive into the more complex sandwich image display, let's start with a simple example of using images. We'll add a logo to the app bar.

We have already provided you with a logo image called `logo.png` for the app bar. If you have cloned/forked our repository, you should already have this, otherwise, download it from [this page](https://github.com/manighahrmani/sandwich_shop/blob/5/assets/images/logo.png) and save it as `logo.png` in the `assets/images` folder.

In your `lib/main.dart` file, update the `AppBar` in the `build` method of `_OrderScreenState` to include a logo. To change its size, you can wrap the `Image.asset()` widget in a `SizedBox`. Here's how you can do it:

```dart
appBar: AppBar(
  leading: SizedBox(
    height: 100,
    child: Image.asset('assets/images/logo.png'),
  ),
  title: const Text(
    'Sandwich Counter',
    style: heading1,
  ),
),
```

The `Image.asset()` widget loads an image from your assets folder. The `leading` property of `AppBar` places the widget before the title. Run your app to see the logo appear in the app bar.

Although the height of the `AppBar` is typically around 56 pixels so the image will be scaled down to fit, setting one of the dimensions in `SizedBox` helps maintain the aspect ratio of the image.

For more information about the `Image` widget and its properties, check the [Flutter documentation on Image](https://api.flutter.dev/flutter/widgets/Image-class.html).

#### **Commit your changes**

Commit this simple logo addition before moving on to the more complex image display.

## **Updating the UI**

Your `main.dart` should still have several errors (all to do with the use of `OrderRepository`). We will fix these shortly while also creating a simple interface where users can select a sandwich type, size, bread type, and quantity, then add it to their cart.

### **Updating the imports**

First, open `lib/main.dart` and make sure you have exactly the following imports at its top:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';
```

As mentioned before, you need to remove the import for `order_repository.dart` since it's no longer needed. Similarly, remove the old import for `pricing_repository.dart` as we will be using its `calculatePrice` method through the `Cart` model (it is indirectly imported).

You'll also need to remove the `BreadType` enum from `lib/main.dart` since it's now defined in the `sandwich.dart` file.

### **Displaying sandwich images**

Now let's add dynamic image display that updates based on the user's selection. We'll show the sandwich image that corresponds to the selected type and size.

You'll need to create images for each sandwich type and size combination. Based on our `SandwichType` enum, you'll need images named like: `veggieDelight_footlong.png` or `veggieDelight_six_inch.png` and so on for all the sandwich types (this means a total of 8 images).

Use your AI assistant to help you find or create placeholder images for the sandwiches and logo. You can use simple coloured rectangles or search for copyright-free images online. Save these images in the `assets/images` folder with the exact naming convention shown above.

Now we'll update the UI to include the image display and replace the old order management system with our new cart-based approach.

Since we're changing the UI structure significantly, you can remove the `OrderItemDisplay` classes from the bottom of your `lib/main.dart` file as it is no longer needed with our new approach.

Replace the entirety of `_OrderScreenState` with the following:

```dart
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

      debugPrint(confirmationMessage);
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
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

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) {
      setState(() {
        _selectedSandwichType = value;
      });
    }
  }

  void _onSizeChanged(bool value) {
    setState(() {
      _isFootlong = value;
    });
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) {
      setState(() {
        _selectedBreadType = value;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return _decreaseQuantity;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                onSelected: _onSandwichTypeChanged,
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Six-inch', style: normalText),
                  Switch(
                    value: _isFootlong,
                    onChanged: _onSizeChanged,
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
                onSelected: _onBreadTypeChanged,
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: _getDecreaseCallback(),
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: heading2),
                  IconButton(
                    onPressed: _increaseQuantity,
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
            ],
          ),
        ),
      ),
    );
  }
}
```

Notice that we are assuming your `Cart` model provides an `add` method that takes a `Sandwich` object and an optional `quantity` parameter. If your implementation differs, adjust the `_addToCart` method accordingly.

The `Image.asset()` shows the current sandwich image. The `_getCurrentImagePath()` method ensures the image updates automatically when users change their selections. The `errorBuilder` property handles cases where an image file doesn't exist, showing a "Image not found" message instead of crashing.

The dropdown menus, switch, and quantity controls work together to update the image in real-time. When the user adds items to the cart, a confirmation message is printed to the debug console using `debugPrint()`. If you don't see the debug console in VS Code, open the Command Palette (**Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS) and type "Focus on Debug Console View" to open it.

Notice that we wrap our `Column` in a `SingleChildScrollView` widget. This makes the entire interface scrollable, which is important when the content becomes too tall for the screen. This is particularly useful on smaller devices or when the screen is resized to a smaller height. You may remember doing an exercise on scrollable widgets in [Worksheet 2](./worksheet-2.md).

If you are confused by what the `errorBuilder` property does, or how the `fit: BoxFit.cover` property affects image display, ask your AI assistant to explain these concepts.

As always, write widget tests to ensure your UI behaves as expected (several tests in the current `test/views/widget_test.dart` file that you have would almost certainly fail). Test scenarios like adding items to the cart, changing quantities, and selecting different sandwich options.

#### **Commit your changes**

Make sure all your changes are committed separately before moving on to the exercises.

## **Exercises**

Complete the exercises below and show your work to a member of staff at your next practical session for a **sign-off**.

Even though your AI assistant may suggest this, for now, try not to use any third-party packages, only built-in Flutter widgets.

1.  Our app currently only shows a message (`confirmationMessage`) in the debug console when items are added to the cart. Let's display this message in the UI instead.

    Browse [the catalog of Flutter widgets](https://docs.flutter.dev/ui/widgets) or ask your AI assistant to suggest a suitable widget for displaying this message on the screen.

    Think about how you as the user would want to see this message. Should it appear as a popup, a banner, or somewhere else on the screen? Would you want it to disappear after a few seconds, or stay until the user dismisses it?
    
    Remember not to implement a separate page for the cart yet, we will do that in a later exercise. Once you are done, update the widget tests to relfect your changes.

    ⚠️ **Show your running app displaying the confirmation message in the UI to a member of staff** for a sign-off.

2.  Let's add a permanent cart summary display to our main screen. In addtion of just showing a confirmation message when items are added, you need to show the number of items in the cart and the total price.

    Try to do this in the simplest way possible. Just make sure that when the "Add to Cart" button is pressed, this displayed summary is updated to reflect the current state of the cart.

    Feel free to use your AI assistant to help you implement this feature, and make sure to write widget tests to verify that the cart summary updates correctly when items are added.

    ⚠️ **Show your running app with the cart summary displaying the number of items and total price to a member of staff** for a sign-off.

3.  (Advanced) So far, our app only has one screen (`main.dart`). Let's add a second screen to view the cart contents. This is a task which we will cover in more detail in the next worksheet, but let's give it a try now. Here's a [link to the Flutter documentation on navigation](https://docs.flutter.dev/cookbook/navigation/navigation-basics) to help you get started.

    Create a new `StatefulWidget` called `CartScreen` (and its associated state class) in `main.dart` for now. It should display a list of all items in the cart. Each item should show the sandwich name, size, bread type, quantity, and individual total price.

    Think about what pieces of information would be most useful to display in the cart view and how the user might reach/interact with this screen. Write a user story if you are planning to use your AI assistant to help you implement this and make sure to provide sufficient context (e.g., the `Cart` model and its methods).


    Hint: You can use `Navigator.push()` to navigate to the cart screen and `Navigator.pop()` to go back to the main screen. Also, your `CartScreen` will need access to the cart data, so you'll need to pass it through the constructor. To display multiple items from a collection, you can use a for loop inside a `Column`'s children list like this:

    ```dart
    Column(
      children: [
        for (String item in itemList)
          Text(item),
      ],
    )
    ```

    Once you have implemented the new page, move the `CartScreen` widget to a new file called `cart_screen.dart` inside the `views` folder and import it where you are using it (in `OrderScreen`). You could additionally create a `order_screen.dart` file for the `OrderScreen` and `OrderScreenState` classes if you wish. This way, `main.dart` will be short and simple, only containing the `App` class and the `main()` function.

    This is what your `lib/main.dart` file may look like after the refactoring:

    ```dart
    import 'package:flutter/material.dart';
    import 'package:sandwich_shop/views/order_screen.dart';

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

    Below is what your project folder may look like after this exercise. Remember to write widget tests to ensure the cart view behaves as expected.

    ```
    sandwich_shop/
    ├── assets/
    │   └── images/
    ├── lib/
    │   ├── main.dart
    │   ├── views/
    │   │   ├── app_styles.dart
    │   │   ├── cart_screen.dart
    │   │   └── order_screen.dart
    │   ├── view_models/
    │   ├── models/
    │   │   ├── cart.dart
    │   │   └── sandwich.dart
    │   └── repositories/
    │       └── pricing_repository.dart
    ├── test/
    │   ├── views/
    │   │   ├── cart_screen_test.dart
    │   │   └── order_screen_test.dart
    │   ├── view_models/
    │   ├── models/
    │   │   ├── cart_test.dart
    │   │   └── sandwich_test.dart
    │   └── repositories/
    │       └── pricing_repository_test.dart
    ├── pubspec.yaml
    └── ...
    ```

    Notice that the widget tests for each screen are in separate files named after the screen they are testing. (Instead of a single `widget_test.dart` file we have `cart_screen_test.dart` and `order_screen_test.dart` files.)

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

4.  (Advanced) In the cart view, re-implement the order notes functionality, but this time for the entire order rather than individual sandwiches.

    Similar to what we used to have in [`main.dart`](https://github.com/manighahrmani/sandwich_shop/blob/5/lib/main.dart), add a `TextField` that allows users to add notes for the entire order (e.g., "No onions" or "Extra serviettes").

    Remember to store these notes in the `Cart` model. You may need to update the `Cart` class to include a `notes` property and a method to update it.

    As always remember to update the unit tests and widget tests to cover this new functionality.

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.
```

This is worksheet 6:
```md
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

One of the learning outcomes of this module is AI-driven development. We have been hinting at this in the earlier worksheets, but let's formalise things a little. Below are the different ways developers use AI:

  - **Vibe Coding**: This refers to the informal and passive approach where developers ask AI for quick solutions without much structure or planning. While this can be useful for simple tasks, it is not sustainable for larger projects and often leads to inconsistent results and technical debt.

  - **Prompt Engineering**: The practice of crafting specific, well-structured prompts to get better results from AI models. This involves understanding how to communicate effectively with AI to get the desired output.

  - **Prompt-driven Development (PDD)**: A more systematic approach where developers use carefully crafted prompts to guide AI through the entire development process. Prompts, often in Markdown format (ending with `.md`), are stored alongside the codebase, modified and refined over time just like code itself. The overall aim is to make AI-driven development a more structured, reproducible and reliable process.

Among some of the advantages of PDD is that well-structured prompts produce more consistent and predictable results. AI can be unpredictable, and predictability is a quality we want in software development. Detailed requirements lead to better code quality and fewer bugs, and if any generated code has issues, we can always go back to the prompt and refine it.

You can learn more about using AI for feature implementation in this video: [AI-Powered App Development with Flutter](https://www.youtube.com/watch?v=fzYN_kgl-OM). The section at 16:58 (Copilot Vision) is particularly relevant for your coursework, as it shows how you can use images and prompts to guide the AI.

### **Prompt-Driven Development in Practice**

Instead of jumping straight into coding, let's start by using AI to help us write proper requirements for a new feature.

Run the app and add a few sandwiches to your cart. You should see a snack bar confirming the addition. You will also see that we have implemented a second screen, `CartScreen` in `lib/views/cart_screen.dart`, that displays the items in the cart. You can navigate to this screen from the order screen by pressing the "View Cart" button. This is what the cart page should look like:

![Initial Cart Page](images/screenshot_initial_cart_page.png)

Let's say we want to enhance our cart functionality. Instead of immediately asking for code, we'll first ask our AI assistant to help us create a prompt. Here's a sample prompt you can use (if you are using Copilot, set it to "Ask" mode):

```
I have a sandwich shop app written in Flutter. I need your help writing good prompt I can send to an LLM to help me implement a new feature.

I have two pages: an order screen where users can select sandwiches and add them to their cart, and a cart screen where users can see the items in their cart and the total price.

I want to let the users modify the items in their cart. There are different ways a user might want to modify their cart like changing quantity or removing items entirely.

For each of these features, include a clear description and what should happen when the user performs an action. Output the result in a Markdown code block.
```

This initial prompt can be improved by adding more specific details about the current app structure. You could, for example, include:

```
The app currently has these models:
- Sandwich (with type, size, bread type)
- Cart (with add/remove/clear methods and total price calculation)
It also has one repository:
- Pricing (calculates prices based on quantity and size; the price of a sandwich has nothing to do with its type or bread)
```

This is what we initially got back from the AI: [prompt.md](https://github.com/manighahrmani/sandwich_shop/blob/2157fc03bb82e63206101518e408f1e02762ec54/prompt.md).
You can also talk about the UI requirements or edge cases you want the code to handle. For example, if the user tries to reduce the quantity of an item below 1, it should be removed from the cart.

Save the output as `prompt.md` in your project directory. Review the document and manually edit it if needed.

In our case, we asked the AI to refine the prompt after providing it with a screenshot of the current cart page and an overview of the app structure. You could also provide the AI with screenshots of other apps such as Deliveroo or Uber Eats to give it a better idea of what you want.

This is what we ended up with: [prompt.md](https://github.com/manighahrmani/sandwich_shop/blob/5b8512d5a5b2074c3dada7a1de213860f5110433/prompt.md#L65).

#### **Commit your changes**

Before moving on, commit your prompt file with an appropriate commit message. Remember, in PDD, prompts are part of the codebase.

### **Creating a Requirements Document**

Once you have a solid prompt, you can use AI to write a requirements document. Here's a sample prompt you can use:

```
Write a detailed requirements document for the feature described in my previous prompt. The requirements should include:

1. A clear description of the feature and its purpose.
2. User stories that describe how different users will interact with the feature.
3. Acceptance criteria that define when the feature is considered complete.

Respond in a structured Markdown format with separate subtasks.
```

This is what we got back from Copilot after a few modifications: [requirements.md](https://github.com/manighahrmani/sandwich_shop/blob/75d4eb7e53024b0868c3acd450cb7f028240cbc5/requirement.md#L5).

#### **Commit your changes**

Before implementing the feature, commit your requirements document with an appropriate commit message.

### **From Requirements to Implementation**

Now that you have a clear requirements document, you can use it to guide your implementation. Here's a sample prompt you can use:

```
Let's implement the feature described in my requirements document.

Implement each subtask separately, as I want to commit each one individually. For each subtask, explain your changes in detail, show me what files you are modifying, and then we can proceed to the next subtask.
```

Remember, when using Copilot, you can set it to "Edit" mode to let it modify your files directly. Additionally, provide it with context by pasting relevant parts of your codebase (you can do this by typing a hash symbol `#` followed by the name of the file, for example `#cart.dart`).

Notice how you can pause after each subtask to review the changes. It is an important part of the PDD process to read, test, and commit each change separately. This allows you to ensure the AI is producing code that meets your requirements and adheres to best practices.

![Using Copilot to implement cart modifications](images/screenshot_pdd_implementation_step.png)
Once you have completed all the subtasks, test your app to ensure everything works as expected. As before, update the widget tests for the cart screen in `test/views/cart_screen_test.dart` to cover the new functionality.

Here is a screenshot of our cart page after implementing the modifications:

![Updated Cart Page](images/screenshot_final_cart_page.png)

As before, remember to update the widget tests for the `cart_screen.dart` in `test/views/cart_screen_test.dart` to cover the new functionality you have added.

#### **Commit your changes**

Once you have implemented and tested the feature, commit your changes with an appropriate commit message.

## **Navigation in Flutter**

In one of the exercises from last week's worksheet, we started creating a cart screen and navigating to it. This week's code provides our implementation of that screen. Let's take a closer look at how navigation works in Flutter.

Here are some key terms to understand:

  - **Route**: A route is a screen or a page in your app. This is equivalent to an `Activity` in Android or a `ViewController` in iOS.
  - **Navigator**: A widget that manages a [stack](<https://en.wikipedia.org/wiki/Stack_(abstract_data_type)>) of routes. It handles pushing new routes onto the stack (navigating to a new screen) and popping them off (going back).

Think of navigation as a stack of cards. When you navigate to a new screen, you place (push) a new card on top of the stack. When you go back, you remove (pop) the top card, revealing the screen underneath.

For our sandwich shop app, basic navigation using `Navigator.push()` and `Navigator.pop()` is sufficient.

### **Basic Navigation**

Our current navigation pattern is the most common and simple one.

In `lib/views/order_screen.dart`, the "View Cart" button's `onPressed` callback calls the `_navigateToCartView()` method:

```dart
void _navigateToCartView() {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => CartScreen(cart: _cart),
    ),
  );
}
```

The `Navigator.push()` method takes the current `BuildContext` and a `MaterialPageRoute` that builds the new screen. The `builder` function returns the widget for the new screen, in this case `CartScreen`.

Basically, all you need to know is that `Navigator.push()` adds a new screen on top of the current one, in this case, `CartScreen`:

```dart
class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}
```

When the user wants to go back, the "Back to Order" button in the cart screen calls `Navigator.pop(context)` to return to the previous screen.

### **Showing Messages Across Navigation**

It is important to note that Flutter provides a way to show messages that persist across navigation. In our code, we use `ScaffoldMessenger` to show snack bars:

```dart
ScaffoldMessenger.of(context).showSnackBar(snackBar);
```

This is important because `ScaffoldMessenger` ensures the message is shown even if the user navigates to a different screen while it's appearing. Try this: add a sandwich to your cart, then immediately navigate to the cart view. You'll see the confirmation message appears on the cart screen, not just the order screen.

## **Passing Data Between Screens**

### **Passing Data Forwards**

Often, you need to send data to a new screen. This is already being done in your app. When navigating to the cart screen, we are already passing the `_cart` object to the `CartScreen` constructor:

```dart
CartScreen(cart: _cart)
```

The `CartScreen` then receives this data through its constructor:

```dart
class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});
  // ...
}
```

This is the standard way to pass data to a new screen in Flutter.

### **Returning Data from a Screen**

Things become slightly more complex when you want to get data back from a screen. For example, you might want to return a confirmation after an order is placed. Let's implement a checkout flow to demonstrate this.

First, create a new file `lib/views/checkout_screen.dart` and add the following code:

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

#### **Commit your changes**

Commit your changes and add widget tests for the new checkout screen in `test/views/checkout_screen_test.dart`.

Now, update `lib/views/cart_screen.dart`. First, add the necessary import at the top of the file:

```dart
import 'package:sandwich_shop/views/checkout_screen.dart';
```

In the `_CartScreenState` class, add this method to navigate to the checkout screen and handle the returned data:

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

Finally, add a checkout button to your cart screen's UI. In the `build` method of `_CartScreenState`, add this button just before the "Back to Order" button:

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

The `_navigateToCheckout()` method uses `await` when calling `Navigator.push()` to wait for the checkout screen to return data, which we store in `result`. When the payment is processed, the checkout screen calls `Navigator.pop(context, orderConfirmation)` to return the data.

We check that the `result` is not null and that the widget is still `mounted` (i.e., it hasn't been disposed of). If so, we clear the cart, update the UI, and show a success message with the order details.

Run your app and test the full checkout flow.

#### **Commit your changes**

Commit the changes for integrating the checkout screen and update any relevant widget tests.

## **Exercises**

Complete the exercises below. Remember to commit your changes after each exercise.

1.  Let's add a simple profile screen where users can enter their details. For now, you can add a link to this screen at the bottom of your order screen (we will improve this in the next exercise).

    As we did earlier in this worksheet, use your AI assistant to help you write a prompt for this feature.

    By the end of this exercise, you should have created a `ProfileScreen` in a new `lib/views/profile_screen.dart` file. There's no need to perform any actual authentication or data persistence yet.

    Make sure to write widget tests for your new profile screen.

    ⚠️ **Show your working profile screen to a member of staff** for a sign-off.

2.  Let's enhance our app's navigation by adding a `Drawer` menu. A `Drawer` is a panel that slides in from the edge of a `Scaffold` to show the app's main navigation options. You can read more about it in its [documentation page](https://api.flutter.dev/flutter/material/Drawer-class.html).

    Implement a drawer that includes navigation to your order screen, cart view, and profile screen.

    Ask your AI assistant to explain how `Drawer` widgets work and how they integrate with the `AppBar`. Could you make this drawer accessible from all screens in your app?

    Consider how the drawer should behave when navigating. Ask your AI assistant about the difference between `Navigator.push()` and `Navigator.pushReplacement()` in this context.

    As always, update your widget tests to cover the new navigation drawer functionality.

    ⚠️ **Show your working navigation drawer to a member of staff** for a sign-off.

3.  (Advanced) Configure your app to handle [deep links](https://docs.flutter.dev/ui/navigation/deep-linking) using `go_router`, which is the recommended approach for URL-based navigation in Flutter.

    Add the `go_router` package to your project by running `flutter pub add go_router`.

    Ask your AI assistant to help you refactor your app to use `MaterialApp.router` with `GoRouter` instead of `MaterialApp`. You'll need to define routes for your main screens like `/`, `/cart`, and `/profile`.

    Test your implementation by running the app on a web browser and typing URLs like `localhost:PORT/#/cart` in the address bar (where `PORT` is the port number your app is running on). The navigation should work correctly with proper browser back-button support.

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

4.  (Advanced) Create a settings screen where users can configure app-wide preferences, such as enabling dark mode or adjusting font sizes.

    This exercise introduces you to data persistence. You can use the `shared_preferences` package, which allows you to save simple key-value data that persists between app sessions. Add the package by running `flutter pub add shared_preferences`.

    Your task is to create a settings screen and use `shared_preferences` to save at least one user preference. When the user changes a setting, save it. When the app restarts, this preference should be loaded and applied.

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.
```

This is worksheet 7:
```md
# **Worksheet 7 — State Management and Persistence**

## **What you need to know beforehand**

Ensure that you have already completed the following:

- [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
- [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).
- [Worksheet 2 — Stateless Widgets](./worksheet-2.md).
- [Worksheet 3 — Stateful widgets](./worksheet-3.md).
- [Worksheet 4 — App Architecture and Testing](./worksheet-4.md).
- [Worksheet 5 — Data Models and Assets](./worksheet-5.md).
- [Worksheet 6 — AI-Driven Development and Navigation](./worksheet-6.md).

## **Getting help**

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## **Getting started**

For this worksheet, you need to start with the code from branch 7 of our [GitHub repository](https://github.com/manighahrmani/sandwich_shop/tree/6). You can either clone the repository and checkout branch 7:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git checkout 7
```

Or manually ensure your code matches the repository. Run the app to make sure everything works as expected before proceeding.

## **Introduction to App State Management**

⚠️ **Note**: This is a comprehensive worksheet covering advanced topics you do not have to use to be able to pass your coursework. Complete as much as you can, but do not worry if you cannot finish everything.

So far, we've been managing ephemeral state within individual widgets using `setState()`. This works well for simple apps, but as your app grows, you'll find that multiple screens need to share the same data. For example, both your order screen and cart screen need access to the cart data.

Currently, we pass the cart object between screens, but this becomes cumbersome when you have many screens that need the same data. This is where **app state management** comes in.

### **The Provider Package**

Flutter offers several approaches to state management, but we'll use the `provider` package because it's simple to understand and widely used. The provider package uses concepts that apply to other state management approaches as well.

Add the provider package to your project:

```bash
flutter pub add provider
```

We have purposefully not talked about packages a lot so far and we will do so in [#Third-Party Packages](#third-party-packages) later in this worksheet. The provider package you have installed introduces three key concepts:

- **Notifier**: A class that extends the `ChangeNotifier` class and holds the app state. It notifies listeners when the state changes. Our `Cart` class will be our notifier.
- **Provider**: A widget that provides an instance of a `ChangeNotifier` to its descendants. Usually this is done at the top level of your app (in our case, in `main.dart`). We will use `ChangeNotifierProvider` to provide our cart model to the entire app.
- **Consumer**: A widget that listens to changes in the provided notifier and rebuilds when notified. You will see how we will use `Consumer<Cart>` to listen for changes in the cart and update the UI accordingly.

For a more in-depth explanation of these concepts, see [this page on app state management](https://docs.flutter.dev/data-and-backend/state-mgmt/simple).

### **Creating a Cart Model with ChangeNotifier**

Let's refactor our `Cart` class to extend `ChangeNotifier` (feel free to revisit our [Object-Oriented Dart Worksheet](./worksheet-0.md#4---object-oriented-programming-in-dart) for a refresher). This will allow widgets to listen for changes and automatically rebuild when the cart is modified.

Open `lib/models/cart.dart` and update it to the following:

```dart
import 'package:flutter/foundation.dart';
import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart extends ChangeNotifier {
  final Map<Sandwich, int> _items = {};

  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      _items[sandwich] = _items[sandwich]! + quantity;
    } else {
      _items[sandwich] = quantity;
    }
    notifyListeners();
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        _items.remove(sandwich);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;

    for (Sandwich sandwich in _items.keys) {
      int quantity = _items[sandwich]!;
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (int quantity in _items.values) {
      total += quantity;
    }
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

Before committing your changes, see review the changes in the Source Control panel. The key changes are extending `ChangeNotifier` and calling `notifyListeners()` whenever the cart is modified. This tells any listening widgets that they need to rebuild.

### **Providing the Cart to the App**

Now we need to make the cart available to all screens in our app. Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/order_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return Cart();
      },
      child: const MaterialApp(
        title: 'Sandwich Shop App',
        debugShowCheckedModeBanner: false,
        home: OrderScreen(maxQuantity: 5),
      ),
    );
  }
}
```

Again, review the changes in the Source Control panel before committing. The `ChangeNotifierProvider` creates a single instance of `Cart` and makes it available to all descendant widgets. The `create` function is called once, so we have a single shared cart and `context` is passed to it so our provider (`Cart`) knows where it is in the widget tree.

We've also added `debugShowCheckedModeBanner: false` to remove the debug banner from the app. This is a purely aesthetic change.

### **Consuming the Cart in Screens**

Now we need to update our screens to use the provided cart instead of creating their own instances. Let's start with the order screen.

Update `lib/views/order_screen.dart`. First, add the provider import:

```dart
import 'package:provider/provider.dart';
```

Then, in the `_OrderScreenState` class, remove the `final Cart _cart = Cart();` line defining the cart as a local instance variable and update the methods that use the cart:

```dart
class _OrderScreenState extends State<OrderScreen> {
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

  Future<void> _navigateToProfile() async {
    final Map<String, String>? result =
        await Navigator.push<Map<String, String>>(
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

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      final Cart cart = Provider.of<Cart>(context, listen: false);
      cart.add(sandwich, quantity: _quantity);

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
        builder: (BuildContext context) => const CartScreen(),
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
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 4),
                    Text('${cart.countOfItems}'),
                  ],
                ),
              );
            },
          ),
        ],
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
              StyledButton(
                onPressed: _navigateToProfile,
                icon: Icons.person,
                label: 'Profile',
                backgroundColor: Colors.purple,
              ),
              const SizedBox(height: 20),
              Consumer<Cart>(
                builder: (context, cart, child) {
                  return Text(
                    'Cart: ${cart.countOfItems} items - £${cart.totalPrice.toStringAsFixed(2)}',
                    style: normalText,
                    textAlign: TextAlign.center,
                  );
                },
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

You will have an error caused by how the `CartScreen` is constructed without a cart parameter. We will fix this next. Just review the changes in the Source Control panel.

Notice how we use `Provider.of<Cart>(context, listen: false)` to access the cart when we don't need to rebuild the widget when the cart changes (hover your mouse over `listen` in VS Code to see what it does). This is also the case when adding items to the cart or navigating to another screen.

On the other hand, for the cart summary display and the cart indicator in the app bar, we use `Consumer<Cart>` to automatically rebuild when the cart changes. We additionally have a small cart indicator in the app that shows the total number of items in the cart.

Now update `lib/views/cart_screen.dart` to remove the cart parameter and use the provided cart instead:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _navigateToCheckout() async {
    final Cart cart = Provider.of<Cart>(context, listen: false);
    
    if (cart.items.isEmpty) {
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
        builder: (context) => const CheckoutScreen(),
      ),
    );

    if (result != null && mounted) {
      cart.clear();

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

  void _incrementQuantity(Sandwich sandwich) {
    final Cart cart = Provider.of<Cart>(context, listen: false);
    cart.add(sandwich, quantity: 1);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quantity increased')),
    );
  }

  void _decrementQuantity(Sandwich sandwich) {
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final wasPresent = cart.items.containsKey(sandwich);
    cart.remove(sandwich, quantity: 1);
    if (!cart.items.containsKey(sandwich) && wasPresent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity decreased')),
      );
    }
  }

  void _removeItem(Sandwich sandwich) {
    final Cart cart = Provider.of<Cart>(context, listen: false);
    cart.remove(sandwich, quantity: cart.getQuantity(sandwich));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item removed from cart')),
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
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 4),
                    Text('${cart.countOfItems}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Consumer<Cart>(
            builder: (context, cart, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  if (cart.items.isEmpty)
                    const Text(
                      'Your cart is empty.',
                      style: heading2,
                      textAlign: TextAlign.center,
                    )
                  else
                    for (MapEntry<Sandwich, int> entry in cart.items.entries)
                      Column(
                        children: [
                          Text(entry.key.name, style: heading2),
                          Text(
                            '${_getSizeText(entry.key.isFootlong)} on ${entry.key.breadType.name} bread',
                            style: normalText,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _decrementQuantity(entry.key),
                              ),
                              Text(
                                'Qty: ${entry.value}',
                                style: normalText,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _incrementQuantity(entry.key),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '£${_getItemPrice(entry.key, entry.value).toStringAsFixed(2)}',
                                style: normalText,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Remove item',
                                onPressed: () => _removeItem(entry.key),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                  Text(
                    'Total: £${cart.totalPrice.toStringAsFixed(2)}',
                    style: heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Builder(
                    builder: (BuildContext context) {
                      final bool cartHasItems = cart.items.isNotEmpty;
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
                  StyledButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.arrow_back,
                    label: 'Back to Order',
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

Again, you will have an error because the `CheckoutScreen` is constructed without a cart parameter. Review the changes in the Source Control and commit them.

Finally, update `lib/views/checkout_screen.dart` to use the provided cart:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

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

    final Cart cart = Provider.of<Cart>(context, listen: false);
    final Map orderConfirmation = {
      'orderId': orderId,
      'totalAmount': cart.totalPrice,
      'itemCount': cart.countOfItems,
      'estimatedTime': '15-20 minutes',
    };

    if (mounted) {
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
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text('Checkout', style: heading1),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 4),
                    Text('${cart.countOfItems}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Consumer<Cart>(
          builder: (context, cart, child) {
            List<Widget> columnChildren = [];

            columnChildren.add(const Text('Order Summary', style: heading2));
            columnChildren.add(const SizedBox(height: 20));

            for (MapEntry<Sandwich, int> entry in cart.items.entries) {
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
                  '£${cart.totalPrice.toStringAsFixed(2)}',
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

            return Column(
              children: columnChildren,
            );
          },
        ),
      ),
    );
  }
}
```

Don't forget to update the profile screen to maintain consistency with the app bar design. This is a new page that we have added (it was one of the exercises from the previous worksheet). In `lib/views/profile_screen.dart`, add the provider import and update the app bar:

```dart
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
```

Then update the app bar in the build method:

```dart
appBar: AppBar(
  leading: Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 100,
      child: Image.asset('assets/images/logo.png'),
    ),
  ),
  title: const Text(
    'Profile',
    style: heading1,
  ),
  actions: [
    Consumer<Cart>(
      builder: (context, cart, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_cart),
              const SizedBox(width: 4),
              Text('${cart.countOfItems}'),
            ],
          ),
        );
      },
    ),
  ],
),
```

Test your app to ensure the state management is working correctly. The cart should now be shared across all screens and automatically update when modified.

Before moving on, make sure to update the widget tests for all screens to check for the newly added functionality (some of the current tests will fail, and we have not tested the existence of the cart indicator).

## **Third-Party Packages**

There are a lot of third-party Flutter packages that can add functionality to your app. These packages are published on [pub.dev](https://pub.dev). Those of you who are familiar with JavaScript may find this similar to npm packages.

We recommend against using them as much as possible. Every package is a potential source of bugs and security vulnerabilities. Installing a package means trusting the package maintainers, who are often an open-source volunteer and not a professionals paid by Google. You are trusting them not to introduce malicious code or make mistakes that could affect your app. See this YouTube video for an example of one such incident that could have had catastrophic consequences: [The largest supply-chain attack ever](https://youtu.be/QVqIx-Y8s-s).

To add a package to your project, use the `flutter pub add` command:

```bash
flutter pub add package_name
```

This automatically adds the package to your `pubspec.yaml` file and downloads it. You can then import and use the package in your Dart code.

`add` is a subcommand of the `flutter pub` command. This is one of the many commands that Flutter provides to manage your project's dependencies. You can learn more about `flutter pub` and its subcommands (e.g., `outdated` which lists outdated packages in your project) in the [official documentation](https://dart.dev/tools/pub/cmd). Once you clone your project on a different machine, you can run `flutter pub get` to download all dependencies listed in `pubspec.yaml` although Visual Studio Code should do this automatically when you open the project.

For your coursework, **minimize the number of third-party packages you use**. Focus on learning Flutter's built-in capabilities first.

## **Data Persistence**

So far, all our app data, for example the cart contents, is lost when the app is closed. Real apps need to persist data. Flutter offers several approaches to data persistence, depending on your needs.

### **Shared Preferences for Simple Settings**

For simple key-value data like user preferences, use the `shared_preferences` package. Some of you may have already used this package in the previous worksheet, feel free to skip this section if you have.

`shared_preferences` is perfect for storing settings like theme preferences, user names, or simple configuration options.

For this section, you must run the app on a device (your operating system, connected device or emulator) but not web. We will be building a settings screen which would allow us to modify the font size (the font sizes imported from `app_styles.dart`).

Add the package to your project:

```bash
flutter pub add shared_preferences
```

First, let's update our `app_styles.dart` to load font sizes from shared preferences. This will make font size changes visible throughout the entire app. Update `lib/views/app_styles.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStyles {
  static double _baseFontSize = 16.0;
  
  static Future<void> loadFontSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseFontSize = prefs.getDouble('fontSize') ?? 16.0;
  }
  
  static Future<void> saveFontSize(double fontSize) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
    _baseFontSize = fontSize;
  }
  
  static double get baseFontSize => _baseFontSize;
  
  static TextStyle get normalText => TextStyle(fontSize: _baseFontSize);
  
  static TextStyle get heading1 => TextStyle(
    fontSize: _baseFontSize + 8,
    fontWeight: FontWeight.bold,
  );
  
  static TextStyle get heading2 => TextStyle(
    fontSize: _baseFontSize + 4,
    fontWeight: FontWeight.bold,
  );
}

TextStyle get normalText => AppStyles.normalText;
TextStyle get heading1 => AppStyles.heading1;
TextStyle get heading2 => AppStyles.heading2;
```

Now create a settings screen that demonstrates shared preferences. Create a new file `lib/views/settings_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await AppStyles.loadFontSize();
    setState(() {
      _fontSize = AppStyles.baseFontSize;
      _isLoading = false;
    });
  }

  Future<void> _saveFontSize(double fontSize) async {
    await AppStyles.saveFontSize(fontSize);
    setState(() {
      _fontSize = fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: Text('Settings', style: AppStyles.heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Font Size', style: AppStyles.heading2),
            const SizedBox(height: 20),
            Text(
              'Current size: ${_fontSize.toInt()}px',
              style: TextStyle(fontSize: _fontSize),
            ),
            const SizedBox(height: 20),
            Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 6,
              label: _fontSize.toInt().toString(),
              onChanged: _saveFontSize,
            ),
            const SizedBox(height: 20),
            Text(
              'This is sample text to preview the font size.',
              style: TextStyle(fontSize: _fontSize),
            ),
            const SizedBox(height: 20),
            Text(
              'Font size changes are saved automatically. Restart the app to see changes in all screens.',
              style: AppStyles.normalText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Order', style: AppStyles.normalText),
            ),
          ],
        ),
      ),
    );
  }
}
```

Next, we need to initialize the font size when the app starts. Update `lib/main.dart` to load the saved font size:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStyles.loadFontSize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return Cart();
      },
      child: const MaterialApp(
        title: 'Sandwich Shop App',
        debugShowCheckedModeBanner: false,
        home: OrderScreen(maxQuantity: 5),
      ),
    );
  }
}
```

Now add a button to navigate to the settings screen in your order screen. In `lib/views/order_screen.dart`, inside the `_OrderScreenState` class, add this method to handle navigation to the settings screen:

```dart
void _navigateToSettings() {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const SettingsScreen(),
    ),
  );
}
```

Then add this button in the build method after the profile button:

```dart
const SizedBox(height: 20),
StyledButton(
  onPressed: _navigateToSettings,
  icon: Icons.settings,
  label: 'Settings',
  backgroundColor: Colors.grey,
),
```

Don't forget to import the settings screen:

```dart
import 'package:sandwich_shop/views/settings_screen.dart';
```

Since our text styles are no longer constant (they now depend on shared preferences), you'll need to remove the `const` keyword from widgets that use these styles. You'll see errors like "Invalid constant value".

The easiest way to fix these is to open the Problems panel in VS Code (in Command Palette, type "Problems: Focus on Problems View" and hit Enter), then look for errors related to const constructors. Right click on each error or select them and use the Quick Fix (**Ctrl + .** on Windows or **⌘ + .** on Mac) to remove the `const` keyword.

See below what this should look like:

![Problems View Screenshot](images/screenshot_fixing_problems.png)

This would change:
```dart
const Center(
  child: Text(
    'Image not found',
    style: normalText,
  ),
)
```

To:
```dart
Center(
  child: Text(
    'Image not found',
    style: normalText,
  ),
)
```

You'll need to do this for any widget that uses `normalText`, `heading1`, or `heading2` styles.

Once you have tested the settings screen and ensured that font size changes persist across app restarts, add widget tests for the settings screen and make sure the tests still pass for all other screens. And as always remember to commit your changes regularly.

### **SQLite for Complex Data (Optional)**

For more complex data that requires querying and relationships, use SQLite. This is suitable for storing structured data like order history, user profiles, or any data that benefits from SQL queries.

SQLite is similar to PostgreSQL but simpler. Like PostgreSQL, you create tables with columns and data types, but SQLite is embedded in your app rather than running as a separate server.

In this section, which **is completely optional to do**, we will implement a simple order history feature using SQLite. For more information on SQLite, see the [official documentation](https://docs.flutter.dev/cookbook/persistence/sqlite).

Start by adding the required packages to your project with the following command. [`sqflite`](https://pub.dev/packages/sqflite) is the SQLite plugin for Flutter, and [`path`](https://pub.dev/packages/path) helps with the location of the database file:

```bash
flutter pub add sqflite path
```

Let's create a simple order history feature. First, create a model for saved orders. This model represents a row in our database table. Create `lib/models/saved_order.dart`:

```dart
class SavedOrder {
  final int id;
  final String orderId;
  final double totalAmount;
  final int itemCount;
  final DateTime orderDate;

  SavedOrder({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.itemCount,
    required this.orderDate,
  });

  Map<String, Object?> toMap() {
    return {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'itemCount': itemCount,
      'orderDate': orderDate.millisecondsSinceEpoch,
    };
  }

  SavedOrder.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        orderId = map['orderId'] as String,
        totalAmount = map['totalAmount'] as double,
        itemCount = map['itemCount'] as int,
        orderDate =
            DateTime.fromMillisecondsSinceEpoch(map['orderDate'] as int);
}
```

The `toMap()` method converts our Dart object into a Map (like a dictionary) that SQLite can store. The `fromMap()` constructor does the opposite - it takes a Map from SQLite and creates a Dart object. We store dates as milliseconds since epoch because SQLite doesn't have a native date type.

Now create a database service to handle all database operations. Create `lib/services/database_service.dart`:

```dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sandwich_shop/models/saved_order.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'sandwich_shop.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId TEXT NOT NULL,
            totalAmount REAL NOT NULL,
            itemCount INTEGER NOT NULL,
            orderDate INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertOrder(SavedOrder order) async {
    final Database db = await database;
    await db.insert('orders', order.toMap());
  }

  Future<List<SavedOrder>> getOrders() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'orders',
      orderBy: 'orderDate DESC',
    );

    List<SavedOrder> orders = [];
    for (int i = 0; i < maps.length; i++) {
      orders.add(SavedOrder.fromMap(maps[i]));
    }
    return orders;
  }

  Future<void> deleteOrder(int id) async {
    final Database db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

The database is created automatically when first accessed. The `onCreate` callback runs only once to set up the table structure. The `maps.length` gives us the number of rows returned from the query, and we use it to convert each row (`Map`) into a `SavedOrder` object.

Update the checkout screen to save orders to the database. In `lib/views/checkout_screen.dart`, add the imports:

```dart
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/models/saved_order.dart';
```

Then update the `_processPayment` method to the following:

```dart
Future<void> _processPayment() async {
  final Cart cart = Provider.of<Cart>(context, listen: false);
  
  setState(() {
    _isProcessing = true;
  });

  await Future.delayed(const Duration(seconds: 2));

  final DateTime currentTime = DateTime.now();
  final int timestamp = currentTime.millisecondsSinceEpoch;
  final String orderId = 'ORD$timestamp';
  
  final SavedOrder savedOrder = SavedOrder(
    id: 0, // Will be auto-generated by database
    orderId: orderId,
    totalAmount: cart.totalPrice,
    itemCount: cart.countOfItems,
    orderDate: currentTime,
  );

  final DatabaseService databaseService = DatabaseService();
  await databaseService.insertOrder(savedOrder);

  final Map orderConfirmation = {
    'orderId': orderId,
    'totalAmount': cart.totalPrice,
    'itemCount': cart.countOfItems,
    'estimatedTime': '15-20 minutes',
  };

  if (mounted) {
    Navigator.pop(context, orderConfirmation);
  }
}
```

Create an order history screen. Create `lib/views/order_history_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/models/saved_order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<SavedOrder> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final List<SavedOrder> orders = await _databaseService.getOrders();
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  String _formatDate(DateTime date) {
    String output = '${date.day}/${date.month}/${date.year}';
    output += ' ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    return output;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          title: Text('Order History', style: AppStyles.heading1),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_orders.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          title: Text('Order History', style: AppStyles.heading1),
        ),
        body: Center(
          child: Text('No orders yet', style: AppStyles.heading2),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: Text('Order History', style: AppStyles.heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final SavedOrder order = _orders[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order.orderId, style: AppStyles.heading2),
                          Text('£${order.totalAmount.toStringAsFixed(2)}',
                              style: AppStyles.heading2),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${order.itemCount} items',
                              style: AppStyles.normalText),
                          Text(_formatDate(order.orderDate),
                              style: AppStyles.normalText),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

To navigate to this page, we need to add a button to `lib/views/order_screen.dart` that takes us to order history screen. In `lib/views/order_screen.dart`, inside the `_OrderScreenState` class, add this method after the existing navigation methods:

```dart
void _navigateToOrderHistory() {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const OrderHistoryScreen(),
    ),
  );
}
```

And add this button in the build method after the settings button:

```dart
const SizedBox(height: 20),
StyledButton(
  onPressed: _navigateToOrderHistory,
  icon: Icons.history,
  label: 'Order History',
  backgroundColor: Colors.indigo,
),
```

Don't forget to import the order history screen:

```dart
import 'package:sandwich_shop/views/order_history_screen.dart';
```

As with shared preferences, test this feature on a device or simulator (not web). Complete a few orders and navigate to the order history screen to see your saved orders. 

The database file is stored at `/data/data/<your_app_id>/databases/sandwich_shop.db` on Android devices.

Remember to add widget tests for the order history screen and the updated checkout and order screens. Also, since we have added a model and a service, use your AI assistant to help you write unit tests for these new classes. To test SQLite functionality, you can use the `sqflite_common_ffi` package which allows you to run SQLite in a Dart VM environment (like during tests). Add it to your `dev_dependencies` in `pubspec.yaml` by running:

```bash
flutter pub add --dev sqflite_common_ffi
```

Read more about it in the [official documentation](https://pub.dev/packages/sqflite_common_ffi). Once you have added all the tests, make sure to manually check to make sure all functionality is tested and that all tests pass by running `flutter test`.

We have not mentioned committing your changes in this section but we would ideally want you to commit each step of the way. For example, after creating the model, after creating the service, after updating the checkout screen, and after creating the order history screen. Well done if you have completed the worksheet up to this point!

## **Exercises**

This week we have had a heavy worksheet so we will keep the exercises light. Complete the following exercises at your own pace.

1. Our codebase currently has a lot of redundancy and inconsistencies. For example, the app bar is implemented separately in each screen, and the cart indicator is also duplicated.

    You can choose to place duplicated code (widgets) in a separate file, ideally called `common_widgets.dart` inside the `views` folder and import it wherever needed. You can for example, take your solution to the second exercise form [Worksheet 6](worksheet-6.md#exercises) and place it there. Think about what else can be placed there to decrease redundancy and declutter your codebase.

    The goal of this exercise is to eliminate duplication, standardize the look of the app across all screens, and ideally add a more consistent navigation experience.

    ⚠️ **Show your consistent appbar across all pages to a member of staff** for a sign-off.

2. (Advanced) Our database operations so far are only limited to creating a table, inserting and reading data. You are already familiar with SQL commands like `UPDATE` and `DELETE` from your previous database module.

    Extend the functionality of the order history screen to allow users to modify their orders after a certain period of time (e.g., 5 minutes after placing the order).

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

3. (Advanced) We've shown you examples of unit testing and widget testing so far. Another type of testing is integration testing, which tests the complete app or a large part of it.

    In Flutter, integration tests are written using the `integration_test` package. You can read more about it in the [official documentation](https://docs.flutter.dev/testing/integration-tests). We will cover this topic in more detail in the next worksheet but you are welcome to explore it now.

    As a solid goal, write integration tests that cover the main user flows in your app, such as placing an order from start to finish.

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.
```

This is the code they end with after completing worksheet 7.

lib/models/cart.dart
```dart
import 'package:flutter/foundation.dart';
import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart extends ChangeNotifier {
  final Map<Sandwich, int> _items = {};

  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      _items[sandwich] = _items[sandwich]! + quantity;
    } else {
      _items[sandwich] = quantity;
    }
    notifyListeners();
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        _items.remove(sandwich);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;

    for (Sandwich sandwich in _items.keys) {
      int quantity = _items[sandwich]!;
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (int quantity in _items.values) {
      total += quantity;
    }
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

lib/models/sandwich.dart
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

lib/models/saved_order.dart
```dart
class SavedOrder {
  final int id;
  final String orderId;
  final double totalAmount;
  final int itemCount;
  final DateTime orderDate;

  SavedOrder({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.itemCount,
    required this.orderDate,
  });

  Map<String, Object?> toMap() {
    return {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'itemCount': itemCount,
      'orderDate': orderDate.millisecondsSinceEpoch,
    };
  }

  SavedOrder.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        orderId = map['orderId'] as String,
        totalAmount = map['totalAmount'] as double,
        itemCount = map['itemCount'] as int,
        orderDate =
            DateTime.fromMillisecondsSinceEpoch(map['orderDate'] as int);
}
```

lib/repositories/pricing_repository.dart
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

lib/services/database_service.dart
```dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sandwich_shop/models/saved_order.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'sandwich_shop.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId TEXT NOT NULL,
            totalAmount REAL NOT NULL,
            itemCount INTEGER NOT NULL,
            orderDate INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertOrder(SavedOrder order) async {
    final Database db = await database;
    await db.insert('orders', order.toMap());
  }

  Future<List<SavedOrder>> getOrders() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'orders',
      orderBy: 'orderDate DESC',
    );

    List<SavedOrder> orders = [];
    for (int i = 0; i < maps.length; i++) {
      orders.add(SavedOrder.fromMap(maps[i]));
    }
    return orders;
  }

  Future<void> deleteOrder(int id) async {
    final Database db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

lib/views/app_styles.dart
```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStyles {
  static double _baseFontSize = 16.0;

  static Future<void> loadFontSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseFontSize = prefs.getDouble('fontSize') ?? 16.0;
  }

  static Future<void> saveFontSize(double fontSize) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
    _baseFontSize = fontSize;
  }

  static double get baseFontSize => _baseFontSize;

  static TextStyle get normalText => TextStyle(fontSize: _baseFontSize);

  static TextStyle get heading1 => TextStyle(
        fontSize: _baseFontSize + 8,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get heading2 => TextStyle(
        fontSize: _baseFontSize + 4,
        fontWeight: FontWeight.bold,
      );
}

TextStyle get normalText => AppStyles.normalText;
TextStyle get heading1 => AppStyles.heading1;
TextStyle get heading2 => AppStyles.heading2;
```

lib/views/cart_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _navigateToCheckout() async {
    final Cart cart = Provider.of<Cart>(context, listen: false);

    if (cart.items.isEmpty) {
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
        builder: (context) => const CheckoutScreen(),
      ),
    );

    if (result != null && mounted) {
      cart.clear();

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

  void _incrementQuantity(Sandwich sandwich) {
    final Cart cart = Provider.of<Cart>(context, listen: false);
    cart.add(sandwich, quantity: 1);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quantity increased')),
    );
  }

  void _decrementQuantity(Sandwich sandwich) {
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final wasPresent = cart.items.containsKey(sandwich);
    cart.remove(sandwich, quantity: 1);
    if (!cart.items.containsKey(sandwich) && wasPresent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity decreased')),
      );
    }
  }

  void _removeItem(Sandwich sandwich) {
    final Cart cart = Provider.of<Cart>(context, listen: false);
    cart.remove(sandwich, quantity: cart.getQuantity(sandwich));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item removed from cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Cart',
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 4),
                    Text('${cart.countOfItems}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Consumer<Cart>(
            builder: (context, cart, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  if (cart.items.isEmpty)
                    Text(
                      'Your cart is empty.',
                      style: heading2,
                      textAlign: TextAlign.center,
                    )
                  else
                    for (MapEntry<Sandwich, int> entry in cart.items.entries)
                      Column(
                        children: [
                          Text(entry.key.name, style: heading2),
                          Text(
                            '${_getSizeText(entry.key.isFootlong)} on ${entry.key.breadType.name} bread',
                            style: normalText,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _decrementQuantity(entry.key),
                              ),
                              Text(
                                'Qty: ${entry.value}',
                                style: normalText,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _incrementQuantity(entry.key),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '£${_getItemPrice(entry.key, entry.value).toStringAsFixed(2)}',
                                style: normalText,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Remove item',
                                onPressed: () => _removeItem(entry.key),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                  Text(
                    'Total: £${cart.totalPrice.toStringAsFixed(2)}',
                    style: heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Builder(
                    builder: (BuildContext context) {
                      final bool cartHasItems = cart.items.isNotEmpty;
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
                  StyledButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.arrow_back,
                    label: 'Back to Order',
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

lib/views/checkout_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/models/saved_order.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    final Cart cart = Provider.of<Cart>(context, listen: false);

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    final SavedOrder savedOrder = SavedOrder(
      id: 0, // Will be auto-generated by database
      orderId: orderId,
      totalAmount: cart.totalPrice,
      itemCount: cart.countOfItems,
      orderDate: currentTime,
    );

    final DatabaseService databaseService = DatabaseService();
    await databaseService.insertOrder(savedOrder);

    final Map orderConfirmation = {
      'orderId': orderId,
      'totalAmount': cart.totalPrice,
      'itemCount': cart.countOfItems,
      'estimatedTime': '15-20 minutes',
    };

    if (mounted) {
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
    return Scaffold(
      appBar: const CommonAppBar(title: 'Checkout'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Consumer<Cart>(
          builder: (context, cart, child) {
            List<Widget> columnChildren = [];

            columnChildren.add(Text('Order Summary', style: heading2));
            columnChildren.add(const SizedBox(height: 20));

            for (MapEntry<Sandwich, int> entry in cart.items.entries) {
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
                Text('Total:', style: heading2),
                Text(
                  '£${cart.totalPrice.toStringAsFixed(2)}',
                  style: heading2,
                ),
              ],
            );
            columnChildren.add(totalRow);
            columnChildren.add(const SizedBox(height: 40));

            columnChildren.add(
              Text(
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
                Text(
                  'Processing payment...',
                  style: normalText,
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              columnChildren.add(
                ElevatedButton(
                  onPressed: _processPayment,
                  child: Text('Confirm Payment', style: normalText),
                ),
              );
            }

            return Column(
              children: columnChildren,
            );
          },
        ),
      ),
    );
  }
}
```

lib/views/order_history_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/models/saved_order.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<SavedOrder> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final List<SavedOrder> orders = await _databaseService.getOrders();
    if (mounted) {
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    String output = '${date.day}/${date.month}/${date.year}';
    output += ' ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    return output;
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CommonAppBar(title: 'Order History'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_orders.isEmpty) {
      return Scaffold(
        appBar: const CommonAppBar(title: 'Order History'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No orders yet', style: AppStyles.heading2),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: () => Navigator.pop(context),
                icon: Icons.arrow_back,
                label: 'Back to Order',
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(title: 'Order History'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final SavedOrder order = _orders[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order.orderId, style: AppStyles.heading2),
                          Text('£${order.totalAmount.toStringAsFixed(2)}',
                              style: AppStyles.heading2),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${order.itemCount} items',
                              style: AppStyles.normalText),
                          Text(_formatDate(order.orderDate),
                              style: AppStyles.normalText),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            StyledButton(
              onPressed: _goBack,
              icon: Icons.arrow_back,
              label: 'Back to Order',
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
```

lib/views/order_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/order_history_screen.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
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

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const SettingsScreen(),
      ),
    );
  }

  Future<void> _navigateToProfile() async {
    final Map<String, String>? result =
        await Navigator.push<Map<String, String>>(
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

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      final Cart cart = Provider.of<Cart>(context, listen: false);
      cart.add(sandwich, quantity: _quantity);

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
        builder: (BuildContext context) => const CartScreen(),
      ),
    );
  }

  void _navigateToOrderHistory() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const OrderHistoryScreen(),
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
      appBar: CommonAppBar(
        title: 'Sandwich Counter',
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 4),
                    Text('${cart.countOfItems}'),
                  ],
                ),
              );
            },
          ),
        ],
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
                    return Center(
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
                  Text('Six-inch', style: normalText),
                  Switch(
                    value: _isFootlong,
                    onChanged: (value) => setState(() => _isFootlong = value),
                  ),
                  Text('Footlong', style: normalText),
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
                  Text('Quantity: ', style: normalText),
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
              StyledButton(
                onPressed: _navigateToProfile,
                icon: Icons.person,
                label: 'Profile',
                backgroundColor: Colors.purple,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _navigateToSettings,
                icon: Icons.settings,
                label: 'Settings',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _navigateToOrderHistory,
                icon: Icons.history,
                label: 'Order History',
                backgroundColor: Colors.indigo,
              ),
              const SizedBox(height: 20),
              Consumer<Cart>(
                builder: (context, cart, child) {
                  return Text(
                    'Cart: ${cart.countOfItems} items - £${cart.totalPrice.toStringAsFixed(2)}',
                    style: normalText,
                    textAlign: TextAlign.center,
                  );
                },
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

lib/views/profile_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

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
      appBar: CommonAppBar(
        title: 'Profile',
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 4),
                    Text('${cart.countOfItems}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Enter your details:', style: heading2),
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

lib/views/settings_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await AppStyles.loadFontSize();
    setState(() {
      _fontSize = AppStyles.baseFontSize;
      _isLoading = false;
    });
  }

  Future<void> _saveFontSize(double fontSize) async {
    await AppStyles.saveFontSize(fontSize);
    setState(() {
      _fontSize = fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(title: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Font Size', style: AppStyles.heading2),
            const SizedBox(height: 20),
            Text(
              'Current size: ${_fontSize.toInt()}px',
              style: TextStyle(fontSize: _fontSize),
            ),
            const SizedBox(height: 20),
            Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 6,
              label: _fontSize.toInt().toString(),
              onChanged: _saveFontSize,
            ),
            const SizedBox(height: 20),
            Text(
              'This is sample text to preview the font size.',
              style: TextStyle(fontSize: _fontSize),
            ),
            const SizedBox(height: 20),
            Text(
              'Font size changes are saved automatically. Restart the app to see changes in all screens.',
              style: AppStyles.normalText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Order', style: AppStyles.normalText),
            ),
          ],
        ),
      ),
    );
  }
}
```

lib/widgets/common_widgets.dart
```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      title: Text(title, style: AppStyles.heading1),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: AppStyles.normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
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

lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStyles.loadFontSize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return Cart();
      },
      child: const MaterialApp(
        title: 'Sandwich Shop App',
        debugShowCheckedModeBanner: false,
        home: OrderScreen(maxQuantity: 5),
      ),
    );
  }
}
```

test/models/cart_test.dart
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Cart', () {
    late Cart cart;
    late Sandwich sandwichA;
    late Sandwich sandwichB;

    setUp(() {
      cart = Cart();
      sandwichA = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      sandwichB = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.white,
      );
    });

    test('should start empty', () {
      expect(cart.isEmpty, isTrue);
      expect(cart.length, 0);
      expect(cart.items, isEmpty);
    });

    test('should add a sandwich with default quantity 1', () {
      cart.add(sandwichA);
      expect(cart.getQuantity(sandwichA), 1);
      expect(cart.length, 1);
      expect(cart.isEmpty, isFalse);
    });

    test('should add a sandwich with custom quantity', () {
      cart.add(sandwichA, quantity: 3);
      expect(cart.getQuantity(sandwichA), 3);
      expect(cart.length, 1);
    });

    test('should increase quantity if same sandwich is added again', () {
      cart.add(sandwichA);
      cart.add(sandwichA, quantity: 2);
      expect(cart.getQuantity(sandwichA), 3);
    });

    test('should add multiple different sandwiches', () {
      cart.add(sandwichA);
      cart.add(sandwichB, quantity: 2);
      expect(cart.getQuantity(sandwichA), 1);
      expect(cart.getQuantity(sandwichB), 2);
      expect(cart.length, 2);
    });

    test('should remove quantity of a sandwich', () {
      cart.add(sandwichA, quantity: 3);
      cart.remove(sandwichA, quantity: 2);
      expect(cart.getQuantity(sandwichA), 1);
      expect(cart.length, 1);
    });

    test('should remove sandwich completely if quantity drops to zero', () {
      cart.add(sandwichA, quantity: 2);
      cart.remove(sandwichA, quantity: 2);
      expect(cart.getQuantity(sandwichA), 0);
      expect(cart.isEmpty, isTrue);
      expect(cart.length, 0);
    });

    test('should not throw an error when removing a sandwich not in cart', () {
      expect(() => cart.remove(sandwichA), returnsNormally);
    });

    test('should clear all items', () {
      cart.add(sandwichA);
      cart.add(sandwichB);
      cart.clear();
      expect(cart.isEmpty, isTrue);
      expect(cart.items, isEmpty);
    });

    test('getQuantity returns correct quantity', () {
      cart.add(sandwichA, quantity: 4);
      expect(cart.getQuantity(sandwichA), 4);
      expect(cart.getQuantity(sandwichB), 0);
    });

    test('items getter is unmodifiable', () {
      cart.add(sandwichA);
      final Map<Sandwich, int> items = cart.items;
      expect(() => items[sandwichB] = 2, throwsUnsupportedError);
    });

    test('totalPrice calculates sum using PricingRepository', () {
      cart.add(sandwichA, quantity: 2);
      cart.add(sandwichB, quantity: 1);
      expect(cart.totalPrice, isA<double>());
      expect(cart.totalPrice, greaterThan(0));
    });

    test('should handle adding and removing multiple sandwiches correctly', () {
      cart.add(sandwichA, quantity: 2);
      cart.add(sandwichB, quantity: 3);
      cart.remove(sandwichA, quantity: 1);
      cart.remove(sandwichB, quantity: 2);
      expect(cart.getQuantity(sandwichA), 1);
      expect(cart.getQuantity(sandwichB), 1);
      expect(cart.length, 2);
    });

    test('should not allow negative quantities', () {
      cart.add(sandwichA, quantity: 2);
      cart.remove(sandwichA, quantity: 5);
      expect(cart.getQuantity(sandwichA), 0);
      expect(cart.isEmpty, isTrue);
    });
  });
}
```

test/models/sandwich_test.dart
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich', () {
    test('should create a Sandwich with correct properties', () {
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      expect(sandwich.type, SandwichType.veggieDelight);
      expect(sandwich.isFootlong, isTrue);
      expect(sandwich.breadType, BreadType.wholemeal);
      expect(sandwich.name, 'Veggie Delight');
      expect(sandwich.image, 'assets/images/veggieDelight_footlong.png');
    });

    test('should support all BreadType enum values', () {
      for (final BreadType bread in BreadType.values) {
        final Sandwich sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: bread,
        );
        expect(sandwich.breadType, bread);
      }
    });

    test('should support all SandwichType enum values and correct names', () {
      final Map<SandwichType, String> expectedNames = {
        SandwichType.veggieDelight: 'Veggie Delight',
        SandwichType.chickenTeriyaki: 'Chicken Teriyaki',
        SandwichType.tunaMelt: 'Tuna Melt',
        SandwichType.meatballMarinara: 'Meatball Marinara',
      };
      for (final SandwichType type in SandwichType.values) {
        final Sandwich sandwich = Sandwich(
          type: type,
          isFootlong: false,
          breadType: BreadType.white,
        );
        expect(sandwich.type, type);
        expect(sandwich.name, expectedNames[type]);
      }
    });

    test('should generate correct image path for footlong', () {
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      expect(sandwich.image, 'assets/images/chickenTeriyaki_footlong.png');
    });

    test('should generate correct image path for six inch', () {
      final Sandwich sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.white,
      );
      expect(sandwich.image, 'assets/images/meatballMarinara_six_inch.png');
    });
  });
}
```

test/models/saved_order_test.dart
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/saved_order.dart';

void main() {
  group('SavedOrder', () {
    testWidgets('creates SavedOrder with all required fields', (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final SavedOrder order = SavedOrder(
        id: 1,
        orderId: 'ORD123456',
        totalAmount: 25.50,
        itemCount: 3,
        orderDate: testDate,
      );

      expect(order.id, equals(1));
      expect(order.orderId, equals('ORD123456'));
      expect(order.totalAmount, equals(25.50));
      expect(order.itemCount, equals(3));
      expect(order.orderDate, equals(testDate));
    });

    testWidgets('toMap converts SavedOrder to Map correctly', (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final SavedOrder order = SavedOrder(
        id: 1,
        orderId: 'ORD123456',
        totalAmount: 25.50,
        itemCount: 3,
        orderDate: testDate,
      );

      final Map<String, Object?> map = order.toMap();

      expect(map['orderId'], equals('ORD123456'));
      expect(map['totalAmount'], equals(25.50));
      expect(map['itemCount'], equals(3));
      expect(map['orderDate'], equals(testDate.millisecondsSinceEpoch));
      expect(map.containsKey('id'), isFalse);
    });

    testWidgets('fromMap creates SavedOrder from Map correctly',
        (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final Map<String, Object?> map = {
        'id': 1,
        'orderId': 'ORD123456',
        'totalAmount': 25.50,
        'itemCount': 3,
        'orderDate': testDate.millisecondsSinceEpoch,
      };

      final SavedOrder order = SavedOrder.fromMap(map);

      expect(order.id, equals(1));
      expect(order.orderId, equals('ORD123456'));
      expect(order.totalAmount, equals(25.50));
      expect(order.itemCount, equals(3));
      expect(order.orderDate, equals(testDate));
    });

    testWidgets('toMap and fromMap are inverse operations', (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final SavedOrder originalOrder = SavedOrder(
        id: 1,
        orderId: 'ORD123456',
        totalAmount: 25.50,
        itemCount: 3,
        orderDate: testDate,
      );

      final Map<String, Object?> map = originalOrder.toMap();
      map['id'] = originalOrder.id;
      final SavedOrder reconstructedOrder = SavedOrder.fromMap(map);

      expect(reconstructedOrder.id, equals(originalOrder.id));
      expect(reconstructedOrder.orderId, equals(originalOrder.orderId));
      expect(reconstructedOrder.totalAmount, equals(originalOrder.totalAmount));
      expect(reconstructedOrder.itemCount, equals(originalOrder.itemCount));
      expect(reconstructedOrder.orderDate, equals(originalOrder.orderDate));
    });

    testWidgets('handles different data types correctly', (tester) async {
      final DateTime testDate = DateTime(2023, 1, 1, 0, 0);
      final SavedOrder order = SavedOrder(
        id: 999,
        orderId: 'ORD999999999',
        totalAmount: 0.01,
        itemCount: 1,
        orderDate: testDate,
      );

      final Map<String, Object?> map = order.toMap();
      map['id'] = order.id;
      final SavedOrder reconstructedOrder = SavedOrder.fromMap(map);

      expect(reconstructedOrder.id, equals(999));
      expect(reconstructedOrder.orderId, equals('ORD999999999'));
      expect(reconstructedOrder.totalAmount, equals(0.01));
      expect(reconstructedOrder.itemCount, equals(1));
      expect(reconstructedOrder.orderDate, equals(testDate));
    });
  });
}
```

test/repositories/pricing_repository_test.dart
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    final repository = PricingRepository();

    test('calculates price for single six-inch correctly', () {
      final price = repository.calculatePrice(quantity: 1, isFootlong: false);
      expect(price, 7.00);
    });

    test('calculates price for multiple footlongs correctly', () {
      final price = repository.calculatePrice(quantity: 3, isFootlong: true);
      expect(price, 33.00);
    });

    test('calculates price for zero quantity as zero', () {
      final price = repository.calculatePrice(quantity: 0, isFootlong: true);
      expect(price, 0.00);
    });
  });
}
```

test/services/database_service_test.dart
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/models/saved_order.dart';

void main() {
  group('DatabaseService', () {
    late DatabaseService databaseService;

    setUp(() {
      databaseService = DatabaseService();
    });

    testWidgets('creates database service instance', (tester) async {
      expect(databaseService, isNotNull);
      expect(databaseService, isA<DatabaseService>());
    });

    testWidgets('database service has required methods', (tester) async {
      expect(databaseService.insertOrder, isA<Function>());
      expect(databaseService.getOrders, isA<Function>());
      expect(databaseService.deleteOrder, isA<Function>());
    });

    testWidgets('can create SavedOrder for database operations',
        (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final SavedOrder order = SavedOrder(
        id: 0,
        orderId: 'ORD123456',
        totalAmount: 25.50,
        itemCount: 3,
        orderDate: testDate,
      );

      expect(order.orderId, equals('ORD123456'));
      expect(order.totalAmount, equals(25.50));
      expect(order.itemCount, equals(3));
      expect(order.orderDate, equals(testDate));
    });

    testWidgets('SavedOrder toMap excludes id field', (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final SavedOrder order = SavedOrder(
        id: 1,
        orderId: 'ORD123456',
        totalAmount: 25.50,
        itemCount: 3,
        orderDate: testDate,
      );

      final Map<String, Object?> map = order.toMap();
      expect(map.containsKey('id'), isFalse);
      expect(map['orderId'], equals('ORD123456'));
      expect(map['totalAmount'], equals(25.50));
      expect(map['itemCount'], equals(3));
      expect(map['orderDate'], equals(testDate.millisecondsSinceEpoch));
    });
  });
}
```

test/views/cart_screen_test.dart
```dart



Now I need your help writing worksheet 8 for me.
