import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'support/test_database.dart';
import 'support/controlled_database.dart';

const Sandwich testSandwich = Sandwich(
  id: 'footlong',
  name: 'Footlong Sub',
  description: 'Classic freshly baked sub.',
  price: 10.0,
  imagePath: 'assets/images/footlong.jpeg',
);

void main() {
  late Database database;

  setUp(() async {
    CartRepository.instance.clear();
    database = await openTestDatabase();
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });

  Widget buildApp() {
    return MaterialApp(
      home: const BasketScreen(),
      routes: <String, WidgetBuilder>{
        '/orders': (BuildContext context) {
          return const OrdersScreen();
        },
      },
    );
  }

  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());

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

      await tester.pumpWidget(buildApp());

      expect(find.text('Your basket'), findsOneWidget);
      expect(find.text('2 x Footlong Sub'), findsOneWidget);
      expect(find.text('£20.00'), findsWidgets);
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    },
  );

  testWidgets(
    'BasketScreen checkout stores the order and navigates to orders',
    (WidgetTester tester) async {
      const CartItem item = CartItem(
        sandwich: testSandwich,
        quantity: 1,
      );
      CartRepository.instance.addItem(item);

      await tester.pumpWidget(buildApp());

      late List<Map<String, Object?>> rows;
      await tester.runAsync(() async {
        await tester.tap(find.text('Checkout'));
        await tester.pumpAndSettle();
        rows = await database.query('orders');
      });
      await tester.pump();

      expect(find.byType(OrdersScreen), findsOneWidget);
      expect(CartRepository.instance.getItems(), isEmpty);
      expect(rows.length, 1);
      expect(rows.first['summary'], '1 x Footlong Sub');
      expect(rows.first['total'], 11.50);
      expect(find.byType(SnackBar), findsNothing);
    },
  );

  testWidgets('A failed insert keeps the basket and shows an error', (
    WidgetTester tester,
  ) async {
    const CartItem item = CartItem(sandwich: testSandwich, quantity: 1);
    CartRepository.instance.addItem(item);
    await database.execute('''
      CREATE TRIGGER reject_order BEFORE INSERT ON orders
      BEGIN
        SELECT RAISE(FAIL, 'Test insert failure');
      END
    ''');
    await tester.pumpWidget(buildApp());
    await tester.runAsync(() async {
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
    });
    expect(CartRepository.instance.getItems(), hasLength(1));
    expect(find.textContaining('Could not save your order'), findsOneWidget);
    expect(find.byType(OrdersScreen), findsNothing);
    final List<Map<String, Object?>> rows = await database.query('orders');
    expect(rows, isEmpty);
  });

  testWidgets('Checkout snapshots summary and total and accepts only one press',
      (WidgetTester tester) async {
    final CartRepository cart = CartRepository.instance;
    cart.addItem(const CartItem(sandwich: testSandwich, quantity: 2));
    final ControlledDatabase controlled = ControlledDatabase(database);
    final Completer<void> gate = Completer<void>();
    controlled.numberGate = gate;
    SandwichDatabase.instance.setDatabase(controlled);
    await tester.pumpWidget(buildApp());
    final ElevatedButton checkout =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    checkout.onPressed!();
    checkout.onPressed!();
    await tester.pump();
    expect(controlled.numberRequests, 1);
    expect(find.text('Saving your order...'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull);
    expect(tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.delete_outline)).onPressed, isNull);
    final CartItem laterItem =
        CartItem(sandwich: testSandwich, quantity: 3);
    cart.addItem(laterItem);
    late List<Map<String, Object?>> rows;
    await tester.runAsync(() async {
      gate.complete();
      await controlled.insertCompleted.future;
      await tester.pumpAndSettle();
      rows = await database.query('orders');
    });
    await tester.pumpAndSettle();
    expect(controlled.insertRequests, 1);
    expect(rows, hasLength(1));
    expect(rows.first['summary'], '2 x Footlong Sub');
    expect(rows.first['total'], 21.50);
    expect(rows.first['date'],
        matches(RegExp(r'^\d{2}/\d{2}/\d{4} \d{2}:\d{2}$')));
    expect(cart.getItems(), <CartItem>[laterItem]);
  });

  testWidgets('Multiple lines include one delivery fee and remove the right row',
      (WidgetTester tester) async {
    final CartRepository cart = CartRepository.instance;
    cart.addItem(const CartItem(sandwich: testSandwich, quantity: 1));
    cart.addItem(const CartItem(sandwich: testSandwich, quantity: 3));
    await tester.pumpWidget(buildApp());
    expect(find.text('£41.50'), findsOneWidget);
    expect(find.text('£1.50'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pump();
    expect(find.text('1 x Footlong Sub'), findsNothing);
    expect(find.text('3 x Footlong Sub'), findsOneWidget);
    expect(find.text('£31.50'), findsOneWidget);
    await tester.runAsync(() async {
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
    });
    Navigator.of(tester.element(find.byType(OrdersScreen))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Order 1001 saved'), findsOneWidget);
  });

  testWidgets('An order-number query failure keeps the basket and allows retry',
      (WidgetTester tester) async {
    CartRepository.instance.addItem(
        const CartItem(sandwich: testSandwich, quantity: 1));
    await database.execute('ALTER TABLE orders RENAME TO saved_orders');
    await tester.pumpWidget(buildApp());
    await tester.runAsync(() async {
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
    });
    await tester.pump();
    expect(find.textContaining('Could not save your order'), findsOneWidget);
    expect(CartRepository.instance.getItems(), hasLength(1));
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNotNull);
    await database.execute('ALTER TABLE saved_orders RENAME TO orders');
    await tester.runAsync(() async {
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
    });
    expect(CartRepository.instance.getItems(), isEmpty);
  });

  for (final bool failSave in <bool>[false, true]) {
    testWidgets('Disposal during checkout handles failure=$failSave safely',
        (WidgetTester tester) async {
      CartRepository.instance.addItem(
          const CartItem(sandwich: testSandwich, quantity: 1));
      final ControlledDatabase controlled = ControlledDatabase(database);
      final Completer<void> gate = Completer<void>();
      controlled.numberGate = gate;
      SandwichDatabase.instance.setDatabase(controlled);
      if (failSave) {
        await database.execute('DROP TABLE orders');
      }
      await tester.pumpWidget(buildApp());
      await tester.tap(find.text('Checkout'));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() async {
        gate.complete();
        if (failSave) {
          await controlled.numberCompleted.future;
        } else {
          await controlled.insertCompleted.future;
        }
      });
      await tester.pump();
      expect(tester.takeException(), isNull);
      if (failSave) {
        expect(CartRepository.instance.getItems(), hasLength(1));
      } else {
        expect(CartRepository.instance.getItems(), isEmpty);
      }
    });
  }
}
import 'dart:async';
