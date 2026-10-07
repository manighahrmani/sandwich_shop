import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() {
    return _OrderHistoryScreenState();
  }
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderRecord> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final List<OrderRecord> loaded =
          await SandwichDatabase.instance.getAllOrders();
      if (mounted) {
        setState(() {
          _orders = loaded;
        });
      }
    } catch (_) {}
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'No orders yet',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderRecord order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: shopWhite,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ${order.orderNumber}',
            style: const TextStyle(
              color: shopBrand,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            order.itemsSummary,
            style: const TextStyle(
              color: shopText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            order.date,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            'Total paid: £${order.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              color: shopBrand,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    final List<Widget> cards = [];
    for (final OrderRecord order in _orders) {
      cards.add(_buildOrderCard(order));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cards,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget bodyContent;
    if (_orders.isEmpty) {
      bodyContent = _buildEmptyState();
    } else {
      bodyContent = _buildOrdersList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order history', style: shopSectionTitleStyle),
            const SizedBox(height: 16),
            bodyContent,
          ],
        ),
      ),
    );
  }
}
