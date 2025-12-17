import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/secure_storage.dart';
import '../objects/UserClass.dart';

class UserApi {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final SecureStorage _secureStorage = SecureStorage();

  Future<Map<String, String>> _getHeaders({bool withToken = true}) async {
    final headers = {'Content-Type': 'application/ld+json'};
    if (withToken) {
      final token = await _secureStorage.readToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<List<User>> fetchUsers() async {
    final url = "$baseUrl/users";
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> members = data['member'] ?? [];
      return members.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }
  }

  Future<int> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final String baseUrl = dotenv.env['API_BASE_URL']!;
    final uri = Uri.parse("$baseUrl/users");
    final body = json.encode({
      'prenom': firstName,
      'nom': lastName,
      'email': email,
      'password': password,
    });
    try {
      final response = await http.post(
        uri,
        headers: await _getHeaders(withToken: false),
        body: body,
      );
      if (response.statusCode == 201) {
        return 201;
      } else {
        print("Échec : ${response.statusCode}\nRéponse : ${response.body}");
        return response.statusCode;
      }
    } catch (e) {
      print("Exception lors de la requête : $e");
      return 0;
    }
  }

  Future<http.Response> login(String email, String password) async {
    // L'endpoint pour le login avec API Platform est souvent /authentication_token
    final url = "$baseUrl/authentication_token";
    final urlFull = Uri.parse(url);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});
    final response = await http.post(urlFull, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }
}
