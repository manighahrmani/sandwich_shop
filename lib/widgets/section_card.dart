import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: shopWhite,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: shopSectionTitleStyle),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
