class OrderRecord {
  final int? id;
  final int orderNumber;
  final String itemsSummary;
  final String note;
  final int toasted;
  final int vegan;
  final double totalPrice;
  final String date;

  const OrderRecord({
    this.id,
    required this.orderNumber,
    required this.itemsSummary,
    required this.note,
    required this.toasted,
    required this.vegan,
    required this.totalPrice,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'order_number': orderNumber,
      'items_summary': itemsSummary,
      'note': note,
      'toasted': toasted,
      'vegan': vegan,
      'total_price': totalPrice,
      'date': date,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory OrderRecord.fromMap(Map<String, dynamic> map) {
    final int? recordId = map['id'] as int?;
    final int recordNumber = map['order_number'] as int;
    final String recordSummary = map['items_summary'] as String;
    final String recordNote = map['note'] as String;
    final int recordToasted = map['toasted'] as int;
    final int recordVegan = map['vegan'] as int;
    final double recordPrice = (map['total_price'] as num).toDouble();
    final String recordDate = map['date'] as String;

    return OrderRecord(
      id: recordId,
      orderNumber: recordNumber,
      itemsSummary: recordSummary,
      note: recordNote,
      toasted: recordToasted,
      vegan: recordVegan,
      totalPrice: recordPrice,
      date: recordDate,
    );
  }
}
