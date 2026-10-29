import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/order_record.dart';

void main() {
  const OrderRecord order = OrderRecord(
    orderNumber: 1004,
    summary: '2 x Footlong Sub',
    total: 16.50,
    date: '01/01/2026 09:05',
  );

  test('New orders omit database ids and convert to map', () {
    expect(order.id, isNull);
    expect(order.toMap(), <String, Object?>{
      'order_number': 1004,
      'summary': '2 x Footlong Sub',
      'total': 16.50,
      'date': '01/01/2026 09:05',
    });
  });

  test('A database map converts back into an order', () {
    final Map<String, Object?> row = <String, Object?>{
      'id': 7,
      'order_number': 1010,
      'summary': '1 x Six-Inch Sub',
      'total': 6.0,
      'date': '02/01/2026 10:20',
    };
    final OrderRecord restored = OrderRecord.fromMap(row);
    expect(restored.id, 7);
    expect(restored.orderNumber, 1010);
    expect(restored.summary, '1 x Six-Inch Sub');
    expect(restored.total, 6.0);
    expect(restored.date, '02/01/2026 10:20');
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
