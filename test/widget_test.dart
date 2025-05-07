// Flutter widget tests for the Sandwich Shop application.
//
// These tests confirm that the landing page renders the
// primary buttons and that tapping a button shows the
// placeholder SnackBar.

import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/main.dart';

void main() {
  /// Groups all landing‑page smoke tests.
  group('LandingPage smoke tests', () {
    /// Verifies that the two primary action buttons appear.
    testWidgets('Primary buttons are visible', (WidgetTester tester) async {
      const SandwichShopApp application = SandwichShopApp();
      await tester.pumpWidget(application);

      final Finder selectMenuButton = find.text('Select from the menu');
      final Finder buildOwnButton = find.text('Build your own sandwich');

      expect(selectMenuButton, findsOneWidget);
      expect(buildOwnButton, findsOneWidget);
    });

    /// Confirms that tapping a primary button shows the
    /// Feature coming soon SnackBar.
    testWidgets('Tapping primary button shows SnackBar', (
      WidgetTester tester,
    ) async {
      const SandwichShopApp application = SandwichShopApp();
      await tester.pumpWidget(application);

      final Finder selectMenuButton = find.text('Select from the menu');

      await tester.tap(selectMenuButton);
      await tester.pump(); // start SnackBar animation
      await tester.pump(const Duration(seconds: 1));

      final Finder snackBar = find.text('Feature coming soon…');

      expect(snackBar, findsOneWidget);
    });
  });
}
