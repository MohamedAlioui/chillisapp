import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config.dart';
import '../models/panier.dart';
import '../models/commande.dart';

class CartService {
  Future<Panier> getPanierById(String panierId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.paniers}/$panierId'),
    );

    if (response.statusCode == 200) {
      return Panier.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {

      throw Exception('Failed to load panier $panierId +++');
    }
  }

  Future<Commande> createCommandeFromPanier(String panierId, Commande commande) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/commandes/from-panier/$panierId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(commande.toJson()),
    );

    if (response.statusCode == 201) {
      return Commande.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create commande');
    }
  }
}