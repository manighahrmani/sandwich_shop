import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen toggles between display and edit modes',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );

    expect(find.text('My Settings'), findsWidgets);
    expect(find.text('Delivery Address'), findsOneWidget);
    expect(find.text('Edit Settings'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.text('Edit Settings'));
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(find.text('Edit Settings'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });
}
