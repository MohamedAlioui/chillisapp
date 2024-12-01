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
    return PanierItem(
      menuItemId: json['menuItemId'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'quantity': quantity,
      'price': price,
      'name': name,
    };
  }
}