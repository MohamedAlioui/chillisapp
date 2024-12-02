class PanierItem {
  final String menuItemId;
  final int quantity;
  final double price;
  final String name;

  PanierItem({
    required this.menuItemId,
    required this.quantity,
    required this.price,
    required this.name,
  });

  double get subTotal => price * quantity;

  factory PanierItem.fromJson(Map<String, dynamic> json) {
    try {
      final menuItemId = json['menuItemId'] as String? ?? '';
      final quantity = json['quantity'] as int? ?? 0;
      final price = (json['prixUnitaire'] as num?)?.toDouble() ?? 0.0; // Map prixUnitaire to price
      final name = json['nom'] as String? ?? 'Unnamed Item'; // Map nom to name

      print('Deserialized PanierItem: $menuItemId, $quantity, $price, $name');
      return PanierItem(
        menuItemId: menuItemId,
        quantity: quantity,
        price: price,
        name: name,
      );
    } catch (e, stackTrace) {
      print('Error deserializing PanierItem: $e\n$stackTrace');
      throw Exception('Failed to deserialize PanierItem: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'quantity': quantity,
      'price': price, // Map back to prixUnitaire if needed
      'name': name,   // Map back to nom if needed
    };
  }
}