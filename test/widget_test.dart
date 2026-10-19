import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart' as application;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    rootBundle.clear();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('OrderItemDisplay widget tests', () {
    testWidgets('displays zero sandwiches with no emoji', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: OrderItemDisplay(0, 'Footlong Sub')),
        ),
      );

      expect(find.text('0 Footlong Sub sandwich(es): '), findsOneWidget);
    });

    testWidgets('displays three sandwiches with three emojis', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: OrderItemDisplay(3, 'Footlong Sub')),
        ),
      );

      expect(find.text('3 Footlong Sub sandwich(es): 🥪🥪🥪'), findsOneWidget);
    });
  });

  group('App smoke tests', () {
    testWidgets('App displays MenuScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const application.App());
      await tester.pumpAndSettle();
      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    });

    testWidgets('Displays sandwich cards with names and prices', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const application.App());
      await tester.pumpAndSettle();
      expect(find.text('Footlong Sub'), findsOneWidget);
      expect(find.text('£7.50'), findsOneWidget);
      expect(find.text('Six-Inch Sub'), findsOneWidget);
      expect(find.text('£4.50'), findsOneWidget);
      expect(find.text('Order'), findsWidgets);

      await tester.scrollUntilVisible(find.text('Loaded Nachos'), 150);
      expect(find.text('£6.99'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Nonexistent Sandwich'), 150);
      await tester.pumpAndSettle();
      expect(find.text('£0.00'), findsOneWidget);
      expect(find.text('Image unavailable'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Tapping Order navigates to OrderScreen with selected sandwich',
      (WidgetTester tester) async {
        await tester.pumpWidget(const application.App());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Order').first);
        await tester.pumpAndSettle();

        expect(find.byType(OrderScreen), findsOneWidget);
        expect(find.text('Order Footlong Sub'), findsOneWidget);
        expect(find.text('0 Footlong Sub sandwich(es): '), findsOneWidget);

        await tester.tap(find.text('Add'));
        await tester.pump();
        expect(find.text('1 Footlong Sub sandwich(es): 🥪'), findsOneWidget);

        await tester.tap(find.text('Remove'));
        await tester.pump();
        expect(find.text('0 Footlong Sub sandwich(es): '), findsOneWidget);
      },
    );

    testWidgets('OrderScreen quantity does not drop below zero', (
      WidgetTester tester,
    ) async {
      const sandwich = Sandwich(
        id: 'test',
        name: 'Test Sub',
        description: 'Test description',
        price: 5.0,
        imagePath: 'assets/images/footlong.jpeg',
      );

      await tester.pumpWidget(
        const MaterialApp(home: OrderScreen(sandwich: sandwich)),
      );

      await tester.tap(find.text('Remove'));
      await tester.pump();
      expect(find.text('0 Test Sub sandwich(es): '), findsOneWidget);
    });

    testWidgets('OrderScreen quantity does not exceed maxQuantity', (
      WidgetTester tester,
    ) async {
      const sandwich = Sandwich(
        id: 'test',
        name: 'Test Sub',
        description: 'Test description',
        price: 5.0,
        imagePath: 'assets/images/footlong.jpeg',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(sandwich: sandwich, maxQuantity: 3),
        ),
      );

      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Add'));
        await tester.pump();
      }

      expect(find.text('3 Test Sub sandwich(es): 🥪🥪🥪'), findsOneWidget);
    });
  });

  testWidgets('Dark mode applies across routes and survives app recreation', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(application.main);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(MenuScreen))).brightness,
      Brightness.light,
    );

    for (final bool darkMode in <bool>[true, false]) {
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Dark mode'));
      await tester.tap(find.text('Dark mode'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save Settings'));
      await tester.tap(find.text('Save Settings'));
      await tester.pumpAndSettle();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('dark_mode'), darkMode);
      final Brightness expectedBrightness;
      if (darkMode) {
        expectedBrightness = Brightness.dark;
      } else {
        expectedBrightness = Brightness.light;
      }
      expect(
        Theme.of(tester.element(find.byType(Scaffold).last)).brightness,
        expectedBrightness,
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(MenuScreen))).brightness,
        expectedBrightness,
      );
      await tester.tap(find.byIcon(Icons.shopping_basket));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(Scaffold).last)).brightness,
        expectedBrightness,
      );

      await tester.pumpWidget(const SizedBox.shrink());
      rootBundle.clear();
      await tester.runAsync(application.main);
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(MenuScreen))).brightness,
        expectedBrightness,
      );
    }
  });
}
