import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/user_settings.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/repositories/settings_repository.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';

class SettingsScreen extends StatefulWidget {
  final bool largeText;
  final ValueChanged<bool>? onLargeTextChanged;

  const SettingsScreen({
    super.key,
    this.largeText = false,
    this.onLargeTextChanged,
  });

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  bool _receiveNewsletter = false;
  String _confirmationMessage = '';
  bool _largeText = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _largeText = widget.largeText;
    _loadSettings();
  }

  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onLargeTextChanged != null &&
        oldWidget.largeText != widget.largeText) {
      _largeText = widget.largeText;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final User? currentUser = AuthRepository.instance.getCurrentUser();
    if (currentUser == null) {
      setState(() {
        _nameController.text = '';
        _addressController.text = '';
        _emailController.text = '';
        _receiveNewsletter = false;
        if (widget.onLargeTextChanged == null) {
          _largeText = false;
        }
      });
      return;
    }

    String nameText = '';
    String addressText = '';
    String emailText = '';
    bool newsletterValue = false;
    bool largeTextValue = false;

    final UserSettings? cloudSettings =
        await SettingsRepository.instance.loadSettings(currentUser.uid);
    if (cloudSettings != null) {
      nameText = cloudSettings.name;
      addressText = cloudSettings.address;
      emailText = cloudSettings.email;
      newsletterValue = cloudSettings.receiveNewsletter;
      largeTextValue = cloudSettings.largeText;
    }
    final String? authName = currentUser.displayName;
    if (nameText.isEmpty && authName != null && authName.isNotEmpty) {
      nameText = authName;
    }
    final String? authEmail = currentUser.email;
    if (emailText.isEmpty && authEmail != null && authEmail.isNotEmpty) {
      emailText = authEmail;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _nameController.text = nameText;
      _addressController.text = addressText;
      _emailController.text = emailText;
      _receiveNewsletter = newsletterValue;
      _largeText = largeTextValue;
    });
    final ValueChanged<bool>? onChanged = widget.onLargeTextChanged;
    if (onChanged != null) {
      onChanged(largeTextValue);
    }
  }

  Future<void> _saveSettings() async {
    final User? currentUser = AuthRepository.instance.getCurrentUser();
    if (currentUser == null) {
      setState(() {
        _confirmationMessage = 'Please log in to save your settings.';
      });
      return;
    }

    final String name = _nameController.text.trim();
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();

    final UserSettings settings = UserSettings(
      name: name,
      address: address,
      email: email,
      receiveNewsletter: _receiveNewsletter,
      largeText: _largeText,
    );

    await SettingsRepository.instance.saveSettings(currentUser.uid, settings);
    if (name.isNotEmpty) {
      await AuthRepository.instance.updateDisplayName(name);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _confirmationMessage = 'Settings saved for ${settings.name}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [BasketButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full name',
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Delivery address',
                hintText: 'Enter delivery address',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email address',
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              key: const Key('largeTextSwitch'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Bigger text'),
              subtitle: const Text('Make text easier to read'),
              value: _largeText,
              onChanged: (bool value) {
                setState(() {
                  _largeText = value;
                });
                final ValueChanged<bool>? onChanged = widget.onLargeTextChanged;
                if (onChanged != null) {
                  onChanged(value);
                }
              },
            ),
            Row(
              children: [
                const Expanded(child: Text('Receive newsletter and offers')),
                Switch(
                  key: const Key('newsletterSwitch'),
                  value: _receiveNewsletter,
                  onChanged: (bool value) {
                    setState(() {
                      _receiveNewsletter = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Save Settings',
                onPressed: _saveSettings,
              ),
            ),
            if (_confirmationMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _confirmationMessage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
