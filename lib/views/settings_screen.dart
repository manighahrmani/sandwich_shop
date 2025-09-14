import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = 16.0;
      double? savedSize = prefs.getDouble('fontSize');
      
      if (savedSize != null) {
        _fontSize = savedSize;
      }

      _isLoading = false;
    });
  }

  Future<void> _saveFontSize(double fontSize) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
    setState(() {
      _fontSize = fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Font Size', style: heading2),
            const SizedBox(height: 10),
            Text(
              'Current size: ${_fontSize.toInt()}',
              style: TextStyle(fontSize: _fontSize),
            ),
            const SizedBox(height: 20),
            Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 6,
              label: _fontSize.toInt().toString(),
              onChanged: _saveFontSize,
            ),
            const SizedBox(height: 40),
            const Text(
              'This is sample text to preview the font size.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
