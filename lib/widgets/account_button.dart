import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  const AccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.account_circle_outlined),
      tooltip: 'Account',
      onPressed: () {
        final ModalRoute<dynamic>? modalRoute = ModalRoute.of(context);
        final String currentRoute;
        if (modalRoute != null) {
          final RouteSettings routeSettings = modalRoute.settings;
          final String? name = routeSettings.name;
          if (name != null) {
            currentRoute = name;
          } else {
            currentRoute = '';
          }
        } else {
          currentRoute = '';
        }

        if (currentRoute != '/auth') {
          Navigator.pushNamed(context, '/auth');
        }
      },
    );
  }
}

