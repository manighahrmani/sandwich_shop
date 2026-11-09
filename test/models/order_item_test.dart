import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/order_item.dart';

void main() {
  const OrderItem item = OrderItem(
    sandwichId: 'footlong',
    sandwichName: 'Footlong Sub',
    unitPrice: 7.50,
    quantity: 2,
  );

  test('item maps include the order link and purchase snapshot', () {
    expect(item.toMap(42), <String, Object?>{
      'order_id': 42,
      'sandwich_id': 'footlong',
      'sandwich_name': 'Footlong Sub',
      'unit_price': 7.50,
      'quantity': 2,
    });
    final OrderItem restored = OrderItem.fromMap(item.toMap(42));
    expect(restored.toMap(42), item.toMap(42));
    expect(restored.lineTotal, 15.0);
  });

  test('whole-number SQLite prices become doubles', () {
    final Map<String, Object?> row = item.toMap(42);
    row['unit_price'] = 7;
    final OrderItem restored = OrderItem.fromMap(row);
    expect(restored.unitPrice, 7.0);
    expect(restored.unitPrice, isA<double>());
  });
}
