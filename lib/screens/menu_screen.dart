import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';
import 'package:sandwich_shop/widgets/sandwich_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isMenuOpen = true;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  Widget _buildHeader() {
    final IconData toggleIcon;
    if (_isMenuOpen) {
      toggleIcon = Icons.expand_less;
    } else {
      toggleIcon = Icons.expand_more;
    }

    return Material(
      color: shopAccent,
      child: InkWell(
        onTap: _toggleMenu,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sandwich Menu', style: shopSectionTitleStyle),
              Icon(toggleIcon, color: shopText),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SandwichRepository repository = SandwichRepository();
    final List<Sandwich> sandwiches = repository.getSandwiches();

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
      ),
      drawer: const NavDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (_isMenuOpen)
            Expanded(
              child: ListView.builder(
                itemCount: sandwiches.length,
                itemBuilder: (BuildContext context, int index) {
                  return SandwichCard(sandwich: sandwiches[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}
