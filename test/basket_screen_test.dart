import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database database;

  setUp(() async {
    CartRepository.instance.clear();
    database = await databaseFactory.openDatabase(
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
  });

  tearDown(() async {
    await database.close();
    SandwichDatabase.instance.setDatabase(null);
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
        id: 'footlong',
        name: 'Footlong',
        price: 10.0,
        quantity: 2,
      );
      CartRepository.instance.addItem(item);

      await tester.pumpWidget(buildApp());

      expect(find.text('Your basket'), findsOneWidget);
      expect(find.text('2 x Footlong'), findsOneWidget);
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
        id: 'footlong',
        name: 'Footlong',
        price: 10.0,
        quantity: 1,
      );
      CartRepository.instance.addItem(item);

      await tester.pumpWidget(buildApp());

      late List<Map<String, Object?>> rows;
      await tester.runAsync(() async {
        await tester.tap(find.text('Checkout'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
        rows = await database.query('orders');
      });
      await tester.pump();

      expect(find.byType(OrdersScreen), findsOneWidget);
      expect(CartRepository.instance.getItems(), isEmpty);
      expect(rows.length, 1);
      expect(rows.first['summary'], '1 x Footlong');
      expect(find.byType(SnackBar), findsNothing);
    },
  );
}
