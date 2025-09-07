import 'sandwich.dart';

class Cart {
  final List<Sandwich> _items = [];

  void add(Sandwich sandwich) {
    _items.add(sandwich);
  }

  void remove(Sandwich sandwich) {
    _items.remove(sandwich);
  }

  void clear() {
    _items.clear();
  }

  double get totalPrice {
    return 0.0;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;
}
