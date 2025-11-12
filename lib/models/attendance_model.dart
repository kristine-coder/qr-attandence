enum AttendanceStatus { present, absent, late }

class AttendanceRecord {
  final String id;
  final String courseName;
  final String room;
  final DateTime lectureDate;
  final DateTime? checkedAt;
  final AttendanceStatus status;

  const AttendanceRecord({
    required this.id,
    required this.courseName,
    required this.room,
    required this.lectureDate,
    required this.checkedAt,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    AttendanceStatus parseStatus(String? value) {
      switch (value) {
        case 'present':
          return AttendanceStatus.present;
        case 'late':
          return AttendanceStatus.late;
        default:
          return AttendanceStatus.absent;
      }
    }

    return AttendanceRecord(
      id: json['id']?.toString() ?? '',
      courseName: json['courseName'] ?? '',
      room: json['room'] ?? '',
      lectureDate: DateTime.tryParse(json['lectureDate'] ?? '') ?? DateTime.now(),
      checkedAt: json['checkedAt'] != null
          ? DateTime.tryParse(json['checkedAt'])
          : null,
      status: parseStatus(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    String statusToString(AttendanceStatus status) {
      return switch (status) {
        AttendanceStatus.present => 'present',
        AttendanceStatus.late => 'late',
        AttendanceStatus.absent => 'absent',
      };
    }

    return {
      'id': id,
      'courseName': courseName,
      'room': room,
      'lectureDate': lectureDate.toIso8601String(),
      'checkedAt': checkedAt?.toIso8601String(),
      'status': statusToString(status),
    };
  }
}
