import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SandwichRepository unit tests', () {
    test('getSandwiches returns two sandwiches', () {
      final SandwichRepository repository = SandwichRepository();
      final List<Sandwich> sandwiches = repository.getSandwiches();

      expect(sandwiches.length, 2);
    });

    test('getSandwiches contains valid Footlong and Six-Inch subs', () {
      final SandwichRepository repository = SandwichRepository();
      final List<Sandwich> sandwiches = repository.getSandwiches();

      final Sandwich footlong = sandwiches[0];
      expect(footlong.id, 'footlong');
      expect(footlong.name, 'Footlong Sub');
      expect(footlong.price, 7.50);
      expect(footlong.imagePath, isNotEmpty);

      final Sandwich sixInch = sandwiches[1];
      expect(sixInch.id, 'six-inch');
      expect(sixInch.name, 'Six-Inch Sub');
      expect(sixInch.price, 4.50);
      expect(sixInch.imagePath, isNotEmpty);
    });

    test('getSandwichById returns matching sandwich when id exists', () {
      final SandwichRepository repository = SandwichRepository();
      final Sandwich? sandwich = repository.getSandwichById('footlong');

      expect(sandwich, isNotNull);
      expect(sandwich?.name, 'Footlong Sub');
      expect(sandwich?.price, 7.50);
    });

    test('getSandwichById returns null when id does not exist', () {
      final SandwichRepository repository = SandwichRepository();
      final Sandwich? sandwich = repository.getSandwichById('non-existent');

      expect(sandwich, isNull);
    });

    test('loadSandwichesFromAsset reads the bundled JSON menu', () async {
      final SandwichRepository repository = SandwichRepository();
      final List<Sandwich> sandwiches = await repository
          .loadSandwichesFromAsset();

      expect(sandwiches.length, 4);
      expect(sandwiches[0].id, 'footlong');
      expect(sandwiches[1].id, 'six-inch');
      expect(sandwiches[2].id, 'nachos');
      expect(sandwiches[2].price, 6.99);
      expect(sandwiches[2].imagePath, 'assets/images/nachos.jpeg');
      expect(sandwiches[3].id, 'nonexistent');
      expect(sandwiches[3].price, 0.0);
      expect(repository.getSandwiches(), sandwiches);
      expect(repository.getSandwichById('nachos'), sandwiches[2]);
    });

    test('nachos image is bundled and the example image is absent', () async {
      final ByteData image = await rootBundle.load('assets/images/nachos.jpeg');
      expect(image.lengthInBytes, greaterThan(0));
      await expectLater(() async {
        await rootBundle.load('assets/images/nonexistent.jpeg');
      }, throwsFlutterError);
    });
  });
}
