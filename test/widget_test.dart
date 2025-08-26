import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

// Test function for checking if the App widget correctly displays the OrderScreen.
// WidgetTester is a helper class from the flutter_test package.
// It provides methods to interact with widgets in a test environment.
// findsOneWidget is a matcher that checks if exactly one such widget is found.
Future<void> _testAppSetsOrderScreenAsHome(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  expect(find.byType(OrderScreen), findsOneWidget);
}

// Test function for verifying the initial UI state of the OrderScreen.
Future<void> _testInitialStateShowsZeroSandwiches(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
  expect(find.text('Sandwich Counter'), findsOneWidget);
}

// Test function for the 'Add' button functionality.
// tester.tap simulates a tap on the button.
Future<void> _testTappingAddButtonIncreasesQuantity(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
  await tester.pump();
  expect(find.text('1 Footlong sandwich(es): 🥪'), findsOneWidget);
}

// Test function for the 'Remove' button functionality.
Future<void> _testTappingRemoveButtonDecreasesQuantity(
    WidgetTester tester) async {
  await tester.pumpWidget(const App());
  // First, add one to ensure there is something to remove.
  await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
  await tester.pump();
  expect(find.text('1 Footlong sandwich(es): 🥪'), findsOneWidget);

  // Now, test the remove functionality.
  await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
  await tester.pump();
  expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
}

// Test function to ensure the quantity cannot go below zero.
Future<void> _testQuantityDoesNotGoBelowZero(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);

  // Attempt to remove from zero.
  await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
  await tester.pump();
  expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
}

// Test function to ensure the quantity does not exceed the maximum limit.
Future<void> _testQuantityDoesNotExceedMaxQuantity(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  // The maxQuantity is set to 5 in the App widget.
  // We tap 'Add' more than 5 times to test the limit.
  for (int i = 0; i < 10; i++) {
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pump();
  }
  expect(find.text('5 Footlong sandwich(es): 🥪🥪🥪🥪🥪'), findsOneWidget);
}

// Test function for OrderItemDisplay with zero quantity.
Future<void> _testOrderItemDisplayForZero(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
    home: Scaffold(body: OrderItemDisplay(0, 'Footlong')),
  ));
  expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
}

// Test function for OrderItemDisplay with a non-zero quantity.
Future<void> _testOrderItemDisplayForThree(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
    home: Scaffold(body: OrderItemDisplay(3, 'Footlong')),
  ));
  expect(find.text('3 Footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
}

void main() {
  group('App widget', () {
    testWidgets('App sets OrderScreen as home', _testAppSetsOrderScreenAsHome);
  });

  group('OrderScreen interaction tests', () {
    testWidgets('Initial state shows 0 sandwiches',
        _testInitialStateShowsZeroSandwiches);
    testWidgets('Tapping add button increases quantity',
        _testTappingAddButtonIncreasesQuantity);
    testWidgets('Tapping remove button decreases quantity',
        _testTappingRemoveButtonDecreasesQuantity);
    testWidgets(
        'Quantity does not go below zero', _testQuantityDoesNotGoBelowZero);
    testWidgets('Quantity does not exceed maxQuantity',
        _testQuantityDoesNotExceedMaxQuantity);
  });

  group('OrderItemDisplay widget', () {
    testWidgets(
        'Displays correct text and emoji for 0', _testOrderItemDisplayForZero);
    testWidgets(
        'Displays correct text and emoji for 3', _testOrderItemDisplayForThree);
  });
}
