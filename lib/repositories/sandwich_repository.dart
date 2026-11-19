import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:sandwich_shop/models/sandwich.dart';

class SandwichRepository {
  SandwichRepository._internal();

  static final SandwichRepository instance = SandwichRepository._internal();

  FirebaseFirestore? _firestore;
  List<Sandwich>? _cachedSandwiches;

  void setFirestore(FirebaseFirestore? firestore) {
    _firestore = firestore;
  }

  void clearCache() {
    _cachedSandwiches = null;
  }

  FirebaseFirestore get firestore {
    final FirebaseFirestore? existingFirestore = _firestore;
    if (existingFirestore != null) {
      return existingFirestore;
    }
    return FirebaseFirestore.instance;
  }

  List<Sandwich> getSandwiches() {
    final List<Sandwich>? cachedSandwiches = _cachedSandwiches;
    if (cachedSandwiches != null) {
      return cachedSandwiches;
    }
    return const [
      Sandwich(
        id: 'footlong',
        name: 'Footlong Sub',
        description:
            'A freshly baked 12-inch sandwich filled with savoury ingredients.',
        price: 7.50,
        imagePath: 'assets/images/footlong.jpeg',
      ),
      Sandwich(
        id: 'six-inch',
        name: 'Six-Inch Sub',
        description:
            'A light 6-inch sandwich made with your favourite toppings.',
        price: 4.50,
        imagePath: 'assets/images/six_inch.jpeg',
      ),
    ];
  }

  Sandwich? getSandwichById(String id) {
    for (final Sandwich sandwich in getSandwiches()) {
      if (sandwich.id == id) {
        return sandwich;
      }
    }
    return null;
  }

  Future<List<Sandwich>> loadSandwichesFromAsset({
    String assetPath = 'assets/data/sandwiches.json',
  }) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
    final List<Sandwich> loadedSandwiches = [];
    for (final dynamic item in jsonList) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Sandwich sandwich = Sandwich.fromJson(itemMap);
      loadedSandwiches.add(sandwich);
    }

    _cachedSandwiches = loadedSandwiches;
    return loadedSandwiches;
  }

  Future<List<Sandwich>> loadSandwichesFromFirestore() async {
    final CollectionReference<Map<String, dynamic>> sandwichesCollection =
        firestore.collection('sandwiches');
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await sandwichesCollection.get();

    if (snapshot.docs.isEmpty) {
      final List<Sandwich> seededSandwiches = await loadSandwichesFromAsset();
      for (final Sandwich sandwich in seededSandwiches) {
        final DocumentReference<Map<String, dynamic>> sandwichDocument =
            sandwichesCollection.doc(sandwich.id);
        final Map<String, dynamic> sandwichData = sandwich.toJson();
        await sandwichDocument.set(sandwichData);
      }
      return seededSandwiches;
    }

    final List<Sandwich> loadedSandwiches = [];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> document
        in snapshot.docs) {
      final Map<String, dynamic> documentData = document.data();
      final Sandwich sandwich = Sandwich.fromJson(documentData);
      loadedSandwiches.add(sandwich);
    }

    _cachedSandwiches = loadedSandwiches;
    return loadedSandwiches;
  }
}
