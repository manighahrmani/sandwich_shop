import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/order_item.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    OrderRepository.instance.setFirestore(fakeFirestore);
  });

  tearDown(() {
    OrderRepository.instance.setFirestore(null);
  });

  test('getNextOrderNumber starts at 1001 and increments per user', () async {
    expect(await OrderRepository.instance.getNextOrderNumber('user-1'), 1001);

    await OrderRepository.instance.insertOrder(
      'user-1',
      const OrderRecord(
        orderNumber: 1001,
        summary: '1 x Six-Inch Sub',
        total: 6.0,
        date: '01/01/2026 10:00',
      ),
    );

    expect(await OrderRepository.instance.getNextOrderNumber('user-1'), 1002);
    expect(await OrderRepository.instance.getNextOrderNumber('user-2'), 1001);
  });

  test('insertOrder and getAllOrders return orders newest-first per user',
      () async {
    final String firstId = await OrderRepository.instance.insertOrder(
      'user-1',
      const OrderRecord(
        orderNumber: 1001,
        summary: '1 x Six-Inch Sub',
        total: 6.0,
        date: '01/01/2026 10:00',
        items: [
          OrderItem(
            sandwichId: 'six_inch',
            sandwichName: 'Six-Inch Sub',
            unitPrice: 4.5,
            quantity: 1,
          ),
        ],
      ),
    );
    final String secondId = await OrderRepository.instance.insertOrder(
      'user-1',
      const OrderRecord(
        orderNumber: 1002,
        summary: '2 x Footlong Sub',
        total: 16.5,
        date: '02/01/2026 11:00',
      ),
    );
    await OrderRepository.instance.insertOrder(
      'user-2',
      const OrderRecord(
        orderNumber: 1001,
        summary: '1 x Loaded Nachos',
        total: 8.49,
        date: '03/01/2026 12:00',
      ),
    );

    final List<OrderRecord> userOneOrders =
        await OrderRepository.instance.getAllOrders('user-1');
    expect(userOneOrders, hasLength(2));
    expect(userOneOrders[0].id, secondId);
    expect(userOneOrders[0].orderNumber, 1002);
    expect(userOneOrders[1].id, firstId);
    expect(userOneOrders[1].orderNumber, 1001);
    expect(userOneOrders[1].items, hasLength(1));
    expect(userOneOrders[1].items[0].sandwichName, 'Six-Inch Sub');

    final List<OrderRecord> userTwoOrders =
        await OrderRepository.instance.getAllOrders('user-2');
    expect(userTwoOrders, hasLength(1));
    expect(userTwoOrders[0].summary, '1 x Loaded Nachos');
  });

  test('firestore falls back to FirebaseFirestore.instance when null', () {
    OrderRepository.instance.setFirestore(null);

    FirebaseFirestore readFirestore() {
      return OrderRepository.instance.firestore;
    }

    expect(readFirestore, throwsA(isA<FirebaseException>()));
  });
}
