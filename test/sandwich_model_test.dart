import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  test('JSON conversions round-trip all sandwich fields', () {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': 'custom',
      'name': 'Custom sub',
      'description': 'Freshly made',
      'price': 0.0,
      'imagePath': 'custom.jpeg',
    };
    expect(Sandwich.fromJson(data).toJson(), data);
    expect(Sandwich.fromJson(data).formattedPrice, '£0.00');
  });

  for (final String key in <String>[
    'id',
    'name',
    'description',
    'price',
    'imagePath',
  ]) {
    test('JSON missing $key is rejected rather than silently defaulted', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': 'custom',
        'name': 'Custom sub',
        'description': 'Freshly made',
        'price': 4.5,
        'imagePath': 'custom.jpeg',
      };
      data.remove(key);
      expect(() {
        Sandwich.fromJson(data);
      }, throwsA(isA<TypeError>()));
    });
  }
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

    test('fromJson creates a Sandwich instance from valid JSON map', () {
      final Map<String, dynamic> jsonMap = <String, dynamic>{
        'id': 'veggie-delight',
        'name': 'Veggie Delight',
        'description': 'Crisp garden vegetables on fresh bread.',
        'price': 5.50,
        'imagePath': 'assets/images/six_inch.jpeg',
      };

      final Sandwich sandwich = Sandwich.fromJson(jsonMap);

      expect(sandwich.id, 'veggie-delight');
      expect(sandwich.name, 'Veggie Delight');
      expect(sandwich.description, jsonMap['description']);
      expect(sandwich.price, 5.50);
      expect(sandwich.imagePath, 'assets/images/six_inch.jpeg');
      expect(sandwich.toJson(), jsonMap);
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

    test('toJson serialises a Sandwich instance into a JSON map', () {
      const Sandwich sandwich = Sandwich(
        id: 'meatball',
        name: 'Meatball Marinara',
        description: 'Italian meatballs in rich marinara sauce.',
        price: 8.00,
        imagePath: 'assets/images/footlong.jpeg',
      );

      final Map<String, dynamic> jsonMap = sandwich.toJson();

      expect(jsonMap['id'], 'meatball');
      expect(jsonMap['name'], 'Meatball Marinara');
      expect(jsonMap['price'], 8.00);
      expect(jsonMap['imagePath'], 'assets/images/footlong.jpeg');
    });
  });
}
