import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person_outline),
      tooltip: 'Settings',
      onPressed: () {
        final String? currentRoute = ModalRoute.of(context)?.settings.name;
        if (currentRoute != '/settings') {
          Navigator.pushNamed(context, '/settings');
        }
      },
    );
  }
}
