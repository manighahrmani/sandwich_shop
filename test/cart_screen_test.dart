import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/cart_screen.dart';

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets('CartScreen displays empty message when basket has no items',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CartScreen(),
      ),
    );

    expect(find.text('Nothing in your basket yet'), findsOneWidget);
    expect(find.text('Checkout'), findsNothing);
  });

  testWidgets('CartScreen renders items and removes item when delete pressed',
      (WidgetTester tester) async {
    const CartItem item = CartItem(
      id: 'footlong',
      name: 'Footlong',
      price: 10.0,
      quantity: 2,
    );
    CartRepository.instance.addItem(item);

    await tester.pumpWidget(
      const MaterialApp(
        home: CartScreen(),
      ),
    );

    expect(find.text('Your basket'), findsOneWidget);
    expect(find.text('Footlong'), findsOneWidget);
    expect(find.text('£20.00'), findsWidgets);
    expect(find.text('Checkout'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Nothing in your basket yet'), findsOneWidget);
  });

  testWidgets('CartScreen checkout clears basket and shows inline confirmation',
      (WidgetTester tester) async {
    const CartItem item = CartItem(
      id: 'footlong',
      name: 'Footlong',
      price: 10.0,
      quantity: 1,
    );
    CartRepository.instance.addItem(item);

    await tester.pumpWidget(
      const MaterialApp(
        home: CartScreen(),
      ),
    );

    await tester.tap(find.text('Checkout'));
    await tester.pump();

    expect(find.text('Thanks, your order is on its way'), findsOneWidget);
    expect(find.text('Nothing in your basket yet'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });
}
