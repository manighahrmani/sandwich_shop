import 'package:sandwich_shop/models/order_item.dart';

class OrderRecord {
  final String? id;
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

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> itemMaps = <Map<String, dynamic>>[];
    for (final OrderItem item in items) {
      itemMaps.add(item.toMap());
    }

    final Map<String, dynamic> data = <String, dynamic>{
      'order_number': orderNumber,
      'summary': summary,
      'total': total,
      'date': date,
      'items': itemMaps,
    };
    return data;
  }

  factory OrderRecord.fromMap(Map<String, dynamic> map, {String? id}) {
    final int orderNumber = map['order_number'] as int;
    final String summary = map['summary'] as String;
    final num totalNumber = map['total'] as num;
    final double total = totalNumber.toDouble();
    final String date = map['date'] as String;

    final List<OrderItem> parsedItems = <OrderItem>[];
    final dynamic rawItems = map['items'];
    if (rawItems is List<dynamic>) {
      for (final dynamic rawItem in rawItems) {
        if (rawItem is Map) {
          final Map<String, dynamic> itemMap =
              Map<String, dynamic>.from(rawItem);
          parsedItems.add(OrderItem.fromMap(itemMap));
        }
      }
    }

    return OrderRecord(
      id: id,
      orderNumber: orderNumber,
      summary: summary,
      total: total,
      date: date,
      items: parsedItems,
    );
  }
}
