import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich', () {
    test('should create a Sandwich with correct properties', () {
      final sandwich = Sandwich(
        name: 'Veggie Delight',
        isFootlong: true,
        breadType: BreadType.wholemeal,
        image: 'assets/images/veggie.png',
      );

      expect(sandwich.name, 'Veggie Delight');
      expect(sandwich.isFootlong, isTrue);
      expect(sandwich.breadType, BreadType.wholemeal);
      expect(sandwich.image, 'assets/images/veggie.png');
    });

    test('should support all BreadType enum values', () {
      for (final bread in BreadType.values) {
        final sandwich = Sandwich(
          name: 'Test',
          isFootlong: false,
          breadType: bread,
          image: 'assets/images/test.png',
        );
        expect(sandwich.breadType, bread);
      }
    });

    test('should handle isFootlong true and false', () {
      final footlong = Sandwich(
        name: 'Footlong',
        isFootlong: true,
        breadType: BreadType.white,
        image: 'assets/images/footlong.png',
      );
      final sixInch = Sandwich(
        name: 'Six Inch',
        isFootlong: false,
        breadType: BreadType.white,
        image: 'assets/images/six-inch.png',
      );

      expect(footlong.isFootlong, isTrue);
      expect(sixInch.isFootlong, isFalse);
    });

    test('should throw if name is empty', () {
      expect(
        () => Sandwich(
          name: '',
          isFootlong: false,
          breadType: BreadType.wheat,
          image: 'assets/images/empty.png',
        ),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Name cannot be empty'))),
      );
    });

    test('should throw if image is empty', () {
      expect(
        () => Sandwich(
          name: 'No Image',
          isFootlong: false,
          breadType: BreadType.wheat,
          image: '',
        ),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Image must be a valid asset path'))),
      );
    });

    test('should throw if image does not start with assets/images/', () {
      expect(
        () => Sandwich(
          name: 'Bad Image',
          isFootlong: false,
          breadType: BreadType.wheat,
          image: 'bad/path.png',
        ),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Image must be a valid asset path'))),
      );
    });

    test('should allow valid asset image paths', () {
      final sandwich = Sandwich(
        name: 'Valid Image',
        isFootlong: false,
        breadType: BreadType.white,
        image: 'assets/images/valid.png',
      );
      expect(sandwich.image, 'assets/images/valid.png');
    });
  });
}