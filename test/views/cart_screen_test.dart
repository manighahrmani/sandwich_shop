import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CartScreen', () {
    testWidgets('shows empty cart message and hides total when empty',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      final MaterialApp app = MaterialApp(home: CartScreen(cart: emptyCart));

      await tester.pumpWidget(app);

      expect(find.text('Cart View'), findsOneWidget);
      expect(
        find.text('Your cart is empty. Go back and add some sandwiches!'),
        findsOneWidget,
      );
      expect(find.textContaining('Total:'), findsNothing);
    });

    testWidgets('renders single cart item with quantity and price',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('£22.00'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });

    testWidgets('renders multiple items with correct totals',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 3);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Six-inch on wheat bread'), findsOneWidget);
      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Qty: 3'), findsOneWidget);
      expect(find.text('£11.00'), findsOneWidget);
      expect(find.text('£21.00'), findsOneWidget);
      expect(find.text('Total: £32.00'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      final Cart cart = Cart();
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
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
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final appBarImagesFinder = find.descendant(
        of: appBarFinder,
        matching: find.byType(Image),
      );
      expect(appBarImagesFinder, findsOneWidget);

      final Image logoImage = tester.widget(appBarImagesFinder);
      expect(
          (logoImage.image as AssetImage).assetName, 'assets/images/logo.png');
    });

    testWidgets('increments quantity and updates total',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();

      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });

    testWidgets('decrements quantity until removal and shows empty state',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));
      expect(find.text('Qty: 2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text('Your cart is empty. Go back and add some sandwiches!'),
        findsOneWidget,
      );
      expect(find.textContaining('Total:'), findsNothing);
    });

    testWidgets('remove button deletes item and offers undo',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      await tester.tap(find.widgetWithIcon(TextButton, Icons.delete_outline));
      await tester.pump();

      expect(
        find.text('Removed 1 x Veggie Delight from your cart'),
        findsOneWidget,
      );
      expect(
        find.text('Your cart is empty. Go back and add some sandwiches!'),
        findsOneWidget,
      );

      await tester.tap(find.text('Undo'));
      await tester.pump();
      expect(find.text('Qty: 1'), findsOneWidget);
    });

    testWidgets('edit item updates size and price',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      await tester.tap(find.widgetWithIcon(TextButton, Icons.edit_outlined));
      await tester.pumpAndSettle();

      // Toggle footlong off to make it six-inch.
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();

      expect(find.text('Six-inch on white bread'), findsOneWidget);
      expect(find.text('£7.00'), findsOneWidget);
      expect(find.text('Total: £7.00'), findsOneWidget);
    });
  });
}
