import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
  static const String login = '/login';
  static const String attendance = '/attendance';
  static const String attendanceHistory = '/attendance/history';
  static const String profile = '/user/profile';
  static const String validateSession = '/attendance/validate';
}

class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String rememberMe = 'remember_me';
}

class AppColors {
  static const Color primary = Color(0xFF2F80ED);
  static const Color accent = Color(0xFF56CCF2);
  static const Color present = Color(0xFF88D66C);
  static const Color absent = Color(0xFFE57373);
  static const Color late = Color(0xFFF2C94C);
}

class AppPadding {
  static const double screen = 16;
  static const double card = 12;
}

class AppDurations {
  static const Duration snackbar = Duration(seconds: 3);
  static const Duration tokenExpiryBuffer = Duration(minutes: 5);
}
