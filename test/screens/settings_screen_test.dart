import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/user_settings.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/repositories/settings_repository.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';

void main() {
  setUp(() {
    AuthRepository.instance.setAuth(MockFirebaseAuth());
    SettingsRepository.instance.setFirestore(FakeFirebaseFirestore());
  });

  tearDown(() {
    AuthRepository.instance.setAuth(null);
    SettingsRepository.instance.setFirestore(null);
  });

  testWidgets('SettingsScreen displays blank form fields when signed out', (
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

    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Please log in to save your settings.'), findsOneWidget);
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

  testWidgets('Toggling switch and saving settings persists to Firestore', (
    WidgetTester tester,
  ) async {
    final MockFirebaseAuth signedInAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(
        uid: 'user-save-1',
        displayName: 'Alex Smith',
        email: 'alex@example.com',
      ),
    );
    AuthRepository.instance.setAuth(signedInAuth);

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
    expect(
      AuthRepository.instance.getCurrentUser()?.displayName,
      'Gerald Vernon-Jackson',
    );

    final UserSettings? saved =
        await SettingsRepository.instance.loadSettings('user-save-1');
    expect(saved?.name, 'Gerald Vernon-Jackson');
    expect(saved?.address, 'Guildhall, PO1 2AJ');
    expect(saved?.email, 'gerald.vernon-jackson@portsmouthcc.gov.uk');
    expect(saved?.receiveNewsletter, isTrue);
    expect(saved?.largeText, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Gerald Vernon-Jackson'), findsOneWidget);
    expect(find.text('Guildhall, PO1 2AJ'), findsOneWidget);
    expect(
      find.text('gerald.vernon-jackson@portsmouthcc.gov.uk'),
      findsOneWidget,
    );
    expect(
      tester.widget<Switch>(find.byKey(const Key('newsletterSwitch'))).value,
      isTrue,
    );
    expect(
      tester
          .widget<SwitchListTile>(find.byKey(const Key('largeTextSwitch')))
          .value,
      isTrue,
    );
  });

  testWidgets('SettingsScreen loads user settings and clears on sign-out', (
    WidgetTester tester,
  ) async {
    final MockFirebaseAuth signedInAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(
        uid: 'cloud-user-1',
        displayName: 'Alex Smith',
        email: 'alex@example.com',
      ),
    );
    AuthRepository.instance.setAuth(signedInAuth);

    await SettingsRepository.instance.saveSettings(
      'cloud-user-1',
      const UserSettings(
        name: 'Cloud Alex',
        address: '10 Southsea Parade',
        email: 'cloud@example.com',
        receiveNewsletter: true,
        largeText: true,
      ),
    );

    final List<bool> textChanges = [];
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(
          largeText: false,
          onLargeTextChanged: textChanges.add,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cloud Alex'), findsOneWidget);
    expect(find.text('10 Southsea Parade'), findsOneWidget);
    expect(find.text('cloud@example.com'), findsOneWidget);
    expect(textChanges, [true]);

    await signedInAuth.signOut();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Cloud Alex'), findsNothing);
    expect(find.text('10 Southsea Parade'), findsNothing);
    expect(find.text('cloud@example.com'), findsNothing);
    expect(
      tester
          .widget<SwitchListTile>(find.byKey(const Key('largeTextSwitch')))
          .value,
      isFalse,
    );
  });
}
