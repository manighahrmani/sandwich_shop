import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'support/controlled_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  tearDown(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  ControlledPreferences useControlledPreferences() {
    final ControlledPreferences preferences = ControlledPreferences();
    SharedPreferencesStorePlatform.instance = preferences;
    return preferences;
  }

  testWidgets('SettingsScreen displays form fields and switches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Customer Profile'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
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

    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Jordan Lee'), findsOneWidget);
    expect(find.text('15 High Street, Portsmouth'), findsOneWidget);
    expect(find.text('jordan@example.com'), findsOneWidget);
    final Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
    expect(switchWidget.value, isTrue);
  });

  testWidgets('Toggling switch and saving settings updates SharedPreferences', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    final Finder nameField = find.widgetWithText(TextField, 'Full name');
    final Finder addressField =
        find.widgetWithText(TextField, 'Delivery address');
    final Finder emailField = find.widgetWithText(TextField, 'Email address');

    await tester.enterText(nameField, 'Alex Smith');
    await tester.enterText(addressField, '10 Elm Road, Portsmouth');
    await tester.enterText(emailField, 'alex@example.com');

    final Finder switchFinder = find.byType(Switch);
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings saved for Alex Smith'), findsOneWidget);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(prefName), 'Alex Smith');
    expect(prefs.getString(prefAddress), '10 Elm Road, Portsmouth');
    expect(prefs.getString(prefEmail), 'alex@example.com');
    expect(prefs.getBool(prefNewsletter), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Alex Smith'), findsOneWidget);
    expect(find.text('10 Elm Road, Portsmouth'), findsOneWidget);
    expect(find.text('alex@example.com'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('Blank settings have empty fields and newsletter switched off',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    for (final TextField field
        in tester.widgetList<TextField>(find.byType(TextField))) {
      expect(field.controller!.text, isEmpty);
    }
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
  });

  testWidgets('Saving trims text and persists a false newsletter value',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Full name'), '  Sam  ');
    await tester.enterText(
        find.widgetWithText(TextField, 'Delivery address'), '  1 High Road  ');
    await tester.enterText(
        find.widgetWithText(TextField, 'Email address'), '  sam@example.com  ');
    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(prefName), 'Sam');
    expect(preferences.getString(prefAddress), '1 High Road');
    expect(preferences.getString(prefEmail), 'sam@example.com');
    expect(preferences.getBool(prefNewsletter), isFalse);
  });

  testWidgets('A load failure is visible without losing the form',
      (WidgetTester tester) async {
    final ControlledPreferences preferences = useControlledPreferences();
    preferences.failLoad = true;
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not load settings'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('A throwing save reports failure instead of success',
      (WidgetTester tester) async {
    final ControlledPreferences preferences = useControlledPreferences();
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'Sam');
    preferences.failWrite = true;
    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not save settings'), findsOneWidget);
    expect(find.textContaining('Settings saved for'), findsNothing);
    expect(find.text('Sam'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final String key in <String>[
    prefName,
    prefAddress,
    prefEmail,
    prefNewsletter,
  ]) {
    testWidgets('A false setter result for $key is reported as failure',
        (WidgetTester tester) async {
      final ControlledPreferences preferences = useControlledPreferences();
      preferences.rejectedKey = 'flutter.$key';
      await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save Settings'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Could not save settings'), findsOneWidget);
      expect(find.textContaining('Settings saved for'), findsNothing);
      preferences.rejectedKey = null;
      await tester.tap(find.text('Save Settings'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Settings saved for'), findsOneWidget);
    });
  }

  testWidgets('Late loading preserves edits but fills untouched fields',
      (WidgetTester tester) async {
    final ControlledPreferences preferences = useControlledPreferences();
    final Completer<void> gate = Completer<void>();
    preferences.loadGate = gate;
    preferences.values.addAll(<String, Object>{
      'flutter.$prefName': 'Old name',
      'flutter.$prefAddress': 'Saved address',
      'flutter.$prefEmail': 'old@example.com',
      'flutter.$prefNewsletter': false,
    });
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'New');
    await tester.enterText(
        find.widgetWithText(TextField, 'Email address'), 'new@example.com');
    await tester.tap(find.byType(Switch));
    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text('New'), findsOneWidget);
    expect(find.text('new@example.com'), findsOneWidget);
    expect(find.text('Saved address'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('A save uses one snapshot and ignores repeated presses',
      (WidgetTester tester) async {
    final ControlledPreferences preferences = useControlledPreferences();
    final Completer<void> gate = Completer<void>();
    preferences.writeGate = gate;
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'Before');
    final ElevatedButton button =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    button.onPressed!();
    button.onPressed!();
    await tester.pump();
    expect(preferences.writeCount, 1);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull);
    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'After');
    await tester.tap(find.byType(Switch));
    gate.complete();
    await tester.pumpAndSettle();
    expect(preferences.writeCount, 4);
    expect(preferences.values['flutter.$prefName'], 'Before');
    expect(preferences.values['flutter.$prefNewsletter'], isFalse);
    expect(find.text('After'), findsOneWidget);
  });

  for (final bool failLoad in <bool>[false, true]) {
    testWidgets('Disposal during loading handles failure=$failLoad safely',
        (WidgetTester tester) async {
      final ControlledPreferences preferences = useControlledPreferences();
      final Completer<void> gate = Completer<void>();
      preferences.loadGate = gate;
      preferences.failLoad = failLoad;
      await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
      await tester.pumpWidget(const SizedBox.shrink());
      gate.complete();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final bool failSave in <bool>[false, true]) {
    testWidgets('Disposal during saving handles failure=$failSave safely',
        (WidgetTester tester) async {
      final ControlledPreferences preferences = useControlledPreferences();
      final Completer<void> gate = Completer<void>();
      preferences.writeGate = gate;
      preferences.failWrite = failSave;
      await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save Settings'));
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      gate.complete();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
import 'dart:async';
