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
    try {
      final id = json['id'] as String;
      final clientId = json['clientId'] as String;
      final items = (json['items'] as List?)
          ?.map((item) => PanierItem.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [];
      final total = (json['total'] as num?)?.toDouble() ?? 0.0;

      print('Deserialized Panier: id=$id, clientId=$clientId, total=$total');
      return Panier(
        id: id,
        clientId: clientId,
        items: items,
        total: total,
      );
    } catch (e, stackTrace) {
      print('Error deserializing Panier: $e\n$stackTrace');
      throw Exception('Failed to deserialize Panier: ${e.toString()}');
    }
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