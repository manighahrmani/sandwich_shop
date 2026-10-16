import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/test_database.dart';

const Sandwich testSandwich = Sandwich(
  id: 'test',
  name: 'Test Sub',
  description: 'Test description',
  price: 5.0,
  imagePath: 'assets/images/footlong.jpeg',
);

void main() {
  setUp(() {
    rootBundle.clear();
    CartRepository.instance.clear();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });

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
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('Settings screen keeps both navigation actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const SettingsScreen()));
    await tester.pumpAndSettle();
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
      await openTestDatabase();
      await tester.pumpWidget(wrap(const OrdersScreen()));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
  });

  testWidgets('Tapping the orders action navigates to the orders screen', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await openTestDatabase();
      await tester.pumpWidget(wrap(const MenuScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.receipt_long));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.receipt_long));
      await tester.pumpAndSettle();
    });
    await tester.pump();

    expect(find.byType(OrdersScreen), findsOneWidget);
    expect(find.byType(OrdersScreen, skipOffstage: false), findsOneWidget);
  });
}
