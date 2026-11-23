import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    AuthRepository.instance.setAuth(MockFirebaseAuth());
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

  Future<void> launchApp(WidgetTester tester) async {
    await tester.pumpWidget(App(key: UniqueKey()));
    await tester.pumpAndSettle();
  }

  Future<void> returnToMenu(WidgetTester tester) async {
    while (find.byType(MenuScreen).evaluate().isEmpty) {
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  }

  Future<void> openSandwichOrderScreen(
    WidgetTester tester,
    String sandwichId,
    String sandwichName,
  ) async {
    final Finder cardFinder = find.byKey(Key('sandwichCard_$sandwichId'));
    await tester.scrollUntilVisible(cardFinder, 200);
    await tester.ensureVisible(cardFinder);
    final Finder orderButton = find.descendant(
      of: cardFinder,
      matching: find.text('Order'),
    );
    await tester.ensureVisible(orderButton);
    await tester.tap(orderButton);
    await tester.pumpAndSettle();
    expect(find.byType(OrderScreen), findsOneWidget);
    expect(find.text('Order $sandwichName'), findsOneWidget);
  }

  Future<void> addQuantityToBasket(
    WidgetTester tester,
    String sandwichId,
    String sandwichName,
    int quantity,
  ) async {
    await openSandwichOrderScreen(tester, sandwichId, sandwichName);
    for (int step = 0; step < quantity; step++) {
      await tester.tap(find.text('Add'));
      await tester.pump();
    }
    await tester.ensureVisible(find.text('Add to Basket'));
    await tester.tap(find.text('Add to Basket'));
    await tester.pumpAndSettle();
    expect(
        find.text('Added $quantity $sandwichName to basket'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
  }

  group('Sandwich Shop end-to-end workflows', () {
    testWidgets('browsing menu and ordering sandwiches validates quantity', (
      WidgetTester tester,
    ) async {
      await launchApp(tester);

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Footlong Sub'), findsOneWidget);
      expect(find.text('Six-Inch Sub'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Loaded Nachos'), 200);
      expect(find.text('Loaded Nachos'), findsOneWidget);

      await openSandwichOrderScreen(tester, 'footlong', 'Footlong Sub');
      expect(find.text('0 Footlong Sub sandwich(es): '), findsOneWidget);
      expect(find.text('£0.00'), findsOneWidget);

      await tester.ensureVisible(find.text('Add to Basket'));
      await tester.tap(find.text('Add to Basket'));
      await tester.pump();
      expect(find.text('Please select at least 1 sandwich'), findsOneWidget);

      await tester.ensureVisible(find.text('Add'));
      await tester.tap(find.text('Add'));
      await tester.pump();
      await tester.tap(find.text('Add'));
      await tester.pump();
      await tester.tap(find.text('Add'));
      await tester.pump();
      await tester.tap(find.text('Remove'));
      await tester.pump();

      expect(find.text('2 Footlong Sub sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);

      await tester.ensureVisible(find.text('Add to Basket'));
      await tester.tap(find.text('Add to Basket'));
      await tester.pumpAndSettle();
      expect(find.text('Added 2 Footlong Sub to basket'), findsOneWidget);
    });

    testWidgets('basket management and signed-out guards protect actions', (
      WidgetTester tester,
    ) async {
      await launchApp(tester);

      await addQuantityToBasket(tester, 'footlong', 'Footlong Sub', 1);
      await addQuantityToBasket(tester, 'six-inch', 'Six-Inch Sub', 2);

      await tester.tap(find.byIcon(Icons.shopping_basket));
      await tester.pumpAndSettle();
      expect(find.byType(BasketScreen), findsOneWidget);
      expect(find.text('1 x Footlong Sub'), findsOneWidget);
      expect(find.text('2 x Six-Inch Sub'), findsOneWidget);
      expect(find.text('£16.50'), findsOneWidget);
      expect(find.text('£1.50'), findsOneWidget);
      expect(find.text('£18.00'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline).last);
      await tester.pumpAndSettle();
      expect(find.text('2 x Six-Inch Sub'), findsNothing);
      expect(find.text('£7.50'), findsNWidgets(2));
      expect(find.text('£9.00'), findsOneWidget);

      await tester.ensureVisible(find.text('Checkout'));
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
      expect(find.text('Please log in to place an order.'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.receipt_long));
      await tester.pumpAndSettle();
      expect(find.byType(OrdersScreen), findsOneWidget);
      expect(find.text('Please log in to view your orders.'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      await tester.ensureVisible(find.text('Save Settings'));
      await tester.tap(find.text('Save Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Please log in to save your settings.'), findsOneWidget);
    });

    testWidgets('registration, sign-out clearing basket and sign-in work', (
      WidgetTester tester,
    ) async {
      final MockUser existingUser = MockUser(
        uid: 'customer-1',
        email: 'alice@example.com',
      );
      AuthRepository.instance.setAuth(
        MockFirebaseAuth(mockUser: existingUser, signedIn: false),
      );

      await launchApp(tester);

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      expect(find.byType(AuthScreen), findsOneWidget);

      await tester.tap(find.text('Sign In'));
      await tester.pump();
      expect(
        find.text('Please enter both an email and a password.'),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('Need an account? Register'));
      await tester.tap(find.text('Need an account? Register'));
      await tester.pumpAndSettle();
      expect(find.text('Create Account'), findsOneWidget);

      await tester.enterText(
        find.byType(TextField).at(0),
        'alice@example.com',
      );
      await tester.enterText(find.byType(TextField).at(1), 'secret123');
      await tester.ensureVisible(find.text('Register'));
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);

      await addQuantityToBasket(tester, 'six-inch', 'Six-Inch Sub', 1);
      expect(CartRepository.instance.getItems(), hasLength(1));

      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();
      expect(find.text('Log In'), findsOneWidget);
      expect(CartRepository.instance.getItems(), isEmpty);

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).at(0),
        'alice@example.com',
      );
      await tester.enterText(find.byType(TextField).at(1), 'secret123');
      await tester.ensureVisible(find.text('Sign In'));
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('checkout saves multiple orders and clears the basket', (
      WidgetTester tester,
    ) async {
      final MockUser signedInUser = MockUser(
        uid: 'buyer-1',
        email: 'buyer@example.com',
      );
      AuthRepository.instance.setAuth(
        MockFirebaseAuth(mockUser: signedInUser, signedIn: true),
      );

      await launchApp(tester);
      expect(find.text('Sign Out'), findsOneWidget);

      await addQuantityToBasket(tester, 'footlong', 'Footlong Sub', 2);
      await addQuantityToBasket(tester, 'six-inch', 'Six-Inch Sub', 1);

      await tester.tap(find.byIcon(Icons.shopping_basket));
      await tester.pumpAndSettle();
      expect(find.text('£19.50'), findsOneWidget);
      expect(find.text('£1.50'), findsOneWidget);
      expect(find.text('£21.00'), findsOneWidget);

      await tester.ensureVisible(find.text('Checkout'));
      await tester.tap(find.text('Checkout'));
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

      await tester.tap(find.byIcon(Icons.shopping_basket));
      await tester.pumpAndSettle();
      expect(find.text('Your basket is empty'), findsOneWidget);

      await returnToMenu(tester);

      await addQuantityToBasket(tester, 'nachos', 'Loaded Nachos', 1);
      await tester.tap(find.byIcon(Icons.shopping_basket));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Checkout'));
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Order #1002'), findsOneWidget);
      expect(find.text('£8.49'), findsOneWidget);
      expect(find.text('Order #1001'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Order #1002')).dy,
        lessThan(tester.getTopLeft(find.text('Order #1001')).dy),
      );
    });

    testWidgets(
        'cloud settings sync across sign-out and sign-in with bigger text', (
      WidgetTester tester,
    ) async {
      final MockUser existingUser = MockUser(
        uid: 'settings-user-1',
        email: 'sam@example.com',
      );
      AuthRepository.instance.setAuth(
        MockFirebaseAuth(mockUser: existingUser, signedIn: false),
      );

      double scaledFontSize(String text, double baseSize) {
        final RenderParagraph paragraph =
            tester.renderObject<RenderParagraph>(find.text(text));
        return paragraph.textScaler.scale(baseSize);
      }

      await launchApp(tester);
      final double baselineScale = scaledFontSize('Footlong Sub', 18);

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'sam@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'secret123');
      await tester.ensureVisible(find.text('Sign In'));
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'Sam Taylor');
      await tester.enterText(
        find.byType(TextField).at(1),
        '14 Lion Terrace, Portsmouth',
      );
      await tester.enterText(find.byType(TextField).at(2), 'sam@example.com');
      await tester.tap(find.byKey(const Key('largeTextSwitch')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('newsletterSwitch')));
      await tester.tap(find.byKey(const Key('newsletterSwitch')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save Settings'));
      await tester.tap(find.text('Save Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings saved for Sam Taylor'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        scaledFontSize('Footlong Sub', 18),
        closeTo(baselineScale * 1.2, 0.05),
      );

      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();
      expect(scaledFontSize('Footlong Sub', 18), closeTo(baselineScale, 0.05));

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.text('Sam Taylor'), findsNothing);
      final SwitchListTile resetSwitch = tester.widget<SwitchListTile>(
        find.byKey(const Key('largeTextSwitch')),
      );
      expect(resetSwitch.value, isFalse);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'sam@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'secret123');
      await tester.ensureVisible(find.text('Sign In'));
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(
        scaledFontSize('Footlong Sub', 18),
        closeTo(baselineScale * 1.2, 0.05),
      );

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.text('Sam Taylor'), findsOneWidget);
      expect(find.text('14 Lion Terrace, Portsmouth'), findsOneWidget);
      final SwitchListTile restoredSwitch = tester.widget<SwitchListTile>(
        find.byKey(const Key('largeTextSwitch')),
      );
      expect(restoredSwitch.value, isTrue);
    });

    testWidgets('email link request and Google sign-in flow complete cleanly', (
      WidgetTester tester,
    ) async {
      await launchApp(tester);

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'lee@example.com');
      await tester.ensureVisible(find.text('Email me a sign-in link'));
      await tester.tap(find.text('Email me a sign-in link'));
      await tester.pumpAndSettle();
      expect(
        find.text('Sign-in link sent to lee@example.com. Check your inbox.'),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('Sign in with Google'));
      await tester.tap(find.text('Sign in with Google'));
      await tester.pumpAndSettle();

      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });
  });
}
