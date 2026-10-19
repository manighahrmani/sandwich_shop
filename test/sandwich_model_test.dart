import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model tests', () {
    test('creates Sandwich instance with given properties', () {
      const sandwich = Sandwich(
        id: 'veggie',
        name: 'Veggie Sub',
        description: 'Loaded with fresh vegetables.',
        price: 5.25,
        imagePath: 'assets/images/six_inch.jpeg',
      );
      expect(sandwich.id, 'veggie');
      expect(sandwich.name, 'Veggie Sub');
      expect(sandwich.description, 'Loaded with fresh vegetables.');
      expect(sandwich.price, 5.25);
      expect(sandwich.imagePath, 'assets/images/six_inch.jpeg');
    });

    test(
      'formattedPrice returns price prefixed with pound sign and two decimals',
      () {
        const sandwich = Sandwich(
          id: 'footlong',
          name: 'Footlong Sub',
          description: 'Test description',
          price: 7.5,
          imagePath: 'assets/images/footlong.jpeg',
        );
        expect(sandwich.formattedPrice, '£7.50');
      },
    );

    test('JSON conversion preserves every sandwich field', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': 'veggie',
        'name': 'Veggie Sub',
        'description': 'Fresh vegetables.',
        'price': 5.50,
        'imagePath': 'assets/images/six_inch.jpeg',
      };

      final Sandwich sandwich = Sandwich.fromJson(data);
      expect(sandwich.id, 'veggie');
      expect(sandwich.name, 'Veggie Sub');
      expect(sandwich.description, 'Fresh vegetables.');
      expect(sandwich.price, 5.50);
      expect(sandwich.imagePath, 'assets/images/six_inch.jpeg');
      expect(sandwich.toJson(), data);
    });

    test('fromJson accepts a whole-number price', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': 'test',
        'name': 'Test Sub',
        'description': 'Test sandwich.',
        'price': 5,
        'imagePath': 'assets/images/footlong.jpeg',
      };
      final Sandwich sandwich = Sandwich.fromJson(data);
      expect(sandwich.price, 5.0);
      expect(sandwich.price, isA<double>());
    });

    test('fromJson rejects a text price', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': 'nonexistent',
        'name': 'Nonexistent Sandwich',
        'description': 'Intentional invalid price example.',
        'price': 'free',
        'imagePath': 'assets/images/nonexistent.jpeg',
      };
      expect(() {
        Sandwich.fromJson(data);
      }, throwsA(isA<TypeError>()));
    });
  });
}
