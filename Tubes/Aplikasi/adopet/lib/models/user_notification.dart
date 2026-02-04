import 'dart:convert';

class UserNotification {
  final String id;
  final String username; // Target user
  final String title;
  final String message;
  final String type; // 'approved', 'rejected'
  final String petName;
  final DateTime createdAt;
  final bool isRead;

  UserNotification({
    required this.id,
    required this.username,
    required this.title,
    required this.message,
    required this.type,
    required this.petName,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  UserNotification copyWith({
    String? id,
    String? username,
    String? title,
    String? message,
    String? type,
    String? petName,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return UserNotification(
      id: id ?? this.id,
      username: username ?? this.username,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      petName: petName ?? this.petName,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'title': title,
    'message': message,
    'type': type,
    'petName': petName,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
  };

  factory UserNotification.fromJson(Map<String, dynamic> json) => UserNotification(
    id: json['id'],
    username: json['username'],
    title: json['title'],
    message: json['message'],
    type: json['type'],
    petName: json['petName'],
    createdAt: DateTime.parse(json['createdAt']),
    isRead: json['isRead'] ?? false,
  );

  static String encode(List<UserNotification> notifications) =>
      json.encode(notifications.map((n) => n.toJson()).toList());

  static List<UserNotification> decode(String notificationsJson) =>
      (json.decode(notificationsJson) as List).map((n) => UserNotification.fromJson(n)).toList();
}
