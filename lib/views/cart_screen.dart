import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  void _incrementItem(Sandwich sandwich) {
    setState(() {
      widget.cart.add(sandwich);
    });
  }

  void _decrementItem(Sandwich sandwich) {
    final currentQty = widget.cart.getQuantity(sandwich);
    if (currentQty <= 1) {
      setState(() {
        widget.cart.removeItem(sandwich);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${sandwich.name} removed from cart')),
      );
      return;
    }

    setState(() {
      widget.cart.setQuantity(sandwich, currentQty - 1);
    });
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
              if (widget.cart.isEmpty)
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                  child: Text(
                    'Your cart is empty. Go back and add some sandwiches!',
                    style: heading2,
                    textAlign: TextAlign.center,
                  ),
                )
              else ...[
                for (MapEntry<Sandwich, int> entry in widget.cart.items.entries)
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key.name, style: heading2),
                          const SizedBox(height: 4),
                          Text(
                            '${_getSizeText(entry.key.isFootlong)} on ${entry.key.breadType.name} bread',
                            style: normalText,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _decrementItem(entry.key),
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                  ),
                                  Text('Qty: ${entry.value}',
                                      style: normalText),
                                  IconButton(
                                    onPressed: () => _incrementItem(entry.key),
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                              Text(
                                '£${_getItemPrice(entry.key, entry.value).toStringAsFixed(2)}',
                                style: heading2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              if (!widget.cart.isEmpty)
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
