import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/widgets/sandwich_card.dart';

void main() {
  testWidgets('MenuScreen shows the sandwich list open by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MenuScreen(),
      ),
    );

    expect(find.text('Sandwich Menu'), findsOneWidget);
    expect(find.byType(SandwichCard), findsWidgets);
    expect(find.byIcon(Icons.expand_less), findsOneWidget);
  });

  testWidgets('Tapping the header hides and shows the sandwich list',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MenuScreen(),
      ),
    );

    await tester.tap(find.text('Sandwich Menu'));
    await tester.pump();

    expect(find.byType(SandwichCard), findsNothing);
    expect(find.byIcon(Icons.expand_more), findsOneWidget);

    await tester.tap(find.text('Sandwich Menu'));
    await tester.pump();

    expect(find.byType(SandwichCard), findsWidgets);
    expect(find.byIcon(Icons.expand_less), findsOneWidget);
  });
}
