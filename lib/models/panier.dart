import 'panier_item.dart';

class Panier {
  final String id;
  final String clientId;
  final List<PanierItem> items;
  final double total;

  Panier({
    required this.id,
    required this.clientId,
    required this.items,
    required this.total,
  });

  factory Panier.fromJson(Map<String, dynamic> json) {
    return Panier(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      items: (json['items'] as List).map((item) => PanierItem.fromJson(item as Map<String, dynamic>)).toList(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}