import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginSession {
  final String username;
  final DateTime loggedInAt;

  const LoginSession({required this.username, required this.loggedInAt});

  Map<String, dynamic> toJson() {
    return {'username': username, 'loggedInAt': loggedInAt.toIso8601String()};
  }

  factory LoginSession.fromJson(Map<String, dynamic> json) {
    return LoginSession(
      username: json['username'] as String? ?? '',
      loggedInAt: DateTime.tryParse(json['loggedInAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class SecureStorage {
  static const _sessionKey = 'auth_session';
  static const _biometricKey = 'biometric_enabled';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveSession({required String username}) async {
    final session = LoginSession(username: username, loggedInAt: DateTime.now());
    await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
  }

  static Future<LoginSession?> getSession() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      final session = LoginSession.fromJson(decoded);
      if (session.username.trim().isEmpty) {
        return null;
      }
      return session;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearSession() async {
    await _storage.delete(key: _sessionKey);
  }

  static Future<void> saveBiometricStatus(bool isEnabled) async {
    await _storage.write(key: _biometricKey, value: isEnabled.toString());
  }

  static Future<bool> getBiometricStatus() async {
    final raw = await _storage.read(key: _biometricKey);
    return raw == 'true';
  }
}
