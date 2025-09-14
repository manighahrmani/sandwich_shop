import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/order_history_screen.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

void main() {
  group('OrderHistoryScreen', () {
    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      const OrderHistoryScreen orderHistoryScreen = OrderHistoryScreen();
      const MaterialApp app = MaterialApp(home: orderHistoryScreen);

      await tester.pumpWidget(app);

      expect(find.text('Order History'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays logo in app bar', (WidgetTester tester) async {
      const OrderHistoryScreen orderHistoryScreen = OrderHistoryScreen();
      const MaterialApp app = MaterialApp(home: orderHistoryScreen);

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

    testWidgets('displays correct app bar title', (WidgetTester tester) async {
      const OrderHistoryScreen orderHistoryScreen = OrderHistoryScreen();
      const MaterialApp app = MaterialApp(home: orderHistoryScreen);

      await tester.pumpWidget(app);

      expect(find.text('Order History'), findsOneWidget);
    });

    testWidgets('shows loading state before data loads',
        (WidgetTester tester) async {
      const OrderHistoryScreen orderHistoryScreen = OrderHistoryScreen();
      const MaterialApp app = MaterialApp(home: orderHistoryScreen);

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('No orders yet'), findsNothing);
    });

    testWidgets('eventually shows empty state after loading',
        (WidgetTester tester) async {
      const OrderHistoryScreen orderHistoryScreen = OrderHistoryScreen();
      const MaterialApp app = MaterialApp(home: orderHistoryScreen);

      await tester.pumpWidget(app);
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No orders yet'), findsOneWidget);
      expect(
          find.widgetWithText(StyledButton, 'Back to Order'), findsOneWidget);
    });

    testWidgets('back button has correct properties',
        (WidgetTester tester) async {
      const OrderHistoryScreen orderHistoryScreen = OrderHistoryScreen();
      const MaterialApp app = MaterialApp(home: orderHistoryScreen);

      await tester.pumpWidget(app);
      await tester.pump(const Duration(seconds: 1));

      final Finder backButtonFinder =
          find.widgetWithText(StyledButton, 'Back to Order');

      if (backButtonFinder.evaluate().isNotEmpty) {
        final StyledButton backButton =
            tester.widget<StyledButton>(backButtonFinder);
        expect(backButton.onPressed, isNotNull);
        expect(backButton.icon, equals(Icons.arrow_back));
        expect(backButton.backgroundColor, equals(Colors.blue));
      }
    });
  });
}
