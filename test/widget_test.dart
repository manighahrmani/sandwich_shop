import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('App widget', () {
    testWidgets('App sets OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen interaction tests', () {
    testWidgets(
        '"Sandwich Counter" text and initial sandwich quantity are displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('Tapping add button increases quantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('1 Footlong sandwich(es): 🥪'), findsOneWidget);
    });

    testWidgets('Tapping remove button decreases quantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('1 Footlong sandwich(es): 🥪'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('Quantity does not go below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('Quantity does not exceed maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
        await tester.pump();
      }
      expect(find.text('5 Footlong sandwich(es): 🥪🥪🥪🥪🥪'), findsOneWidget);
    });
  });

  group('OrderItemDisplay widget', () {
    testWidgets('Displays the correct text for 0 sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(0, 'Footlong');
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('Displays the correct text and emoji for 3 sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(3, 'Footlong');
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('3 Footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
    });
  });
}
