import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/order_screen.dart';

const Sandwich testSandwich = Sandwich(
  id: 'test',
  name: 'Test Sub',
  description: 'Test description',
  price: 5.0,
  imagePath: 'assets/images/footlong.jpeg',
);

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets('OrderScreen shows quantity buttons and Add to Basket button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );

    expect(find.text('Order Test Sub'), findsOneWidget);
    expect(find.text('0 Test Sub sandwich(es): '), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);
    expect(find.text('Add to Basket'), findsOneWidget);
  });

  testWidgets('Adding to basket without selecting quantity shows warning', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );

    await tester.tap(find.text('Add to Basket'));
    await tester.pump();

    expect(find.text('Please select at least 1 sandwich'), findsOneWidget);
    expect(CartRepository.instance.getItems(), isEmpty);
  });

  testWidgets('Adding to basket records quantity and sandwich', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );

    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pump();

    await tester.tap(find.text('Add to Basket'));
    await tester.pump();

    final List<CartItem> items = CartRepository.instance.getItems();
    expect(items.length, 1);

    final CartItem added = items.first;
    expect(added.quantity, 2);
    expect(added.sandwich.id, 'test');
    expect(added.sandwich.name, 'Test Sub');
    expect(find.text('Added 2 Test Sub to basket'), findsOneWidget);
  });

  testWidgets('Custom maximum and lower boundary keep the quantity in range', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OrderScreen(sandwich: testSandwich, maxQuantity: 2),
      ),
    );
    for (int press = 0; press < 4; press++) {
      await tester.tap(find.text('Add'));
      await tester.pump();
    }
    expect(find.text('2 Test Sub sandwich(es): 🥪🥪'), findsOneWidget);
    for (int press = 0; press < 4; press++) {
      await tester.tap(find.text('Remove'));
      await tester.pump();
    }
    expect(find.text('0 Test Sub sandwich(es): '), findsOneWidget);
    await tester.tap(find.text('Add to Basket'));
    await tester.pump();
    expect(CartRepository.instance.getItems(), isEmpty);
  });

  testWidgets('Repeated basket additions keep independent immutable lines', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );
    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.tap(find.text('Add to Basket'));
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.tap(find.text('Add to Basket'));
    await tester.pump();
    final List<CartItem> items = CartRepository.instance.getItems();
    expect(items, hasLength(2));
    expect(items.first.quantity, 1);
    expect(items.last.quantity, 2);
    expect(CartRepository.instance.totalItemCount, 3);
    expect(find.text('Added 2 Test Sub to basket'), findsOneWidget);
  });
}
