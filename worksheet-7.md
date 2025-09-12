This is the content of main.dart when they finish with worksheet 6:
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

This is the content of order_screen_view.dart when they finish with worksheet 6:
```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/cart_view_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

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
              StyledButton(
                onPressed: _navigateToProfile,
                icon: Icons.person,
                label: 'Profile',
                backgroundColor: Colors.purple,
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

Here is the content of cart_view_screen.dart when they finish with worksheet 6:
```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen_view.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

class CartViewScreen extends StatefulWidget {
  final Cart cart;

  const CartViewScreen({super.key, required this.cart});

  @override
  State<CartViewScreen> createState() {
    return _CartViewScreenState();
  }
}

class _CartViewScreenState extends State<CartViewScreen> {
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
    setState(() {
      widget.cart.add(sandwich, quantity: 1);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quantity increased')),
    );
  }

  void _decrementQuantity(Sandwich sandwich) {
    final wasPresent = widget.cart.items.containsKey(sandwich);
    setState(() {
      widget.cart.remove(sandwich, quantity: 1);
    });
    if (!widget.cart.items.containsKey(sandwich) && wasPresent) {
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
    setState(() {
      widget.cart.remove(sandwich, quantity: widget.cart.getQuantity(sandwich));
    });
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              if (widget.cart.items.isEmpty)
                const Text(
                  'Your cart is empty.',
                  style: heading2,
                  textAlign: TextAlign.center,
                )
              else
                for (MapEntry<Sandwich, int> entry in widget.cart.items.entries)
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
                'Total: £${widget.cart.totalPrice.toStringAsFixed(2)}',
                style: heading2,
                textAlign: TextAlign.center,
              ),
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
              StyledButton(
                onPressed: () => Navigator.pop(context),
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

Here is the content of checkout_screen.dart when they finish with worksheet 6:
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

Here are our models. Here is the content of sandwich.dart:
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

Here is the content of cart.dart:
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

Here is the pricing_repository.dart:
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

And here is app_styles.dart:
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

Pay attention to the style of my code:
- I add minimal to no comments in the code
- I specify types for everything (unless when it is `dynamic` or something very complex)
- I don't want to use higher-order functions (I prefer longer code and simpler code, I don't want to use `.map`, `.forEach`, etc)
- I prefer using `if` statements instead of ternary operators
- I prefer not to use the `...` spread operator (use longer code instead)
- I prefer named functions and variables instead of anonymous functions

## State Management

I have already taught ephemeral state management in the previous worksheets. This week I want to introduce them to app state management.

I am basing this section on the following documentation page: https://docs.flutter.dev/data-and-backend/state-mgmt/simple

I want to introduce them to the concept of lifting state up, ChangeNotifier, ChangeNotifierProvider, and Consumer. But I want to keep it as simple as possible and not go into too much detail.

Here is the content of the documentation page for your reference:
```
Now that you know about declarative UI programming and the difference between ephemeral and app state, you are ready to learn about simple app state management.

On this page, we are going to be using the provider package. If you are new to Flutter and you don't have a strong reason to choose another approach (Redux, Rx, hooks, etc.), this is probably the approach you should start with. The provider package is easy to understand and it doesn't use much code. It also uses concepts that are applicable in every other approach.

That said, if you have a strong background in state management from other reactive frameworks, you can find packages and tutorials listed on the options page.

Our example
An animated gif showing a Flutter app in use. It starts with the user on a login screen. They log in and are taken to the catalog screen, with a list of items. The click on several items, and as they do so, the items are marked as "added". The user clicks on a button and gets taken to the cart view. They see the items there. They go back to the catalog, and the items they bought still show "added". End of animation.
For illustration, consider the following simple app.

The app has two separate screens: a catalog, and a cart (represented by the MyCatalog, and MyCart widgets, respectively). It could be a shopping app, but you can imagine the same structure in a simple social networking app (replace catalog for "wall" and cart for "favorites").

The catalog screen includes a custom app bar (MyAppBar) and a scrolling view of many list items (MyListItems).

Here's the app visualized as a widget tree.

A widget tree with MyApp at the top, and  MyCatalog and MyCart below it. MyCart area leaf nodes, but MyCatalog have two children: MyAppBar and a list of MyListItems.
So we have at least 5 subclasses of Widget. Many of them need access to state that "belongs" elsewhere. For example, each MyListItem needs to be able to add itself to the cart. It might also want to see whether the currently displayed item is already in the cart.

This takes us to our first question: where should we put the current state of the cart?

Lifting state up
In Flutter, it makes sense to keep the state above the widgets that use it.

Why? In declarative frameworks like Flutter, if you want to change the UI, you have to rebuild it. There is no easy way to have MyCart.updateWith(somethingNew). In other words, it's hard to imperatively change a widget from outside, by calling a method on it. And even if you could make this work, you would be fighting the framework instead of letting it help you.

// BAD: DO NOT DO THIS
void myTapHandler() {
  var cartWidget = somehowGetMyCartWidget();
  cartWidget.updateWith(item);
}
content_copy
Even if you get the above code to work, you would then have to deal with the following in the MyCart widget:

// BAD: DO NOT DO THIS
Widget build(BuildContext context) {
  return SomeWidget(
    // The initial state of the cart.
  );
}

void updateWith(Item item) {
  // Somehow you need to change the UI from here.
}
content_copy
You would need to take into consideration the current state of the UI and apply the new data to it. It's hard to avoid bugs this way.

In Flutter, you construct a new widget every time its contents change. Instead of MyCart.updateWith(somethingNew) (a method call) you use MyCart(contents) (a constructor). Because you can only construct new widgets in the build methods of their parents, if you want to change contents, it needs to live in MyCart's parent or above.

// GOOD
void myTapHandler(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  cartModel.add(item);
}
content_copy
Now MyCart has only one code path for building any version of the UI.

// GOOD
Widget build(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  return SomeWidget(
    // Just construct the UI once, using the current state of the cart.
    // ···
  );
}
content_copy
In our example, contents needs to live in MyApp. Whenever it changes, it rebuilds MyCart from above (more on that later). Because of this, MyCart doesn't need to worry about lifecycle—it just declares what to show for any given contents. When that changes, the old MyCart widget disappears and is completely replaced by the new one.

Same widget tree as above, but now we show a small 'cart' badge next to MyApp, and there are two arrows here. One comes from one of the MyListItems to the 'cart', and another one goes from the 'cart' to the MyCart widget.
This is what we mean when we say that widgets are immutable. They don't change—they get replaced.

Now that we know where to put the state of the cart, let's see how to access it.

Accessing the state
When a user clicks on one of the items in the catalog, it's added to the cart. But since the cart lives above MyListItem, how do we do that?

A simple option is to provide a callback that MyListItem can call when it is clicked. Dart's functions are first class objects, so you can pass them around any way you want. So, inside MyCatalog you can define the following:

@override
Widget build(BuildContext context) {
  return SomeWidget(
    // Construct the widget, passing it a reference to the method above.
    MyListItem(myTapCallback),
  );
}

void myTapCallback(Item item) {
  print('user tapped on $item');
}
content_copy
This works okay, but for an app state that you need to modify from many different places, you'd have to pass around a lot of callbacks—which gets old pretty quickly.

Fortunately, Flutter has mechanisms for widgets to provide data and services to their descendants (in other words, not just their children, but any widgets below them). As you would expect from Flutter, where Everything is a Widget™, these mechanisms are just special kinds of widgets—InheritedWidget, InheritedNotifier, InheritedModel, and more. We won't be covering those here, because they are a bit low-level for what we're trying to do.

Instead, we are going to use a package that works with the low-level widgets but is simple to use. It's called provider.

Before working with provider, don't forget to add the dependency on it to your pubspec.yaml.

To add the provider package as a dependency, run flutter pub add:

flutter pub add provider
content_copy
Now you can import 'package:provider/provider.dart'; and start building.

With provider, you don't need to worry about callbacks or InheritedWidgets. But you do need to understand 3 concepts:

ChangeNotifier
ChangeNotifierProvider
Consumer
ChangeNotifier
ChangeNotifier is a simple class included in the Flutter SDK which provides change notification to its listeners. In other words, if something is a ChangeNotifier, you can subscribe to its changes. (It is a form of Observable, for those familiar with the term.)

In provider, ChangeNotifier is one way to encapsulate your application state. For very simple apps, you get by with a single ChangeNotifier. In complex ones, you'll have several models, and therefore several ChangeNotifiers. (You don't need to use ChangeNotifier with provider at all, but it's an easy class to work with.)

In our shopping app example, we want to manage the state of the cart in a ChangeNotifier. We create a new class that extends it, like so:

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Item> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// The current total price of all items (assuming all items cost $42).
  int get totalPrice => _items.length * 42;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Item item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
content_copy
The only code that is specific to ChangeNotifier is the call to notifyListeners(). Call this method any time the model changes in a way that might change your app's UI. Everything else in CartModel is the model itself and its business logic.

ChangeNotifier is part of flutter:foundation and doesn't depend on any higher-level classes in Flutter. It's easily testable (you don't even need to use widget testing for it). For example, here's a simple unit test of CartModel:

test('adding item increases total cost', () {
  final cart = CartModel();
  final startingPrice = cart.totalPrice;
  var i = 0;
  cart.addListener(() {
    expect(cart.totalPrice, greaterThan(startingPrice));
    i++;
  });
  cart.add(Item('Dash'));
  expect(i, 1);
});
content_copy
ChangeNotifierProvider
ChangeNotifierProvider is the widget that provides an instance of a ChangeNotifier to its descendants. It comes from the provider package.

We already know where to put ChangeNotifierProvider: above the widgets that need to access it. In the case of CartModel, that means somewhere above both MyCart and MyCatalog.

You don't want to place ChangeNotifierProvider higher than necessary (because you don't want to pollute the scope). But in our case, the only widget that is on top of both MyCart and MyCatalog is MyApp.

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}
content_copy
Note that we're defining a builder that creates a new instance of CartModel. ChangeNotifierProvider is smart enough not to rebuild CartModel unless absolutely necessary. It also automatically calls dispose() on CartModel when the instance is no longer needed.

If you want to provide more than one class, you can use MultiProvider:

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        Provider(create: (context) => SomeOtherClass()),
      ],
      child: const MyApp(),
    ),
  );
}
content_copy
Consumer
Now that CartModel is provided to widgets in our app through the ChangeNotifierProvider declaration at the top, we can start using it.

This is done through the Consumer widget.

return Consumer<CartModel>(
  builder: (context, cart, child) {
    return Text('Total price: ${cart.totalPrice}');
  },
);
content_copy
We must specify the type of the model that we want to access. In this case, we want CartModel, so we write Consumer<CartModel>. If you don't specify the generic (<CartModel>), the provider package won't be able to help you. provider is based on types, and without the type, it doesn't know what you want.

The only required argument of the Consumer widget is the builder. Builder is a function that is called whenever the ChangeNotifier changes. (In other words, when you call notifyListeners() in your model, all the builder methods of all the corresponding Consumer widgets are called.)

The builder is called with three arguments. The first one is context, which you also get in every build method.

The second argument of the builder function is the instance of the ChangeNotifier. It's what we were asking for in the first place. You can use the data in the model to define what the UI should look like at any given point.

The third argument is child, which is there for optimization. If you have a large widget subtree under your Consumer that doesn't change when the model changes, you can construct it once and get it through the builder.

return Consumer<CartModel>(
  builder: (context, cart, child) => Stack(
    children: [
      // Use SomeExpensiveWidget here, without rebuilding every time.
      ?child,
      Text('Total price: ${cart.totalPrice}'),
    ],
  ),
  // Build the expensive widget here.
  child: const SomeExpensiveWidget(),
);
content_copy
It is best practice to put your Consumer widgets as deep in the tree as possible. You don't want to rebuild large portions of the UI just because some detail somewhere changed.

// DON'T DO THIS
return Consumer<CartModel>(
  builder: (context, cart, child) {
    return HumongousWidget(
      // ...
      child: AnotherMonstrousWidget(
        // ...
        child: Text('Total price: ${cart.totalPrice}'),
      ),
    );
  },
);
content_copy
Instead:

// DO THIS
return HumongousWidget(
  // ...
  child: AnotherMonstrousWidget(
    // ...
    child: Consumer<CartModel>(
      builder: (context, cart, child) {
        return Text('Total price: ${cart.totalPrice}');
      },
    ),
  ),
);
content_copy
Provider.of
Sometimes, you don't really need the data in the model to change the UI but you still need to access it. For example, a ClearCart button wants to allow the user to remove everything from the cart. It doesn't need to display the contents of the cart, it just needs to call the clear() method.

We could use Consumer<CartModel> for this, but that would be wasteful. We'd be asking the framework to rebuild a widget that doesn't need to be rebuilt.

For this use case, we can use Provider.of, with the listen parameter set to false.

Provider.of<CartModel>(context, listen: false).removeAll();
content_copy
Using the above line in a build method won't cause this widget to rebuild when notifyListeners is called.

Putting it all together
You can check out the example covered in this article. If you want something simpler, see what the simple Counter app looks like when built with provider.

By following along with these articles, you've greatly improved your ability to create state-based applications. Try building an application with provider yourself to master these skills.
```

Use this topic to update the current implementation of the cart with minimum changes.

## Persistence

For this section I want to use the following documentation page:
https://docs.flutter.dev/cookbook/persistence


### Packages and plugins

I also want to touch more on third-party packages and how to find them on pub.dev and how to install them using `flutter pub add <package_name>`.
But note that for their coursework they should try to minimize the number of third-party packages they use as much as possible. This is because every package is a potential source of bugs and security vulnerabilities in their app (you are essentially trusting the package maintainer not to do anything malicious or not to make any mistakes). Here is a video that shows a recent vulnerability in a popular npm package that could have caused catastrophic damage: https://youtu.be/QVqIx-Y8s-s?feature=shared

Use this documentation page as a reference: https://docs.flutter.dev/packages-and-plugins/using-packages

Here is the content of this documentation page (don't use all of it, just summerize what is relevant to their app):

```
Existing packages enable many use cases—for example, making network requests (http), navigation/route handling (go_router), integration with device APIs (url_launcher and battery_plus), and using third-party platform SDKs like Firebase (FlutterFire).

To write a new package, see developing packages. To add assets, images, or fonts, whether stored in files or packages, see Adding assets and images.

Using packages
The following section describes how to use existing published packages.

Searching for packages
Packages are published to pub.dev.

The Flutter landing page on pub.dev displays top packages that are compatible with Flutter (those that declare dependencies generally compatible with Flutter), and supports searching among all published packages.

The Flutter Favorites page on pub.dev lists the plugins and packages that have been identified as packages you should first consider using when writing your app. For more information on what it means to be a Flutter Favorite, see the Flutter Favorites program.

You can also browse the packages on pub.dev by filtering on Android, iOS, web, Linux, Windows, macOS, or any combination thereof.

Adding a package dependency to an app using flutter pub add
To add the package css_colors to an app:

Use the pub add command from inside the project directory

flutter pub add css_colors
Import it

Add a corresponding import statement in the Dart code.
Stop and restart the app, if necessary

If the package brings platform-specific code (Kotlin/Java for Android, Swift/Objective-C for iOS), that code must be built into your app. Hot reload and hot restart only update the Dart code, so a full restart of the app might be required to avoid errors like MissingPluginException when using the package.
Adding a package dependency to an app
To add the package css_colors to an app:

Depend on it

Open the pubspec.yaml file located inside the app folder, and add css_colors: ^1.0.0 under dependencies.
Install it

From the terminal: Run flutter pub get.
OR
From VS Code: Click Get Packages located in right side of the action ribbon at the top of pubspec.yaml indicated by the Download icon.
From Android Studio/IntelliJ: Click Pub get in the action ribbon at the top of pubspec.yaml.
Import it

Add a corresponding import statement in the Dart code.
Stop and restart the app, if necessary

If the package brings platform-specific code (Kotlin/Java for Android, Swift/Objective-C for iOS), that code must be built into your app. Hot reload and hot restart only update the Dart code, so a full restart of the app might be required to avoid errors like MissingPluginException when using the package.
Removing a package dependency to an app using flutter pub remove
To remove the package css_colors from an app:

Use the pub remove command from inside the project directory
flutter pub remove css_colors
The Installing tab, available on any package page on pub.dev, is a handy reference for these steps.

For a complete example, see the css_colors example below.

Conflict resolution
Suppose you want to use some_package and another_package in an app, and both of these depend on url_launcher, but in different versions. That causes a potential conflict. The best way to avoid this is for package authors to use version ranges rather than specific versions when specifying dependencies.

dependencies:
  url_launcher: ^5.4.0    # Good, any version >= 5.4.0 but < 6.0.0
  image_picker: '5.4.3'   # Not so good, only version 5.4.3 works.
content_copy
If some_package declares the dependencies above and another_package declares a compatible url_launcher dependency like '5.4.6' or ^5.5.0, pub resolves the issue automatically. Platform-specific dependencies on Gradle modules and/or CocoaPods are solved in a similar way.

Even if some_package and another_package declare incompatible versions for url_launcher, they might actually use url_launcher in compatible ways. In this situation, the conflict can be resolved by adding a dependency override declaration to the app's pubspec.yaml file, forcing the use of a particular version.

For example, to force the use of url_launcher version 5.4.0, make the following changes to the app's pubspec.yaml file:

dependencies:
  some_package:
  another_package:
dependency_overrides:
  url_launcher: '5.4.0'
content_copy
If the conflicting dependency is not itself a package, but an Android-specific library like guava, the dependency override declaration must be added to Gradle build logic instead.

To force the use of guava version 28.0, make the following changes to the app's android/build.gradle file:

configurations.all {
    resolutionStrategy {
        force 'com.google.guava:guava:28.0-android'
    }
}
content_copy
CocoaPods doesn't currently offer dependency override functionality.

Developing new packages
If no package exists for your specific use case, you can write a custom package.

Managing package dependencies and versions
To minimize the risk of version collisions, specify a version range in the pubspec.yaml file.

Package versions
All packages have a version number, specified in the package's pubspec.yaml file. The current version of a package is displayed next to its name (for example, see the url_launcher package), as well as a list of all prior versions (see url_launcher versions).

To ensure that the app doesn't break when you update a package, specify a version range using one of the following formats.

Ranged constraints: Specify a minimum and maximum version.

dependencies:
  url_launcher: '>=5.4.0 <6.0.0'
content_copy
Ranged constraints using the caret syntax: Specify the version that serves as the inclusive minimum version. This covers all versions from that version to the next major version.

dependencies:
  collection: '^5.4.0'
content_copy
This syntax means the same as the one noted in the first bullet.

To learn more, check out the package versioning guide.

Updating package dependencies
When running flutter pub get for the first time after adding a package, Flutter saves the concrete package version found in the pubspec.lock lockfile. This ensures that you get the same version again if you, or another developer on your team, run flutter pub get.

To upgrade to a new version of the package, for example to use new features in that package, run flutter pub upgrade to retrieve the highest available version of the package that is allowed by the version constraint specified in pubspec.yaml. Note that this is a different command from flutter upgrade or flutter update-packages, which both update Flutter itself.

Dependencies on unpublished packages
Packages can be used even when not published on pub.dev. For private packages, or for packages not ready for publishing, additional dependency options are available:

Path dependency
A Flutter app can depend on a package using a file system path: dependency. The path can be either relative or absolute. Relative paths are evaluated relative to the directory containing pubspec.yaml. For example, to depend on a package, packageA, located in a directory next to the app, use the following syntax:

  dependencies:
  packageA:
    path: ../packageA/
content_copy
Git dependency
You can also depend on a package stored in a Git repository. If the package is located at the root of the repo, use the following syntax:

  dependencies:
    packageA:
      git:
        url: https://github.com/flutter/packageA.git
content_copy
Git dependency using SSH
If the repository is private and you can connect to it using SSH, depend on the package by using the repo's SSH url:

  dependencies:
    packageA:
      git:
        url: git@github.com:flutter/packageA.git
content_copy
Git dependency on a package in a folder
Pub assumes the package is located in the root of the Git repository. If that isn't the case, specify the location with the path argument. For example:

dependencies:
  packageA:
    git:
      url: https://github.com/flutter/packages.git
      path: packages/packageA
content_copy
Finally, use the ref argument to pin the dependency to a specific git commit, branch, or tag. For more details, see Package dependencies.

Examples
The following examples walk through the necessary steps for using packages.

Example: Using the css_colors package
The css_colors package defines color constants for CSS colors, so use the constants wherever the Flutter framework expects the Color type.

To use this package:

Create a new project called cssdemo.

Open pubspec.yaml, and add the css-colors dependency:

dependencies:
  flutter:
    sdk: flutter
  css_colors: ^1.0.0
content_copy
Run flutter pub get in the terminal, or click Get Packages in VS Code.

Open lib/main.dart and replace its full contents with:

import 'package:css_colors/css_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DemoPage());
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color: CSSColors.orange));
  }
}
content_copy
Run the app. The app's background should now be orange.
Example: Using the url_launcher package to launch the browser
The url_launcher plugin package enables opening the default browser on the mobile platform to display a given URL, and is supported on Android, iOS, web, Windows, Linux, and macOS. This package is a special Dart package called a plugin package (or plugin), which includes platform-specific code.

To use this plugin:

Create a new project called launchdemo.

Open pubspec.yaml, and add the url_launcher dependency:

dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^5.4.0
content_copy
Run flutter pub get in the terminal, or click Get Packages get in VS Code.

Open lib/main.dart and replace its full contents with the following:

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DemoPage());
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  void launchURL() {
    launchUrl(p.toUri('https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: launchURL,
          child: const Text('Show Flutter homepage'),
        ),
      ),
    );
  }
}
content_copy
Run the app (or stop and restart it, if it was already running before adding the plugin). Click Show Flutter homepage. You should see the default browser open on the device, displaying the homepage for flutter.dev.
```

### Shared Preferences

In the last worksheet we had the following exercise
```
4.  (Advanced) Create a settings screen where users can configure app-wide preferences, such as enabling dark mode or adjusting font sizes.

    This exercise introduces you to data persistence. You can use the `shared_preferences` package, which allows you to save simple key-value data that persists between app sessions. Add the package by running `flutter pub add shared_preferences`.

    Your task is to create a settings screen and use `shared_preferences` to save at least one user preference. When the user changes a setting, save it. When the app restarts, this preference should be loaded and applied.

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.
```

Show them a minimal solution for a settings page (a single setting like font size is enough for this week) and cite this page: https://pub.dev/packages/shared_preferences

Also use the content of this documentation page for the content of this section: https://docs.flutter.dev/cookbook/persistence/key-value
You should also cite this YouTube video: https://youtu.be/sa_U0jffQII

Here is the content of the documentation page for your reference:
```
1. Add the dependency
Before starting, add the shared_preferences package as a dependency.

To add the shared_preferences package as a dependency, run flutter pub add:

flutter pub add shared_preferences
content_copy
2. Save data
To persist data, use the setter methods provided by the SharedPreferences class. Setter methods are available for various primitive types, such as setInt, setBool, and setString.

Setter methods do two things: First, synchronously update the key-value pair in memory. Then, persist the data to disk.

// Load and obtain the shared preferences for this app.
final prefs = await SharedPreferences.getInstance();

// Save the counter value to persistent storage under the 'counter' key.
await prefs.setInt('counter', counter);
content_copy
3. Read data
To read data, use the appropriate getter method provided by the SharedPreferences class. For each setter there is a corresponding getter. For example, you can use the getInt, getBool, and getString methods.

final prefs = await SharedPreferences.getInstance();

// Try reading the counter value from persistent storage.
// If not present, null is returned, so default to 0.
final counter = prefs.getInt('counter') ?? 0;
content_copy
Note that the getter methods throw an exception if the persisted value has a different type than the getter method expects.

4. Remove data
To delete data, use the remove() method.

final prefs = await SharedPreferences.getInstance();

// Remove the counter key-value pair from persistent storage.
await prefs.remove('counter');
content_copy
Supported types
Although the key-value storage provided by shared_preferences is easy and convenient to use, it has limitations:

Only primitive types can be used: int, double, bool, String, and List<String>.
It's not designed to store large amounts of data.
There is no guarantee that data will be persisted across app restarts.
Testing support
It's a good idea to test code that persists data using shared_preferences. To enable this, the package provides an in-memory mock implementation of the preference store.

To set up your tests to use the mock implementation, call the setMockInitialValues static method in a setUpAll() method in your test files. Pass in a map of key-value pairs to use as the initial values.

SharedPreferences.setMockInitialValues(<String, Object>{'counter': 2});
content_copy
Complete example
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shared preferences demo',
      home: MyHomePage(title: 'Shared preferences demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  /// Load the initial counter value from persistent storage on start,
  /// or fallback to 0 if it doesn't exist.
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  /// After a click, increment the counter state and
  /// asynchronously save it to persistent storage.
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times: '),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### SQLite

My students have already done SQL last year (PostgreSQL) so I am not introducing the syntax of SQL again. I just want to show them how they can integrate an SQLite database into their Flutter app.

Start by talking about what kind of apps would need a database. Why a relational database (why not just key-value storage)? When would you use a NoSQL database instead?

Then I want to use this documentation page as the textbook for this section: https://docs.flutter.dev/cookbook/persistence/sqlite

Here is the content of this documentation page for your reference:
```
If you are writing an app that needs to persist and query large amounts of data on the local device, consider using a database instead of a local file or key-value store. In general, databases provide faster inserts, updates, and queries compared to other local persistence solutions.

Flutter apps can make use of the SQLite databases via the sqflite plugin available on pub.dev. This recipe demonstrates the basics of using sqflite to insert, read, update, and remove data about various Dogs.

If you are new to SQLite and SQL statements, review the SQLite Tutorial to learn the basics before completing this recipe.

This recipe uses the following steps:

Add the dependencies.
Define the Dog data model.
Open the database.
Create the dogs table.
Insert a Dog into the database.
Retrieve the list of dogs.
Update a Dog in the database.
Delete a Dog from the database.
1. Add the dependencies
To work with SQLite databases, import the sqflite and path packages.

The sqflite package provides classes and functions to interact with a SQLite database.
The path package provides functions to define the location for storing the database on disk.
To add the packages as a dependency, run flutter pub add:

flutter pub add sqflite path
content_copy
Make sure to import the packages in the file you'll be working in.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
content_copy
2. Define the Dog data model
Before creating the table to store information on Dogs, take a few moments to define the data that needs to be stored. For this example, define a Dog class that contains three pieces of data: A unique id, the name, and the age of each dog.

class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({required this.id, required this.name, required this.age});
}
content_copy
3. Open the database
Before reading and writing data to the database, open a connection to the database. This involves two steps:

Define the path to the database file using getDatabasesPath() from the sqflite package, combined with the join function from the path package.
Open the database with the openDatabase() function from sqflite.
Note
In order to use the keyword await, the code must be placed inside an async function. You should place all the following table functions inside void main() async {}.

// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
final database = openDatabase(
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.
  join(await getDatabasesPath(), 'doggie_database.db'),
);
content_copy
4. Create the dogs table
Next, create a table to store information about various Dogs. For this example, create a table called dogs that defines the data that can be stored. Each Dog contains an id, name, and age. Therefore, these are represented as three columns in the dogs table.

The id is a Dart int, and is stored as an INTEGER SQLite Datatype. It is also good practice to use an id as the primary key for the table to improve query and update times.
The name is a Dart String, and is stored as a TEXT SQLite Datatype.
The age is also a Dart int, and is stored as an INTEGER Datatype.
For more information about the available Datatypes that can be stored in a SQLite database, see the official SQLite Datatypes documentation.

final database = openDatabase(
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.
  join(await getDatabasesPath(), 'doggie_database.db'),
  // When the database is first created, create a table to store dogs.
  onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
    );
  },
  // Set the version. This executes the onCreate function and provides a
  // path to perform database upgrades and downgrades.
  version: 1,
);
content_copy
5. Insert a Dog into the database
Now that you have a database with a table suitable for storing information about various dogs, it's time to read and write data.

First, insert a Dog into the dogs table. This involves two steps:

Convert the Dog into a Map
Use the insert() method to store the Map in the dogs table.
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({required this.id, required this.name, required this.age});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
content_copy
// Define a function that inserts dogs into the database
Future<void> insertDog(Dog dog) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
content_copy
// Create a Dog and add it to the dogs table
var fido = Dog(id: 0, name: 'Fido', age: 35);

await insertDog(fido);
content_copy
6. Retrieve the list of Dogs
Now that a Dog is stored in the database, query the database for a specific dog or a list of all dogs. This involves two steps:

Run a query against the dogs table. This returns a List<Map>.
Convert the List<Map> into a List<Dog>.
// A method that retrieves all the dogs from the dogs table.
Future<List<Dog>> dogs() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the dogs.
  final List<Map<String, Object?>> dogMaps = await db.query('dogs');

  // Convert the list of each dog's fields into a list of `Dog` objects.
  return [
    for (final {'id': id as int, 'name': name as String, 'age': age as int}
        in dogMaps)
      Dog(id: id, name: name, age: age),
  ];
}
content_copy
// Now, use the method above to retrieve all the dogs.
print(await dogs()); // Prints a list that include Fido.
content_copy
7. Update a Dog in the database
After inserting information into the database, you might want to update that information at a later time. You can do this by using the update() method from the sqflite library.

This involves two steps:

Convert the Dog into a Map.
Use a where clause to ensure you update the correct Dog.
Future<void> updateDog(Dog dog) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'dogs',
    dog.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [dog.id],
  );
}
content_copy
// Update Fido's age and save it to the database.
fido = Dog(id: fido.id, name: fido.name, age: fido.age + 7);
await updateDog(fido);

// Print the updated results.
print(await dogs()); // Prints Fido with age 42.
content_copy
Warning
Always use whereArgs to pass arguments to a where statement. This helps safeguard against SQL injection attacks.

Do not use string interpolation, such as where: "id = ${dog.id}"!

8. Delete a Dog from the database
In addition to inserting and updating information about Dogs, you can also remove dogs from the database. To delete data, use the delete() method from the sqflite library.

In this section, create a function that takes an id and deletes the dog with a matching id from the database. To make this work, you must provide a where clause to limit the records being deleted.

Future<void> deleteDog(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the database.
  await db.delete(
    'dogs',
    // Use a `where` clause to delete a specific dog.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}
content_copy
Example
To run the example:

Create a new Flutter project.
Add the sqflite and path packages to your pubspec.yaml.
Paste the following code into a new file called lib/db_test.dart.
Run the code with flutter run lib/db_test.dart.
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query('dogs');

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return [
      for (final {'id': id as int, 'name': name as String, 'age': age as int}
          in dogMaps)
        Dog(id: id, name: name, age: age),
    ];
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // Create a Dog and add it to the dogs table
  var fido = Dog(id: 0, name: 'Fido', age: 35);

  await insertDog(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await dogs()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = Dog(id: fido.id, name: fido.name, age: fido.age + 7);
  await updateDog(fido);

  // Print the updated results.
  print(await dogs()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteDog(fido.id);

  // Print the list of dogs (empty).
  print(await dogs());
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({required this.id, required this.name, required this.age});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
```

At the very end note that next week we will talk about Firebase and how to use it as a backend for their app (some of the persistence features can be implemented using Firebase instead of SQLite).