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
import 'package:sandwich_shop/screens/auth_screen.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:sandwich_shop/screens/orders_screen.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
    });

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
      },
    );

    testWidgets('registration, sign-out clearing basket and sign-in work', (
      WidgetTester tester,
    ) async {
      final MockUser existingUser = MockUser(
        uid: 'customer-1',
        email: 'name@example.com',
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
      await tester.enterText(emailField, 'name@example.com');
      await tester.enterText(passwordField, 'secret123');
      final Finder registerButton = find.text('Register');
      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);

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

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      final Finder signInFields = find.byType(TextField);
      final Finder signInEmailField = signInFields.at(0);
      final Finder signInPasswordField = signInFields.at(1);
      await tester.enterText(signInEmailField, 'name@example.com');
      await tester.enterText(signInPasswordField, 'secret123');
      final Finder signInButton = find.text('Sign In');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('checkout saves multiple itemised orders and clears basket', (
      WidgetTester tester,
    ) async {
      final MockUser signedInUser = MockUser(
        uid: 'buyer-1',
        email: 'name@example.com',
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
    });

    testWidgets(
      'user settings and bigger text sync across sign-out and sign-in',
      (WidgetTester tester) async {
        final MockUser existingUser = MockUser(
          uid: 'settings-user-1',
          email: 'name@example.com',
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
        await tester.enterText(authEmailField, 'name@example.com');
        await tester.enterText(authPasswordField, 'secret123');
        final Finder signInButton = find.text('Sign In');
        await tester.ensureVisible(signInButton);
        await tester.tap(signInButton);
        await tester.pumpAndSettle();

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
        await tester.enterText(emailField, 'name@example.com');

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
        await tester.enterText(secondAuthEmailField, 'name@example.com');
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
      },
    );

    testWidgets('email link request and Google sign-in complete cleanly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(App(key: UniqueKey()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      final Finder textFields = find.byType(TextField);
      final Finder emailField = textFields.at(0);
      await tester.enterText(emailField, 'name@example.com');

      final Finder emailLinkButton = find.text('Email me a sign-in link');
      await tester.ensureVisible(emailLinkButton);
      await tester.tap(emailLinkButton);
      await tester.pumpAndSettle();
      expect(
        find.text('Sign-in link sent to name@example.com. Check your inbox.'),
        findsOneWidget,
      );

      final Finder googleButton = find.text('Sign in with Google');
      await tester.ensureVisible(googleButton);
      await tester.tap(googleButton);
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });
  });
}
