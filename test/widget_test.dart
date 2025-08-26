import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

Future<void> _testAppSetsOrderScreenAsHome(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder orderScreenFinder = find.byType(OrderScreen);
  expect(orderScreenFinder, findsOneWidget);
}

Future<void> _testInitialStateShowsZeroSandwiches(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder initialQuantityFinder = find.text('0 Footlong sandwich(es): ');
  expect(initialQuantityFinder, findsOneWidget);

  Finder appBarTitleFinder = find.text('Sandwich Counter');
  expect(appBarTitleFinder, findsOneWidget);
}

Future<void> _testTappingAddButtonIncreasesQuantity(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder addIconFinder = find.byIcon(Icons.add);
  await tester.tap(addIconFinder);
  await tester.pump();

  Finder updatedQuantityFinder = find.text('1 Footlong sandwich(es): 🥪');
  expect(updatedQuantityFinder, findsOneWidget);
}

Future<void> _testTappingRemoveButtonDecreasesQuantity(
    WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder addIconFinder = find.byIcon(Icons.add);
  await tester.tap(addIconFinder);
  await tester.pump();

  Finder quantityOfOneFinder = find.text('1 Footlong sandwich(es): 🥪');
  expect(quantityOfOneFinder, findsOneWidget);

  Finder removeIconFinder = find.byIcon(Icons.remove);
  await tester.tap(removeIconFinder);
  await tester.pump();

  Finder quantityOfZeroFinder = find.text('0 Footlong sandwich(es): ');
  expect(quantityOfZeroFinder, findsOneWidget);
}

Future<void> _testQuantityDoesNotGoBelowZero(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder initialQuantityFinder = find.text('0 Footlong sandwich(es): ');
  expect(initialQuantityFinder, findsOneWidget);

  Finder removeIconFinder = find.byIcon(Icons.remove);
  await tester.tap(removeIconFinder);
  await tester.pump();

  expect(initialQuantityFinder, findsOneWidget);
}

Future<void> _testQuantityDoesNotExceedMaxQuantity(WidgetTester tester) async {
  await tester.pumpWidget(const App());

  Finder addIconFinder = find.byIcon(Icons.add);
  for (int i = 0; i < 10; i++) {
    await tester.tap(addIconFinder);
    await tester.pump();
  }

  Finder maxQuantityFinder = find.text('5 Footlong sandwich(es): 🥪🥪🥪🥪🥪');
  expect(maxQuantityFinder, findsOneWidget);
}

Future<void> _testOrderItemDisplayForZero(WidgetTester tester) async {
  MaterialApp testApp = const MaterialApp(
    home: Scaffold(body: OrderItemDisplay(0, 'Footlong')),
  );
  await tester.pumpWidget(testApp);

  Finder zeroDisplayFinder = find.text('0 Footlong sandwich(es): ');
  expect(zeroDisplayFinder, findsOneWidget);
}

Future<void> _testOrderItemDisplayForThree(WidgetTester tester) async {
  MaterialApp testApp = const MaterialApp(
    home: Scaffold(body: OrderItemDisplay(3, 'Footlong')),
  );
  await tester.pumpWidget(testApp);

  Finder threeDisplayFinder = find.text('3 Footlong sandwich(es): 🥪🥪🥪');
  expect(threeDisplayFinder, findsOneWidget);
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
