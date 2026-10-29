import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
import 'package:sandwich_shop/widgets/orders_button.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() {
    return _OrdersScreenState();
  }
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderRecord> _orders = [];
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final List<OrderRecord> orders =
          await SandwichDatabase.instance.getAllOrders();
      if (!mounted) {
        return;
      }
      setState(() {
        _orders = orders;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Could not load orders: $error';
        _loading = false;
      });
    }
  }

  Widget _buildOrderCard(OrderRecord order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('£${order.total.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Text(order.summary),
            const SizedBox(height: 4),
            Text(
              order.date,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      body = Center(child: Text(_errorMessage));
    } else if (_orders.isEmpty) {
      body = const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            'No orders yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    } else {
      body = ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildOrderCard(_orders[index]);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [OrdersButton(), BasketButton()],
      ),
      body: body,
    );
  }
}
