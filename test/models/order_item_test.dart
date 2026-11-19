import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/order_item.dart';

void main() {
  const OrderItem item = OrderItem(
    sandwichId: 'footlong',
    sandwichName: 'Footlong Sub',
    unitPrice: 7.50,
    quantity: 2,
  );

  test('item maps store and restore the purchase snapshot', () {
    expect(item.toMap(), <String, dynamic>{
      'sandwich_id': 'footlong',
      'sandwich_name': 'Footlong Sub',
      'unit_price': 7.50,
      'quantity': 2,
    });
    final OrderItem restored = OrderItem.fromMap(item.toMap());
    expect(restored.toMap(), item.toMap());
    expect(restored.lineTotal, 15.0);
  });

  test('whole-number Firestore prices become doubles', () {
    final Map<String, dynamic> row = item.toMap();
    row['unit_price'] = 7;
    final OrderItem restored = OrderItem.fromMap(row);
    expect(restored.unitPrice, 7.0);
    expect(restored.unitPrice, isA<double>());
  });
}
