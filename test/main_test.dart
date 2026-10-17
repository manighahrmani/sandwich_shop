import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/order_screen.dart';

void main() {
  setUp(() {
    rootBundle.clear();
  });

  group('App smoke tests', () {
    testWidgets('App displays MenuScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    });

    testWidgets('Displays sandwich cards with names and prices', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.text('Footlong Sub'), findsOneWidget);
      expect(find.text('£7.50'), findsOneWidget);
      expect(find.text('Six-Inch Sub'), findsOneWidget);
      expect(find.text('£4.50'), findsOneWidget);
      expect(find.text('Order'), findsNWidgets(2));
    });

    testWidgets(
      'Tapping Order navigates to OrderScreen with selected sandwich',
      (WidgetTester tester) async {
        await tester.pumpWidget(const App());
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
  });

  test('Android, iOS and macOS are supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = null;
  });

  test('Windows and Linux desktop are not supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('The unsupported platform screen explains what to do',
      (WidgetTester tester) async {
    await tester.pumpWidget(const UnsupportedPlatformApp());
    expect(find.textContaining('Android emulator'), findsOneWidget);
  });
}
