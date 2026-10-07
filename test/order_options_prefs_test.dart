import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Sandwich testSandwich = Sandwich(
  id: 'test',
  name: 'Test Sub',
  description: 'Test description',
  price: 5.0,
  imagePath: 'assets/images/footlong.jpeg',
);

final Finder noteFieldFinder = find.byWidgetPredicate((Widget widget) {
  return widget is TextField &&
      widget.decoration?.labelText == 'Note for the kitchen';
});

void main() {
  setUp(() {
    CartRepository.instance.clear();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('Order screen pre-fills saved options on open', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      prefToasted: true,
      prefVegan: true,
      prefNote: 'No onions',
    });

    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );
    await tester.pumpAndSettle();

    final Switch toastedSwitch = tester.widget<Switch>(
      find.byType(Switch).first,
    );
    final Switch veganSwitch = tester.widget<Switch>(find.byType(Switch).last);
    expect(toastedSwitch.value, isTrue);
    expect(veganSwitch.value, isTrue);
    expect(find.text('No onions'), findsOneWidget);
  });

  testWidgets('Toggling and adding to basket saves options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(prefToasted), isTrue);

    await tester.enterText(noteFieldFinder, 'Extra cheese');
    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.tap(find.text('Add to Basket'));
    await tester.pumpAndSettle();

    final SharedPreferences updated = await SharedPreferences.getInstance();
    expect(updated.getString(prefNote), 'Extra cheese');
  });
}
