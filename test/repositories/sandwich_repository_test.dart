import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    SandwichRepository.instance.clearCache();
    SandwichRepository.instance.setFirestore(fakeFirestore);
  });

  tearDown(() {
    SandwichRepository.instance.clearCache();
    SandwichRepository.instance.setFirestore(null);
  });

  group('SandwichRepository unit tests', () {
    test('getSandwiches returns two sandwiches', () {
      final List<Sandwich> sandwiches =
          SandwichRepository.instance.getSandwiches();

      expect(sandwiches.length, 2);
    });

    test('getSandwiches contains valid Footlong and Six-Inch subs', () {
      final List<Sandwich> sandwiches =
          SandwichRepository.instance.getSandwiches();

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
      final Sandwich? sandwich = SandwichRepository.instance.getSandwichById(
        'footlong',
      );

      expect(sandwich, isNotNull);
      expect(sandwich?.name, 'Footlong Sub');
      expect(sandwich?.price, 7.50);
    });

    test('getSandwichById returns null when id does not exist', () {
      final Sandwich? sandwich = SandwichRepository.instance.getSandwichById(
        'non-existent',
      );

      expect(sandwich, isNull);
    });

    test('loadSandwichesFromAsset reads the bundled JSON menu', () async {
      final List<Sandwich> sandwiches =
          await SandwichRepository.instance.loadSandwichesFromAsset();

      expect(sandwiches.length, 3);
      expect(sandwiches[0].id, 'footlong');
      expect(sandwiches[1].id, 'six-inch');
      expect(sandwiches[2].id, 'nachos');
      expect(sandwiches[2].price, 6.99);
      expect(sandwiches[2].imagePath, 'assets/images/nachos.jpeg');
      expect(SandwichRepository.instance.getSandwiches(), sandwiches);
    });

    test('firestore falls back to FirebaseFirestore.instance when null', () {
      SandwichRepository.instance.setFirestore(null);

      FirebaseFirestore readFirestore() {
        return SandwichRepository.instance.firestore;
      }

      expect(readFirestore, throwsA(isA<FirebaseException>()));
    });

    test('loadSandwichesFromFirestore seeds empty collection from asset',
        () async {
      final List<Sandwich> sandwiches =
          await SandwichRepository.instance.loadSandwichesFromFirestore();

      expect(sandwiches.length, 3);
      final QuerySnapshot<Map<String, dynamic>> stored =
          await fakeFirestore.collection('sandwiches').get();
      expect(stored.docs.length, 3);
    });

    test('loadSandwichesFromFirestore reads existing Firestore documents',
        () async {
      await fakeFirestore.collection('sandwiches').doc('wrap').set(
        <String, dynamic>{
          'id': 'wrap',
          'name': 'Chicken Wrap',
          'description': 'Fresh grilled chicken wrap.',
          'price': 5.25,
          'imagePath': 'assets/images/six_inch.jpeg',
        },
      );

      final List<Sandwich> sandwiches =
          await SandwichRepository.instance.loadSandwichesFromFirestore();

      expect(sandwiches.length, 1);
      expect(sandwiches[0].id, 'wrap');
      expect(sandwiches[0].name, 'Chicken Wrap');
      expect(sandwiches[0].price, 5.25);
      expect(SandwichRepository.instance.getSandwiches(), sandwiches);
    });
  });
}
