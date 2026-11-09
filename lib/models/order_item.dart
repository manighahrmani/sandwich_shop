class OrderItem {
  final String sandwichId;
  final String sandwichName;
  final double unitPrice;
  final int quantity;

  const OrderItem({
    required this.sandwichId,
    required this.sandwichName,
    required this.unitPrice,
    required this.quantity,
  });

  double get lineTotal {
    return unitPrice * quantity;
  }

  Map<String, Object?> toMap(int orderId) {
    return <String, Object?>{
      'order_id': orderId,
      'sandwich_id': sandwichId,
      'sandwich_name': sandwichName,
      'unit_price': unitPrice,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, Object?> map) {
    final num price = map['unit_price'] as num;
    return OrderItem(
      sandwichId: map['sandwich_id'] as String,
      sandwichName: map['sandwich_name'] as String,
      unitPrice: price.toDouble(),
      quantity: map['quantity'] as int,
    );
  }
}
