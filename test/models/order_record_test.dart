import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/order_item.dart';
import 'package:sandwich_shop/models/order_record.dart';

void main() {
  const OrderRecord order = OrderRecord(
    orderNumber: 1004,
    summary: '2 x Footlong Sub',
    total: 16.50,
    date: '01/01/2026 09:05',
    items: [
      OrderItem(
        sandwichId: 'footlong',
        sandwichName: 'Footlong Sub',
        unitPrice: 7.50,
        quantity: 2,
      ),
    ],
  );

  test('New orders omit document ids and convert items to maps', () {
    expect(order.id, isNull);
    expect(order.toMap(), <String, dynamic>{
      'order_number': 1004,
      'summary': '2 x Footlong Sub',
      'total': 16.50,
      'date': '01/01/2026 09:05',
      'items': <Map<String, dynamic>>[
        <String, dynamic>{
          'sandwich_id': 'footlong',
          'sandwich_name': 'Footlong Sub',
          'unit_price': 7.50,
          'quantity': 2,
        },
      ],
    });
  });

  test('A Firestore map converts back into an order with document id', () {
    final Map<String, dynamic> docData = <String, dynamic>{
      'order_number': 1010,
      'summary': '1 x Six-Inch Sub',
      'total': 6.0,
      'date': '02/01/2026 10:20',
      'items': <Map<String, dynamic>>[
        <String, dynamic>{
          'sandwich_id': 'six_inch',
          'sandwich_name': 'Six-Inch Sub',
          'unit_price': 4.5,
          'quantity': 1,
        },
      ],
    };
    final OrderRecord restored = OrderRecord.fromMap(docData, id: 'doc-7');
    expect(restored.id, 'doc-7');
    expect(restored.orderNumber, 1010);
    expect(restored.summary, '1 x Six-Inch Sub');
    expect(restored.total, 6.0);
    expect(restored.date, '02/01/2026 10:20');
    expect(restored.items, hasLength(1));
    expect(restored.items[0].sandwichName, 'Six-Inch Sub');
    expect(restored.toMap(), docData);
  });

  test('Whole-number Firestore totals become doubles and missing items default',
      () {
    final Map<String, dynamic> docData = <String, dynamic>{
      'order_number': 1005,
      'summary': '1 x Six-Inch Sub',
      'total': 6,
      'date': '02/01/2026 10:20',
    };
    final OrderRecord restored = OrderRecord.fromMap(docData);
    expect(restored.total, 6.0);
    expect(restored.total, isA<double>());
    expect(restored.items, isEmpty);
  });
}
