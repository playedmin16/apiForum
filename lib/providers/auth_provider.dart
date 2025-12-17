import 'package:flutter/material.dart';
import 'package:api_forum/utils/secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  final SecureStorage _secureStorage = SecureStorage();

  String? get token => _token;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _secureStorage.readToken().then((token) {
      _token = token;
      notifyListeners();
    });
  }

  void login(String token) {
    _token = token;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _secureStorage.deleteCredentials();
    notifyListeners();
  }
}
