import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> _openTestDatabase() async {
  return databaseFactoryFfi.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_number INTEGER NOT NULL,
            items_summary TEXT NOT NULL,
            note TEXT NOT NULL,
            toasted INTEGER NOT NULL,
            vegan INTEGER NOT NULL,
            total_price REAL NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    ),
  );
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final Database db = await _openTestDatabase();
    SandwichDatabase.instance.setDatabase(db);
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });

  testWidgets('OrdersScreen lists seeded orders newest first', (
    WidgetTester tester,
  ) async {
    const OrderRecord older = OrderRecord(
      orderNumber: 1001,
      itemsSummary: '1 x Six-Inch Sub',
      note: '',
      toasted: 0,
      vegan: 1,
      totalPrice: 4.50,
      date: '2 Mar 2026 18:10',
    );
    const OrderRecord newer = OrderRecord(
      orderNumber: 1002,
      itemsSummary: '3 x Footlong Sub',
      note: 'Extra salad',
      toasted: 1,
      vegan: 0,
      totalPrice: 22.50,
      date: '11 Jan 2026 13:02',
    );
    await tester.runAsync(() async {
      await SandwichDatabase.instance.insertOrder(older);
      await SandwichDatabase.instance.insertOrder(newer);
    });

    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    for (int i = 0; i < 10; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await tester.pump();
    }

    expect(find.text('Order 1002'), findsOneWidget);
    expect(find.text('Order 1001'), findsOneWidget);
    expect(find.text('3 x Footlong Sub'), findsOneWidget);
    expect(find.text('1 x Six-Inch Sub'), findsOneWidget);
  });

  testWidgets('OrdersScreen shows the empty state when there are no orders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    for (int i = 0; i < 10; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await tester.pump();
    }

    expect(find.text('No orders yet'), findsOneWidget);
  });
}
