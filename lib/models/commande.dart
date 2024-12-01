import 'package:chilisfinal/models/panier_item.dart';

class Commande {
  final String? idCommande;
  final String clientId;
  final List<PanierItem> items;
  final double total;
  final String localisationResto;
  final String etat;
  final String typeCommande;
  final String commentaire;
  final String adresseLivraison;

  Commande({
    this.idCommande,
    required this.clientId,
    required this.items,
    required this.total,
    required this.localisationResto,
    required this.etat,
    required this.typeCommande,
    required this.commentaire,
    required this.adresseLivraison,
  });

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      idCommande: json['idCommande'] as String?,
      clientId: json['clientId'] as String,
      items: (json['items'] as List).map((item) => PanierItem.fromJson(item as Map<String, dynamic>)).toList(),
      total: (json['total'] as num).toDouble(),
      localisationResto: json['localisationResto'] as String,
      etat: json['etat'] as String,
      typeCommande: json['typeCommande'] as String,
      commentaire: json['commentaire'] as String,
      adresseLivraison: json['adresseLivraison'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCommande': idCommande,
      'clientId': clientId,
      'items': items.map((item) => item?.toJson()).toList(),
      'total': total,
      'localisationResto': localisationResto,
      'etat': etat,
      'typeCommande': typeCommande,
      'commentaire': commentaire,
      'adresseLivraison': adresseLivraison,
    };
  }
}