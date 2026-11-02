import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUp(() {
    rootBundle.clear();
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group('App smoke tests', () {
    testWidgets('App displays MenuScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
    });

    testWidgets('Displays sandwich cards with names and prices', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.text('Footlong Sub'), findsOneWidget);
      expect(find.text('£7.50'), findsOneWidget);
      expect(find.text('Six-Inch Sub'), findsOneWidget);
      expect(find.text('£4.50'), findsOneWidget);
      expect(find.text('Order'), findsWidgets);
      await tester.scrollUntilVisible(find.text('Loaded Nachos'), 150);
      expect(find.text('£6.99'), findsOneWidget);
    });

    testWidgets(
      'Tapping Order navigates to OrderScreen with selected sandwich',
      (WidgetTester tester) async {
        await tester.pumpWidget(const App());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Order').first);
        await tester.pumpAndSettle();

        expect(find.byType(OrderScreen), findsOneWidget);
        expect(find.text('Order Footlong Sub'), findsOneWidget);
        expect(find.text('0 Footlong Sub sandwich(es): '), findsOneWidget);

        await tester.tap(find.text('Add'));
        await tester.pump();
        expect(find.text('1 Footlong Sub sandwich(es): 🥪'), findsOneWidget);

        await tester.tap(find.text('Remove'));
        await tester.pump();
        expect(find.text('0 Footlong Sub sandwich(es): '), findsOneWidget);
      },
    );
  });

  testWidgets(
    'Font size applies across pages, keeps system scaling, and persists',
    (WidgetTester tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      sqfliteFfiInit();
      final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: SandwichDatabase.instance.createTables,
        ),
      );
      SandwichDatabase.instance.setDatabase(database);

      double scaledFontSize(String text, double fontSize) {
        return tester
            .renderObject<RenderParagraph>(find.text(text))
            .textScaler
            .scale(fontSize);
      }

      try {
        await tester.pumpWidget(const App());
        await tester.pumpAndSettle();
        expect(scaledFontSize('Footlong Sub', 18), closeTo(27, 0.01));

        await tester.tap(find.byIcon(Icons.person_outline));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('largeTextCheckbox')));
        await tester.pumpAndSettle();
        expect(scaledFontSize('Customer Profile', 22), closeTo(39.6, 0.01));

        await tester.ensureVisible(find.text('Save Settings'));
        await tester.tap(find.text('Save Settings'));
        await tester.pumpAndSettle();
        final SharedPreferencesAsync prefs = SharedPreferencesAsync();
        expect(await prefs.getBool(prefLargeText), isTrue);

        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(scaledFontSize('Footlong Sub', 18), closeTo(32.4, 0.01));

        await tester.tap(find.text('Order').first);
        await tester.pumpAndSettle();
        expect(scaledFontSize('Order Footlong Sub', 22), closeTo(39.6, 0.01));

        await tester.pageBack();
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.shopping_basket));
        await tester.pumpAndSettle();
        expect(scaledFontSize('Your basket is empty', 16), closeTo(28.8, 0.01));

        await tester.tap(find.byIcon(Icons.receipt_long));
        await tester.pumpAndSettle();
        expect(scaledFontSize('No orders yet', 16), closeTo(28.8, 0.01));

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(const App());
        await tester.pumpAndSettle();
        expect(scaledFontSize('Footlong Sub', 18), closeTo(32.4, 0.01));
        await tester.tap(find.byIcon(Icons.person_outline));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<CheckboxListTile>(
                find.byKey(const Key('largeTextCheckbox')),
              )
              .value,
          isTrue,
        );

        await tester.tap(find.byKey(const Key('largeTextCheckbox')));
        await tester.pumpAndSettle();
        expect(scaledFontSize('Customer Profile', 22), closeTo(33, 0.01));
        await tester.ensureVisible(find.text('Save Settings'));
        await tester.tap(find.text('Save Settings'));
        await tester.pumpAndSettle();
        expect(await prefs.getBool(prefLargeText), isFalse);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(const App());
        await tester.pumpAndSettle();
        expect(scaledFontSize('Footlong Sub', 18), closeTo(27, 0.01));
      } finally {
        await SandwichDatabase.instance.close();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      }
    },
  );

  for (final bool largeText in [false, true]) {
    testWidgets('Nonlinear system scaling is preserved (bigger: $largeText)', (
      WidgetTester tester,
    ) async {
      await SharedPreferencesAsync().setBool(prefLargeText, largeText);
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      final TransitionBuilder appBuilder = tester
          .widget<MaterialApp>(find.byType(MaterialApp))
          .builder!;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: _NonlinearTextScaler()),
            child: Builder(
              builder: (BuildContext context) {
                return appBuilder(context, const Text('Sample text'));
              },
            ),
          ),
        ),
      );
      final TextScaler scaler = tester
          .renderObject<RenderParagraph>(find.text('Sample text'))
          .textScaler;
      double expectedSmallSize = 27;
      double expectedLargeSize = 32;
      if (largeText) {
        expectedSmallSize = 32.4;
        expectedLargeSize = 38.4;
      }
      expect(scaler.scale(18), closeTo(expectedSmallSize, 0.01));
      expect(scaler.scale(22), closeTo(expectedLargeSize, 0.01));
    });
  }

  test('Android is supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = null;
  });

  test('Other platforms are not supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('The unsupported platform screen explains what to do', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UnsupportedPlatformApp());
    expect(find.textContaining('Android emulator'), findsOneWidget);
  });
}

class _NonlinearTextScaler extends TextScaler {
  const _NonlinearTextScaler();

  @override
  double scale(double fontSize) {
    if (fontSize <= 20) {
      return fontSize * 1.5;
    }
    return fontSize + 10;
  }

  @override
  double get textScaleFactor {
    return 1.5;
  }
}
