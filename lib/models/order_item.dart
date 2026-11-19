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

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{
      'sandwich_id': sandwichId,
      'sandwich_name': sandwichName,
      'unit_price': unitPrice,
      'quantity': quantity,
    };
    return data;
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    final String sandwichId = map['sandwich_id'] as String;
    final String sandwichName = map['sandwich_name'] as String;
    final num price = map['unit_price'] as num;
    final int quantity = map['quantity'] as int;

    return OrderItem(
      sandwichId: sandwichId,
      sandwichName: sandwichName,
      unitPrice: price.toDouble(),
      quantity: quantity,
    );
  }
}
