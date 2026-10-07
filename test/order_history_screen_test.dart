import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/screens/order_history_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final Database db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS orders (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              order_number INTEGER NOT NULL,
              items_summary TEXT NOT NULL,
              kitchen_note TEXT NOT NULL,
              nut_free INTEGER NOT NULL,
              gluten_free INTEGER NOT NULL,
              no_onions INTEGER NOT NULL,
              total_price REAL NOT NULL,
              date TEXT NOT NULL
            )
          ''');
        },
      ),
    );
    SandwichDatabase.instance.setDatabase(db);
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });

  testWidgets('OrderHistoryScreen renders a seeded order',
      (WidgetTester tester) async {
    const OrderRecord order = OrderRecord(
      orderNumber: 1001,
      itemsSummary: '2 x Italian B.M.T. Footlong',
      kitchenNote: 'Toasted',
      nutFree: 0,
      glutenFree: 0,
      noOnions: 1,
      totalPrice: 13.50,
      date: '18 Apr 2026 12:45',
    );

    await tester.runAsync(() async {
      await SandwichDatabase.instance.insertOrder(order);
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: OrderHistoryScreen(),
      ),
    );

    for (int i = 0; i < 10; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await tester.pump();
    }

    expect(find.text('Order history'), findsOneWidget);
    expect(find.text('Order 1001'), findsOneWidget);
    expect(find.text('2 x Italian B.M.T. Footlong'), findsOneWidget);
    expect(find.text('18 Apr 2026 12:45'), findsOneWidget);
    expect(find.text('Total paid: £13.50'), findsOneWidget);
  });

  testWidgets('OrderHistoryScreen shows empty state when there are no orders',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OrderHistoryScreen(),
      ),
    );

    for (int i = 0; i < 10; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await tester.pump();
    }

    expect(find.text('No orders yet'), findsOneWidget);
  });
}
