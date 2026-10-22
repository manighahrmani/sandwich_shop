import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
void main() {
  group('Sandwich model tests', () {
    test('creates a sandwich instance with the correct properties', () {
      const sandwich = Sandwich(
        id: 'veggie',
        name: 'Veggie Sub',
        description: 'A delicious test sandwich',
        price: 5.55,
        imagePath: 'assets/images/six_inch.png',
      );

      expect(sandwich.formattedPrice, '£5.55');
      expect(sandwich.name, 'Veggie Sub');
      expect(sandwich.description, 'A delicious test sandwich');
      expect(sandwich.price, 5.55);
      expect(sandwich.imagePath, 'assets/images/six_inch.png');
    });

      test('formattedPrice returns price with £ prefix and 2 decimal places', () {
      const sandwich = Sandwich(
        id: 'footlong',
        name: 'Footlong Sub',
        description: 'Test description',
        price: 7.55,
        imagePath: 'assets/images/footlong.png',
      );

      expect(sandwich.formattedPrice, '£7.55');
    });
  });
}