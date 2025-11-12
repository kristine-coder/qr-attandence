class User {
  final String id;
  final String email;
  final String fullName;
  final String faculty;
  final String avatarUrl;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.faculty,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? json['name'] ?? '',
      faculty: json['faculty'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'faculty': faculty,
      'avatarUrl': avatarUrl,
    };
  }
}
