import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';

import '../support/controlled_assets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'An empty JSON catalogue remains empty instead of using the fixed menu',
    () async {
      final ControlledAssets assets = ControlledAssets();
      assets.install();
      addTearDown(assets.uninstall);
      final SandwichRepository repository = SandwichRepository();
      expect(await repository.loadSandwichesFromAsset(), isEmpty);
      expect(repository.getSandwiches(), isEmpty);
      expect(repository.getSandwichById('footlong'), isNull);
    },
  );

  test(
    'Runtime JSON replaces the fixed catalogue and supports lookups',
    () async {
      final ControlledAssets assets = ControlledAssets();
      assets.contents = '''
      [{"id":"custom","name":"Custom sub","description":"Fresh",
        "price":3,"imagePath":"custom.jpeg"}]
    ''';
      assets.install();
      addTearDown(assets.uninstall);
      final SandwichRepository repository = SandwichRepository();
      final List<Sandwich> loaded = await repository.loadSandwichesFromAsset();
      expect(loaded.single.name, 'Custom sub');
      expect(loaded.single.price, 3.0);
      expect(repository.getSandwichById('custom'), same(loaded.single));
      expect(repository.getSandwichById('footlong'), isNull);
      assets.contents = 'not JSON';
      await expectLater(
        repository.loadSandwichesFromAsset(assetPath: 'broken.json'),
        throwsFormatException,
      );
      expect(repository.getSandwiches(), same(loaded));
    },
  );

  for (final String invalidData in <String>[
    'not JSON',
    '{}',
    '[null]',
    '[{"id":1}]',
  ]) {
    test('An invalid JSON catalogue is rejected: $invalidData', () async {
      final ControlledAssets assets = ControlledAssets();
      assets.contents = invalidData;
      assets.install();
      addTearDown(assets.uninstall);
      final SandwichRepository repository = SandwichRepository();
      await expectLater(
        repository.loadSandwichesFromAsset(),
        throwsA(anything),
      );
    });
  }

  test(
    'loadSandwichesFromAsset reads and caches the bundled catalogue',
    () async {
      final SandwichRepository repository = SandwichRepository();
      final List<Sandwich> sandwiches =
          await repository.loadSandwichesFromAsset();
      expect(sandwiches, hasLength(2));
      expect(sandwiches.first.id, 'footlong');
      expect(sandwiches.last.id, 'six-inch');
      expect(repository.getSandwiches(), same(sandwiches));
    },
  );

  test(
    'a missing asset reports an error instead of returning the fixed menu',
    () async {
      final SandwichRepository repository = SandwichRepository();
      await expectLater(
        repository.loadSandwichesFromAsset(
          assetPath: 'assets/data/missing.json',
        ),
        throwsFlutterError,
      );
    },
  );

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
  });
}
