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
    ThemeData theme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.green,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    MaterialApp application = MaterialApp(
      title: 'Sandwich Shop',
      theme: theme,
      home: LandingPage(),
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
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    SnackBar bar = SnackBar(content: Text('Feature coming soon…'));
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
    PopupMenuItem<String> basketItem = PopupMenuItem<String>(
      value: 'basket',
      onTap: _handleAccountAction,
      child: Text('Basket'),
    );

    PopupMenuItem<String> accountItem = PopupMenuItem<String>(
      value: 'account',
      onTap: _handleAccountAction,
      child: Text('Account'),
    );

    PopupMenuItem<String> ordersItem = PopupMenuItem<String>(
      value: 'orders',
      onTap: _handleOrdersAction,
      child: Text('Orders'),
    );

    PopupMenuItem<String> logoutItem = PopupMenuItem<String>(
      value: 'logout',
      onTap: _handleLogoutAction,
      child: Text('Log out'),
    );

    return <PopupMenuEntry<String>>[
      basketItem,
      accountItem,
      ordersItem,
      logoutItem,
    ];
  }

  /// Builds the landing-page widget tree.
  @override
  Widget build(BuildContext context) {
    // Title shown in the AppBar.
    Text screenTitle = Text('Sandwich Shop', style: TextStyle(fontSize: 24));

    // Avatar icon displayed in the AppBar.
    CircleAvatar avatarIcon = CircleAvatar(
      backgroundColor: Colors.green,
      child: Icon(Icons.shopping_basket, size: 24),
    );

    // Primary action buttons.
    ElevatedButton selectMenuButton = ElevatedButton(
      onPressed: _handleSelectMenuPressed,
      child: Text('Select from the menu'),
    );

    ElevatedButton buildOwnButton = ElevatedButton(
      onPressed: _handleBuildOwnPressed,
      child: Text('Build your own sandwich'),
    );

    // Page scaffold.
    Scaffold page = Scaffold(
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
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[selectMenuButton, buildOwnButton],
        ),
      ),
    );

    return page;
  }
}
