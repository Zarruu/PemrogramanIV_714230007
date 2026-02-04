import 'dart:convert';

class AppUser {
  final String username;
  final String password;
  final String name;
  final String email;
  final String role; // 'admin' or 'user'
  final String photoUrl;
  final DateTime createdAt;

  AppUser({
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    this.role = 'user',
    this.photoUrl = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  AppUser copyWith({
    String? username,
    String? password,
    String? name,
    String? email,
    String? role,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return AppUser(
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'name': name,
    'email': email,
    'role': role,
    'photoUrl': photoUrl,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    username: json['username'],
    password: json['password'],
    name: json['name'],
    email: json['email'],
    role: json['role'] ?? 'user',
    photoUrl: json['photoUrl'] ?? '',
    createdAt: DateTime.parse(json['createdAt']),
  );

  static String encode(List<AppUser> users) =>
      json.encode(users.map((u) => u.toJson()).toList());

  static List<AppUser> decode(String usersJson) =>
      (json.decode(usersJson) as List).map((u) => AppUser.fromJson(u)).toList();
}
