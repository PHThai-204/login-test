class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String taxCodeId;
  final bool enabled;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.taxCodeId,
    required this.enabled,
  });

  factory UserModel.fromJson(Map<String, dynamic> data, String docId) {
    return UserModel(
      id: docId,
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '',
      taxCodeId: data['taxCodeId'] ?? '',
      enabled: data['enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'taxCodeId': taxCodeId,
      'enabled': enabled,
    };
  }
}

