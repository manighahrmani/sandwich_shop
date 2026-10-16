import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/user_settings.dart';
import 'package:sandwich_shop/widgets/basket_button.dart';
import 'package:sandwich_shop/widgets/orders_button.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefName = 'user_name';
const String prefAddress = 'user_address';
const String prefEmail = 'user_email';
const String prefNewsletter = 'user_newsletter';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
  bool _nameEdited = false;
  bool _addressEdited = false;
  bool _emailEdited = false;
  bool _newsletterEdited = false;
  bool _savingSettings = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedName = prefs.getString(prefName);
      final String? savedAddress = prefs.getString(prefAddress);
      final String? savedEmail = prefs.getString(prefEmail);
      final bool? savedNewsletter = prefs.getBool(prefNewsletter);

      String name = '';
      if (savedName != null) {
        name = savedName;
      }

      String address = '';
      if (savedAddress != null) {
        address = savedAddress;
      }

      String email = '';
      if (savedEmail != null) {
        email = savedEmail;
      }

      bool newsletter = false;
      if (savedNewsletter != null) {
        newsletter = savedNewsletter;
      }

      if (mounted) {
        setState(() {
          if (!_nameEdited) {
            _nameController.text = name;
          }
          if (!_addressEdited) {
            _addressController.text = address;
          }
          if (!_emailEdited) {
            _emailController.text = email;
          }
          if (!_newsletterEdited) {
            _receiveNewsletter = newsletter;
          }
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _confirmationMessage = 'Could not load settings: $error';
        });
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_savingSettings) {
      return;
    }
    final String name = _nameController.text.trim();
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final bool receiveNewsletter = _receiveNewsletter;
    setState(() {
      _savingSettings = true;
      _confirmationMessage = 'Saving settings...';
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool nameSaved = await prefs.setString(prefName, name);
      final bool addressSaved = await prefs.setString(prefAddress, address);
      final bool emailSaved = await prefs.setString(prefEmail, email);
      final bool newsletterSaved = await prefs.setBool(
        prefNewsletter,
        receiveNewsletter,
      );
      if (!nameSaved || !addressSaved || !emailSaved || !newsletterSaved) {
        throw StateError('The preferences could not be stored');
      }

      final UserSettings settings = UserSettings(
        name: name,
        address: address,
        email: email,
        receiveNewsletter: receiveNewsletter,
      );

      if (mounted) {
        setState(() {
          _confirmationMessage = 'Settings saved for ${settings.name}';
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _confirmationMessage = 'Could not save settings: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _savingSettings = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        actions: const [OrdersButton(), BasketButton()],
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
              onChanged: (String value) {
                _nameEdited = true;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full name',
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              onChanged: (String value) {
                _addressEdited = true;
              },
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
              onChanged: (String value) {
                _emailEdited = true;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email address',
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Text('Receive newsletter and offers')),
                Switch(
                  value: _receiveNewsletter,
                  onChanged: (bool value) {
                    setState(() {
                      _receiveNewsletter = value;
                      _newsletterEdited = true;
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
                onPressed: _savingSettings ? null : _saveSettings,
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
