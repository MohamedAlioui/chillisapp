import 'package:flutter/material.dart';

class CartItem {
  final String id; // Unique identifier for the product
  final String title; // Product name
  final double price; // Product price
  final String image; // Image URL or asset path
  int quantity; // Product quantity in the cart

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  // Method to convert CartItem into JSON (useful for persistence or backend communication)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'quantity': quantity,
    };
  }

  // Factory to create CartItem from JSON (useful for loading data)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      quantity: json['quantity'] ?? 1,
    );
  }
}
