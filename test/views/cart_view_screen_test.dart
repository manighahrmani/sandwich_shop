import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/cart_view_screen.dart';
import 'package:sandwich_shop/views/order_screen_view.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CartViewScreen', () {
    testWidgets('displays empty cart message when cart is empty',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: emptyCart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
    });

    testWidgets('displays cart items when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('£22.00'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });

    testWidgets('displays multiple cart items correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 3);

      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Six-inch on wheat bread'), findsOneWidget);
      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Qty: 3'), findsOneWidget);
      expect(find.text('Total: £32.00'), findsOneWidget);
    });

    testWidgets('shows checkout button when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      expect(find.widgetWithText(StyledButton, 'Checkout'), findsOneWidget);
    });

    testWidgets('hides checkout button when cart is empty',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: emptyCart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      expect(find.widgetWithText(StyledButton, 'Checkout'), findsNothing);
    });

    testWidgets('increment quantity button works correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      expect(find.text('Qty: 1'), findsOneWidget);

      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('Quantity increased'), findsOneWidget);
    });

    testWidgets('decrement quantity button works correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      expect(find.text('Qty: 2'), findsOneWidget);

      final Finder removeButtonFinder = find.byIcon(Icons.remove);
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Quantity decreased'), findsOneWidget);
    });

    testWidgets('remove item button works correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      expect(find.text('Veggie Delight'), findsOneWidget);

      final Finder deleteButtonFinder = find.byIcon(Icons.delete);
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Veggie Delight'), findsNothing);
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      final Cart cart = Cart();
      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      final Finder backButtonFinder =
          find.widgetWithText(StyledButton, 'Back to Order');
      expect(backButtonFinder, findsOneWidget);

      final StyledButton backButton =
          tester.widget<StyledButton>(backButtonFinder);
      expect(backButton.onPressed, isNotNull);
    });

    testWidgets('displays logo in app bar', (WidgetTester tester) async {
      final Cart cart = Cart();
      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      // Find the app bar first
      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      // Find images within the app bar
      final appBarImagesFinder = find.descendant(
        of: appBarFinder,
        matching: find.byType(Image),
      );
      expect(appBarImagesFinder, findsOneWidget);

      // Verify the logo image asset path
      final Image logoImage = tester.widget(appBarImagesFinder);
      expect(
          (logoImage.image as AssetImage).assetName, 'assets/images/logo.png');
    });

    testWidgets('displays cart indicator in app bar',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 3);

      const CartViewScreen cartViewScreen = CartViewScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: cartViewScreen,
        ),
      );

      await tester.pumpWidget(app);

      // Find the cart indicator in the app bar
      final appBarFinder = find.byType(AppBar);
      final cartIconFinder = find.descendant(
        of: appBarFinder,
        matching: find.byIcon(Icons.shopping_cart),
      );
      expect(cartIconFinder, findsOneWidget);

      // Verify cart count is displayed
      expect(find.text('3'), findsOneWidget);
    });
  });
}
