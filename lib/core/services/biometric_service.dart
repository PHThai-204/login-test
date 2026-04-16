import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics || !isSupported) return false;

      final bool authenticated = await _auth.authenticate(
        localizedReason: 'Xác thực sinh trắc học',
        biometricOnly: true,
      );
      return authenticated;
    } catch (e) {
      debugPrint('BBB: $e');
      return false;
    }
  }
}