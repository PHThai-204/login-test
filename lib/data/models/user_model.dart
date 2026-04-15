import 'package:cloud_firestore/cloud_firestore.dart';class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String taxCode;
  final String passwordHash;
  final bool enabled;
  final DateTime? updatedAt;
  final int failedAttempts;
  final DateTime? lockUntil;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.taxCode,
    required this.passwordHash,
    required this.enabled,
    this.updatedAt,
    this.failedAttempts = 0,
    this.lockUntil,
  });

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  factory UserModel.fromJson(Map<String, dynamic> data, String docId) {
    return UserModel(
      id: docId,
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '',
      taxCode: data['taxCode'] ?? '',
      passwordHash: data['passwordHash'] ?? '',
      enabled: data['enabled'] ?? false,
      failedAttempts: data['failedAttempts'] ?? 0,
      updatedAt: _parseDateTime(data['updatedAt']),
      lockUntil: _parseDateTime(data['lockUntil']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'taxCodeId': taxCode,
      'passwordHash': passwordHash,
      'enabled': enabled,
      'failedAttempts': failedAttempts,
      'updatedAt': updatedAt?.toIso8601String(),
      'lockUntil': lockUntil?.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirebaseJson() {
    return {
      'username': username,
      'fullName': fullName,
      'taxCodeId': taxCode,
      'passwordHash': passwordHash,
      'enabled': enabled,
      'failedAttempts': failedAttempts,
      'updatedAt': FieldValue.serverTimestamp(),
      'lockUntil': lockUntil != null ? Timestamp.fromDate(lockUntil!) : null,
    };
  }

  factory UserModel.fromCacheJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '',
      taxCode: data['taxCodeId'] ?? '',
      passwordHash: data['passwordHash'] ?? '',
      enabled: data['enabled'] ?? false,
      failedAttempts: data['failedAttempts'] ?? 0,
      updatedAt: _parseDateTime(data['updatedAt']),
      lockUntil: _parseDateTime(data['lockUntil']),
    );
  }
}