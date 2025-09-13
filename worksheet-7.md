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

For this worksheet, you need to start with the code from branch 6 of our [GitHub repository](https://github.com/manighahrmani/sandwich_shop/tree/6). You can either clone the repository and checkout branch 6:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git checkout 6
```

Or manually ensure your code matches the repository. Run the app to make sure everything works as expected before proceeding.

## **Introduction to App State Management**

So far, we've been managing state within individual widgets using `setState()`. This works well for simple apps, but as your app grows, you'll find that multiple screens need to share the same data. For example, both your order screen and cart screen need access to the cart data.

Currently, we pass the cart object between screens, but this becomes cumbersome when you have many screens that need the same data. This is where **app state management** comes in.

App state is different from the ephemeral state we've been using (see [Worksheet 3](./worksheet-3.md)). While ephemeral state belongs to a single widget, app state is shared across multiple parts of your app and persists as users navigate between screens.

### **The Provider Package**

Flutter offers several approaches to state management, but we'll use the `provider` package because it's simple to understand and widely used. The provider package uses concepts that apply to other state management approaches as well.

Add the provider package to your project:

```bash
flutter pub add provider
```

We have purposefully not talked about packages a lot so far and we will do so in [#Third-Party Packages](#third-party-packages) later in this worksheet. The provider package you have installed introduces three key concepts:

- **ChangeNotifier**: A class that can notify listeners when it changes. For example, our cart model will be a ChangeNotifier.
- **ChangeNotifierProvider**: A widget that provides a ChangeNotifier to its descendants. In our case, the descendants of the cart will be the order screen and cart screen.
- **Consumer**: A widget that listens to changes in a ChangeNotifier and rebuilds when necessary. For us, the cart summary display in the order screen will be a Consumer.

### **Creating a Cart Model with ChangeNotifier**

Let's refactor our `Cart` class to extend `ChangeNotifier` (feel free to revisit our [Object-Oriented Dart Worksheet](./worksheet-0.md#4---object-oriented-programming-in-dart) if you need a refresher). This will allow widgets to listen for changes and automatically rebuild when the cart is modified.

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
import 'package:sandwich_shop/views/order_screen_view.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: const MaterialApp(
        title: 'Sandwich Shop App',
        debugShowCheckedModeBanner: false,
        home: OrderScreen(maxQuantity: 5),
      ),
    );
  }
}
```

Again, review the changes in the Source Control panel before committing. The `ChangeNotifierProvider` creates a single instance of `Cart` and makes it available to all descendant widgets (all screens in our app). The `create` function is called only once, so we have a single shared cart.

We've also added `debugShowCheckedModeBanner: false` to remove the debug banner from the app.

### **Consuming the Cart in Screens**

Now we need to update our screens to use the provided cart instead of creating their own instances. Let's start with the order screen.

Update `lib/views/order_screen_view.dart`. First, add the provider import:

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
        builder: (BuildContext context) => const CartViewScreen(),
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

You will have an error caused by how the `CartViewScreen` is constructed without a cart parameter. We will fix this next. Just review the changes in the Source Control panel and commit your changes.

Notice how we use `Provider.of<Cart>(context, listen: false)` to access the cart when we don't need to rebuild the widget when the cart changes. On the other hand, for the cart summary display and the cart indicator in the app bar, we use `Consumer<Cart>` to automatically rebuild when the cart changes. The cart indicator in the app bar will now show the total number of items across all screens, updating automatically as items are added or removed.

Now update `lib/views/cart_view_screen.dart` to remove the cart parameter and use the provided cart instead:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen_view.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

class CartViewScreen extends StatefulWidget {
  const CartViewScreen({super.key});

  @override
  State<CartViewScreen> createState() {
    return _CartViewScreenState();
  }
}

class _CartViewScreenState extends State<CartViewScreen> {
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

You'll notice that all screens now have a cart indicator showing the total number of items. This cart indicator updates automatically as you add or remove items, showing how the provider pattern can be used for state management.

Before moving on, make sure to update the widget tests for all screens to check for the newly added functionality (some of the current tests will fail, and we have not tested the existance of the cart indicator).

## **Third-Party Packages**

Flutter has a rich ecosystem of third-party packages that can add functionality to your app. These packages are published on [pub.dev](https://pub.dev), Flutter's official package repository.

While packages can save development time, use them judiciously. Every package is a potential source of bugs and security vulnerabilities. You're essentially trusting the package maintainer not to introduce malicious code or make mistakes that could affect your app.

To add a package to your project, use the `flutter pub add` command:

```bash
flutter pub add package_name
```

This automatically adds the package to your `pubspec.yaml` file and downloads it. You can then import and use the package in your Dart code.

For your coursework, try to minimize the number of third-party packages you use. Focus on learning Flutter's built-in capabilities first.

## **Data Persistence**

So far, all data in our app is lost when the app is closed. Real apps need to persist data between sessions. Flutter offers several approaches to data persistence, depending on your needs.

### **Shared Preferences for Simple Settings**

For simple key-value data like user preferences, use the `shared_preferences` package. This is perfect for storing settings like theme preferences, user names, or simple configuration options.

Add the package to your project:

```bash
flutter pub add shared_preferences
```

Let's create a simple settings screen that demonstrates shared preferences. Create a new file `lib/views/settings_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _isLoading = false;
    });
  }

  Future<void> _saveFontSize(double fontSize) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
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
        title: const Text('Settings', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Font Size', style: heading2),
            const SizedBox(height: 10),
            Text(
              'Current size: ${_fontSize.toInt()}',
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
            const SizedBox(height: 40),
            const Text(
              'This is sample text to preview the font size.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
```

Add a button to navigate to the settings screen in your order screen. In `lib/views/order_screen_view.dart`, add this method after the existing navigation methods:

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

And add this button in the build method after the existing buttons:

```dart
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

#### **Commit your changes**

Test the settings screen. The font size should persist when you close and reopen the app.

### **SQLite for Complex Data**

For more complex data that requires querying and relationships, use SQLite. This is suitable for storing structured data like order history, user profiles, or any data that benefits from SQL queries.

Add the required packages:

```bash
flutter pub add sqflite path
```

Let's create a simple order history feature. First, create a model for saved orders. Create `lib/models/saved_order.dart`:

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
      'id': id,
      'orderId': orderId,
      'totalAmount': totalAmount,
      'itemCount': itemCount,
      'orderDate': orderDate.millisecondsSinceEpoch,
    };
  }

  factory SavedOrder.fromMap(Map<String, Object?> map) {
    return SavedOrder(
      id: map['id'] as int,
      orderId: map['orderId'] as String,
      totalAmount: map['totalAmount'] as double,
      itemCount: map['itemCount'] as int,
      orderDate: DateTime.fromMillisecondsSinceEpoch(map['orderDate'] as int),
    );
  }

  @override
  String toString() {
    return 'SavedOrder{id: $id, orderId: $orderId, totalAmount: $totalAmount, itemCount: $itemCount, orderDate: $orderDate}';
  }
}
```

Now create a database helper. Create `lib/services/database_service.dart`:

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
    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SavedOrder>> getOrders() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'orders',
      orderBy: 'orderDate DESC',
    );

    return List.generate(maps.length, (i) {
      return SavedOrder.fromMap(maps[i]);
    });
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

Update the checkout screen to save orders to the database. In `lib/views/checkout_screen.dart`, add the import:

```dart
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/models/saved_order.dart';
```

Then update the `_processPayment` method:

```dart
Future<void> _processPayment() async {
  setState(() {
    _isProcessing = true;
  });

  await Future.delayed(const Duration(seconds: 2));

  final DateTime currentTime = DateTime.now();
  final int timestamp = currentTime.millisecondsSinceEpoch;
  final String orderId = 'ORD$timestamp';

  final Cart cart = Provider.of<Cart>(context, listen: false);
  
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
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History', style: heading1),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(
                  child: Text(
                    'No orders yet',
                    style: heading2,
                  ),
                )
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final SavedOrder order = _orders[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          order.orderId,
                          style: heading2,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${order.itemCount} items - £${order.totalAmount.toStringAsFixed(2)}',
                              style: normalText,
                            ),
                            Text(
                              _formatDate(order.orderDate),
                              style: normalText,
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
```

Add a button to navigate to order history in your order screen. In `lib/views/order_screen_view.dart`, add this method after the existing navigation methods:

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

And add this button in the build method after the existing buttons:

```dart
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

#### **Commit your changes**

Test the order history feature. Complete a few orders and verify they appear in the order history screen.

## **Exercises**

Complete the exercises below. Remember to commit your changes after each exercise and use your AI assistant to help you think through the problems.

0. Remove the redundancy by introducing a common widgets file in the views folder. Put the common appbar in there. Also refactor the tests to test this part separately. Also the styled button can be put inside this common widgets file.

1. Our current state management only handles the cart. Let's add user preferences to the provider pattern.

   Create a `UserPreferences` class that extends `ChangeNotifier` and manages settings like font size and theme preferences. Update your app to use `MultiProvider` to provide both the cart and user preferences.

   Update the settings screen to use the new `UserPreferences` provider instead of directly accessing `SharedPreferences`.

   ⚠️ **Show your working user preferences provider to a member of staff** for a sign-off.

2. Let's enhance the order history with more detailed information. Currently, we only save basic order information, but we should also save what items were ordered.

   Create a new table for order items that stores the sandwich details for each order. You'll need to modify the database schema and create appropriate models.

   Update the order history screen to show the actual items that were ordered, not just the count and total price.

   ⚠️ **Show your enhanced order history with item details to a member of staff** for a sign-off.

3. (Advanced) Add a favorites feature that allows users to save their favorite sandwich combinations.

   Create a new model for favorite sandwiches and add database operations to save, load, and delete favorites. Add a favorites screen where users can view their saved combinations and quickly add them to their cart.

   Consider how this feature should integrate with your existing state management. Should favorites be part of a provider, or handled differently?

   This task is **optional** and there's no need to show it to a member of staff for a sign-off.

4. (Advanced) Implement data export functionality that allows users to export their order history as a CSV file.

   You'll need to use the `path_provider` package to find a suitable directory for saving files, and format the order data as CSV. Consider how users will access the exported file on different platforms.

   This task is **optional** and there's no need to show it to a member of staff for a sign-off.

## **Looking Ahead**

Next week, we'll explore cloud services and how to integrate your app with Firebase for features like user authentication, cloud storage, and real-time data synchronization. Some of the persistence features we've implemented this week can be enhanced or replaced with cloud-based solutions.