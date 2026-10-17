import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Widget wrap(Widget home) {
    return MaterialApp(home: home);
  }

  testWidgets('Menu screen shows the basket action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const MenuScreen()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsNothing);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('Settings screen keeps the basket action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const SettingsScreen()));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsNothing);
  });

  testWidgets('Order screen shows the basket action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const OrderScreen(sandwich: testSandwich)));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsNothing);
  });

  testWidgets('Basket screen shows the basket action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const BasketScreen()));

    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsNothing);
  });
}
