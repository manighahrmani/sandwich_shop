import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'support/test_database.dart';
import 'support/controlled_database.dart';

void main() {
  tearDown(() async {
    await SandwichDatabase.instance.close();
  });

  testWidgets('OrdersScreen lists seeded orders newest-first', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await openTestDatabase();
      await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1001,
          summary: '1 x Six-Inch Sub',
          note: '',
          toasted: 0,
          vegan: 0,
          total: 4.50,
          date: '01/01/2026 10:00',
        ),
      );
      await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1002,
          summary: '2 x Footlong Sub',
          note: '',
          toasted: 0,
          vegan: 0,
          total: 15.00,
          date: '02/01/2026 11:00',
        ),
      );

      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.text('Order #1002'), findsOneWidget);
    expect(find.text('Order #1001'), findsOneWidget);
    expect(find.text('2 x Footlong Sub'), findsOneWidget);
    expect(find.byType(Divider), findsNothing);
    final double newestY = tester.getTopLeft(find.text('Order #1002')).dy;
    final double oldestY = tester.getTopLeft(find.text('Order #1001')).dy;
    expect(newestY, lessThan(oldestY));
  });

  testWidgets('OrdersScreen shows an empty state when there are no orders', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await openTestDatabase();
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.text('No orders yet'), findsOneWidget);
  });

  testWidgets('A query failure shows an error rather than an empty history', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final Database database = await openTestDatabase();
      await database.execute('DROP TABLE orders');
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await tester.pumpAndSettle();
    });
    expect(find.textContaining('Could not load orders'), findsOneWidget);
    expect(find.text('No orders yet'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Order cards render every option, note, date and formatted total',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await openTestDatabase();
      await SandwichDatabase.instance.insertOrder(const OrderRecord(
        orderNumber: 1001,
        summary: '2 x Footlong Sub',
        note: 'No onions',
        toasted: 1,
        vegan: 1,
        total: 16.5,
        date: '01/01/2026 09:05',
      ));
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await tester.pumpAndSettle();
    });
    await tester.pump();
    expect(find.text('Toasted • Vegan • Note: No onions'), findsOneWidget);
    expect(find.text('£16.50'), findsOneWidget);
    expect(find.text('01/01/2026 09:05'), findsOneWidget);
  });

  for (final bool failQuery in <bool>[false, true]) {
    testWidgets('Orders disposal during loading is safe: failure=$failQuery',
        (WidgetTester tester) async {
      late Database database;
      await tester.runAsync(() async {
        database = await openTestDatabase();
        if (failQuery) {
          await database.execute('DROP TABLE orders');
        }
      });
      final ControlledDatabase controlled = ControlledDatabase(database);
      final Completer<void> gate = Completer<void>();
      controlled.queryGate = gate;
      SandwichDatabase.instance.setDatabase(controlled);
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() async {
        gate.complete();
        await controlled.queryCompleted.future;
      });
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
}
import 'dart:async';
