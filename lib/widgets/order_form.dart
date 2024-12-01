import 'package:flutter/material.dart';

class OrderForm extends StatelessWidget {
  final TextEditingController commentController;
  final TextEditingController addressController;
  final String selectedDeliveryType;

  const OrderForm({
    Key? key,
    required this.commentController,
    required this.addressController,
    required this.selectedDeliveryType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (selectedDeliveryType == 'delivery')
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Delivery Address',
                border: OutlineInputBorder(),
                hintText: 'Enter your delivery address',
              ),
              maxLines: 2,
            ),
          ),
        TextField(
          controller: commentController,
          decoration: const InputDecoration(
            labelText: 'Special Instructions',
            border: OutlineInputBorder(),
            hintText: 'Add any special instructions for your order',
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}