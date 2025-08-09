import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('App smoke tests', () {
    testWidgets('Counter text is visible', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      final Finder counterText = find.text(
        '5 Footlong sandwich(es): 🥪🥪🥪🥪🥪',
      );
      expect(counterText, findsOneWidget);
    });

    testWidgets('App bar title is visible', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      final Finder titleText = find.text('Sandwich Counter');
      expect(titleText, findsOneWidget);
    });
  });
}
