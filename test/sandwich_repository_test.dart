import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';

void main() {
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
  });
}
