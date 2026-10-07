import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
import 'package:sandwich_shop/widgets/orders_button.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  String _buildSummary(List<CartItem> items) {
    final List<String> lines = [];
    for (final CartItem item in items) {
      lines.add('${item.quantity} x ${item.name}');
    }
    return lines.join(', ');
  }

  bool _anyToasted(List<CartItem> items) {
    for (final CartItem item in items) {
      if (item.toasted) {
        return true;
      }
    }
    return false;
  }

  bool _anyVegan(List<CartItem> items) {
    for (final CartItem item in items) {
      if (item.vegan) {
        return true;
      }
    }
    return false;
  }

  String _buildNote(List<CartItem> items) {
    final List<String> notes = [];
    for (final CartItem item in items) {
      if (item.note.isNotEmpty) {
        notes.add(item.note);
      }
    }
    return notes.join('; ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/${now.year} $hour:$minute';
  }

  Future<void> _checkout(CartRepository cart, List<CartItem> items) async {
    final SandwichDatabase database = SandwichDatabase.instance;
    final int orderNumber = await database.getNextOrderNumber();
    final OrderRecord record = OrderRecord(
      orderNumber: orderNumber,
      summary: _buildSummary(items),
      note: _buildNote(items),
      toasted: _anyToasted(items) ? 1 : 0,
      vegan: _anyVegan(items) ? 1 : 0,
      total: cart.getTotalDue(),
      date: _formatDate(DateTime.now()),
    );
    await database.insertOrder(record);
    cart.clear();
    if (!mounted) {
      return;
    }
    Navigator.pushNamed(context, '/orders');
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Your basket is empty',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildOptionsText(CartItem item) {
    final List<String> parts = [];
    if (item.toasted) {
      parts.add('Toasted');
    }
    if (item.vegan) {
      parts.add('Vegan');
    }
    if (item.note.isNotEmpty) {
      parts.add('Note: ${item.note}');
    }

    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        parts.join(' • '),
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }

  Widget _buildLineItem(CartRepository cart, CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.quantity} x ${item.name}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                _buildOptionsText(item),
              ],
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

  Widget _buildBasketList(CartRepository cart, List<CartItem> items) {
    final List<Widget> children = [];

    children.add(const Text('Your basket', style: shopSectionTitleStyle));
    children.add(const SizedBox(height: 16));

    for (int index = 0; index < items.length; index++) {
      final CartItem item = items[index];
      children.add(_buildLineItem(cart, item, index));
    }

    children.add(const SizedBox(height: 24));
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
          label: 'Checkout',
          onPressed: () {
            _checkout(cart, items);
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
      content = _buildBasketList(cart, items);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton(), OrdersButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }
}
