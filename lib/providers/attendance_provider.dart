import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/attendance_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class AttendanceProvider extends ChangeNotifier {
  AttendanceProvider({ApiService? apiService, AuthService? authService})
      : _apiService = apiService ?? ApiService(),
        _authService = authService ?? AuthService();

  final ApiService _apiService;
  final AuthService _authService;

  final List<AttendanceRecord> _records = [];
  bool _loading = false;
  String? _error;

  List<AttendanceRecord> get records => List.unmodifiable(_records);
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> fetchHistory() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _authService.getToken();
      final response = await _apiService.get(
        ApiConstants.attendanceHistory,
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );
      final json = jsonDecode(response.body) as List<dynamic>;
      _records
        ..clear()
        ..addAll(json.map((item) => AttendanceRecord.fromJson(item as Map<String, dynamic>)));
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> submitAttendance(String code) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _authService.getToken();
      final response = await _apiService.post(
        ApiConstants.attendance,
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        body: {'sessionCode': code},
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final record = AttendanceRecord.fromJson(json['attendance'] as Map<String, dynamic>);
      _records.removeWhere((existing) => existing.id == record.id);
      _records.insert(0, record);
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadDemoData() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final today = DateTime.now();
      final day0 = DateTime(today.year, today.month, today.day);
      final day1 = day0.subtract(const Duration(days: 1));
      final day2 = day0.subtract(const Duration(days: 4));
      final day3 = day0.subtract(const Duration(days: 7));

      _records
        ..clear()
        ..addAll([
          AttendanceRecord(
            id: 'demo-1',
            courseName: 'Mobile Development',
            room: 'C-120',
            lectureDate: day1,
            checkedAt: day1.add(const Duration(hours: 9, minutes: 5)),
            status: AttendanceStatus.present,
          ),
          AttendanceRecord(
            id: 'demo-2',
            courseName: 'Software Engineering',
            room: 'B-204',
            lectureDate: day2,
            checkedAt: day2.add(const Duration(hours: 8, minutes: 55)),
            status: AttendanceStatus.late,
          ),
          AttendanceRecord(
            id: 'demo-3',
            courseName: 'Discrete Mathematics',
            room: 'A-101',
            lectureDate: day3,
            checkedAt: null,
            status: AttendanceStatus.absent,
          ),
        ]);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
