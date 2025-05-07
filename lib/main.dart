import 'package:flutter/material.dart';

void main() {
  runApp(const SandwichShopApp());
}

/// Entry‑point widget for the sandwich‑shop application.
class SandwichShopApp extends StatelessWidget {
  const SandwichShopApp({super.key});

  /// Builds the root MaterialApp with a simple green theme and
  /// routes to the LandingPage.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.green,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    final MaterialApp application = MaterialApp(
      title: 'Sandwich Shop',
      theme: theme,
      home: const LandingPage(),
    );

    return application;
  }
}

/// First screen that offers the main choices.
///
/// A stateful widget is used so the handlers can access context
/// directly, avoiding anonymous (lambda) functions.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  /// Shows a standard feature‑not‑implemented SnackBar.
  void _showNotImplemented() {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final SnackBar bar = SnackBar(content: Text('Feature coming soon…'));
    messenger.showSnackBar(bar);
  }

  /// Called when "Select from the menu" is pressed.
  void _handleSelectMenuPressed() {
    _showNotImplemented();
  }

  /// Called when "Build your own sandwich" is pressed.
  void _handleBuildOwnPressed() {
    _showNotImplemented();
  }

  /// Responds to the "Account" menu item.
  void _handleAccountAction() {
    _showNotImplemented();
  }

  /// Responds to the "Orders" menu item.
  void _handleOrdersAction() {
    _showNotImplemented();
  }

  /// Responds to the "Log out" menu item.
  void _handleLogoutAction() {
    _showNotImplemented();
  }

  /// Builds the landing‑page user interface.
  @override
  Widget build(BuildContext context) {
    // App‑bar title.
    const Text screenTitle = Text(
      'Welcome to the Sandwich Shop',
      style: TextStyle(fontSize: 24),
    );

    // Avatar icon shown in the app‑bar.
    final CircleAvatar avatarIcon = CircleAvatar(
      backgroundColor: Colors.green,
      child: const Icon(Icons.fastfood, size: 24),
    );

    // Primary action buttons.
    final ElevatedButton selectMenuButton = ElevatedButton(
      onPressed: _handleSelectMenuPressed,
      child: const Text('Select from the menu'),
    );

    final ElevatedButton buildOwnButton = ElevatedButton(
      onPressed: _handleBuildOwnPressed,
      child: const Text('Build your own sandwich'),
    );

    // Drop‑down menu items for the account avatar.
    final PopupMenuItem<String> accountItem = PopupMenuItem<String>(
      value: 'account',
      onTap: _handleAccountAction,
      child: const Text('Account'),
    );

    final PopupMenuItem<String> ordersItem = PopupMenuItem<String>(
      value: 'orders',
      onTap: _handleOrdersAction,
      child: const Text('Orders'),
    );

    final PopupMenuItem<String> logoutItem = PopupMenuItem<String>(
      value: 'logout',
      onTap: _handleLogoutAction,
      child: const Text('Log out'),
    );

    // Assemble the scaffold.
    final Scaffold page = Scaffold(
      appBar: AppBar(
        title: screenTitle,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Account menu',
            icon: avatarIcon,
            itemBuilder:
                (BuildContext ctx) => [accountItem, ordersItem, logoutItem],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectMenuButton,
            const SizedBox(height: 16),
            buildOwnButton,
          ],
        ),
      ),
    );

    return page;
  }
}
