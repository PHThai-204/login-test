import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class AppUtils {
  static Future<String> validatePassword(String password) async {
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