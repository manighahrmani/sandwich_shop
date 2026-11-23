# Worksheet 10 — Integration testing and CI/CD

<!-- DRAFT: Integration testing section matches branch 10 with recorded Android emulator GIFs. CI/CD and Deployment sections are deferred for later. -->

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 9](#continue-from-worksheet-9)
- [Integration testing](#integration-testing)
  - [What integration testing is](#what-integration-testing-is)
  - [How Flutter runs integration tests](#how-flutter-runs-integration-tests)
  - [Install the integration test package](#install-the-integration-test-package)
  - [Add stable keys to sandwich cards](#add-stable-keys-to-sandwich-cards)
  - [Write the menu load and scroll test](#write-the-menu-load-and-scroll-test)
  - [Run the test on the Android emulator](#run-the-test-on-the-android-emulator)
  - [Test order validation and subtotal](#test-order-validation-and-subtotal)
  - [Test basket removal and signed-out guards](#test-basket-removal-and-signed-out-guards)
  - [Test registration, sign-out and sign-in](#test-registration-sign-out-and-sign-in)
  - [Test multi-order checkout and order history](#test-multi-order-checkout-and-order-history)
  - [Test cloud settings and bigger text sync](#test-cloud-settings-and-bigger-text-sync)
  - [Test email link and Google sign-in](#test-email-link-and-google-sign-in)
  - [Run integration tests in Chrome](#run-integration-tests-in-chrome)
- [Continuous integration](#continuous-integration)
  - [What CI and CD mean](#what-ci-and-cd-mean)
  - [Create a workflow](#create-a-workflow)
  - [Read the results](#read-the-results)
  - [Add integration tests](#add-integration-tests)
- [Deployment](#deployment)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 9

Continue with your Sandwich Shop app from [Worksheet 9](worksheet-9.md). Your unit and widget tests should already pass with coverage measured as shown in [Measure coverage](worksheet-8.md#measure-coverage). If you need the starting code, clone the [Sandwich Shop repository](https://github.com/manighahrmani/sandwich_shop) and switch to branch `9`:

```bash
cd ~/Downloads
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git switch 9
```

Open the folder in VS Code with **File > Open Folder**, install the packages and confirm all Worksheet 9 tests pass before making changes:

```bash
flutter pub get
flutter test
```

Do not switch branches over unfinished work. Branch `10` contains the completed Sandwich Shop app for this worksheet; use it to compare your finished work, not as your starting point.

## Integration testing

### What integration testing is

Back in [Why automated testing matters](worksheet-4.md#why-automated-testing-matters), we saw that Flutter divides automated tests into unit tests, widget tests and integration tests. Up to Worksheet 9, you wrote unit tests to verify models and repositories on their own and widget tests to check one screen at a time inside a fast simulated environment.

An integration test (also called an end-to-end test or GUI test) runs a complete app or a multi-screen user journey inside a real target runtime, such as an Android emulator, a physical phone or Chrome, to verify that all widgets, routes, plugins and services work together as expected. See Flutter's [Testing Flutter apps](https://docs.flutter.dev/testing/overview) and [Integration testing concepts](https://docs.flutter.dev/cookbook/testing/integration/introduction) pages for the official overview.

Flutter contrasts the three test types along four trade-offs:

| Test type | Execution speed | Dependencies | Maintenance cost | Confidence |
| --- | --- | --- | --- | --- |
| Unit | Quick | Few | Low | Low |
| Widget | Quick | More | Higher | Higher |
| Integration | Slow | Most | Highest | Highest |

Even when unit and widget tests reach high line coverage, bugs can still appear at the boundaries between screens and shared state. Pressing **Checkout** in `BasketScreen` might look right in a standalone widget test yet push the wrong route afterwards, fail to clear the basket in `CartRepository`, or leave **Bigger text** active in `main.dart` after a customer signs out. Integration tests catch those wiring bugs by driving the full `App` across screens.

Because integration tests run much more slowly and take more effort to maintain than unit or widget tests, you do not duplicate every edge case here. Follow Flutter's rule of thumb: keep many fast unit and widget tests tracked by code coverage, plus enough integration tests to verify all critical end-to-end journeys.

### How Flutter runs integration tests

Flutter provides the official `integration_test` package in the Flutter SDK, documented in [Check app functionality with an integration test](https://docs.flutter.dev/testing/integration-tests). Integration tests live in a top-level `integration_test/` directory rather than `test/`, so an ordinary `flutter test` run stays fast and skips device tests until you target `integration_test/`.

Flutter's guides use two terms to explain where code runs:

- Host machine: your laptop or desktop computer running the terminal command.
- Target device: the Android emulator, physical phone or web browser executing the app (for Chrome tests, the host machine and target device are the same computer).

The same `integration_test/app_test.dart` file is cross-platform and works on Android, iOS, desktop and Chrome (via `flutter drive`). However, integration tests differ from unit tests in one vital way: all `testWidgets` blocks inside an integration test file run in one shared Dart process on the device. Calling `app.main()` repeatedly across tests would call `Firebase.initializeApp()` multiple times and leak singleton state between tests.

To keep every journey fast, deterministic and isolated without hardcoding live Firebase passwords or polluting production Firestore collections, branch `10` follows Flutter's local-data integration pattern from [Testing each layer](https://docs.flutter.dev/app-architecture/case-study/testing):

- Before each test, `setUp` injects fresh `MockFirebaseAuth` and `FakeFirebaseFirestore` instances through the `setAuth` and `setFirestore` hooks we added in [Worksheet 9](worksheet-9.md#test-the-authentication-repository).
- Each test mounts a fresh `App(key: UniqueKey())` so `_AppState` resets its auth listener and cloud **Bigger text** scale cleanly for that test.

This tests all Flutter screens, named routes, form controllers, state listeners and repository logic end to end with mocks and fakes rather than live Firebase servers. When you later want end-to-end checks against real Firestore queries and server-side security rules locally, connect the app to the [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite) instead of live production data. Note also that `integration_test` compiles and runs your local source code before release; it does not test a live deployed Firebase Hosting site such as `https://<project-id>.web.app`, which teams test separately after deployment with web browser automation tools such as Playwright or Cypress.

### Install the integration test package

Add `integration_test` from the Flutter SDK under `dev_dependencies` from the root of your project:

```bash
flutter pub add "dev:integration_test:{sdk: flutter}"
```

Open `pubspec.yaml` and confirm that `integration_test` appears beside `flutter_test` under `dev_dependencies`, while keeping your existing packages (`firebase_auth_mocks`, `fake_cloud_firestore` and `shared_preferences_platform_interface`):

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

Run `flutter pub get` if VS Code does not fetch dependencies automatically. Because `integration_test` is a `dev_dependency`, release builds exclude it.

### Add stable keys to sandwich cards

On the menu screen, `SandwichCard` renders an **Order** button on each card (`Footlong Sub`, `Six-Inch Sub` and `Loaded Nachos`). Calling `find.text('Order')` therefore matches three buttons at once, and calling `first` breaks whenever the item order changes. Note that live Cloud Firestore returns documents sorted alphabetically by document ID (`footlong`, `nachos`, `six-inch`), whereas a bundled JSON asset keeps array order.

Give each `Card` a `Key` built from `sandwich.id`, matching Flutter's [Find widgets](https://docs.flutter.dev/cookbook/testing/widget/finders) guide. Open `lib/widgets/sandwich_card.dart` and add the `key` line inside `build`:

```dart
  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('sandwichCard_${sandwich.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
```

Open `test/widgets/sandwich_card_test.dart` and also assert this key inside the `SandwichCard shows the name, description and price` test, right after checking `'£5.00'`:

```dart
    expect(find.byKey(const Key('sandwichCard_test')), findsOneWidget);
```

Save both files and run `flutter test` to confirm all existing unit and widget tests still pass.

### Write the menu load and scroll test

Create an `integration_test` directory in the root of your project and create a new file named `integration_test/app_test.dart`. Start with the imports for the test runner, our repositories and `MenuScreen`, plus `main()` calling `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`:

```dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';
import 'package:sandwich_shop/repositories/settings_repository.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
}
```

Calling `IntegrationTestWidgetsFlutterBinding.ensureInitialized()` configures Flutter's live binding so `WidgetTester` drives the app inside the real emulator or browser frame loop.

Inside `main()`, below `IntegrationTestWidgetsFlutterBinding.ensureInitialized();`, add a `FakeFirebaseFirestore` variable alongside `setUp` and `tearDown`. Calling `rootBundle.clear()` from `flutter/services.dart` clears any cached asset data, ensuring every test starts with empty preferences, an empty basket, a fresh Firestore instance and a signed-out user:

```dart
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    rootBundle.clear();
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    fakeFirestore = FakeFirebaseFirestore();
    final MockFirebaseAuth defaultAuth = MockFirebaseAuth();
    AuthRepository.instance.setAuth(defaultAuth);
    CartRepository.instance.clear();
    SandwichRepository.instance.clearCache();
    SandwichRepository.instance.setFirestore(fakeFirestore);
    SettingsRepository.instance.setFirestore(fakeFirestore);
    OrderRepository.instance.setFirestore(fakeFirestore);
  });

  tearDown(() {
    CartRepository.instance.clear();
    AuthRepository.instance.setAuth(null);
    SandwichRepository.instance.clearCache();
    SandwichRepository.instance.setFirestore(null);
    SettingsRepository.instance.setFirestore(null);
    OrderRepository.instance.setFirestore(null);
  });
```

Clearing `SandwichRepository.instance.clearCache()` forces `MenuScreen` to seed and read the menu from `fakeFirestore` on every test run, matching [Read the menu from Firestore](worksheet-9.md#read-the-menu-from-firestore).

Below `tearDown()`, add a `group` with your first test verifying that `App` opens on `MenuScreen`, displays `Footlong Sub` and `Six-Inch Sub`, and scrolls down to `Loaded Nachos`:

```dart
  group('Sandwich Shop end-to-end workflows', () {
    testWidgets('menu screen opens and loads sandwiches from Firestore', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(App(key: UniqueKey()));
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Footlong Sub'), findsOneWidget);
      expect(find.text('Six-Inch Sub'), findsOneWidget);

      final Finder nachosFinder = find.text('Loaded Nachos');
      await tester.scrollUntilVisible(nachosFinder, 200);
      expect(nachosFinder, findsOneWidget);
    });
  });
```

Passing `UniqueKey()` to `App` tells Flutter to build a brand-new `_AppState` for each test so no auth subscription or font scale carries over from the previous test. Calling `await tester.pumpAndSettle()` waits until pending frames and animations settle; avoid calling it when a continuous spinner stays visible, as `pumpAndSettle` will wait until it times out. Calling `scrollUntilVisible` scrolls the list in 200-pixel steps until `Loaded Nachos` is visible on smaller screens.

### Run the test on the Android emulator

Start your Android emulator following [Preparing an Android emulator or device](worksheet-7.md#preparing-an-android-emulator-or-device) and check its device ID:

```bash
flutter devices
```

Look for your emulator ID (for example `emulator-5554`), then run `integration_test/app_test.dart`:

```bash
flutter test integration_test/app_test.dart -d emulator-5554
```

Flutter builds and installs a debug APK on the emulator, launches the test runner inside the real Android app, drives the UI automatically and prints the test summary in your terminal. Replace `emulator-5554` with the device ID from `flutter devices` if yours differs.

Notice that running integration tests takes noticeably longer than unit tests, and `flutter test --coverage` does not include `integration_test/` in `coverage/lcov.info`. Keep measuring line coverage with your `test/` suite from [Worksheet 8](worksheet-8.md#test-coverage).

### Test order validation and subtotal

Add the `OrderScreen` import at the top of `integration_test/app_test.dart`:

```dart
import 'package:sandwich_shop/screens/order_screen.dart';
```

Now add a second test inside `group(...)` to open `OrderScreen` from `Footlong Sub` and verify its empty-quantity validation. Notice two patterns used here: `find.descendant` looks for `'Order'` strictly inside `footlongCard` (stored in explicitly typed `Finder` variables without chaining), and `tester.ensureVisible` scrolls a widget onto the viewport before `tap` to prevent off-screen tap warnings on mobile screens:

```dart
    testWidgets('ordering a sandwich validates quantity and updates subtotal', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(App(key: UniqueKey()));
      await tester.pumpAndSettle();

      final Finder footlongCard =
          find.byKey(const Key('sandwichCard_footlong'));
      await tester.ensureVisible(footlongCard);
      final Finder orderTextFinder = find.text('Order');
      final Finder footlongOrderButton = find.descendant(
        of: footlongCard,
        matching: orderTextFinder,
      );
      await tester.tap(footlongOrderButton);
      await tester.pumpAndSettle();

      expect(find.byType(OrderScreen), findsOneWidget);
      expect(find.text('Order Footlong Sub'), findsOneWidget);
      expect(find.text('0 Footlong Sub sandwich(es): '), findsOneWidget);
      expect(find.text('£0.00'), findsOneWidget);

      final Finder addToBasketButton = find.text('Add to Basket');
      await tester.ensureVisible(addToBasketButton);
      await tester.tap(addToBasketButton);
      await tester.pump();
      expect(find.text('Please select at least 1 sandwich'), findsOneWidget);
    });
```

Inside that same test, right before the closing `});`, add the quantity changes, formatted emoji summary check, subtotal check and confirmation snack bar:

```dart
      final Finder addButton = find.text('Add');
      final Finder removeButton = find.text('Remove');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pump();
      await tester.tap(addButton);
      await tester.pump();
      await tester.tap(addButton);
      await tester.pump();
      await tester.tap(removeButton);
      await tester.pump();

      expect(find.text('2 Footlong Sub sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);

      await tester.ensureVisible(addToBasketButton);
      await tester.tap(addToBasketButton);
      await tester.pumpAndSettle();
      expect(find.text('Added 2 Footlong Sub to basket'), findsOneWidget);
```

### Test basket removal and signed-out guards

Add imports for `BasketScreen`, `OrdersScreen` and `SettingsScreen` at the top of `integration_test/app_test.dart`:

```dart
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
```

Start a third test inside `group(...)` to add one `Footlong Sub` and two `Six-Inch Sub`s to the basket. Calling `await tester.pageBack()` simulates tapping the app bar back button so we return cleanly to `MenuScreen` between items:

```dart
    testWidgets(
      'basket edits work and signed-out guards protect actions',
      (WidgetTester tester) async {
        await tester.pumpWidget(App(key: UniqueKey()));
        await tester.pumpAndSettle();

        final Finder orderTextFinder = find.text('Order');
        final Finder addButton = find.text('Add');
        final Finder addToBasketButton = find.text('Add to Basket');

        final Finder footlongCard = find.byKey(
          const Key('sandwichCard_footlong'),
        );
        await tester.scrollUntilVisible(footlongCard, 200);
        await tester.ensureVisible(footlongCard);
        final Finder footlongOrderButton = find.descendant(
          of: footlongCard,
          matching: orderTextFinder,
        );
        await tester.tap(footlongOrderButton);
        await tester.pumpAndSettle();
        await tester.tap(addButton);
        await tester.pump();
        await tester.ensureVisible(addToBasketButton);
        await tester.tap(addToBasketButton);
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();

        final Finder sixInchCard = find.byKey(
          const Key('sandwichCard_six-inch'),
        );
        await tester.scrollUntilVisible(sixInchCard, 200);
        await tester.ensureVisible(sixInchCard);
        final Finder sixInchOrderButton = find.descendant(
          of: sixInchCard,
          matching: orderTextFinder,
        );
        await tester.tap(sixInchOrderButton);
        await tester.pumpAndSettle();
        await tester.tap(addButton);
        await tester.pump();
        await tester.tap(addButton);
        await tester.pump();
        await tester.ensureVisible(addToBasketButton);
        await tester.tap(addToBasketButton);
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();
      },
    );
```

Inside that same test, right before the closing `},`, open `BasketScreen`, check the initial subtotal, delivery charge and total, and remove the second item using `deleteButtons.last`. When only `1 x Footlong Sub` remains, both the line item price and **Items subtotal** read `'£7.50'`, so we check `findsNWidgets(2)` explicitly instead of `findsOneWidget`:

```dart
        final Finder basketIcon = find.byIcon(Icons.shopping_basket);
        await tester.tap(basketIcon);
        await tester.pumpAndSettle();
        expect(find.byType(BasketScreen), findsOneWidget);
        expect(find.text('1 x Footlong Sub'), findsOneWidget);
        expect(find.text('2 x Six-Inch Sub'), findsOneWidget);
        expect(find.text('£16.50'), findsOneWidget);
        expect(find.text('£1.50'), findsOneWidget);
        expect(find.text('£18.00'), findsOneWidget);

        final Finder deleteButtons = find.byIcon(Icons.delete_outline);
        final Finder secondDeleteButton = deleteButtons.last;
        await tester.tap(secondDeleteButton);
        await tester.pumpAndSettle();
        expect(find.text('2 x Six-Inch Sub'), findsNothing);
        expect(find.text('£7.50'), findsNWidgets(2));
        expect(find.text('£9.00'), findsOneWidget);
```

Next, still before the closing `},`, verify that **Checkout**, `OrdersScreen` and `SettingsScreen` all prompt a signed-out visitor to log in:

```dart
        final Finder checkoutButton = find.text('Checkout');
        await tester.ensureVisible(checkoutButton);
        await tester.tap(checkoutButton);
        await tester.pumpAndSettle();
        expect(find.text('Please log in to place an order.'), findsOneWidget);
        expect(find.text('Log In'), findsOneWidget);

        final Finder ordersIcon = find.byIcon(Icons.receipt_long);
        await tester.tap(ordersIcon);
        await tester.pumpAndSettle();
        expect(find.byType(OrdersScreen), findsOneWidget);
        expect(find.text('Please log in to view your orders.'), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();

        final Finder settingsIcon = find.byIcon(Icons.person_outline);
        await tester.tap(settingsIcon);
        await tester.pumpAndSettle();
        expect(find.byType(SettingsScreen), findsOneWidget);
        final Finder saveSettingsButton = find.text('Save Settings');
        await tester.ensureVisible(saveSettingsButton);
        await tester.tap(saveSettingsButton);
        await tester.pumpAndSettle();
        expect(
          find.text('Please log in to save your settings.'),
          findsOneWidget,
        );
```

Run the test on your Android emulator to see the basket edits and signed-out guards verified end to end, as shown below:

![Animated recording of the Android emulator running the basket edits and signed-out guards integration test](images/10/integration_test_order_basket.gif)

### Test registration, sign-out and sign-in

Add the `AuthScreen` import at the top of `integration_test/app_test.dart`:

```dart
import 'package:sandwich_shop/screens/auth_screen.dart';
```

Now add an authentication workflow test inside `group(...)`. We construct `MockFirebaseAuth` with `MockUser(uid: 'customer-1', email: 'alice@example.com')` and `signedIn: false`, open `AuthScreen`, check blank sign-in validation, switch to **Create Account**, and select the email and password `TextField` widgets with `textFields.at(0)` and `textFields.at(1)` to register `alice@example.com`:

```dart
    testWidgets('registration, sign-out clearing basket and sign-in work', (
      WidgetTester tester,
    ) async {
      final MockUser existingUser = MockUser(
        uid: 'customer-1',
        email: 'alice@example.com',
      );
      final MockFirebaseAuth signedOutAuth = MockFirebaseAuth(
        mockUser: existingUser,
        signedIn: false,
      );
      AuthRepository.instance.setAuth(signedOutAuth);

      await tester.pumpWidget(App(key: UniqueKey()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      expect(find.byType(AuthScreen), findsOneWidget);

      await tester.tap(find.text('Sign In'));
      await tester.pump();
      expect(
        find.text('Please enter both an email and a password.'),
        findsOneWidget,
      );

      final Finder toggleButton = find.text('Need an account? Register');
      await tester.ensureVisible(toggleButton);
      await tester.tap(toggleButton);
      await tester.pumpAndSettle();
      expect(find.text('Create Account'), findsOneWidget);

      final Finder textFields = find.byType(TextField);
      final Finder emailField = textFields.at(0);
      final Finder passwordField = textFields.at(1);
      await tester.enterText(emailField, 'alice@example.com');
      await tester.enterText(passwordField, 'secret123');
      final Finder registerButton = find.text('Register');
      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });
```

Inside that same test, right before the closing `});`, add a `Six-Inch Sub` to the basket while signed in, tap **Sign Out** and verify both that **Log In** returns and that the side-effect rule from [Worksheet 9](worksheet-9.md#test-signing-up-signing-in-and-signing-out) empties `BasketScreen`:

```dart
      final Finder sixInchCard = find.byKey(const Key('sandwichCard_six-inch'));
      await tester.scrollUntilVisible(sixInchCard, 200);
      await tester.ensureVisible(sixInchCard);
      final Finder orderTextFinder = find.text('Order');
      final Finder sixInchOrderButton = find.descendant(
        of: sixInchCard,
        matching: orderTextFinder,
      );
      await tester.tap(sixInchOrderButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pump();
      final Finder addToBasketButton = find.text('Add to Basket');
      await tester.ensureVisible(addToBasketButton);
      await tester.tap(addToBasketButton);
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();
      expect(find.text('Log In'), findsOneWidget);

      final Finder basketIcon = find.byIcon(Icons.shopping_basket);
      await tester.tap(basketIcon);
      await tester.pumpAndSettle();
      expect(find.text('Your basket is empty'), findsOneWidget);
```

Finally, before the closing `});`, return to `MenuScreen` and sign back in with the newly registered account:

```dart
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      final Finder signInFields = find.byType(TextField);
      final Finder signInEmailField = signInFields.at(0);
      final Finder signInPasswordField = signInFields.at(1);
      await tester.enterText(signInEmailField, 'alice@example.com');
      await tester.enterText(signInPasswordField, 'secret123');
      final Finder signInButton = find.text('Sign In');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
```

This authentication journey runs on the emulator as shown below:

![Animated recording of the Android emulator running the registration, sign-out and sign-in integration test](images/10/integration_test_auth.gif)

### Test multi-order checkout and order history

Now add the checkout journey test inside `group(...)`. Starting signed in (`uid: 'buyer-1'`), add two `Footlong Sub`s and one `Six-Inch Sub` to the basket:

```dart
    testWidgets('checkout saves multiple itemised orders and clears basket', (
      WidgetTester tester,
    ) async {
      final MockUser signedInUser = MockUser(
        uid: 'buyer-1',
        email: 'buyer@example.com',
      );
      final MockFirebaseAuth signedInAuth = MockFirebaseAuth(
        mockUser: signedInUser,
        signedIn: true,
      );
      AuthRepository.instance.setAuth(signedInAuth);

      await tester.pumpWidget(App(key: UniqueKey()));
      await tester.pumpAndSettle();
      expect(find.text('Sign Out'), findsOneWidget);

      final Finder orderTextFinder = find.text('Order');
      final Finder addButton = find.text('Add');
      final Finder addToBasketButton = find.text('Add to Basket');

      final Finder footlongCard = find.byKey(
        const Key('sandwichCard_footlong'),
      );
      await tester.scrollUntilVisible(footlongCard, 200);
      await tester.ensureVisible(footlongCard);
      final Finder footlongOrderButton = find.descendant(
        of: footlongCard,
        matching: orderTextFinder,
      );
      await tester.tap(footlongOrderButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pump();
      await tester.tap(addButton);
      await tester.pump();
      await tester.ensureVisible(addToBasketButton);
      await tester.tap(addToBasketButton);
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      final Finder sixInchCard = find.byKey(const Key('sandwichCard_six-inch'));
      await tester.scrollUntilVisible(sixInchCard, 200);
      await tester.ensureVisible(sixInchCard);
      final Finder sixInchOrderButton = find.descendant(
        of: sixInchCard,
        matching: orderTextFinder,
      );
      await tester.tap(sixInchOrderButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pump();
      await tester.ensureVisible(addToBasketButton);
      await tester.tap(addToBasketButton);
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
    });
```

Inside that same test, right before the closing `});`, open `BasketScreen`, check `'£19.50'`, `'£1.50'` and `'£21.00'`, tap **Checkout**, confirm `OrdersScreen` opens with `'Order #1001'` and its two itemised lines, and verify `BasketScreen` is now empty:

```dart
      final Finder basketIcon = find.byIcon(Icons.shopping_basket);
      await tester.tap(basketIcon);
      await tester.pumpAndSettle();
      expect(find.text('£19.50'), findsOneWidget);
      expect(find.text('£1.50'), findsOneWidget);
      expect(find.text('£21.00'), findsOneWidget);

      final Finder checkoutButton = find.text('Checkout');
      await tester.ensureVisible(checkoutButton);
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.byType(OrdersScreen), findsOneWidget);
      expect(find.text('Order #1001'), findsOneWidget);
      expect(find.text('£21.00'), findsOneWidget);
      expect(
        find.text('2 x Footlong Sub at £7.50 each: £15.00'),
        findsOneWidget,
      );
      expect(
        find.text('1 x Six-Inch Sub at £4.50 each: £4.50'),
        findsOneWidget,
      );

      await tester.tap(basketIcon);
      await tester.pumpAndSettle();
      expect(find.text('Your basket is empty'), findsOneWidget);
```

Still before the closing `});`, navigate back to `MenuScreen`, order one `Loaded Nachos` and check out a second time. Using `tester.getTopLeft` returns an `Offset` holding screen coordinates, so checking that `order1002Position.dy` is `lessThan(order1001Position.dy)` proves `OrdersScreen` renders the newer order above the older one, matching `descending: true` in [Store and read orders](worksheet-9.md#store-and-read-orders):

```dart
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      final Finder nachosCard = find.byKey(const Key('sandwichCard_nachos'));
      await tester.scrollUntilVisible(nachosCard, 200);
      await tester.ensureVisible(nachosCard);
      final Finder nachosOrderButton = find.descendant(
        of: nachosCard,
        matching: orderTextFinder,
      );
      await tester.tap(nachosOrderButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pump();
      await tester.ensureVisible(addToBasketButton);
      await tester.tap(addToBasketButton);
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(basketIcon);
      await tester.pumpAndSettle();
      await tester.ensureVisible(checkoutButton);
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      final Finder order1002Finder = find.text('Order #1002');
      final Finder order1001Finder = find.text('Order #1001');
      expect(order1002Finder, findsOneWidget);
      expect(find.text('£8.49'), findsOneWidget);
      expect(order1001Finder, findsOneWidget);

      final Offset order1002Position = tester.getTopLeft(order1002Finder);
      final Offset order1001Position = tester.getTopLeft(order1001Finder);
      expect(order1002Position.dy, lessThan(order1001Position.dy));
```

Run the test on your Android emulator to observe the multi-order checkout journey, as shown below:

![Animated recording of the Android emulator running the multi-order checkout and order history integration test](images/10/integration_test_checkout.gif)

### Test cloud settings and bigger text sync

Next, add a test inside `group(...)` to verify cloud profile settings and **Bigger text** across screens and auth sessions. Calling `tester.element(menuItemText)` returns the `Element` rendering `'Footlong Sub'`, letting `MediaQuery.textScalerOf(...)` return a `TextScaler` so we can record `baselineSize` before signing in as `sam@example.com`:

```dart
    testWidgets(
      'cloud settings and bigger text sync across sign-out and sign-in',
      (WidgetTester tester) async {
        final MockUser existingUser = MockUser(
          uid: 'settings-user-1',
          email: 'sam@example.com',
        );
        final MockFirebaseAuth signedOutAuth = MockFirebaseAuth(
          mockUser: existingUser,
          signedIn: false,
        );
        AuthRepository.instance.setAuth(signedOutAuth);

        await tester.pumpWidget(App(key: UniqueKey()));
        await tester.pumpAndSettle();

        final Finder menuItemText = find.text('Footlong Sub');
        final Element baselineElement = tester.element(menuItemText);
        final TextScaler baselineScaler = MediaQuery.textScalerOf(
          baselineElement,
        );
        final double baselineSize = baselineScaler.scale(18);

        await tester.tap(find.text('Log In'));
        await tester.pumpAndSettle();
        final Finder authFields = find.byType(TextField);
        final Finder authEmailField = authFields.at(0);
        final Finder authPasswordField = authFields.at(1);
        await tester.enterText(authEmailField, 'sam@example.com');
        await tester.enterText(authPasswordField, 'secret123');
        final Finder signInButton = find.text('Sign In');
        await tester.ensureVisible(signInButton);
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
      },
    );
```

Inside that same test, right before the closing `},`, open `SettingsScreen`, fill in the three profile fields, toggle the `largeTextSwitch` and `newsletterSwitch` keys, save settings and return to `MenuScreen`. Using `closeTo(baselineSize * 1.2, 0.05)` accounts for floating-point rounding when checking that text now scales to `1.2x`:

```dart
        final Finder settingsIcon = find.byIcon(Icons.person_outline);
        await tester.tap(settingsIcon);
        await tester.pumpAndSettle();
        expect(find.byType(SettingsScreen), findsOneWidget);

        final Finder settingsFields = find.byType(TextField);
        final Finder nameField = settingsFields.at(0);
        final Finder addressField = settingsFields.at(1);
        final Finder emailField = settingsFields.at(2);
        await tester.enterText(nameField, 'Sam Taylor');
        await tester.enterText(addressField, '14 Lion Terrace, Portsmouth');
        await tester.enterText(emailField, 'sam@example.com');

        final Finder largeTextSwitchFinder = find.byKey(
          const Key('largeTextSwitch'),
        );
        await tester.tap(largeTextSwitchFinder);
        await tester.pumpAndSettle();

        final Finder newsletterSwitchFinder = find.byKey(
          const Key('newsletterSwitch'),
        );
        await tester.ensureVisible(newsletterSwitchFinder);
        await tester.tap(newsletterSwitchFinder);
        await tester.pumpAndSettle();

        final Finder saveSettingsButton = find.text('Save Settings');
        await tester.ensureVisible(saveSettingsButton);
        await tester.tap(saveSettingsButton);
        await tester.pumpAndSettle();
        expect(find.text('Settings saved for Sam Taylor'), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();

        final Element enlargedElement = tester.element(menuItemText);
        final TextScaler enlargedScaler = MediaQuery.textScalerOf(
          enlargedElement,
        );
        final double enlargedSize = enlargedScaler.scale(18);
        expect(enlargedSize, closeTo(baselineSize * 1.2, 0.05));
```

Finally, still before the closing `},`, tap **Sign Out** to confirm the scale resets to `baselineSize`, inspect the live `SwitchListTile` widget via `tester.widget<SwitchListTile>(...)` to check its `value` is `false`, and then sign back in to confirm both the `1.2x` scale and saved fields reload from Cloud Firestore:

```dart
        await tester.tap(find.text('Sign Out'));
        await tester.pumpAndSettle();

        final Element signedOutElement = tester.element(menuItemText);
        final TextScaler signedOutScaler = MediaQuery.textScalerOf(
          signedOutElement,
        );
        final double signedOutSize = signedOutScaler.scale(18);
        expect(signedOutSize, closeTo(baselineSize, 0.05));

        await tester.tap(settingsIcon);
        await tester.pumpAndSettle();
        expect(find.text('Sam Taylor'), findsNothing);
        final SwitchListTile resetSwitch = tester.widget<SwitchListTile>(
          largeTextSwitchFinder,
        );
        final bool resetValue = resetSwitch.value;
        expect(resetValue, isFalse);

        await tester.pageBack();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Log In'));
        await tester.pumpAndSettle();
        final Finder secondAuthFields = find.byType(TextField);
        final Finder secondAuthEmailField = secondAuthFields.at(0);
        final Finder secondAuthPasswordField = secondAuthFields.at(1);
        await tester.enterText(secondAuthEmailField, 'sam@example.com');
        await tester.enterText(secondAuthPasswordField, 'secret123');
        await tester.ensureVisible(signInButton);
        await tester.tap(signInButton);
        await tester.pumpAndSettle();

        final Element restoredElement = tester.element(menuItemText);
        final TextScaler restoredScaler = MediaQuery.textScalerOf(
          restoredElement,
        );
        final double restoredSize = restoredScaler.scale(18);
        expect(restoredSize, closeTo(baselineSize * 1.2, 0.05));

        await tester.tap(settingsIcon);
        await tester.pumpAndSettle();
        expect(find.text('Sam Taylor'), findsOneWidget);
        expect(find.text('14 Lion Terrace, Portsmouth'), findsOneWidget);
        final SwitchListTile restoredSwitch = tester.widget<SwitchListTile>(
          largeTextSwitchFinder,
        );
        final bool restoredValue = restoredSwitch.value;
        expect(restoredValue, isTrue);
```

This cloud settings and text-scaling sync test runs on the emulator as shown below:

![Animated recording of the Android emulator running the cloud settings and bigger text sync integration test](images/10/integration_test_settings_sync.gif)

### Test email link and Google sign-in

Finally, add a test covering the two remaining authentication options on `AuthScreen`: requesting a passwordless sign-in link via **Email me a sign-in link** and signing in via **Sign in with Google**:

```dart
    testWidgets('email link request and Google sign-in complete cleanly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(App(key: UniqueKey()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      final Finder textFields = find.byType(TextField);
      final Finder emailField = textFields.at(0);
      await tester.enterText(emailField, 'lee@example.com');

      final Finder emailLinkButton = find.text('Email me a sign-in link');
      await tester.ensureVisible(emailLinkButton);
      await tester.tap(emailLinkButton);
      await tester.pumpAndSettle();
      expect(
        find.text('Sign-in link sent to lee@example.com. Check your inbox.'),
        findsOneWidget,
      );

      final Finder googleButton = find.text('Sign in with Google');
      await tester.ensureVisible(googleButton);
      await tester.tap(googleButton);
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });
```

Run the complete test suite on your Android emulator once more and confirm all seven end-to-end tests pass:

```bash
flutter test integration_test/app_test.dart -d emulator-5554
```

You can also ask GitHub Copilot in **Plan** mode (as in [Plan first](worksheet-8.md#plan-first)) to suggest additional edge-case journeys, and compare your completed file with `integration_test/app_test.dart` on branch `10`.

### Run integration tests in Chrome

As noted in Flutter's [Check app functionality with an integration test](https://docs.flutter.dev/testing/integration-tests) guide and [Running Flutter Driver tests with Web](https://github.com/flutter/flutter/blob/main/docs/contributing/testing/Running-Flutter-Driver-tests-with-Web.md), `flutter test integration_test/app_test.dart` does not currently run directly on web targets. To run the same `integration_test/app_test.dart` file in Chrome, Flutter uses `flutter drive` alongside a short driver file and ChromeDriver.

Create `test_driver/integration_test.dart` with the content below:

```dart
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  await integrationDriver();
}
```

Install a `chromedriver` binary matching your installed Chrome version from [Chrome for Testing](https://googlechromelabs.github.io/chrome-for-testing/) (or install one with `npx @puppeteer/browsers install chromedriver@stable` using Node.js from [Worksheet 9](worksheet-9.md#install-the-firebase-and-flutterfire-tools)), start it on port `4444` in one terminal, and run `flutter drive` in a second terminal:

```bash
chromedriver --port=4444
```

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome
```

## Continuous integration

<!-- TODO (come back to CI/CD later):
Continuous integration: Define CI vs CD, add .github/workflows/tests.yml (checkout, Flutter setup with caching, flutter pub get, dart format --output=none --set-exit-if-changed lib test, dart analyze, flutter test --coverage, coverage summary, and lcov.info artifact upload), walk through reading passing/failing Actions logs, and explain why slow emulator tests run locally or on a schedule.
-->

### What CI and CD mean

<!-- TODO: see CI/CD notes above. -->

### Create a workflow

<!-- TODO: add .github/workflows/tests.yml (pin action versions, explain every line). -->

### Read the results

<!-- TODO: show the Actions tab, a passing run, a failing run, coverage summary and lcov.info artifact. -->

### Add integration tests

<!-- TODO: explain running fast unit/widget tests on every push vs running slow emulator/driver integration tests locally or on a schedule. -->

## Deployment

<!-- TODO (come back to CI/CD later):
Deployment: Automate Firebase Hosting deployment on green main builds (or PR preview channels) via GitHub Actions and a repository secret, plus building a release Android APK (flutter build apk --release) with a high-level overview of signing and Play Store ($25 one-off) / App Store ($99/year).
-->

## Exercises

The exercises below are optional extension tasks and are not assessed in Demo 5. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw).

1. (Advanced) Add the `integration_test` package to your Southsea Cinema project following [Install the integration test package](#install-the-integration-test-package) and add stable keys where lists of cards share button labels. Write end-to-end integration tests in `integration_test/app_test.dart` covering browsing films, ticket quantity validation, signed-out guards, sign-in/sign-out state clearing, multi-ticket booking checkout and cloud theme/profile settings sync, then run them on your Android emulator (and optionally Chrome).

<!-- TODO (exercises to add once CI/CD & Deployment sections are written):
2. Add a GitHub Actions workflow to the cinema repository that formats, analyses and tests the app with coverage.
3. Build a release APK / automate Firebase Hosting deploy.
-->

<!-- OFFICIAL INTEGRATION TESTING SOURCES & NOTES (verified in Chrome 2026-11-23, ready to cite in Worksheet 10 & Lecture 10)

1. Verified Official URLs:
- Testing Flutter apps (Unit vs Widget vs Integration definitions & trade-offs table): https://docs.flutter.dev/testing/overview
- Check app functionality with an integration test: https://docs.flutter.dev/testing/integration-tests
- Integration testing concepts (host machine vs target device): https://docs.flutter.dev/cookbook/testing/integration/introduction
- Measure performance with an integration test: https://docs.flutter.dev/cookbook/testing/integration/profiling
- Find widgets: https://docs.flutter.dev/cookbook/testing/widget/finders
- Mock dependencies using Mockito: https://docs.flutter.dev/cookbook/testing/unit/mocking
- Plugins in Flutter tests: https://docs.flutter.dev/testing/plugins-in-tests
- Testing each layer (Flutter Architecture Case Study / Compass App): https://docs.flutter.dev/app-architecture/case-study/testing
- IntegrationTestWidgetsFlutterBinding API: https://api.flutter.dev/flutter/package-integration_test_integration_test/IntegrationTestWidgetsFlutterBinding-class.html
- LiveTestWidgetsFlutterBinding API: https://api.flutter.dev/flutter/flutter_test/LiveTestWidgetsFlutterBinding-class.html
- WidgetTester.pumpAndSettle API: https://api.flutter.dev/flutter/flutter_test/WidgetTester/pumpAndSettle.html
- WidgetTester.pump API: https://api.flutter.dev/flutter/flutter_test/WidgetTester/pump.html
- package:integration_test README: https://github.com/flutter/flutter/tree/master/packages/integration_test
- Running Flutter Driver tests with Web: https://github.com/flutter/flutter/blob/main/docs/contributing/testing/Running-Flutter-Driver-tests-with-Web.md
- Compass App integration test (local faked data): https://github.com/flutter/samples/blob/main/compass_app/app/integration_test/app_local_data_test.dart
- Compass App integration test (server data): https://github.com/flutter/samples/blob/main/compass_app/app/integration_test/app_server_data_test.dart
- Patrol package (native OS permission dialogues / notifications): https://pub.dev/packages/patrol
- Known Flutter issues:
  - Coverage collection with integration_test (open): https://github.com/flutter/flutter/issues/65429
  - Restart/reinstall app between tests (open): https://github.com/flutter/flutter/issues/48955
  - Multi-file desktop integration_test runner issue (open): https://github.com/flutter/flutter/issues/101031
- Introduction to Firebase Local Emulator Suite: https://firebase.google.com/docs/emulator-suite
- Install & configure Firebase Local Emulator Suite: https://firebase.google.com/docs/emulator-suite/install_and_configure
- Connect & prototype (Firestore Emulator): https://firebase.google.com/docs/emulator-suite/connect_and_prototype?database=Firestore
- Connect Authentication Emulator: https://firebase.google.com/docs/emulator-suite/connect_auth
- Connect Cloud Firestore Emulator: https://firebase.google.com/docs/emulator-suite/connect_firestore
- Firebase Auth on Flutter (persistence caveats): https://firebase.google.com/docs/auth/flutter/start
- Auth Emulator REST clear-accounts reference: https://firebase.google.com/docs/reference/rest/auth#section-auth-emulator-clearaccounts
- FirebaseAuth.useAuthEmulator API: https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/useAuthEmulator.html
- FirebaseFirestore.useFirestoreEmulator API: https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/FirebaseFirestore/useFirestoreEmulator.html

2. Formal Definitions (from https://docs.flutter.dev/testing/overview & https://docs.flutter.dev/cookbook/testing/integration/introduction):
- Unit test: Tests a single function, method or class to verify logic under varied conditions. External dependencies are mocked; usually no disk I/O, rendering or external user input. (Speed: Quick; Dependencies: Few; Maintenance: Low; Confidence: Low.)
- Widget test (component test): Verifies that a single widget looks and interacts as expected using a lightweight test UI environment rather than a full device. (Speed: Quick; Dependencies: More; Maintenance: Higher; Confidence: Higher.)
- Integration test (end-to-end / GUI test): Tests a complete app or a large journey on a real device, emulator or web browser to verify that all widgets and services work together as expected (and optionally profiles performance). (Speed: Slow; Dependencies: Most; Maintenance: Highest; Confidence: Highest.)
- Official balance rule: "Generally speaking, a well-tested app has many unit and widget tests, tracked by code coverage, plus enough integration tests to cover all the important use cases."
- Host machine: Development computer executing the test command. Target device: Emulator, physical device or browser running the Flutter app.

3. Official Commands & Setup:
- Add dependency: flutter pub add "dev:integration_test:{sdk: flutter}"
- Android emulator / mobile device:
  flutter test integration_test/app_test.dart -d <device_id>
  (Caveat: confirm the test runner removes the app afterwards if testing native installs manually; --release builds omit package:integration_test.)
- Web (Chrome / headless): flutter test integration_test/... does NOT support Web. Must create test_driver/integration_test.dart calling integrationDriver(), run matching chromedriver on port 4444 (e.g. npx @puppeteer/browsers install chromedriver@stable && chromedriver --port=4444), then run:
  flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d chrome
  (or -d web-server for headless runs).

4. Firebase Strategy & Best Practices / Pitfalls:
- Strategy A (used in Sandwich Shop branch 10): Repository dependency injection with MockFirebaseAuth + FakeFirebaseFirestore (same pattern as Compass App's app_local_data_test.dart). Deterministic, zero external setup for students, isolated per test, exercises real MaterialApp routing, forms, Theme/MediaQuery scaling and full multi-screen UI flows on Android emulator or ChromeDriver.
- Strategy B (full-stack Firebase Local Emulator Suite): Use firebase emulators:exec --only auth,firestore (with demo project ID such as demo-sandwich-shop), calling FirebaseAuth.instance.useAuthEmulator('localhost', 9099) and FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080) with Settings(persistenceEnabled: false) right after Firebase.initializeApp(). Note: Auth Emulator port 9099 (flush via DELETE localhost:9099/emulator/v1/projects/{id}/accounts) and Firestore Emulator port 8080 (flush via DELETE localhost:8080/emulator/v1/projects/{id}/databases/(default)/documents); automaticHostMapping maps localhost to 10.0.2.2 on Android; Cloud Firestore emulator does NOT enforce composite indexes (verify indexes on a live project).
- Pitfall 1 — Repeated app.main() calls: All testWidgets blocks run inside one Dart VM/JS runtime. Re-calling app.main() re-triggers Firebase.initializeApp() and retains singleton state. Instead, initialise one-time services once, reset repositories/fakes in setUp/tearDown, and mount tester.pumpWidget(App(key: UniqueKey())).
- Pitfall 2 — pumpAndSettle vs infinite animations & async latency: LiveTestWidgetsFlutterBinding uses real wall-clock time. pumpAndSettle times out after 10 minutes on continuous spinners (e.g. CircularProgressIndicator) and does not wait for unscheduled backend callbacks; poll with bounded pump(Duration) loops where network latency exists.
- Pitfall 3 — Unambiguous finders: Prefer stable Key / ValueKey identifiers (such as Key('sandwichCard_footlong') and Key('largeTextSwitch')) for interactive controls and scroll off-screen items into view with scrollUntilVisible / ensureVisible before tapping.
- Pitfall 4 — Known limits: Code coverage is not collected by integration_test (flutter/flutter#65429); traceAction performance profiling is unsupported on Web; integration_test cannot tap native OS dialogues (Android/iOS permission sheets), where Flutter docs point to Patrol.
-->

<!-- CI/CD, RELEASE & DEPLOYMENT RESEARCH NOTES (verified 2026-11-23, ready for authoring the rest of Worksheet 10)

1. Verified Official URLs:
- GitHub Actions billing & runner quotas: https://docs.github.com/en/billing/managing-billing-for-your-products/about-billing-for-github-actions
- Android emulator runner (ReactiveCircus): https://github.com/ReactiveCircus/android-emulator-runner
- Firebase Hosting + GitHub Actions guide: https://firebase.google.com/docs/hosting/github-integration
- Firebase Hosting action (FirebaseExtended): https://github.com/FirebaseExtended/action-hosting-deploy
- Google GitHub Actions Auth (Workload Identity Federation): https://github.com/google-github-actions/auth
- Flutter build modes (Debug, Profile, Release): https://docs.flutter.dev/testing/build-modes
- Flutter Android build and release (signing, keytool, key.properties, Kotlin DSL, AAB vs APK): https://docs.flutter.dev/deployment/android
- Flutter iOS build and release: https://docs.flutter.dev/deployment/ios
- Google Play closed testing requirement (12 testers / 14 continuous days): https://support.google.com/googleplay/android-developer/answer/14151465
- Apple Developer Program enrolment & fee ($99/year): https://developer.apple.com/programs/how-it-works/
- Firebase App Distribution: https://firebase.google.com/docs/app-distribution

2. Verified GitHub Actions Releases (checked via GitHub API 2026-11-23):
- actions/checkout: v7.0.1 (@v7; SHA pins in repo ci.yml)
- subosito/flutter-action: v2.23.0 (@v2, channel: stable, cache: true)
- actions/upload-artifact: v7.0.2 (@v7; v3 is deprecated)
- actions/setup-java: v6.3.0 (@v6, distribution: temurin)
- ReactiveCircus/android-emulator-runner: v2.38.0 (@v2)
- FirebaseExtended/action-hosting-deploy: v0.11.0 (@v0, Node 24)
- google-github-actions/auth: v3 (@v3)
- softprops/action-gh-release: v3.0.4 (@v3)

3. Continuous Integration Facts & Workflow Pattern:
- Quotas: Public repositories get free unlimited minutes on standard GitHub-hosted runners; free personal private repositories get 2,000 minutes/month (ubuntu-latest costs 1x; macos costs 10x).
- Standard Flutter CI job (.github/workflows/tests.yml on push & pull_request):
  1. actions/checkout
  2. subosito/flutter-action with channel: stable, cache: true
  3. flutter pub get
  4. dart format --output=none --set-exit-if-changed lib test integration_test test_driver
  5. dart analyze
  6. flutter test --coverage
  7. Append Markdown coverage summary to $GITHUB_STEP_SUMMARY (awk over coverage/lcov.info)
  8. Upload coverage/lcov.info via actions/upload-artifact
- Emulator integration tests in CI: Linux ubuntu-latest runners support KVM hardware acceleration with ReactiveCircus/android-emulator-runner@v2 (with KVM group/device rule). Still run on schedule/manual dispatch or locally rather than every push because AVD boot + Gradle build takes several minutes.

4. Firebase Hosting Continuous Deployment:
- Recommended setup: firebase init hosting:github generates live deploy on push to main (channelId: live) and automatic temporary preview channels on pull requests (expires: 7d) using FirebaseExtended/action-hosting-deploy@v0 and repository secret FIREBASE_SERVICE_ACCOUNT_<PROJECT>.
- Legacy firebase login:ci token is deprecated — do not teach it.
- Note Workload Identity Federation (google-github-actions/auth@v3) as the keyless enterprise alternative to exported JSON service account keys.

5. Android Release Build, Signing & Distribution Gaps on Branch 10:
- Branch 10 (android/app/build.gradle.kts, Kotlin DSL) currently has:
  - applicationId = "com.example.sandwich_shop" (Google Play rejects com.example.*; must change to a unique reverse-domain ID before Play publishing).
  - buildTypes.release using signingConfig = signingConfigs.getByName("debug") (suitable only for local testing; Play Store and release APK distribution require a dedicated upload keystore).
- Branch 10 .gitignore does not yet ignore android/key.properties, *.jks or *.keystore — add those patterns BEFORE generating an upload keystore with keytool.
- Flutter commands:
  - flutter build apk --release produces build/app/outputs/flutter-apk/app-release.apk (direct install, sideloading, GitHub Releases, Firebase App Distribution).
  - flutter build appbundle --release produces build/app/outputs/bundle/release/app-release.aab (required format for Google Play).
- Store & distribution costs (2026):
  - Google Play Console: $25 USD one-off registration fee; personal accounts created after Nov 2023 must run a closed test with at least 12 testers opted in continuously for 14 days before applying for production.
  - Apple Developer Program: $99 USD/year; requires macOS and Xcode for iOS builds and submission.
  - Firebase App Distribution: free on Spark plan (up to 500 testers per project) for distributing test APK/AAB/IPA builds.
-->
