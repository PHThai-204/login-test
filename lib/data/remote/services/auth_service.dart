import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_test/data/models/user_model.dart';
import 'dart:convert';
import 'package:cryptography/cryptography.dart' show Hmac, Pbkdf2, SecretKey;

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> login({
    required String taxCode,
    required String username,
    required String password,
  }) async {
    try {
      final query = await _firestore
          .collection('accounts')
          .where('taxCodeId', isEqualTo: taxCode)
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw AuthException('Thông tin đăng nhập không hợp lệ');
      }

      final userDoc = query.docs.first;
      final userData = userDoc.data();
      final user = UserModel.fromJson(userData, userDoc.id);

      if (!user.enabled) {
        throw AuthException('Tài khoản đã bị khóa');
      }

      final passwordHash = userData['passwordHash'] as String;
      final hashedInput = await _validatePassword(password);
      if (hashedInput != passwordHash) {
        throw AuthException('Mật khẩu không chính xác');
      }

      return user;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Lỗi đăng nhập: $e');
    }
  }

  Future<String> _validatePassword(String password) async {
    final pbkdf2 = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 100000, bits: 256);

    final secretKey = SecretKey(utf8.encode(password));

    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: utf8.encode('test-demo-app_login'),
    );

    final bytes = await newSecretKey.extractBytes();

    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
