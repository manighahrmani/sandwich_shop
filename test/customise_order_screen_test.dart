import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/customise_order_screen.dart';

void main() {
  testWidgets('CustomiseOrderScreen renders note field and allergy switches',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomiseOrderScreen(),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(3));
    expect(find.text('Place order'), findsOneWidget);
  });

  testWidgets('CustomiseOrderScreen toggles an allergy switch',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomiseOrderScreen(),
      ),
    );

    final Finder nutFreeSwitch = find.byType(Switch).first;
    Switch switchWidget = tester.widget(nutFreeSwitch);
    expect(switchWidget.value, isFalse);

    await tester.tap(nutFreeSwitch);
    await tester.pump();

    switchWidget = tester.widget(nutFreeSwitch);
    expect(switchWidget.value, isTrue);
  });

  testWidgets('CustomiseOrderScreen accepts a kitchen note',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomiseOrderScreen(),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Extra toasted please');
    await tester.pump();

    expect(find.text('Extra toasted please'), findsOneWidget);
  });

  testWidgets('CustomiseOrderScreen shows inline confirmation on Place order',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomiseOrderScreen(),
      ),
    );

    await tester.ensureVisible(find.text('Place order'));
    await tester.tap(find.text('Place order'));
    await tester.pump();

    expect(find.textContaining('ready for'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });
}
