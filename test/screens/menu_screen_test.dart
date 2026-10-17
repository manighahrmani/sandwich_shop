import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:sandwich_shop/widgets/sandwich_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/controlled_assets.dart';

void main() {
  setUp(() {
    rootBundle.clear();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets(
    'MenuScreen shows sandwich list, settings button and basket button',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MenuScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(SandwichCard), findsWidgets);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    },
  );

  testWidgets('Tapping the basket button navigates to BasketScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return const MenuScreen();
          },
          '/basket': (BuildContext context) {
            return const BasketScreen();
          },
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.shopping_basket));
    await tester.pumpAndSettle();

    expect(find.byType(BasketScreen), findsOneWidget);
  });

  testWidgets('Tapping the settings button navigates to SettingsScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return const MenuScreen();
          },
          '/settings': (BuildContext context) {
            return const SettingsScreen();
          },
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets('A delayed empty catalogue shows loading then an empty list',
      (WidgetTester tester) async {
    final ControlledAssets assets = ControlledAssets();
    final Completer<void> gate = Completer<void>();
    assets.gate = gate;
    assets.install();
    addTearDown(assets.uninstall);
    await tester.pumpWidget(const MaterialApp(home: MenuScreen()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    gate.complete();
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(SandwichCard), findsNothing);
  });

  for (final bool missing in <bool>[false, true]) {
    testWidgets('Invalid or missing menu is visibly reported: missing=$missing',
        (WidgetTester tester) async {
      final ControlledAssets assets = ControlledAssets();
      assets.contents = 'invalid JSON';
      assets.missing = missing;
      assets.install();
      addTearDown(assets.uninstall);
      await tester.pumpWidget(const MaterialApp(home: MenuScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('Could not load the menu'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(SandwichCard), findsNothing);
    });
  }

  for (final bool missing in <bool>[false, true]) {
    testWidgets('Menu disposal during loading is safe: missing=$missing',
        (WidgetTester tester) async {
      final ControlledAssets assets = ControlledAssets();
      final Completer<void> gate = Completer<void>();
      assets.gate = gate;
      assets.missing = missing;
      assets.install();
      addTearDown(assets.uninstall);
      await tester.pumpWidget(const MaterialApp(home: MenuScreen()));
      await tester.pumpWidget(const SizedBox.shrink());
      gate.complete();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
