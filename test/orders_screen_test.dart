import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<Database> openDatabaseForTest() async {
    final Database database = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE orders (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              order_number INTEGER NOT NULL,
              summary TEXT NOT NULL,
              note TEXT NOT NULL,
              toasted INTEGER NOT NULL,
              vegan INTEGER NOT NULL,
              total REAL NOT NULL,
              date TEXT NOT NULL
            )
          ''');
        },
      ),
    );
    SandwichDatabase.instance.setDatabase(database);
    return database;
  }

  testWidgets('OrdersScreen lists seeded orders newest-first', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final Database database = await openDatabaseForTest();
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
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await database.close();
      SandwichDatabase.instance.setDatabase(null);
    });
    await tester.pump();

    expect(find.text('Order #1002'), findsOneWidget);
    expect(find.text('Order #1001'), findsOneWidget);
    expect(find.text('2 x Footlong Sub'), findsOneWidget);
    expect(find.byType(Divider), findsNothing);
  });

  testWidgets('OrdersScreen shows an empty state when there are no orders', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final Database database = await openDatabaseForTest();
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await database.close();
      SandwichDatabase.instance.setDatabase(null);
    });
    await tester.pump();

    expect(find.text('No orders yet'), findsOneWidget);
  });
}
