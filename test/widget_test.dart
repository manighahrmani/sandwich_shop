import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

/// Finds the specific [ElevatedButton] inside a [StyledButton] identified by its icon.
Finder _findElevatedButtonByIcon(IconData icon) {
  // First, find the specific StyledButton that has the desired icon.
  Finder styledButtonFinder = find.widgetWithIcon(StyledButton, icon);
  // Then, find the ElevatedButton that is a descendant of that StyledButton.
  return find.descendant(
    of: styledButtonFinder,
    matching: find.byType(ElevatedButton),
  );
}

/// Tests if the [App] widget correctly displays the [OrderScreen] as its home.
///
/// This test pumps the [App] widget and verifies that exactly one [OrderScreen]
/// widget is found in the widget tree, confirming it's the initial screen.
Future<void> _testAppSetsOrderScreenAsHome(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder orderScreenFinder = find.byType(OrderScreen);
  expect(orderScreenFinder, findsOneWidget);
}

/// Verifies that the initial UI state of the [OrderScreen] is correct.
///
/// This test pumps the [App] widget and checks for two things:
/// 1. The text shows 0 sandwiches with the default bread and item type.
/// 2. The app bar title 'Sandwich Counter' is displayed.
Future<void> _testInitialStateShowsZeroSandwiches(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder initialQuantityFinder = find.text('0 white footlong sandwich(es): ');
  expect(initialQuantityFinder, findsOneWidget);

  Finder appBarTitleFinder = find.text('Sandwich Counter');
  expect(appBarTitleFinder, findsOneWidget);
}

/// Tests the 'Add' button functionality to ensure it increases the quantity.
///
/// It pumps the [App] widget, finds the 'Add' button by its unique icon,
/// simulates a tap, and then rebuilds the widget tree. Finally, it verifies
/// that the quantity displayed on the screen has increased to 1.
Future<void> _testTappingAddButtonIncreasesQuantity(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder addIconFinder = find.byIcon(Icons.add);
  await tester.tap(addIconFinder);
  await tester.pump();

  Finder updatedQuantityFinder = find.text('1 white footlong sandwich(es): 🥪');
  expect(updatedQuantityFinder, findsOneWidget);
}

/// Tests the 'Remove' button functionality to ensure it decreases the quantity.
///
/// This test first taps the 'Add' button to increase the quantity to 1. It then
/// simulates a tap on the 'Remove' button and verifies that the quantity is
/// correctly decreased back to 0.
Future<void> _testTappingRemoveButtonDecreasesQuantity(
    WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder addIconFinder = find.byIcon(Icons.add);
  await tester.tap(addIconFinder);
  await tester.pump();

  Finder quantityOfOneFinder = find.text('1 white footlong sandwich(es): 🥪');
  expect(quantityOfOneFinder, findsOneWidget);

  Finder removeIconFinder = find.byIcon(Icons.remove);
  await tester.tap(removeIconFinder);
  await tester.pump();

  Finder quantityOfZeroFinder = find.text('0 white footlong sandwich(es): ');
  expect(quantityOfZeroFinder, findsOneWidget);
}

/// Ensures that the sandwich quantity cannot be decreased below zero.
///
/// The test starts with the initial state of 0 sandwiches. It then simulates
/// a tap on the 'Remove' button and verifies that the quantity remains at 0,
/// confirming the lower bound logic.
Future<void> _testQuantityDoesNotGoBelowZero(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder initialQuantityFinder = find.text('0 white footlong sandwich(es): ');
  expect(initialQuantityFinder, findsOneWidget);

  Finder removeIconFinder = find.byIcon(Icons.remove);
  await tester.tap(removeIconFinder);
  await tester.pump();

  expect(initialQuantityFinder, findsOneWidget);
}

/// Ensures that the sandwich quantity does not exceed the maximum limit.
///
/// The [App] widget is initialized with a `maxQuantity` of 5. This test
/// simulates tapping the 'Add' button 10 times and verifies that the quantity
/// displayed on the screen does not exceed 5.
Future<void> _testQuantityDoesNotExceedMaxQuantity(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder addIconFinder = find.byIcon(Icons.add);
  for (int i = 0; i < 10; i++) {
    await tester.tap(addIconFinder);
    await tester.pump();
  }

  Finder maxQuantityFinder =
      find.text('5 white footlong sandwich(es): 🥪🥪🥪🥪🥪');
  expect(maxQuantityFinder, findsOneWidget);
}

/// Verifies that the 'Remove' button is disabled when the quantity is zero.
///
/// This test checks the initial state, finds the underlying [ElevatedButton]
/// for the remove action, and asserts that its `onPressed` property is null,
/// which signifies it is disabled. It also confirms the 'Add' button is enabled.
Future<void> _testRemoveButtonIsDisabledAtZero(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder removeButtonFinder = _findElevatedButtonByIcon(Icons.remove);
  ElevatedButton removeButton =
      tester.widget<ElevatedButton>(removeButtonFinder);
  expect(removeButton.onPressed, isNull);

  Finder addButtonFinder = _findElevatedButtonByIcon(Icons.add);
  ElevatedButton addButton = tester.widget<ElevatedButton>(addButtonFinder);
  expect(addButton.onPressed, isNotNull);
}

/// Verifies that the 'Add' button is disabled when the max quantity is reached.
///
/// This test increments the quantity to its maximum limit of 5. It then finds
/// the underlying [ElevatedButton] for the add action and asserts that its
/// `onPressed` property is null. It also confirms the 'Remove' button is enabled.
Future<void> _testAddButtonIsDisabledAtMaxQuantity(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder addIconFinder = find.byIcon(Icons.add);
  for (int i = 0; i < 5; i++) {
    await tester.tap(addIconFinder);
    await tester.pump();
  }

  Finder addButtonFinder = _findElevatedButtonByIcon(Icons.add);
  ElevatedButton addButton = tester.widget<ElevatedButton>(addButtonFinder);
  expect(addButton.onPressed, isNull);

  Finder removeButtonFinder = _findElevatedButtonByIcon(Icons.remove);
  ElevatedButton removeButton =
      tester.widget<ElevatedButton>(removeButtonFinder);
  expect(removeButton.onPressed, isNotNull);
}

/// Verifies that the [Switch] correctly toggles the sandwich type.
///
/// This test finds the [Switch] widget, taps it, and confirms that the
/// displayed text in the [OrderItemDisplay] updates from 'footlong' to 'six-inch'.
Future<void> _testSwitchTogglesSandwichType(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder initialDisplayFinder = find.text('0 white footlong sandwich(es): ');
  expect(initialDisplayFinder, findsOneWidget);

  Finder switchFinder = find.byType(Switch);
  await tester.tap(switchFinder);
  await tester.pump();

  Finder updatedDisplayFinder = find.text('0 white six-inch sandwich(es): ');
  expect(updatedDisplayFinder, findsOneWidget);
}

/// Verifies that the [DropdownMenu] correctly changes the bread type.
///
/// This test finds and opens the [DropdownMenu], selects a new bread type ('wheat'),
/// and confirms that the displayed text in the [OrderItemDisplay] updates.
Future<void> _testDropdownChangesBreadType(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder initialDisplayFinder = find.text('0 white footlong sandwich(es): ');
  expect(initialDisplayFinder, findsOneWidget);

  Finder dropdownFinder = find.byType(DropdownMenu<BreadType>);
  await tester.tap(dropdownFinder);
  await tester.pumpAndSettle(); // Wait for menu animation to finish.

  // Find the menu item for 'wheat' and tap it. Use '.last' to ensure it's
  // the one in the menu and not the one in the closed dropdown button.
  Finder wheatMenuItemFinder = find.text('wheat').last;
  await tester.tap(wheatMenuItemFinder);
  await tester.pumpAndSettle(); // Wait for menu to close.

  Finder updatedDisplayFinder = find.text('0 wheat footlong sandwich(es): ');
  expect(updatedDisplayFinder, findsOneWidget);
}

/// Tests the [OrderItemDisplay] widget's output for a quantity of zero.
///
/// This test pumps only the [OrderItemDisplay] widget with a quantity of 0
/// and verifies that it correctly displays the text for zero items.
Future<void> _testOrderItemDisplayForZero(WidgetTester tester) async {
  MaterialApp testApp = const MaterialApp(
    home: Scaffold(
      body: OrderItemDisplay(
        quantity: 0,
        itemType: 'footlong',
        breadType: BreadType.white,
      ),
    ),
  );
  await tester.pumpWidget(testApp);

  Finder zeroDisplayFinder = find.text('0 white footlong sandwich(es): ');
  expect(zeroDisplayFinder, findsOneWidget);
}

/// Tests the [OrderItemDisplay] widget's output for a non-zero quantity.
///
/// This test pumps the [OrderItemDisplay] widget with a quantity of 3 and
/// verifies that it correctly displays the text with three sandwich emojis.
Future<void> _testOrderItemDisplayForThree(WidgetTester tester) async {
  MaterialApp testApp = const MaterialApp(
    home: Scaffold(
      body: OrderItemDisplay(
        quantity: 3,
        itemType: 'footlong',
        breadType: BreadType.wheat,
      ),
    ),
  );
  await tester.pumpWidget(testApp);

  Finder threeDisplayFinder =
      find.text('3 wheat footlong sandwich(es): 🥪🥪🥪');
  expect(threeDisplayFinder, findsOneWidget);
}

/// The main entry point for running all widget tests.
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
    testWidgets(
        'Remove button is disabled at zero', _testRemoveButtonIsDisabledAtZero);
    testWidgets('Add button is disabled at max quantity',
        _testAddButtonIsDisabledAtMaxQuantity);
    testWidgets('Switch toggles sandwich type', _testSwitchTogglesSandwichType);
    testWidgets(
        'Dropdown menu changes bread type', _testDropdownChangesBreadType);
  });

  group('OrderItemDisplay widget', () {
    testWidgets(
        'Displays correct text and emoji for 0', _testOrderItemDisplayForZero);
    testWidgets(
        'Displays correct text and emoji for 3', _testOrderItemDisplayForThree);
  });
}
