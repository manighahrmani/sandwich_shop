import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';

const Sandwich testSandwich = Sandwich(
  id: 'footlong',
  name: 'Footlong Sub',
  description: 'Classic freshly baked sub.',
  price: 10.0,
  imagePath: 'assets/images/footlong.jpeg',
);

void main() {
  setUp(() {
    CartRepository.instance.clear();
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

  testWidgets('Multiple lines include one delivery fee and remove the right row',
      (WidgetTester tester) async {
    final CartRepository cart = CartRepository.instance;
    cart.addItem(const CartItem(sandwich: testSandwich, quantity: 1));
    cart.addItem(const CartItem(sandwich: testSandwich, quantity: 3));
    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));
    expect(find.text('£41.50'), findsOneWidget);
    expect(find.text('£1.50'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pump();
    expect(find.text('1 x Footlong Sub'), findsNothing);
    expect(find.text('3 x Footlong Sub'), findsOneWidget);
    expect(find.text('£31.50'), findsOneWidget);
  });

  testWidgets('Checkout clears the basket and shows a confirmation', (
    WidgetTester tester,
  ) async {
    CartRepository.instance.addItem(
      const CartItem(sandwich: testSandwich, quantity: 2),
    );
    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    await tester.tap(find.text('Checkout'));
    await tester.pump();

    expect(CartRepository.instance.getItems(), isEmpty);
    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Thanks, your order is on its way'), findsOneWidget);
  });
}
