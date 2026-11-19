import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/order_item.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    OrderRepository.instance.setFirestore(fakeFirestore);
    AuthRepository.instance.setAuth(
      MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'user-1', email: 'alice@example.com'),
      ),
    );
  });

  tearDown(() {
    OrderRepository.instance.setFirestore(null);
    AuthRepository.instance.setAuth(null);
  });

  testWidgets('OrdersScreen prompts signed-out users to log in and reloads', (
    WidgetTester tester,
  ) async {
    final MockFirebaseAuth mockAuth = MockFirebaseAuth(
      signedIn: false,
      mockUser: MockUser(uid: 'user-1', email: 'alice@example.com'),
    );
    AuthRepository.instance.setAuth(mockAuth);
    await OrderRepository.instance.insertOrder(
      'user-1',
      const OrderRecord(
        orderNumber: 1001,
        summary: '1 x Six-Inch Sub',
        total: 6.0,
        date: '01/01/2026 10:00',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: const OrdersScreen(),
        routes: {
          '/auth': (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  await mockAuth.signInWithEmailAndPassword(
                    email: 'alice@example.com',
                    password: 'password123',
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Complete Sign In'),
              ),
            );
          },
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Please log in to view your orders.'), findsOneWidget);
    expect(find.text('Order #1001'), findsNothing);

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Complete Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Order #1001'), findsOneWidget);
  });

  testWidgets('OrdersScreen lists signed-in user orders newest-first only', (
    WidgetTester tester,
  ) async {
    await OrderRepository.instance.insertOrder(
      'user-1',
      const OrderRecord(
        orderNumber: 1001,
        summary: '1 x Six-Inch Sub',
        total: 4.50,
        date: '01/01/2026 10:00',
      ),
    );
    await OrderRepository.instance.insertOrder(
      'user-1',
      const OrderRecord(
        orderNumber: 1002,
        summary: '2 x Footlong Sub',
        total: 15.00,
        date: '02/01/2026 11:00',
      ),
    );
    await OrderRepository.instance.insertOrder(
      'user-2',
      const OrderRecord(
        orderNumber: 1009,
        summary: 'Other user order',
        total: 9.99,
        date: '03/01/2026 12:00',
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Order #1002'), findsOneWidget);
    expect(find.text('Order #1001'), findsOneWidget);
    expect(find.text('Order #1009'), findsNothing);
    expect(find.text('2 x Footlong Sub'), findsOneWidget);
    final double newestY = tester.getTopLeft(find.text('Order #1002')).dy;
    final double oldestY = tester.getTopLeft(find.text('Order #1001')).dy;
    expect(newestY, lessThan(oldestY));
  });

  testWidgets('OrdersScreen shows an empty state when there are no orders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    await tester.pumpAndSettle();

    expect(find.text('No orders yet'), findsOneWidget);
  });

  testWidgets('OrdersScreen shows old summaries and purchased item details', (
    WidgetTester tester,
  ) async {
    await OrderRepository.instance.insertOrder(
      'user-1',
      const OrderRecord(
        orderNumber: 1001,
        summary: 'Historical summary',
        total: 9.0,
        date: '01/01/2026 10:00',
      ),
    );
    await OrderRepository.instance.insertOrder(
      'user-1',
      const OrderRecord(
        orderNumber: 1002,
        summary: 'Summary should not replace item details',
        total: 21.0,
        date: '02/01/2026 10:00',
        items: [
          OrderItem(
            sandwichId: 'footlong',
            sandwichName: 'Original Footlong',
            unitPrice: 7.50,
            quantity: 2,
          ),
          OrderItem(
            sandwichId: 'six_inch',
            sandwichName: 'Original Six-Inch',
            unitPrice: 4.50,
            quantity: 1,
          ),
        ],
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Historical summary'), findsOneWidget);
    expect(find.text('Summary should not replace item details'), findsNothing);
    expect(
      find.text('2 x Original Footlong at £7.50 each: £15.00'),
      findsOneWidget,
    );
    expect(
      find.text('1 x Original Six-Inch at £4.50 each: £4.50'),
      findsOneWidget,
    );
    expect(find.text('£21.00'), findsOneWidget);
    expect(find.text('£9.00'), findsOneWidget);
  });

  testWidgets('OrdersScreen shows a message when orders cannot be loaded', (
    WidgetTester tester,
  ) async {
    OrderRepository.instance.setFirestore(null);

    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Could not load orders'), findsOneWidget);
  });
}
