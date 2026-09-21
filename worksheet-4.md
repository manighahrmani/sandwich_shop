# Worksheet 4 — Unit and Widget Testing

## Table of contents

- [What you need to know beforehand](#what-you-need-to-know-beforehand)
- [Getting help](#getting-help)
- [Getting started](#getting-started)
- [Why automated testing matters](#why-automated-testing-matters)
- [Unit testing with flutter test](#unit-testing-with-flutter-test)
  - [Understand unit tests](#understand-unit-tests)
  - [Create the repository test file](#create-the-repository-test-file)
  - [Write test assertions with expect](#write-test-assertions-with-expect)
  - [Run unit tests from the terminal](#run-unit-tests-from-the-terminal)
  - [Commit your changes (1)](#commit-your-changes-1)
- [Widget testing in Flutter](#widget-testing-in-flutter)
  - [Understand widget tests](#understand-widget-tests)
  - [The WidgetTester and pumpWidget](#the-widgettester-and-pumpwidget)
  - [Test initial UI rendering](#test-initial-ui-rendering)
  - [Commit your changes (2)](#commit-your-changes-2)
- [Simulating user interaction in tests](#simulating-user-interaction-in-tests)
  - [Tap buttons with tester tap](#tap-buttons-with-tester-tap)
  - [Verify state updates and navigation](#verify-state-updates-and-navigation)
  - [Commit your changes (3)](#commit-your-changes-3)
- [Testing boundary conditions and isolation](#testing-boundary-conditions-and-isolation)
  - [Test widgets in isolation](#test-widgets-in-isolation)
  - [Test minimum and maximum limits](#test-minimum-and-maximum-limits)
  - [Commit your changes (4)](#commit-your-changes-4)
- [Code formatting and static analysis](#code-formatting-and-static-analysis)
  - [Format your code with dart format](#format-your-code-with-dart-format)
  - [Analyse your code with the Dart analyser](#analyse-your-code-with-the-dart-analyser)
  - [Commit your changes (5)](#commit-your-changes-5)
- [Exercises](#exercises)

## What you need to know beforehand

Ensure that you have completed [Worksheet 1 — Dart, Git, GitHub and Flutter](./worksheet-1.md), [Worksheet 2 — Stateless and Stateful Widgets](./worksheet-2.md), and [Worksheet 3 — Data Models, Repositories, Assets and In-Page Navigation](./worksheet-3.md). You should have an application separated into models, repositories, and widgets, with stack-based navigation using `Navigator.push`.

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

You can continue directly with the repository you updated in Worksheet 3. Alternatively, switch to branch `3` of the [Sandwich Shop repository](https://github.com/manighahrmani/sandwich_shop/tree/3), which holds the complete solution from Worksheet 3:

```bash
git checkout 3
```

Ensure that your working tree is clean before starting. If you have uncommitted changes from earlier exercises, commit or stash them first.

## Why automated testing matters

As your application grows, manually checking every button and screen after every edit becomes slow and error-prone. A small change to a model or repository can quietly break a screen you forgot to inspect.

Automated tests allow you to define expectations in code. Whenever you run your tests, the computer verifies all assertions in seconds. In Flutter, tests are divided into three tiers:

1. **Unit tests:** Fast tests that verify individual functions, methods, or classes in isolation without starting the Flutter engine.
2. **Widget tests:** Medium-speed tests that render widgets in a simulated environment to verify layout, text, and user gestures.
3. **Integration tests:** Comprehensive tests that run the entire application on a physical device or browser instance.

In this worksheet, we will focus on unit testing and widget testing to verify our Sandwich Shop application.

## Unit testing with flutter test

Unit tests verify that non-UI classes behave correctly. In our application, `SandwichRepository` provides the menu data. We should ensure it returns valid data before widgets attempt to display it.

### Understand unit tests

Flutter provides the `test()` function from `package:flutter_test/flutter_test.dart`. Each test contains an assertion using the `expect(actual, matcher)` function. If the actual value matches the expected value, the test passes. If not, the test fails with a clear diagnostic message.

To learn more about unit test syntax and matchers, review the [official unit testing guide](https://docs.flutter.dev/cookbook/testing/unit/introduction).

### Create the repository test file

All test files must reside in the `test/` directory at the root of your project and end with `_test.dart`.

Create a new file named `test/sandwich_repository_test.dart`. Start by importing `flutter_test` along with your repository and model classes:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';

void main() {}
```

The `main()` function in a test file is executed by the Flutter test runner.

### Write test assertions with expect

Group your related tests using `group()`. Inside the group, write two tests: one to check that the repository returns two sandwiches, and one to verify their names and prices:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';

void main() {
  group('SandwichRepository unit tests', () {
    test('getSandwiches returns two sandwiches', () {
      final SandwichRepository repository = SandwichRepository();
      final List<Sandwich> sandwiches = repository.getSandwiches();

      expect(sandwiches.length, 2);
    });

    test('getSandwiches contains valid Footlong and Six-Inch subs', () {
      final SandwichRepository repository = SandwichRepository();
      final List<Sandwich> sandwiches = repository.getSandwiches();

      final Sandwich footlong = sandwiches[0];
      expect(footlong.id, 'footlong');
      expect(footlong.name, 'Footlong Sub');
      expect(footlong.price, 7.50);
      expect(footlong.imagePath, isNotEmpty);

      final Sandwich sixInch = sandwiches[1];
      expect(sixInch.id, 'six-inch');
      expect(sixInch.name, 'Six-Inch Sub');
      expect(sixInch.price, 4.50);
      expect(sixInch.imagePath, isNotEmpty);
    });
  });
}
```

Notice how clean unit tests are. They run pure Dart code without needing to build any UI widgets.

### Run unit tests from the terminal

Open your terminal and execute `flutter test` targeting your new test file:

```bash
flutter test test/sandwich_repository_test.dart
```

You should see output similar to the following, confirming that both tests passed:

```text
00:00 +0: SandwichRepository unit tests getSandwiches returns two sandwiches
00:00 +1: SandwichRepository unit tests getSandwiches contains valid Footlong and Six-Inch subs
00:00 +2: All tests passed!
```

### Commit your changes (1)

Stage `test/sandwich_repository_test.dart` and commit your changes with the message `Add unit tests for SandwichRepository`.

## Widget testing in Flutter

While unit tests check data and logic, widget tests verify that widgets look and behave as expected.

### Understand widget tests

Widget tests use `testWidgets()` instead of `test()`. The test callback receives a `WidgetTester` object that allows you to render widgets, search for elements in the widget tree, simulate user taps, and advance time.

For an overview of widget testing concepts, review the [official widget testing guide](https://docs.flutter.dev/cookbook/testing/widget/introduction).

### The WidgetTester and pumpWidget

The `tester.pumpWidget()` method tells Flutter to build and render a given widget into the test environment. Because widget rendering is asynchronous, you must `await` the result.

Open `test/widget_test.dart`. We will structure our widget tests into test cases that verify the home menu and interactions.

### Test initial UI rendering

Replace the contents of `test/widget_test.dart` with two test cases that verify that `App` starts on `MenuScreen` and displays our sandwich cards:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';

void main() {
  group('App smoke tests', () {
    testWidgets('App displays MenuScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sandwich Menu'), findsOneWidget);
    });

    testWidgets('Displays sandwich cards with names and prices',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      expect(find.text('Footlong Sub'), findsOneWidget);
      expect(find.text('£7.50'), findsOneWidget);
      expect(find.text('Six-Inch Sub'), findsOneWidget);
      expect(find.text('£4.50'), findsOneWidget);
      expect(find.text('Order'), findsNWidgets(2));
    });
  });
}
```

The `find.text()` finder searches the rendered tree for specific strings, while `find.byType()` checks for specific widget classes. `findsOneWidget` and `findsNWidgets(2)` assert the number of matches.

Run your tests with `flutter test test/widget_test.dart`. Both tests should pass.

### Commit your changes (2)

Stage `test/widget_test.dart` and commit your changes with the message `Add widget tests for MenuScreen and sandwich cards`.

## Simulating user interaction in tests

Widget testing shines when you simulate user actions like tapping buttons and verifying what changes on the screen.

### Tap buttons with tester tap

The `tester.tap()` method simulates a touch event on any widget found by a finder. After tapping a widget that changes state or navigates, you must call `tester.pumpAndSettle()`.

`tester.pumpAndSettle()` repeatedly redraws frames until all animations, transitions, and timers have completed. This is essential when testing `Navigator.push()`, as the route transition animation takes several frames to finish.

### Verify state updates and navigation

Add a third test case inside `test/widget_test.dart` that taps the **Order** button, confirms that the order screen opens, and tests the **Add** and **Remove** buttons:

```dart
testWidgets('Tapping Order navigates to OrderScreen with selected sandwich',
    (WidgetTester tester) async {
  await tester.pumpWidget(const App());

  // Tap the Order button on the first card
  await tester.tap(find.text('Order').first);
  await tester.pumpAndSettle();

  // Verify that OrderScreen opened with Footlong Sub details
  expect(find.byType(OrderScreen), findsOneWidget);
  expect(find.text('Order Footlong Sub'), findsOneWidget);
  expect(find.text('0 Footlong Sub sandwich(es): '), findsOneWidget);

  // Tap Add to increment counter
  await tester.tap(find.text('Add'));
  await tester.pump();
  expect(find.text('1 Footlong Sub sandwich(es): 🥪'), findsOneWidget);

  // Tap Remove to decrement counter
  await tester.tap(find.text('Remove'));
  await tester.pump();
  expect(find.text('0 Footlong Sub sandwich(es): '), findsOneWidget);
});
```

Ensure that you import `package:sandwich_shop/screens/order_screen.dart` at the top of `test/widget_test.dart`.

Run `flutter test test/widget_test.dart`. Notice how the test runner verifies navigation, argument passing, and state updates in under a second.

### Commit your changes (3)

Stage `test/widget_test.dart` and commit your work with the message `Test navigation and order counter interactions`.

## Testing boundary conditions and isolation

Good automated tests do not just verify normal use; they verify edge cases and boundary limits.

### Test widgets in isolation

You do not need to run the entire app to test a single screen. You can pump any widget directly inside a `MaterialApp`.

This isolation allows you to supply specific configurations to test boundary conditions, such as minimum and maximum limits.

### Test minimum and maximum limits

Add two isolated tests to `test/widget_test.dart` to verify that `OrderScreen` does not decrement below zero and does not increment past `maxQuantity`:

```dart
testWidgets('OrderScreen quantity does not drop below zero',
    (WidgetTester tester) async {
  const sandwich = Sandwich(
    id: 'test',
    name: 'Test Sub',
    description: 'Test description',
    price: 5.0,
    imagePath: 'assets/images/footlong.png',
  );

  await tester.pumpWidget(
    const MaterialApp(
      home: OrderScreen(sandwich: sandwich),
    ),
  );

  await tester.tap(find.text('Remove'));
  await tester.pump();
  expect(find.text('0 Test Sub sandwich(es): '), findsOneWidget);
});

testWidgets('OrderScreen quantity does not exceed maxQuantity',
    (WidgetTester tester) async {
  const sandwich = Sandwich(
    id: 'test',
    name: 'Test Sub',
    description: 'Test description',
    price: 5.0,
    imagePath: 'assets/images/footlong.png',
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
```

Ensure that `package:sandwich_shop/models/sandwich.dart` is imported.

Run all tests across the entire project by executing `flutter test` without arguments:

```bash
flutter test
```

All unit and widget tests across both test files should pass cleanly.

### Commit your changes (4)

Stage `test/widget_test.dart` and commit your changes with the message `Add isolated boundary tests for OrderScreen`.

## Code formatting and static analysis

Before committing your work or presenting it for evaluation, you should always check code formatting and static analysis.

### Format your code with dart format

Dart has an official code formatter that enforces consistent spacing, indentation, and trailing commas. Run it across your project from the terminal:

```bash
dart format lib/ test/
```

If any files were modified by the formatter, stage and commit them.

### Analyse your code with the Dart analyser

The Dart analyser checks for potential bugs, dead code, missing imports, and violations of style rules defined in `analysis_options.yaml`. Run the analyser in your terminal:

```bash
dart analyze lib/ test/
```

You should see:

```text
Analyzing lib, test...
No issues found!
```

If any warnings or lints appear, resolve them before demonstrating your coursework.

### Commit your changes (5)

If you made any formatting fixes, stage the updated files and commit them with the message `Format code with dart format`.

## Exercises

As in Worksheet 1 and Worksheet 2, these exercises apply to your Southsea Cinema coursework and, together with the Worksheet 3 exercises, prepare you for Demo 2 (by Friday 16 October 2026). See the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Commit after each exercise. You must demonstrate your work for a sign-off during your own timetabled practical session.

In Worksheet 3, you refactored the Southsea Cinema application to show movie cards on the home page and navigate to the movie listing page. For Demo 2, you must demonstrate that your codebase is supported by passing automated tests and clean static analysis.

1. Create a unit test file named `test/movie_repository_test.dart` inside your `southsea_cinema` fork. Write tests using `group()`, `test()`, and `expect()` that verify that `MovieRepository.getMovies()` returns a list containing the two expected movies (*The Phantom of the Opera* and *Halloween 1978*), that their titles match, and that their ticket prices are positive numbers. Commit your changes with the message `Add unit tests for MovieRepository`.

2. Open `test/widget_test.dart` in your `southsea_cinema` fork. Write a widget test named `Home page displays movie cards and navigates to listing page` using `testWidgets()`. Pump `SouthseaCinemaApp`, verify that the app title and both movie titles appear, find the **BOOK NOW** buttons, tap the first button with `tester.tap()`, and call `tester.pumpAndSettle()`. Assert that the movie listing page opened displaying the chosen film title and ticket pricing. Commit your changes with the message `Add widget tests for HomeView and navigation`.

3. Run `flutter test` from the root of your `southsea_cinema` project. Ensure that all unit and widget tests pass without failures.

4. Run `dart analyze` and `dart format --output=none --set-exit-if-changed .` across your project. Ensure that there are zero analyser issues and that all code is formatted according to standard Dart conventions. Commit any formatting changes with the message `Format coursework code`.

5. Run your application using `flutter run -d chrome`. Check that the movie cards display their poster images and that clicking **BOOK NOW** opens the dynamic listing page. Show the running application and your passing test suite to a member of staff at your practical session for your Demo 2 sign-off.
