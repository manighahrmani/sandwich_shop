import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/screens/order_screen.dart';
import 'package:sandwich_shop/widgets/sandwich_card.dart';

void main() {
  const Sandwich sandwich = Sandwich(
    id: 'six-inch',
    name: 'Six-Inch Sub',
    description: 'Freshly prepared with your favourite toppings.',
    price: 4.50,
    imagePath: 'assets/images/six_inch.jpeg',
  );

  testWidgets(
    'A sandwich card renders its image, name, description and price',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SandwichCard(sandwich: sandwich)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(sandwich.name), findsOneWidget);
      expect(find.text(sandwich.description), findsOneWidget);
      expect(find.text('£4.50'), findsOneWidget);
      final Image image = tester.widget<Image>(find.byType(Image));
      expect((image.image as AssetImage).assetName, sandwich.imagePath);
    },
  );

  testWidgets(
    'The card opens an order for its own sandwich and supports back',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SandwichCard(sandwich: sandwich)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Order'));
      await tester.pumpAndSettle();
      expect(find.byType(OrderScreen), findsOneWidget);
      expect(
        tester.widget<OrderScreen>(find.byType(OrderScreen)).sandwich,
        same(sandwich),
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(SandwichCard), findsOneWidget);
    },
  );
}
