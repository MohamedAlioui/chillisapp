import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/panier_item.dart';

class CartScreen extends StatelessWidget {
  final String userEmail;
  final String userName;
  final String userPhotoUrl;
  final String panierId; // Panier ID (cart ID)
  final String userId;   // User ID

  // Constructor to accept user info and panierId
  CartScreen({
    required this.userEmail,
    required this.userName,
    required this.userPhotoUrl,
    required this.panierId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Accessing the CartProvider to get cart items
    final cart = Provider.of<CartProvider>(context);
    final items = cart.cartItems; // Assuming cartItems is a list of PanierItem

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
        actions: [
          // Displaying user info in the AppBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(userPhotoUrl), // User's photo
            ),
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
        child: Text("Votre panier est vide."), // No items in cart
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: item.image.isNotEmpty
                        ? Image.network(
                      item.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.image_not_supported, size: 60),
                    title: Text(item.nom),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Prix : ${item.prixUnitaire.toStringAsFixed(2)} DT"),
                        Text("Quantité : ${item.quantity}"),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            // Decrease Quantity Button
                            IconButton(
                              onPressed: () {
                                if (item.quantity > 1) {
                                  cart.updateItemQuantity(item.menuItemId, item.quantity - 1);
                                }
                              },
                              icon: Icon(Icons.remove, color: Colors.red),
                            ),
                            Text(
                              '${item.quantity}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Increase Quantity Button
                            IconButton(
                              onPressed: () {
                                cart.updateItemQuantity(item.menuItemId, item.quantity + 1);
                              },
                              icon: Icon(Icons.add, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey),
                      onPressed: () => cart.removeItem(item.menuItemId), // Remove item from cart
                    ),
                  ),
                );
              },
            ),
          ),
          // Cart summary and total at the bottom
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${cart.totalAmount.toStringAsFixed(2)} DT', // Display total amount
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          // Order Button (To trigger the order logic)
          ElevatedButton(
            onPressed: () {
              print("Commander pressé");
              // Add your order logic here (like sending a request to your API to process the order).
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Commander',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
