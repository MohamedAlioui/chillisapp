import 'package:flutter/material.dart';

class DeliveryOptions extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String?> onTypeChanged;

  const DeliveryOptions({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            RadioListTile(
              title: const Text('Pickup'),
              value: 'pickup',
              groupValue: selectedType,
              onChanged: onTypeChanged,
            ),
            RadioListTile(
              title: const Text('Delivery'),
              value: 'delivery',
              groupValue: selectedType,
              onChanged: onTypeChanged,
            ),
          ],
        ),
      ),
    );
  }
}