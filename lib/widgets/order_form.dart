import 'package:flutter/material.dart';

class OrderForm extends StatelessWidget {
  final TextEditingController commentController;
  final TextEditingController addressController;
  final String selectedDeliveryType;
  final List<String>? restaurantLocations;

  const OrderForm({
    Key? key,
    required this.commentController,
    required this.addressController,
    required this.selectedDeliveryType,
    this.restaurantLocations, // Add this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedDeliveryType == 'pickup')
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select Restaurant Location',
            ),
            items: restaurantLocations
                ?.map((location) => DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    ))
                .toList(),
            onChanged: (value) {
              // Handle restaurant location change
              print('Selected Restaurant Location: $value');
            },
          ),
        if (selectedDeliveryType == 'delivery')
          TextFormField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Delivery Address',
            ),
          ),
        TextFormField(
          controller: commentController,
          decoration: const InputDecoration(
            labelText: 'Comment',
          ),
        ),
      ],
    );
  }
}
