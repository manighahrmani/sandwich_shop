import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  const Sandwich sandwich = Sandwich(
    id: 'test',
    name: 'Test sub',
    description: 'A test sandwich',
    price: 4.50,
    imagePath: 'assets/images/six_inch.jpeg',
  );

  test('CartItem keeps its sandwich and quantity and multiplies the price', () {
    const CartItem item = CartItem(sandwich: sandwich, quantity: 3);
    expect(item.sandwich, same(sandwich));
    expect(item.quantity, 3);
    expect(item.lineTotal, 13.50);
  });

  test('A zero quantity has a zero line total', () {
    const CartItem item = CartItem(sandwich: sandwich, quantity: 0);
    expect(item.lineTotal, 0.0);
  });
}
