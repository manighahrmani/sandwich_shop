import 'package:flutter/material.dart';

void main() {
  runApp(const SandwichShopApp());
}

// The root widget of the application. It sets up the MaterialApp and defines
// the home screen.
class SandwichShopApp extends StatelessWidget {
  const SandwichShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      // The home screen is the stateful widget that manages the counter.
      home: SandwichOrderScreen(),
    );
  }
}

// The StatefulWidget that represents the screen. It is responsible for creating
// its mutable State object.
class SandwichOrderScreen extends StatefulWidget {
  const SandwichOrderScreen({super.key});

  @override
  State<SandwichOrderScreen> createState() => _SandwichOrderScreenState();
}

// The State class where the data that can change is held.
class _SandwichOrderScreenState extends State<SandwichOrderScreen> {
  int _sandwiches = 0; // The state variable for the sandwich count.

  void _addSandwich() {
    // setState notifies Flutter that the state has changed and the UI needs
    // to be rebuilt.
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // The custom widget now displays the state variable.
            SandwichCounter(
              count: _sandwiches,
              sandwichType: 'Footlong',
            ),
            const SizedBox(height: 20),
            // A Row holds the buttons that modify the state.
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

// The StatelessWidget for displaying the count, now with emojis.
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
    // The text now includes the sandwich emoji repeated for the current count.
    return Text(
      '$count $sandwichType sandwich(es): ${'🥪' * count}',
      style: const TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );
  }
}
