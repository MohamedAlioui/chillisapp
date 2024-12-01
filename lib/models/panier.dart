// lib/models/panier.dart
import 'panier_item.dart';

class Panier {
  final String clientId;
  final String? id;
  final List<PanierItem> items;
  double total;

  Panier({
    required this.clientId,
    required this.id,
    required this.items,
    required this.total,
  });

  factory Panier.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List;
    List<PanierItem> itemsList =
    itemList.map((item) => PanierItem.fromJson(item)).toList();
    return Panier(
      clientId: json['clientId'],
      id: json['id'],
      items: itemsList,
      total: json['total']?.toDouble() ?? 0.0,
    );
  }
}
