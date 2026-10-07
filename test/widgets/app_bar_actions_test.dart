import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const Sandwich testSandwich = Sandwich(
  id: 'test',
  name: 'Test Sub',
  description: 'Test description',
  price: 5.0,
  imagePath: 'assets/images/footlong.jpeg',
);

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    CartRepository.instance.clear();
    SharedPreferences.setMockInitialValues(<String, Object>{});
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

  Widget wrap(Widget home) {
    return MaterialApp(
      home: home,
      routes: <String, WidgetBuilder>{
        '/orders': (BuildContext context) {
          return const OrdersScreen();
        },
      },
    );
  }

  testWidgets('Menu screen shows both basket and orders actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const MenuScreen()));

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });

  testWidgets('Order screen shows both basket and orders actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const OrderScreen(sandwich: testSandwich)));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });

  testWidgets('Basket screen shows both basket and orders actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const BasketScreen()));

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });

  testWidgets('Orders screen shows both basket and orders actions', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final Database database = await openDatabaseForTest();
      await tester.pumpWidget(wrap(const OrdersScreen()));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await database.close();
      SandwichDatabase.instance.setDatabase(null);
    });
    await tester.pump();

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });

  testWidgets('Tapping the orders action navigates to the orders screen', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final Database database = await openDatabaseForTest();
      await tester.pumpWidget(wrap(const MenuScreen()));
      await tester.tap(find.byIcon(Icons.receipt_long));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await database.close();
      SandwichDatabase.instance.setDatabase(null);
    });
    await tester.pump();

    expect(find.byType(OrdersScreen), findsOneWidget);
  });
}
