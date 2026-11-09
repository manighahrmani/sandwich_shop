import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_item.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUp(() async {
    sqfliteFfiInit();
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: SandwichDatabase.instance.configureDatabase,
        onCreate: SandwichDatabase.instance.createTables,
      ),
    );
    SandwichDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });

  testWidgets('OrdersScreen lists saved orders newest-first', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1001,
          summary: '1 x Six-Inch Sub',
          total: 4.50,
          date: '01/01/2026 10:00',
        ),
      );
      await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1002,
          summary: '2 x Footlong Sub',
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
    final double newestY = tester.getTopLeft(find.text('Order #1002')).dy;
    final double oldestY = tester.getTopLeft(find.text('Order #1001')).dy;
    expect(newestY, lessThan(oldestY));
  });

  testWidgets('OrdersScreen shows an empty state when there are no orders', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.text('No orders yet'), findsOneWidget);
  });

  testWidgets('OrdersScreen shows old summaries and purchased item details', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1001,
          summary: 'Historical summary',
          total: 9.0,
          date: '01/01/2026 10:00',
        ),
      );
      await SandwichDatabase.instance.insertOrder(
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
    });
    await tester.pump();

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
}
