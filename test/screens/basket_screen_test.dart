import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';

const Sandwich testSandwich = Sandwich(
  id: 'footlong',
  name: 'Footlong Sub',
  description: 'Classic freshly baked sub.',
  price: 10.0,
  imagePath: 'assets/images/footlong.jpeg',
);

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    CartRepository.instance.clear();
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
    CartRepository.instance.clear();
    OrderRepository.instance.setFirestore(null);
    AuthRepository.instance.setAuth(null);
  });

  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Checkout'), findsNothing);
  });

  testWidgets(
    'BasketScreen renders items and removes item when delete pressed',
    (WidgetTester tester) async {
      const CartItem item = CartItem(
        sandwich: testSandwich,
        quantity: 2,
      );
      CartRepository.instance.addItem(item);

      await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

      expect(find.text('Your basket'), findsOneWidget);
      expect(find.text('2 x Footlong Sub'), findsOneWidget);
      expect(find.text('£20.00'), findsWidgets);
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    },
  );

  testWidgets('Checkout prompts signed-out users to log in and keeps basket', (
    WidgetTester tester,
  ) async {
    AuthRepository.instance.setAuth(MockFirebaseAuth());
    CartRepository.instance.addItem(
      const CartItem(sandwich: testSandwich, quantity: 2),
    );

    bool openedAuth = false;
    await tester.pumpWidget(
      MaterialApp(
        home: const BasketScreen(),
        routes: {
          '/auth': (BuildContext context) {
            openedAuth = true;
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            );
          },
        },
      ),
    );

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Please log in to place an order.'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(CartRepository.instance.getItems().length, 1);

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    expect(openedAuth, isTrue);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Please log in to place an order.'), findsNothing);
    expect(CartRepository.instance.getItems().length, 1);
  });

  testWidgets(
      'Checkout saves the order to Firestore, clears basket and opens orders',
      (WidgetTester tester) async {
    CartRepository.instance.addItem(
      const CartItem(sandwich: testSandwich, quantity: 2),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: const BasketScreen(),
        routes: {
          '/orders': (BuildContext context) {
            return const OrdersScreen();
          },
        },
      ),
    );

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    final List<OrderRecord> orders =
        await OrderRepository.instance.getAllOrders('user-1');
    expect(orders.length, 1);
    expect(orders[0].orderNumber, 1001);
    expect(orders[0].summary, '2 x Footlong Sub');
    expect(orders[0].total, 21.50);
    expect(orders[0].items, hasLength(1));
    expect(orders[0].items[0].sandwichId, 'footlong');
    expect(orders[0].items[0].sandwichName, 'Footlong Sub');
    expect(orders[0].items[0].unitPrice, 10.0);
    expect(orders[0].items[0].quantity, 2);

    expect(CartRepository.instance.getItems(), isEmpty);
    expect(find.byType(OrdersScreen), findsOneWidget);
    expect(find.text('Order #1001'), findsOneWidget);
    expect(
      find.text('2 x Footlong Sub at £10.00 each: £20.00'),
      findsOneWidget,
    );
    expect(find.text('£21.50'), findsOneWidget);
  });

  testWidgets('Checkout keeps the basket when saving fails', (
    WidgetTester tester,
  ) async {
    OrderRepository.instance.setFirestore(null);
    CartRepository.instance.addItem(
      const CartItem(sandwich: testSandwich, quantity: 2),
    );
    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(CartRepository.instance.getItems().length, 1);
    expect(find.text('2 x Footlong Sub'), findsOneWidget);
    expect(find.textContaining('Could not save your order'), findsOneWidget);
  });
}
