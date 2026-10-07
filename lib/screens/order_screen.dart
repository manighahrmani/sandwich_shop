import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
import 'package:sandwich_shop/widgets/orders_button.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefToasted = 'order_toasted';
const String prefVegan = 'order_vegan';
const String prefNote = 'order_note';

class OrderScreen extends StatefulWidget {
  final Sandwich sandwich;
  final int maxQuantity;

  const OrderScreen({super.key, required this.sandwich, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  bool _toasted = false;
  bool _vegan = false;
  late TextEditingController _noteController;
  String _confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _loadSavedOptions();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedOptions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool toasted = prefs.getBool(prefToasted) ?? false;
    final bool vegan = prefs.getBool(prefVegan) ?? false;
    final String note = prefs.getString(prefNote) ?? '';
    if (!mounted) {
      return;
    }
    setState(() {
      _toasted = toasted;
      _vegan = vegan;
      _noteController.text = note;
    });
  }

  Future<void> _saveOptions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefToasted, _toasted);
    await prefs.setBool(prefVegan, _vegan);
    await prefs.setString(prefNote, _noteController.text.trim());
  }

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToBasket() {
    if (_quantity > 0) {
      final String note = _noteController.text.trim();
      final CartItem item = CartItem(
        id: widget.sandwich.id,
        name: widget.sandwich.name,
        price: widget.sandwich.price,
        quantity: _quantity,
        toasted: _toasted,
        vegan: _vegan,
        note: note,
      );
      CartRepository.instance.addItem(item);
      _saveOptions();
      setState(() {
        _confirmationMessage =
            'Added $_quantity ${widget.sandwich.name} to basket';
      });
    } else {
      setState(() {
        _confirmationMessage = 'Please select at least 1 sandwich';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton(), OrdersButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ${widget.sandwich.name}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            OrderItemDisplay(_quantity, widget.sandwich.name),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decreaseQuantity,
                  child: const Text('Remove'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _increaseQuantity,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Text('Toasted')),
                Switch(
                  value: _toasted,
                  onChanged: (bool value) {
                    setState(() {
                      _toasted = value;
                    });
                    _saveOptions();
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Vegan')),
                Switch(
                  value: _vegan,
                  onChanged: (bool value) {
                    setState(() {
                      _vegan = value;
                    });
                    _saveOptions();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Note for the kitchen',
                hintText: 'Add any notes for this order',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Add to Basket',
                onPressed: _addToBasket,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
  }
}
