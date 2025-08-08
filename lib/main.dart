import 'package:flutter/material.dart';

void main() {
  runApp(const SandwichShopApp());
}

// The root widget remains stateless. Its primary job is to set up the app's
// theme and initial screen.
class SandwichShopApp extends StatelessWidget {
  const SandwichShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const SandwichOrderScreen(),
    );
  }
}

// The StatefulWidget that represents the main screen, managing the interactive
// state of the sandwich counter.
class SandwichOrderScreen extends StatefulWidget {
  const SandwichOrderScreen({super.key});

  @override
  State<SandwichOrderScreen> createState() => _SandwichOrderScreenState();
}

class _SandwichOrderScreenState extends State<SandwichOrderScreen> {
  int _sandwiches = 0;

  void _addSandwich() {
    setState(() {
      _sandwiches++;
    });
  }

  void _removeSandwich() {
    setState(() {
      if (_sandwiches > 0) {
        _sandwiches--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SandwichCounter(
              count: _sandwiches,
              sandwichType: 'Footlong',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addSandwich,
                  child: const Text('Add'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _removeSandwich,
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// A separate, reusable StatelessWidget for displaying the count. It is
// self-contained and only responsible for presentation.
class SandwichCounter extends StatelessWidget {
  final String sandwichType;
  final int count;

  const SandwichCounter({
    required this.count,
    required this.sandwichType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count $sandwichType sandwich(es)',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
