import 'package:flutter/material.dart';

/// Main entry file for the Sandwich Shop Flutter application.
///
/// Runs [SandwichShopApp].
void main() {
  runApp(const SandwichShopApp());
}

/// Root widget for the Sandwich Shop application.
class SandwichShopApp extends StatelessWidget {
  const SandwichShopApp({super.key});

  /// Builds the root [MaterialApp] with a simple green theme whose
  /// home page is [LandingPage].
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

/// First screen that offers the main user actions.
///
/// A [StatefulWidget] is used so callback methods can access
/// [BuildContext] directly.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  /// Shows a generic *feature coming soon* [SnackBar].
  void _showNotImplemented() {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final SnackBar bar = const SnackBar(content: Text('Feature coming soon…'));
    messenger.showSnackBar(bar);
  }

  /// Handles presses on *Select from the menu*.
  void _handleSelectMenuPressed() {
    _showNotImplemented();
  }

  /// Handles presses on *Build your own sandwich*.
  void _handleBuildOwnPressed() {
    _showNotImplemented();
  }

  /// Handles the *Account* menu item.
  void _handleAccountAction() {
    _showNotImplemented();
  }

  /// Handles the *Orders* menu item.
  void _handleOrdersAction() {
    _showNotImplemented();
  }

  /// Handles the *Log out* menu item.
  void _handleLogoutAction() {
    _showNotImplemented();
  }

  /// Builds the list of account popup-menu entries.
  List<PopupMenuEntry<String>> _buildAccountMenu(BuildContext context) {
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

    return <PopupMenuEntry<String>>[accountItem, ordersItem, logoutItem];
  }

  /// Builds the landing-page widget tree.
  @override
  Widget build(BuildContext context) {
    // Title shown in the AppBar.
    const Text screenTitle = Text(
      'Sandwich Shop',
      style: TextStyle(fontSize: 24),
    );

    // Avatar icon displayed in the AppBar.
    final CircleAvatar avatarIcon = CircleAvatar(
      backgroundColor: Colors.green,
      child: const Icon(Icons.shopping_basket, size: 24),
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

    // Page scaffold.
    final Scaffold page = Scaffold(
      appBar: AppBar(
        title: screenTitle,
        actions: <Widget>[
          PopupMenuButton<String>(
            tooltip: 'Account menu',
            icon: avatarIcon,
            itemBuilder: _buildAccountMenu,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
