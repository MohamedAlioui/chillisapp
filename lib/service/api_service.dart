// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chilisfinal/models/panier.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Panier?> fetchPanierById(String panierId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/paniers/$panierId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Panier.fromJson(data);
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      throw Exception('Failed to fetch panier: $e');
    }
  }
}
