import 'package:flutter/material.dart';

class SandwichCounter extends StatelessWidget {
  final String sandwichType;
  final int count;

  const SandwichCounter(this.count, this.sandwichType);

  @override
  Widget build(BuildContext context) {
    return Text('$count $sandwichType sandwich(es): ${'🥪' * count}');
  }
}

void main() {
  runApp(SandwichShopApp());
}

class SandwichShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Sandwich Counter')),
        body: Center(child: SandwichCounter(5, 'Footlong')),
      ),
    );
  }
}
