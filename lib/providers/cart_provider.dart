import 'package:flutter/material.dart';
import '../models/panier_item.dart';

class CartProvider with ChangeNotifier {
  // Cart items are stored as a Map with item IDs as keys and PanierItem objects as values
  Map<String, PanierItem> _cartItems = {};

  // Returns a list of cart items
  List<PanierItem> get cartItems => _cartItems.values.toList();

  // Calculates the total amount of the cart
  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((key, item) {
      total += item.prixUnitaire * item.quantity; // Using unit price and quantity for total
    });
    return total;
  }

  // Add an item to the cart
  void addItem(PanierItem item) {
    if (_cartItems.containsKey(item.menuItemId)) {
      // If item already exists in the cart, update its quantity
      _cartItems.update(
        item.menuItemId,
            (existingItem) => PanierItem(
          menuItemId: existingItem.menuItemId, // Use menuItemId
          prixUnitaire: existingItem.prixUnitaire, // Use prixUnitaire for unit price
          quantity: existingItem.quantity + item.quantity, // Add the new quantity to the existing one
          nom: existingItem.nom, subTotal: 0, image: '', // Use nom for the name
        ),
      );
    } else {
      // If item doesn't exist, add it to the cart
      _cartItems.putIfAbsent(item.menuItemId, () => item);
    }
    notifyListeners();  // Notify listeners (UI will be updated)
  }

  // Update the quantity of an item
  void updateItemQuantity(String menuItemId, int quantity) {
    if (_cartItems.containsKey(menuItemId)) {
      // If item exists, update its quantity
      _cartItems.update(
        menuItemId,
            (existingItem) => PanierItem(
          menuItemId: existingItem.menuItemId,
          nom: existingItem.nom,
          prixUnitaire: existingItem.prixUnitaire,
          quantity: quantity, subTotal: 0, image: '',
              // Update the quantity
        ),
      );
      notifyListeners();  // Notify listeners
    }
  }

  // Remove an item from the cart
  void removeItem(String menuItemId) {
    _cartItems.remove(menuItemId);  // Remove the item from the cart using its menuItemId
    notifyListeners();  // Notify listeners
  }

  // Clear all items from the cart
  void clearCart() {
    _cartItems = {};  // Clear the cart
    notifyListeners();  // Notify listeners
  }
}
