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
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    CartRepository.instance.clear();
  });

  testWidgets('Order options are saved to shared preferences on add to basket',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    await tester.enterText(noteFieldFinder, 'No pickles');
    await tester.pump();

    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.tap(find.text('Add to Basket'));
    await tester.pumpAndSettle();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(prefToasted), isTrue);
    expect(prefs.getBool(prefVegan), isFalse);
    expect(prefs.getString(prefNote), 'No pickles');
  });

  testWidgets('Saved order options pre-fill the order screen on open',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      prefToasted: true,
      prefVegan: true,
      prefNote: 'Extra sauce',
    });

    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );
    await tester.pumpAndSettle();

    final List<Switch> switches =
        tester.widgetList<Switch>(find.byType(Switch)).toList();
    expect(switches[0].value, isTrue);
    expect(switches[1].value, isTrue);

    final TextField noteField = tester.widget<TextField>(noteFieldFinder);
    expect(noteField.controller?.text, 'Extra sauce');
  });
}
