import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('OrderScreen interaction tests', () {
    testWidgets('Initial state shows 0 sandwiches',
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
  });
}
