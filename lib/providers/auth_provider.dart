import 'package:flutter/material.dart';
import 'package:api_forum/utils/secure_storage.dart';
import 'package:api_forum/api/userApi.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _nom;
  String? _prenom;
  final SecureStorage _secureStorage = SecureStorage();

  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoggedIn => isAuthenticated;
  String? get nom => _nom;
  String? get prenom => _prenom;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await _secureStorage.readToken();
    if (_token != null) {
      await _loadUser();
    }
    notifyListeners();
  }

  Future<void> _loadUser() async {
    try {
      final userData = await UserApi().getUser();
      _nom = userData['nom'];
      _prenom = userData['prenom'];
    } catch (e) {
      // Ignore error, maybe token invalid
    }
  }

  Future<void> login(String token) async {
    _token = token;
    await _secureStorage.saveToken(token);
    await _loadUser();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _nom = null;
    _prenom = null;
    _secureStorage.deleteCredentials();
    notifyListeners();
  }
}
