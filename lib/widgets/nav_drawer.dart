import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: shopBrand,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      appTitle,
                      style: TextStyle(
                        color: shopWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: shopWhite),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const DrawerTile(title: 'Menu', route: '/'),
            const DrawerTile(title: 'My Basket', route: '/cart'),
            const DrawerTile(title: 'My Settings', route: '/settings'),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final String route;

  const DrawerTile({
    super.key,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
        if (currentRoute != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
