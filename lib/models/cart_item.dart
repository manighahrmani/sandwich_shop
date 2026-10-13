import 'package:sandwich_shop/models/sandwich.dart';

class CartItem {
  final Sandwich sandwich;
  final int quantity;

  const CartItem({required this.sandwich, required this.quantity});

  double get lineTotal {
    return sandwich.price * quantity;
  }
}
