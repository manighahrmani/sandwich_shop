import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';

class AccountButton extends StatelessWidget {
  const AccountButton({super.key});

  void _openAuthScreen(BuildContext context) {
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
  }

  Future<void> _signOut() async {
    await AuthRepository.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthRepository.instance.watchAuthState(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        final User? currentUser = snapshot.data;

        String labelText = 'Log In';
        if (currentUser != null) {
          labelText = 'Sign Out';
        }

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: shopWhite,
            foregroundColor: shopBrand,
          ),
          onPressed: () {
            if (currentUser != null) {
              _signOut();
            } else {
              _openAuthScreen(context);
            }
          },
          child: Text(labelText),
        );
      },
    );
  }
}
