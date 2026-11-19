import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandwich_shop/models/order_record.dart';

class OrderRepository {
  OrderRepository._internal();

  static final OrderRepository instance = OrderRepository._internal();

  FirebaseFirestore? _firestore;

  void setFirestore(FirebaseFirestore? firestore) {
    _firestore = firestore;
  }

  FirebaseFirestore get firestore {
    final FirebaseFirestore? existingFirestore = _firestore;
    if (existingFirestore != null) {
      return existingFirestore;
    }
    return FirebaseFirestore.instance;
  }

  CollectionReference<Map<String, dynamic>> _ordersCollection(String userId) {
    final CollectionReference<Map<String, dynamic>> usersCollection =
        firestore.collection('users');
    final DocumentReference<Map<String, dynamic>> userDocument =
        usersCollection.doc(userId);
    return userDocument.collection('orders');
  }

  Future<String> insertOrder(String userId, OrderRecord order) async {
    final CollectionReference<Map<String, dynamic>> ordersCollection =
        _ordersCollection(userId);
    final Map<String, dynamic> orderData = order.toMap();
    final DocumentReference<Map<String, dynamic>> docRef =
        await ordersCollection.add(orderData);
    return docRef.id;
  }

  Future<List<OrderRecord>> getAllOrders(String userId) async {
    final CollectionReference<Map<String, dynamic>> ordersCollection =
        _ordersCollection(userId);
    final Query<Map<String, dynamic>> sortedQuery = ordersCollection.orderBy(
      'order_number',
      descending: true,
    );
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await sortedQuery.get();

    final List<OrderRecord> orders = <OrderRecord>[];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in snapshot.docs) {
      final Map<String, dynamic> data = doc.data();
      orders.add(OrderRecord.fromMap(data, id: doc.id));
    }
    return orders;
  }

  Future<int> getNextOrderNumber(String userId) async {
    final CollectionReference<Map<String, dynamic>> ordersCollection =
        _ordersCollection(userId);
    final Query<Map<String, dynamic>> sortedQuery = ordersCollection.orderBy(
      'order_number',
      descending: true,
    );
    final Query<Map<String, dynamic>> latestOrderQuery = sortedQuery.limit(1);
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await latestOrderQuery.get();

    if (snapshot.docs.isEmpty) {
      return 1001;
    }
    final QueryDocumentSnapshot<Map<String, dynamic>> latestDocument =
        snapshot.docs.first;
    final Map<String, dynamic> latestData = latestDocument.data();
    final int currentMax = latestData['order_number'] as int;
    return currentMax + 1;
  }
}
