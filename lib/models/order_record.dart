class OrderRecord {
  final int? id;
  final int orderNumber;
  final String itemsSummary;
  final String kitchenNote;
  final int nutFree;
  final int glutenFree;
  final int noOnions;
  final double totalPrice;
  final String date;

  const OrderRecord({
    this.id,
    required this.orderNumber,
    required this.itemsSummary,
    required this.kitchenNote,
    required this.nutFree,
    required this.glutenFree,
    required this.noOnions,
    required this.totalPrice,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'order_number': orderNumber,
      'items_summary': itemsSummary,
      'kitchen_note': kitchenNote,
      'nut_free': nutFree,
      'gluten_free': glutenFree,
      'no_onions': noOnions,
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
    final String recordNote = map['kitchen_note'] as String;
    final int recordNutFree = map['nut_free'] as int;
    final int recordGlutenFree = map['gluten_free'] as int;
    final int recordNoOnions = map['no_onions'] as int;
    final double recordPrice = (map['total_price'] as num).toDouble();
    final String recordDate = map['date'] as String;

    return OrderRecord(
      id: recordId,
      orderNumber: recordNumber,
      itemsSummary: recordSummary,
      kitchenNote: recordNote,
      nutFree: recordNutFree,
      glutenFree: recordGlutenFree,
      noOnions: recordNoOnions,
      totalPrice: recordPrice,
      date: recordDate,
    );
  }
}
