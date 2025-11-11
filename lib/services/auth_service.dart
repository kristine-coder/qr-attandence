import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class AuthService {
  AuthService({
    ApiService? apiService,
    FlutterSecureStorage? secureStorage,
  })  : _apiService = apiService ?? ApiService(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage;

  Future<User> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final response = await _apiService.post(ApiConstants.login, body: {
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    });

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final token = json['accessToken'] as String?;
    final refreshToken = json['refreshToken'] as String?;

    if (token == null) {
      throw const AuthException('Missing access token');
    }

    await _secureStorage.write(key: StorageKeys.accessToken, value: token);

    if (refreshToken != null) {
      await _secureStorage.write(key: StorageKeys.refreshToken, value: refreshToken);
    }

    if (rememberMe) {
      await _secureStorage.write(key: StorageKeys.rememberMe, value: 'true');
    } else {
      await _secureStorage.delete(key: StorageKeys.rememberMe);
    }

    final userJson = json['user'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return User.fromJson(userJson);
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
    await _secureStorage.delete(key: StorageKeys.rememberMe);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: StorageKeys.accessToken);
  }
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => 'AuthException(message: $message)';
}
