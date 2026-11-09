import 'package:sandwich_shop/models/order_item.dart';

class OrderRecord {
  final int? id;
  final int orderNumber;
  final String summary;
  final double total;
  final String date;
  final List<OrderItem> items;

  const OrderRecord({
    this.id,
    required this.orderNumber,
    required this.summary,
    required this.total,
    required this.date,
    this.items = const [],
  });

  Map<String, Object?> toMap() {
    final Map<String, Object?> data = <String, Object?>{
      'order_number': orderNumber,
      'summary': summary,
      'total': total,
      'date': date,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  factory OrderRecord.fromMap(
    Map<String, Object?> map, {
    List<OrderItem> items = const [],
  }) {
    final int orderNumber = map['order_number'] as int;
    final String summary = map['summary'] as String;
    final num totalNumber = map['total'] as num;
    final double total = totalNumber.toDouble();
    final String date = map['date'] as String;

    return OrderRecord(
      id: map['id'] as int?,
      orderNumber: orderNumber,
      summary: summary,
      total: total,
      date: date,
      items: items,
    );
  }
}
