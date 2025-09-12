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

    final Map<String, dynamic> orderConfirmation = {
      'orderId': orderId,
      'totalAmount': widget.cart.totalPrice,
      'itemCount': widget.cart.countOfItems,
      'estimatedTime': '15-20 minutes',
      'status': 'confirmed'
    };

    // Check if this State object is being shown in the widget tree
    if (mounted) {
      // Pop the checkout screen and return to the order screen with the confirmation
      Navigator.pop(context, orderConfirmation);
    }
  }

  void _cancelOrder() {
    final Map<String, String> cancellationData = {'status': 'cancelled'};
    Navigator.pop(context, cancellationData);
  }

  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    PricingRepository repo = PricingRepository();
    return repo.calculatePrice(
        quantity: quantity, isFootlong: sandwich.isFootlong);
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
          ),
          child: const Text('Confirm Payment', style: normalText),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _cancelOrder,
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
