import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/order_screen_view.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as the home screen',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      expect(find.byType(OrderScreen), findsOneWidget);
    });

    testWidgets('provides Cart through ChangeNotifierProvider',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);

      // Verify ChangeNotifierProvider exists
      expect(find.byType(ChangeNotifierProvider<Cart>), findsOneWidget);

      // Verify MaterialApp exists
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('displays logo in app bar', (WidgetTester tester) async {
      const App app = App();
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

    testWidgets('displays app bar title', (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);

      // Find the app bar title
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('displays cart indicator with initial values',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);

      // Find the cart indicator text showing initial cart state
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('has proper app structure with Provider and MaterialApp',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);

      // Verify the widget tree structure
      expect(find.byType(ChangeNotifierProvider<Cart>), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);

      // Verify OrderScreen is the home screen with correct maxQuantity
      final OrderScreen orderScreen = tester.widget(find.byType(OrderScreen));
      expect(orderScreen.maxQuantity, equals(5));

      // Verify MaterialApp properties
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.title, equals('Sandwich Shop App'));
      expect(materialApp.debugShowCheckedModeBanner, equals(false));
    });
  });
}
