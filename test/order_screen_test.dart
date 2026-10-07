import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
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

// The quantity DropdownMenu renders its own TextField, so match the note
// field by its label rather than by widget type alone.
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

  testWidgets('OrderScreen shows two switches and one note field', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );

    expect(find.byType(Switch), findsNWidgets(2));
    expect(noteFieldFinder, findsOneWidget);
  });

  testWidgets('Toggling the toasted switch flips its value', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );

    final Finder toastedSwitch = find.byType(Switch).first;
    Switch switchWidget = tester.widget<Switch>(toastedSwitch);
    expect(switchWidget.value, isFalse);

    await tester.tap(toastedSwitch);
    await tester.pump();

    switchWidget = tester.widget<Switch>(toastedSwitch);
    expect(switchWidget.value, isTrue);
  });

  testWidgets('Adding to basket records quantity, toggles and note', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrderScreen(sandwich: testSandwich)),
    );

    await tester.enterText(noteFieldFinder, 'No pickles');

    await tester.tap(find.byType(Switch).first);
    await tester.pump();

    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pump();

    await tester.tap(find.text('Add to Basket'));
    await tester.pump();

    final List<CartItem> items = CartRepository.instance.getItems();
    expect(items.length, 1);

    final CartItem added = items.first;
    expect(added.quantity, 2);
    expect(added.toasted, isTrue);
    expect(added.vegan, isFalse);
    expect(added.note, 'No pickles');
  });
}
