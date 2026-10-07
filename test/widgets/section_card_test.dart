import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/widgets/section_card.dart';

void main() {
  testWidgets('SectionCard renders its title and child',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionCard(
            title: 'Allergy options',
            child: Text('inner content'),
          ),
        ),
      ),
    );

    expect(find.text('Allergy options'), findsOneWidget);
    expect(find.text('inner content'), findsOneWidget);
  });
}
