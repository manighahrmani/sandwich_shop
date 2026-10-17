import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/main.dart' as application;
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/basket_screen.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';
import 'package:sandwich_shop/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    CartRepository.instance.clear();
  });

  testWidgets(
    'The real entry point applies the shared theme and named routes',
    (WidgetTester tester) async {
      application.main();
      await tester.pumpAndSettle();
      expect(find.byType(MenuScreen), findsOneWidget);
      final MaterialApp app = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(app.title, appTitle);
      expect(app.debugShowCheckedModeBanner, isFalse);
      expect(app.theme!.scaffoldBackgroundColor, shopBackground);
      expect(app.theme!.appBarTheme.backgroundColor, shopBrand);
      expect(app.theme!.appBarTheme.foregroundColor, shopWhite);

      await tester.tap(find.byIcon(Icons.shopping_basket));
      await tester.pumpAndSettle();
      expect(find.byType(BasketScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
    },
  );
}
