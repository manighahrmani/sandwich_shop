import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('SettingsScreen displays form fields and two switches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Customer Profile'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsNWidgets(2));
    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.text('Bigger text'), findsOneWidget);
    expect(find.text('Make text easier to read'), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
  });

  testWidgets('Bigger text switch defaults off and can be toggled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    final Finder largeTextSwitch = find.byKey(const Key('largeTextSwitch'));
    expect(tester.widget<SwitchListTile>(largeTextSwitch).value, isFalse);

    await tester.tap(find.text('Bigger text'));
    await tester.pump();

    expect(tester.widget<SwitchListTile>(largeTextSwitch).value, isTrue);

    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(tester.widget<SwitchListTile>(largeTextSwitch).value, isFalse);
  });

  testWidgets('Bigger text previews changes without saving them', (
    WidgetTester tester,
  ) async {
    final List<bool> changes = [];
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(largeText: true, onLargeTextChanged: changes.add),
      ),
    );
    await tester.pumpAndSettle();

    final Finder largeTextSwitch = find.byKey(const Key('largeTextSwitch'));
    expect(tester.widget<SwitchListTile>(largeTextSwitch).value, isTrue);

    await tester.tap(largeTextSwitch);
    await tester.pump();
    expect(tester.widget<SwitchListTile>(largeTextSwitch).value, isFalse);
    expect(changes, [false]);
    expect(await SharedPreferencesAsync().getBool(prefLargeText), isNull);

    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(largeText: false, onLargeTextChanged: changes.add),
      ),
    );
    await tester.pump();
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(largeText: true, onLargeTextChanged: changes.add),
      ),
    );
    await tester.pump();
    expect(tester.widget<SwitchListTile>(largeTextSwitch).value, isTrue);
    expect(changes, [false]);
  });

  testWidgets('Bigger text switch has an accessible label', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
      await tester.pumpAndSettle();

      final node = tester.getSemantics(
        find.byKey(const Key('largeTextSwitch')),
      );
      expect(node.label, 'Bigger text\nMake text easier to read');
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('Toggling switch and saving settings updates state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    final Finder nameField = find.widgetWithText(TextField, 'Full name');
    final Finder addressField = find.widgetWithText(
      TextField,
      'Delivery address',
    );
    final Finder emailField = find.widgetWithText(TextField, 'Email address');

    await tester.enterText(nameField, 'Gerald Vernon-Jackson');
    await tester.enterText(addressField, 'Guildhall, PO1 2AJ');
    await tester.enterText(
      emailField,
      'gerald.vernon-jackson@portsmouthcc.gov.uk',
    );
    await tester.tap(find.byKey(const Key('largeTextSwitch')));
    await tester.pump();

    final Finder switchFinder = find.byKey(const Key('newsletterSwitch'));
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();

    expect(
      find.text('Settings saved for Gerald Vernon-Jackson'),
      findsOneWidget,
    );

    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getString(prefName), 'Gerald Vernon-Jackson');
    expect(await prefs.getString(prefAddress), 'Guildhall, PO1 2AJ');
    expect(
      await prefs.getString(prefEmail),
      'gerald.vernon-jackson@portsmouthcc.gov.uk',
    );
    expect(await prefs.getBool(prefNewsletter), isTrue);
    expect(await prefs.getBool(prefLargeText), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Gerald Vernon-Jackson'), findsOneWidget);
    expect(find.text('Guildhall, PO1 2AJ'), findsOneWidget);
    expect(
      find.text('gerald.vernon-jackson@portsmouthcc.gov.uk'),
      findsOneWidget,
    );
    final Switch reopenedSwitch = tester.widget<Switch>(
      find.byKey(const Key('newsletterSwitch')),
    );
    expect(reopenedSwitch.value, isTrue);
    expect(
      tester
          .widget<SwitchListTile>(find.byKey(const Key('largeTextSwitch')))
          .value,
      isTrue,
    );
  });

  testWidgets('SettingsScreen pre-fills saved settings on open', (
    WidgetTester tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefName: 'Abdul Kadir',
      prefAddress: 'Portsmouth Guildhall, PO1 2AJ',
      prefEmail: 'abdul.kadir@portsmouthcc.gov.uk',
      prefNewsletter: true,
      prefLargeText: true,
    });

    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Abdul Kadir'), findsOneWidget);
    expect(find.text('Portsmouth Guildhall, PO1 2AJ'), findsOneWidget);
    expect(find.text('abdul.kadir@portsmouthcc.gov.uk'), findsOneWidget);
    final Switch switchWidget = tester.widget<Switch>(
      find.byKey(const Key('newsletterSwitch')),
    );
    expect(switchWidget.value, isTrue);
    expect(
      tester
          .widget<SwitchListTile>(find.byKey(const Key('largeTextSwitch')))
          .value,
      isTrue,
    );
  });
}
