class OrderRecord {
  final int? id;
  final int orderNumber;
  final String summary;
  final double total;
  final String date;

  const OrderRecord({
    this.id,
    required this.orderNumber,
    required this.summary,
    required this.total,
    required this.date,
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

  factory OrderRecord.fromMap(Map<String, Object?> map) {
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
    );
  }
}
