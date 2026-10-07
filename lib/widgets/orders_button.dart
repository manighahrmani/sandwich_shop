import 'package:flutter/material.dart';

class OrdersButton extends StatelessWidget {
  const OrdersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.receipt_long),
      onPressed: () {
        final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
        if (currentRoute != '/orders') {
          Navigator.pushNamed(context, '/orders');
        }
      },
    );
  }
}
