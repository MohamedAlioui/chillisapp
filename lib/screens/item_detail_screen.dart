// lib/screens/item_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';

class ItemDetailScreen extends StatefulWidget {
  final MenuItem menuItem;

  ItemDetailScreen({required this.menuItem});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1; // Initial quantity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.nom),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image or fallback icon
            widget.menuItem.image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.menuItem.image!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : Icon(Icons.image_not_supported, size: 250, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              widget.menuItem.nom,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(widget.menuItem.description),
            SizedBox(height: 16),
            Text(
              "Prix: ${widget.menuItem.prix} DT",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 20),
            // Quantity management
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                  icon: Icon(Icons.remove, color: Colors.red),
                ),
                Text('$_quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: Icon(Icons.add, color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Add item to the cart with selected quantity

                // Show a SnackBar to confirm the addition
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.menuItem.nom} ajouté au panier avec $_quantity unités !'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              label: Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
