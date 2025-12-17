import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/secure_storage.dart';
import '../objects/MessageClass.dart';

class MessageApi {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final SecureStorage _secureStorage = SecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _secureStorage.readToken();
    if (token != null) {
      return {'Authorization': 'Bearer $token'};
    }
    return {};
  }

  Future<List<Message>> fetchMessages() async {
    final url = "$baseUrl/messages";
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> members = data['member'] ?? [];
      return members.map((item) => Message.fromJson(item)).toList();
    } else {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }
  }
}
