import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/user_settings.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEditing = false;
  UserSettings _settings = const UserSettings(
    name: 'Student User',
    address: 'University of Portsmouth\nPortsmouth\nPO1 2UP',
    email: 'student@port.ac.uk',
    customerId: 'SS-1024',
    receiveNewsEmail: true,
  );

  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _customerIdController;
  bool _receiveNewsEmail = true;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: _settings.address);
    _emailController = TextEditingController(text: _settings.email);
    _customerIdController = TextEditingController(text: _settings.customerId);
    _receiveNewsEmail = _settings.receiveNewsEmail;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _customerIdController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    setState(() {
      _settings = _settings.copyWith(
        address: _addressController.text.trim(),
        email: _emailController.text.trim(),
        customerId: _customerIdController.text.trim(),
        receiveNewsEmail: _receiveNewsEmail,
      );
      _isEditing = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _addressController.text = _settings.address;
      _emailController.text = _settings.email;
      _customerIdController.text = _settings.customerId;
      _receiveNewsEmail = _settings.receiveNewsEmail;
      _isEditing = false;
    });
  }

  Widget _buildDisplayMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(_settings.address, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text(
          'Email Address',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(_settings.email, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text(
          'Customer ID',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(_settings.customerId, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text(
          'Preferences',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text('Receive news by email: '),
            Text(
              _settings.receiveNewsEmail ? 'Yes' : 'No',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          child: const Text('Edit Settings'),
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _addressController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter address',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Email Address',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter email address',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Customer ID',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _customerIdController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter customer ID',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Receive news by email'),
            Switch(
              value: _receiveNewsEmail,
              onChanged: (bool value) {
                setState(() {
                  _receiveNewsEmail = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            ElevatedButton(
              onPressed: _cancelEditing,
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget formContent;
    if (_isEditing) {
      formContent = _buildEditMode();
    } else {
      formContent = _buildDisplayMode();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
        backgroundColor: shopBrand,
        foregroundColor: shopWhite,
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Settings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            formContent,
          ],
        ),
      ),
    );
  }
}
