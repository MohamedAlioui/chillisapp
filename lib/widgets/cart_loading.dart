import 'package:flutter/material.dart';

class CartLoading extends StatelessWidget {
  const CartLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading cart...'),
        ],
      ),
    );
  }
}