import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/sandwich_card.dart';

void main() {
  const Sandwich sandwich = Sandwich(
    id: 'test',
    name: 'Test Sub',
    description: 'A sandwich used in a test.',
    price: 5.00,
    imagePath: 'assets/images/missing.png',
  );

  testWidgets('SandwichCard shows the name, description and price', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SandwichCard(sandwich: sandwich))),
    );
    await tester.pump();
    expect(find.text('Test Sub'), findsOneWidget);
    expect(find.text('A sandwich used in a test.'), findsOneWidget);
    expect(find.text('£5.00'), findsOneWidget);
  });

  testWidgets('SandwichCard shows a message when the image is missing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SandwichCard(sandwich: sandwich))),
    );
    await tester.pumpAndSettle();
    expect(find.text('Image unavailable'), findsOneWidget);
  });
}
