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

  void _editItem(Sandwich sandwich) async {
    SandwichType selectedType = sandwich.type;
    bool isFootlong = sandwich.isFootlong;
    BreadType selectedBread = sandwich.breadType;

    String _sandwichName(SandwichType type) {
      return Sandwich(
        type: type,
        isFootlong: true,
        breadType: BreadType.white,
      ).name;
    }

    final Sandwich? updated = await showModalBottomSheet<Sandwich>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit item', style: heading2),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SandwichType>(
                    value: selectedType,
                    decoration:
                        const InputDecoration(labelText: 'Sandwich type'),
                    items: SandwichType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(_sandwichName(type)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setModalState(() => selectedType = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Footlong'),
                    value: isFootlong,
                    onChanged: (value) =>
                        setModalState(() => isFootlong = value),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<BreadType>(
                    value: selectedBread,
                    decoration: const InputDecoration(labelText: 'Bread type'),
                    items: BreadType.values
                        .map(
                          (bread) => DropdownMenuItem(
                            value: bread,
                            child: Text(bread.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setModalState(() => selectedBread = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final updatedSandwich = Sandwich(
                            type: selectedType,
                            isFootlong: isFootlong,
                            breadType: selectedBread,
                          );
                          Navigator.pop(context, updatedSandwich);
                        },
                        child: const Text('Save changes'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    if (!mounted || updated == null) return;

    setState(() {
      widget.cart.updateItem(sandwich, updated);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updated ${sandwich.name} to ${updated.name}')),
    );
  }

  void _removeItem(Sandwich sandwich) {
    final removedQty = widget.cart.getQuantity(sandwich);
    if (removedQty == 0) return;

    setState(() {
      widget.cart.removeItem(sandwich);
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Removed $removedQty x ${sandwich.name} from your cart'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.cart.add(sandwich, quantity: removedQty);
            });
          },
        ),
      ),
    );
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _editItem(entry.key),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () => _removeItem(entry.key),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Remove'),
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
