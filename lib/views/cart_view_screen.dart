import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen_view.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartViewScreen extends StatefulWidget {
  final Cart cart;

  const CartViewScreen({super.key, required this.cart});

  @override
  State<CartViewScreen> createState() {
    return _CartViewScreenState();
  }
}

class _CartViewScreenState extends State<CartViewScreen> {
  void _goBack() {
    Navigator.pop(context);
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
              StyledButton(
                onPressed: _goBack,
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
