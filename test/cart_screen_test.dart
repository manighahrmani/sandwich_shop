import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/cart_screen.dart';
import 'package:sandwich_shop/screens/order_history_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    CartRepository.instance.clear();
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

  Widget buildApp() {
    return MaterialApp(
      initialRoute: '/cart',
      routes: <String, WidgetBuilder>{
        '/cart': (BuildContext context) {
          return const CartScreen();
        },
        '/history': (BuildContext context) {
          return const OrderHistoryScreen();
        },
      },
    );
  }

  testWidgets('CartScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Nothing in your basket yet'), findsOneWidget);
    expect(find.text('Place order'), findsNothing);
  });

  testWidgets('CartScreen renders items and removes item when delete pressed', (
    WidgetTester tester,
  ) async {
    const CartItem item = CartItem(
      id: 'footlong',
      name: 'Footlong',
      price: 10.0,
      quantity: 2,
    );
    CartRepository.instance.addItem(item);

    await tester.pumpWidget(buildApp());

    expect(find.text('Your basket'), findsOneWidget);
    expect(find.text('Footlong'), findsOneWidget);
    expect(find.text('£20.00'), findsWidgets);
    expect(find.text('Place order'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Nothing in your basket yet'), findsOneWidget);
  });

  testWidgets('CartScreen checkout persists the order and opens the history', (
    WidgetTester tester,
  ) async {
    const CartItem item = CartItem(
      id: 'footlong',
      name: 'Footlong',
      price: 10.0,
      quantity: 1,
    );
    CartRepository.instance.addItem(item);

    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Place order'));
    await tester.pump();

    for (int i = 0; i < 10; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await tester.pump();
    }
    await tester.pumpAndSettle();

    // Basket is cleared and we land on the order history screen.
    expect(CartRepository.instance.getItems(), isEmpty);
    expect(find.text('Order history'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });
}
