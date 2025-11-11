import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService}) : _authService = authService ?? AuthService();

  final AuthService _authService;

  User? _currentUser;
  bool _loading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }
}
