import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/order_options.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _checkout() async {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();
    if (items.isEmpty) {
      return;
    }

    int nextOrderNumber = 1001;
    try {
      nextOrderNumber = await SandwichDatabase.instance.getNextOrderNumber();
    } catch (_) {}

    final int totalItems = cart.getTotalItems();
    final String firstItemName = items[0].name;
    final String summary;
    if (items.length == 1) {
      summary = '$totalItems x $firstItemName';
    } else {
      summary = '$totalItems items - $firstItemName and more';
    }

    final DateTime now = DateTime.now();
    const List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final String minuteString = now.minute.toString().padLeft(2, '0');
    final String hourString = now.hour.toString().padLeft(2, '0');
    final String formattedDate =
        '${now.day} ${monthNames[now.month - 1]} ${now.year} $hourString:$minuteString';

    final OrderOptions options = cart.getOptions();
    final OrderRecord newOrder = OrderRecord(
      orderNumber: nextOrderNumber,
      itemsSummary: summary,
      kitchenNote: options.kitchenNote,
      nutFree: options.nutFree ? 1 : 0,
      glutenFree: options.glutenFree ? 1 : 0,
      noOnions: options.noOnions ? 1 : 0,
      totalPrice: cart.getTotalDue(),
      date: formattedDate,
    );

    try {
      await SandwichDatabase.instance.insertOrder(newOrder);
    } catch (_) {}
    cart.clear();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/history');
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Nothing in your basket yet',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildLineItem(CartRepository cart, CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: shopWhite,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: shopAccent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text('£${item.totalPrice.toStringAsFixed(2)}'),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                cart.removeItem(index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool emphasise = false}) {
    final TextStyle style;
    if (emphasise) {
      style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    } else {
      style = const TextStyle(color: shopText);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  Widget _buildCartList(CartRepository cart, List<CartItem> items) {
    final List<Widget> children = [];

    children.add(const Text('Your basket', style: shopSectionTitleStyle));
    children.add(const SizedBox(height: 16));

    for (int index = 0; index < items.length; index++) {
      final CartItem item = items[index];
      children.add(_buildLineItem(cart, item, index));
    }

    children.add(const Divider(height: 32));
    children.add(
      _buildTotalRow(
        'Items subtotal',
        '£${cart.getSubtotal().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Delivery',
        '£${cart.getDeliveryFee().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Total to pay',
        '£${cart.getTotalDue().toStringAsFixed(2)}',
        emphasise: true,
      ),
    );
    children.add(const SizedBox(height: 24));

    children.add(
      SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          label: 'Place order',
          onPressed: () async {
            await _checkout();
          },
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    final Widget content;
    if (items.isEmpty) {
      content = _buildEmptyState();
    } else {
      content = _buildCartList(cart, items);
    }

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle, style: shopHeaderStyle)),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }
}
