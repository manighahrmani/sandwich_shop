import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

/// Tests if the [App] widget correctly displays the [OrderScreen] as its home.
///
/// The [WidgetTester] is a helper class from the `flutter_test` package that
/// provides methods to interact with widgets in a test environment. This test
/// pumps the [App] widget and verifies that exactly one [OrderScreen] widget
/// is found in the widget tree, confirming it's the initial screen.
/// The [findsOneWidget] matcher is used to check for the presence of a single widget.
Future<void> _testAppSetsOrderScreenAsHome(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  expect(find.byType(OrderScreen), findsOneWidget);
}

/// Verifies that the initial UI state of the [OrderScreen] shows zero sandwiches.
///
/// This test pumps the [App] widget and checks for two things:
/// 1. The text '0 Footlong sandwich(es): ' is present, indicating the initial
///    quantity is zero.
/// 2. The app bar title 'Sandwich Counter' is displayed.
Future<void> _testInitialStateShowsZeroSandwiches(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
  expect(find.text('Sandwich Counter'), findsOneWidget);
}

/// Tests the 'Add' button functionality to ensure it increases the quantity.
///
/// It pumps the [App] widget, simulates a tap on the 'Add' button using
/// [tester.tap], and then rebuilds the widget tree with [tester.pump].
/// Finally, it verifies that the quantity displayed on the screen has
/// increased to 1.
Future<void> _testTappingAddButtonIncreasesQuantity(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
  await tester.pump();
  expect(find.text('1 Footlong sandwich(es): 🥪'), findsOneWidget);
}

/// Tests the 'Remove' button functionality to ensure it decreases the quantity.
///
/// This test first taps the 'Add' button to increase the quantity to 1,
/// ensuring there is an item to remove. It then simulates a tap on the 'Remove'
/// button and verifies that the quantity is correctly decreased back to 0.
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

/// Ensures that the sandwich quantity cannot be decreased below zero.
///
/// The test starts with the initial state of 0 sandwiches. It then simulates
/// a tap on the 'Remove' button and verifies that the quantity remains at 0,
/// confirming the lower bound logic.
Future<void> _testQuantityDoesNotGoBelowZero(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);

  // Attempt to remove from zero.
  await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
  await tester.pump();
  expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
}

/// Ensures that the sandwich quantity does not exceed the maximum limit.
///
/// The [App] widget is initialized with a `maxQuantity` of 5. This test
/// simulates tapping the 'Add' button 10 times, which is more than the
/// allowed maximum. It then verifies that the quantity displayed on the screen
/// does not exceed 5, confirming the upper bound logic.
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

/// Tests the [OrderItemDisplay] widget's output for a quantity of zero.
///
/// This test pumps only the [OrderItemDisplay] widget with a quantity of 0
/// and verifies that it correctly displays the text for zero items, without
/// any sandwich emojis.
Future<void> _testOrderItemDisplayForZero(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
    home: Scaffold(body: OrderItemDisplay(0, 'Footlong')),
  ));
  expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);
}

/// Tests the [OrderItemDisplay] widget's output for a non-zero quantity.
///
/// This test pumps the [OrderItemDisplay] widget with a quantity of 3 and
/// verifies that it correctly displays the text along with three sandwich
/// emojis.
Future<void> _testOrderItemDisplayForThree(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
    home: Scaffold(body: OrderItemDisplay(3, 'Footlong')),
  ));
  expect(find.text('3 Footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
}

/// The main entry point for running all widget tests.
void main() {
  // `group` allows organizing related tests together.
  group('App widget', () {
    // `testWidgets` defines a single test case and provides a `WidgetTester`.
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
