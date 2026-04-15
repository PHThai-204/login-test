import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String taxCodeId;
  final String passwordHash;
  final bool enabled;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.taxCodeId,
    required this.passwordHash,
    required this.enabled,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> data, String docId) {
    DateTime? updatedAt;
    if (data['updatedAt'] != null) {
      if (data['updatedAt'] is Timestamp) {
        updatedAt = (data['updatedAt'] as Timestamp).toDate();
      } else if (data['updatedAt'] is String) {
        updatedAt = DateTime.tryParse(data['updatedAt']);
      }
    }

    return UserModel(
      id: docId,
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '',
      taxCodeId: data['taxCodeId'] ?? '',
      passwordHash: data['passwordHash'] ?? '',
      enabled: data['enabled'] ?? false,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'taxCodeId': taxCodeId,
      'passwordHash': passwordHash,
      'enabled': enabled,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirebaseJson() {
    return {
      'username': username,
      'fullName': fullName,
      'taxCodeId': taxCodeId,
      'passwordHash': passwordHash,
      'enabled': enabled,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromCacheJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '',
      taxCodeId: data['taxCodeId'] ?? '',
      passwordHash: data['passwordHash'] ?? '',
      enabled: data['enabled'] ?? false,
      updatedAt: data['updatedAt'] != null ? DateTime.tryParse(data['updatedAt']) : null,
    );
  }
}
