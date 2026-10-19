import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  bool darkMode = false;

  Widget buildSettingsApp() {
    return MaterialApp(
      home: SettingsScreen(
        darkMode: darkMode,
        onDarkModeChanged: (bool value) {
          darkMode = value;
        },
      ),
    );
  }

  setUp(() {
    darkMode = false;
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('SettingsScreen displays form fields and switches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSettingsApp());
    await tester.pumpAndSettle();

    expect(find.text('Customer Profile'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsNWidgets(2));
    expect(find.text('Dark mode'), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
  });

  testWidgets('Toggling switch and saving settings updates state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSettingsApp());
    await tester.pumpAndSettle();

    final Finder nameField = find.widgetWithText(TextField, 'Full name');
    final Finder addressField =
        find.widgetWithText(TextField, 'Delivery address');
    final Finder emailField = find.widgetWithText(TextField, 'Email address');

    await tester.enterText(nameField, 'Alex Smith');
    await tester.enterText(addressField, '10 Elm Road, Portsmouth');
    await tester.enterText(emailField, 'alex@example.com');

    final Finder switchFinder = find.byType(Switch).first;
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.ensureVisible(find.text('Save Settings'));
    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings saved for Alex Smith'), findsOneWidget);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(prefName), 'Alex Smith');
    expect(prefs.getString(prefAddress), '10 Elm Road, Portsmouth');
    expect(prefs.getString(prefEmail), 'alex@example.com');
    expect(prefs.getBool(prefNewsletter), isTrue);
    expect(prefs.getBool(prefDarkMode), isFalse);
    expect(darkMode, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(buildSettingsApp());
    await tester.pumpAndSettle();
    expect(find.text('Alex Smith'), findsOneWidget);
    expect(find.text('10 Elm Road, Portsmouth'), findsOneWidget);
    expect(find.text('alex@example.com'), findsOneWidget);
    final Switch reopenedSwitch =
        tester.widget<Switch>(find.byType(Switch).first);
    expect(reopenedSwitch.value, isTrue);
  });

  testWidgets('SettingsScreen pre-fills saved settings on open', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      prefName: 'Jordan Lee',
      prefAddress: '15 High Street, Portsmouth',
      prefEmail: 'jordan@example.com',
      prefNewsletter: true,
    });

    await tester.pumpWidget(buildSettingsApp());
    await tester.pumpAndSettle();

    expect(find.text('Jordan Lee'), findsOneWidget);
    expect(find.text('15 High Street, Portsmouth'), findsOneWidget);
    expect(find.text('jordan@example.com'), findsOneWidget);
    final Switch switchWidget =
        tester.widget<Switch>(find.byType(Switch).first);
    expect(switchWidget.value, isTrue);
  });

  testWidgets('Saving dark mode writes the preference and notifies the app', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSettingsApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Dark mode'));
    await tester.tap(find.text('Dark mode'));
    await tester.pumpAndSettle();
    expect(darkMode, isFalse);

    await tester.ensureVisible(find.text('Save Settings'));
    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(prefDarkMode), isTrue);
    expect(darkMode, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(buildSettingsApp());
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(find.byType(Switch).last).value, isTrue);
  });
}
