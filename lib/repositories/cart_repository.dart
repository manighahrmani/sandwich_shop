import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/order_options.dart';

class CartRepository {
  CartRepository._internal();

  static final CartRepository instance = CartRepository._internal();

  final List<CartItem> _items = [];
  OrderOptions _options = const OrderOptions();

  List<CartItem> getItems() {
    return List<CartItem>.unmodifiable(_items);
  }

  OrderOptions getOptions() {
    return _options;
  }

  void setOptions(OrderOptions options) {
    _options = options;
  }

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  int getTotalItems() {
    int total = 0;
    for (final CartItem item in _items) {
      total += item.quantity;
    }
    return total;
  }

  double getSubtotal() {
    double sum = 0.0;
    for (final CartItem item in _items) {
      sum += item.totalPrice;
    }
    return sum;
  }

  double getDeliveryFee() {
    if (_items.isEmpty) {
      return 0.0;
    }
    return 1.50;
  }

  double getTotalDue() {
    return getSubtotal() + getDeliveryFee();
  }

  void clear() {
    _items.clear();
    _options = const OrderOptions();
  }
}
