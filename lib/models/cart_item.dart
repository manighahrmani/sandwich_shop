class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final bool toasted;
  final bool vegan;
  final String note;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.toasted = false,
    this.vegan = false,
    this.note = '',
  });

  double get totalPrice {
    return price * quantity;
  }
}
