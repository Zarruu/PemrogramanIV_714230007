import 'dart:convert';

class Adoption {
  final String? id;
  final String petId;
  final String petName;
  final String petImageUrl;
  final String applicantUsername; // Track which user submitted
  final String applicantName;
  final String applicantPhone;
  final String applicantEmail;
  final String applicantAddress;
  final String reason;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;

  Adoption({
    this.id,
    required this.petId,
    required this.petName,
    required this.petImageUrl,
    required this.applicantUsername,
    required this.applicantName,
    required this.applicantPhone,
    required this.applicantEmail,
    required this.applicantAddress,
    required this.reason,
    this.status = 'pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Adoption copyWith({
    String? id,
    String? petId,
    String? petName,
    String? petImageUrl,
    String? applicantUsername,
    String? applicantName,
    String? applicantPhone,
    String? applicantEmail,
    String? applicantAddress,
    String? reason,
    String? status,
    DateTime? createdAt,
  }) {
    return Adoption(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      petName: petName ?? this.petName,
      petImageUrl: petImageUrl ?? this.petImageUrl,
      applicantUsername: applicantUsername ?? this.applicantUsername,
      applicantName: applicantName ?? this.applicantName,
      applicantPhone: applicantPhone ?? this.applicantPhone,
      applicantEmail: applicantEmail ?? this.applicantEmail,
      applicantAddress: applicantAddress ?? this.applicantAddress,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'petName': petName,
    'petImageUrl': petImageUrl,
    'applicantUsername': applicantUsername,
    'applicantName': applicantName,
    'applicantPhone': applicantPhone,
    'applicantEmail': applicantEmail,
    'applicantAddress': applicantAddress,
    'reason': reason,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Adoption.fromJson(Map<String, dynamic> json) => Adoption(
    id: json['id'],
    petId: json['petId'],
    petName: json['petName'],
    petImageUrl: json['petImageUrl'],
    applicantUsername: json['applicantUsername'],
    applicantName: json['applicantName'],
    applicantPhone: json['applicantPhone'],
    applicantEmail: json['applicantEmail'],
    applicantAddress: json['applicantAddress'],
    reason: json['reason'],
    status: json['status'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  static String encode(List<Adoption> adoptions) =>
      json.encode(adoptions.map((a) => a.toJson()).toList());

  static List<Adoption> decode(String adoptionsJson) =>
      (json.decode(adoptionsJson) as List).map((a) => Adoption.fromJson(a)).toList();
}
