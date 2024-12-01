// lib/models/panier_item.dart
class PanierItem {
  final String menuItemId;
  final String nom;
  final double prixUnitaire;
  late final int quantity;
  final double subTotal;
  final String image;

  PanierItem({
    required this.menuItemId,
    required this.nom,
    required this.prixUnitaire,
    required this.quantity,
    required this.subTotal,
    required this.image

  });

  factory PanierItem.fromJson(Map<String, dynamic> json) {
    return PanierItem(
      menuItemId: json['menuItemId'],
      nom: json['nom'],
      prixUnitaire: json['prixUnitaire'].toDouble(),
      quantity: json['quantity'],
      subTotal: json['subTotal'].toDouble(),
      image: '',
    );
  }
}
