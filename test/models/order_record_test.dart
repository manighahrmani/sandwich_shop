import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/order_record.dart';

void main() {
  const OrderRecord order = OrderRecord(
    orderNumber: 1004,
    summary: '2 x Footlong Sub',
    total: 16.50,
    date: '01/01/2026 09:05',
  );

  test('New orders omit database ids and default optional values', () {
    expect(order.id, isNull);
    expect(order.note, isEmpty);
    expect(order.toasted, 0);
    expect(order.vegan, 0);
    expect(order.toMap(), <String, Object?>{
      'order_number': 1004,
      'summary': '2 x Footlong Sub',
      'note': '',
      'toasted': 0,
      'vegan': 0,
      'total': 16.50,
      'date': '01/01/2026 09:05',
    });
  });

  test('A database map converts back into an order', () {
    final Map<String, Object?> row = <String, Object?>{
      'id': 7,
      'order_number': 1010,
      'summary': '1 x Six-Inch Sub',
      'note': 'No onions',
      'toasted': 1,
      'vegan': 1,
      'total': 6.0,
      'date': '02/01/2026 10:20',
    };
    final OrderRecord restored = OrderRecord.fromMap(row);
    expect(restored.id, 7);
    expect(restored.note, 'No onions');
    expect(restored.toasted, 1);
    expect(restored.vegan, 1);
    expect(restored.toMap(), row);
  });

  test('Whole-number SQLite totals become doubles', () {
    final Map<String, Object?> row = order.toMap();
    row['total'] = 6;
    final OrderRecord restored = OrderRecord.fromMap(row);
    expect(restored.total, 6.0);
    expect(restored.total, isA<double>());
  });
}
