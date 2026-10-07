import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/models/order_options.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';
import 'package:sandwich_shop/widgets/nav_drawer.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';
import 'package:sandwich_shop/widgets/section_card.dart';

class CustomiseOrderScreen extends StatefulWidget {
  const CustomiseOrderScreen({super.key});

  @override
  State<CustomiseOrderScreen> createState() {
    return _CustomiseOrderScreenState();
  }
}

class _CustomiseOrderScreenState extends State<CustomiseOrderScreen> {
  late TextEditingController _noteController;
  bool _nutFree = false;
  bool _glutenFree = false;
  bool _noOnions = false;
  String _confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveOptions() {
    final OrderOptions options = OrderOptions(
      kitchenNote: _noteController.text.trim(),
      nutFree: _nutFree,
      glutenFree: _glutenFree,
      noOnions: _noOnions,
    );
    CartRepository.instance.setOptions(options);
    setState(() {
      _confirmationMessage =
          'Saved. These choices will be added to your next order.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appTitle, style: shopHeaderStyle)),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customise order', style: shopSectionTitleStyle),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Note for the kitchen',
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add any notes for the kitchen',
                ),
              ),
            ),
            SectionCard(
              title: 'Allergy options',
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Nut free'),
                    value: _nutFree,
                    onChanged: (bool value) {
                      setState(() {
                        _nutFree = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Gluten free'),
                    value: _glutenFree,
                    onChanged: (bool value) {
                      setState(() {
                        _glutenFree = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('No onions'),
                    value: _noOnions,
                    onChanged: (bool value) {
                      setState(() {
                        _noOnions = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Save choices',
                onPressed: _saveOptions,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
