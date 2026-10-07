import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
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

Widget _buildApp() {
  return MaterialApp(
    initialRoute: '/basket',
    routes: <String, WidgetBuilder>{
      '/basket': (BuildContext context) {
        return const BasketScreen();
      },
      '/orders': (BuildContext context) {
        return const OrdersScreen();
      },
    },
  );
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    CartRepository.instance.clear();
    final Database db = await _openTestDatabase();
    SandwichDatabase.instance.setDatabase(db);
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
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
        id: 'footlong',
        name: 'Footlong',
        price: 10.0,
        quantity: 2,
      );
      CartRepository.instance.addItem(item);

      await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

      expect(find.text('Your basket'), findsOneWidget);
      expect(find.text('Footlong'), findsOneWidget);
      expect(find.text('£20.00'), findsWidgets);
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    },
  );

  testWidgets('BasketScreen checkout stores the order and shows the orders '
      'screen', (WidgetTester tester) async {
    const CartItem item = CartItem(
      id: 'footlong',
      name: 'Footlong',
      price: 10.0,
      quantity: 1,
      toasted: true,
      note: 'No onions',
    );
    CartRepository.instance.addItem(item);

    await tester.pumpWidget(_buildApp());

    await tester.tap(find.text('Checkout'));
    for (int i = 0; i < 15; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await tester.pump();
    }

    expect(find.byType(OrdersScreen), findsOneWidget);
    expect(find.text('1 x Footlong'), findsOneWidget);
    expect(CartRepository.instance.getItems(), isEmpty);
    expect(find.byType(SnackBar), findsNothing);
  });
}
