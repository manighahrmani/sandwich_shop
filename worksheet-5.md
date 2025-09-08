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

## **Introduction to Data Models**

So far, we've been passing simple data types like `String` and `int` between our widgets. As our app grows in complexity, it's better to group related data into custom data types (classes). We call these **data models**.

If you've worked with databases before, you can think of data models as being similar to **entities**. An entity is a real-world object or concept that can be distinctly identified. In our case, a "Sandwich" is a perfect example of an entity that we can represent with a data model.

### **Business Logic Decisions**

During your development, you as the developer would make certain business decisions about how the app should function. Here is an example of one such decision we have made regarding our app. 

We assume that the price of a sandwich depends only on its size (footlong vs six-inch), not on the type of sandwich or bread type. This keeps our pricing simple and consistent.

This is why our `PricingRepository` only needs to know the quantity and size (`isFootlong`) to calculate the total price. The sandwich type (like "Veggie Delight" or "Turkey Club") and bread type don't affect the price.

### **Creating the `Sandwich` model**

Let's start by defining a `Sandwich` model. This will help us manage all the properties of a sandwich in one place.

In your `lib` folder, create a new folder called `models`. Inside this folder, create a new file called `sandwich.dart`. This is what your project structure may look like:

```
lib/
├── views/
│   ├── app_styles.dart
│   └── main.dart
├── view_models/
├── models/
│   └── sandwich.dart
└── repositories/
    └── pricing_repository.dart
```

You will notice that we have not listed `lib/repository/order_repository.dart`. You can **delete `order_repository.dart` from your `repositories` folder** as it's no longer needed with our new data model approach (more on this later). Make sure to remove the import statement for this file from `main.dart` as well as the `order_repository_test.dart` unit test from the `test/repository` folder.

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

Ask your AI assistant to explain why we use getters here instead of storing the name and image as instance variables recieved in the constructor.

Before moving on, use your AI assistant to write a unit test for the `Sandwich` model. Remember to create a `models` folder inside the `test` folder to mirror the structure of the `lib` folder. Your test file should ideally be named `sandwich_test.dart`.

#### **Commit your changes**

Here's a reminder to commit your changes (commit them individually, the addition of the model and the test).

### **The `Cart` model**

Now that we can represent a single sandwich, we need a way to manage a collection of them in an order. We need to create a `Cart` class that can hold multiple `Sandwich` objects along with their quantities.

Create a new file called `cart.dart` in the `models` folder. Ask your AI assistant to help you implement a `Cart` class. Take your time writing a prompt that clearly describes the functionality you want. Think about what typical operations a user would perform on a cart of a food delivery app.

Remember that the price calculation should use our existing `PricingRepository` since it's the single source of truth for pricing logic. You'll need to import the `PricingRepository` and use its `calculatePrice` method in the `cart.dart` file.

As before, write unit tests for the `Cart` model in a new file called `cart_test.dart` inside the `test/models` folder.

#### **Commit your changes**

Commit the addition of the `Cart` model and its tests before moving on.

## **Managing Assets**

Our `Sandwich` model automatically generates image paths, but we haven't provided any images yet. In Flutter, static files like images, fonts, and configuration files are called **assets**.

First, create an `assets` folder in the root of your project, at the same level as the `lib` and `test` folders. Inside the `assets` folder, create another folder called `images`.

You'll need to create images for each sandwich type and size combination. Based on our `SandwichType` enum, you'll need images named like: `veggieDelight_footlong.png` or `veggieDelight_six_inch.png` and so on for all the sandwich types.

We have already provided you with a logo image called `logo.png` for the app bar. If you have [cloned/forked the repository](https://github.com/manighahrmani/sandwich_shop) this should already be in your folder, otherwise, download it from [this page](https://github.com/manighahrmani/sandwich_shop/blob/5/assets/images/logo.png) and save it as `logo.png` in the `assets/images` folder.

Use your AI assistant to help you find or create placeholder images for the sandwiches and logo. You can use simple coloured rectangles or search for copyright-free images online. Save these images in the `assets/images` folder with the exact naming convention shown above.

Next, you need to tell Flutter about these new assets. Open the `pubspec.yaml` file and add an `assets` section like this (**the `uses-material-design: true` line already exists there, just add everything below it**).

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

Make sure the indentation is correct, as `pubspec.yaml` is sensitive to whitespace. The line `assets:` should be at the same indentation level as `uses-material-design:`.

Now you can use these images in your app. For more information, you can read the official Flutter documentation on [adding assets and images](https://docs.flutter.dev/ui/assets/assets-and-images).

#### **Commit your changes**

Commit your new assets with the message `Add sandwich images as assets`.

### **Adding a simple logo to the app bar**

Before we dive into the more complex sandwich image display, let's start with a simple example of using images. We'll add a logo to the app bar.

In your `main.dart` file, update the `AppBar` in the `build` method to include a logo:

```dart
appBar: AppBar(
  leading: Image.asset('assets/images/logo.png'),
  title: const Text(
    'Sandwich Counter',
    style: heading1,
  ),
),
```

The `Image.asset()` widget loads an image from your assets folder. The `leading` property of `AppBar` places the widget before the title. Run your app to see the logo appear in the app bar.

For more information about the `Image` widget and its properties, check the [Flutter documentation on Image](https://api.flutter.dev/flutter/widgets/Image-class.html).

#### **Commit your changes**

Commit this simple logo addition before moving on to the more complex image display.

## **Updating the UI**

Now that we have our models and assets, let's update our UI to use them. We'll create a simple interface where users can select a sandwich type, size, bread type, and quantity, then add it to their cart.

### **Updating the imports**

First, open `lib/views/main.dart` and add the necessary imports at the top of the file:

```dart
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';
```

As mentioned before, you need to remove the import for `order_repository.dart` since it's no longer needed. The same goes for `pricing_repository.dart` as we will be using its `calculatePrice` method through the `Cart` model.

You'll also need to remove the `BreadType` enum from `main.dart` since it's now defined in the `sandwich.dart` file.

### **Displaying sandwich images**

Now let's add dynamic image display that updates based on the user's selection. We'll show the sandwich image that corresponds to the selected type and size.

First, let's add an image display to our UI. In your `_OrderScreenState` class, add this method to get the current sandwich image path:

```dart
String _getCurrentImagePath() {
  final Sandwich sandwich = Sandwich(
    type: _selectedSandwichType,
    isFootlong: _isFootlong,
    breadType: _selectedBreadType,
  );
  return sandwich.image;
}
```

This method creates a temporary `Sandwich` object with the current selections and uses its `image` getter to get the correct image path.

### **Creating the sandwich customization UI**

Now we'll update the UI to include the image display and replace the old order management system with our new cart-based approach.

Since we're changing the UI structure significantly, you can remove the `StyledButton` and `OrderItemDisplay` classes from the bottom of your `main.dart` file as they're no longer needed with our new approach.

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
      String confirmationMessage = 'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';
      
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
      Sandwich sandwich = Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
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
    );
  }
}
```

The `Image.asset()` shows the current sandwich image. The `_getCurrentImagePath()` method ensures the image updates automatically when users change their selections. The `errorBuilder` property handles cases where an image file doesn't exist, showing a "Image not found" message instead of crashing.
The dropdown menus, switch, and quantity controls work together to update the image in real-time. When the user adds items to the cart, a confirmation message is printed to the debug console using `debugPrint()`. If you don't see the debug console in VS Code, open the Command Palette (**Ctrl+Shift+P** or **⌘+Shift+P**) and type "Focus on Debug Console View" to open it.

Ask your AI assistant to explain any parts of this code you don't understand, particularly:
- How `setState()` triggers image updates when selections change
- What the `errorBuilder` property does and why it's important
- How the `fit: BoxFit.cover` property affects image display

For more information about image handling in Flutter, check the [Flutter documentation on Image](https://api.flutter.dev/flutter/widgets/Image-class.html) and [BoxFit](https://api.flutter.dev/flutter/painting/BoxFit.html).

As always, write widget tests to ensure your UI behaves as expected. Test scenarios like adding items to the cart, changing quantities, and selecting different sandwich options.

#### **Commit your changes**

Once you've update and tested the UI, commit your changes.

#### **Commit your changes**

Make sure all your changes are committed before moving on to the exercises or the next worksheet.

## **Exercises**

<!-- TODO: Add exercises for:
1. Cart View - create new screen showing all cart items with quantities and prices
1. Display Cart Total - show total price using Cart.totalPrice getter this is currently done as debug print
1. Remove from Cart - add functionality to remove items from cart
1. Order Notes - re-implement notes functionality for individual orders (not individual sandwiches)
1. Validation - prevent adding more than 10 of any single sandwich type (this was previously in order_repository.dart).
-->