import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config.dart';
import '../utils/http_exception.dart';

class UserService {
  Future<String> fetchUserPanierId(String userId) async {
    try {
      print('Fetching user data from: ${ApiConfig.clients}/$userId');
      final response = await http.get(Uri.parse('${ApiConfig.clients}/$userId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);

        // Safely access panierId and handle potential null or invalid types
        final panierId = userData['panierId'];

        if (panierId == null) {
          throw HttpException('User does not have an active cart');
        }

        // Convert to string regardless of original type
        return panierId.toString();
      } else {
        throw HttpException(
            'Failed to fetch user data',
            response.statusCode
        );
      }
    } catch (e) {
      if (e is HttpException) {
        rethrow;
      }
      throw HttpException('Error fetching user data: ${e.toString()}');
    }
  }
}