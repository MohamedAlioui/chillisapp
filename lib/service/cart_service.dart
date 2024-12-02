import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config.dart';
import '../models/panier.dart';
import '../models/commande.dart';
import '../models/panier_item.dart';

class CartService {
  Future<Panier> getPanierById(String panierId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.paniers}/$panierId'),
    );

    if (response.statusCode == 200) {
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      print('Decoded Response: $decodedResponse'); // Debugging
      return Panier.fromJson(decodedResponse);
    } else {
      throw Exception('Failed to load panier $panierId');
    }
  }

  Future<Commande> createCommandeFromPanier(
      String panierId, Commande commande) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/commandes/from-panier/$panierId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(commande.toJson()),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}'); // Debugging

      if (response.statusCode == 200) {
        return Commande.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create commande: ${response.body}');
      }
    } catch (e) {
      print('Error in createCommandeFromPanier: $e');
      throw Exception('Failed to create commande: $e');
    }
  }

  Future<void> addItemToCart(PanierItem item) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.paniers}/add-item'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add item to cart');
    }
  }
}
