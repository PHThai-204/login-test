import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_test/core/services/biometric_service.dart';
import 'package:login_test/core/themes/app_color.dart';
import 'package:login_test/core/themes/app_theme.dart';
import 'package:login_test/data/local/secure_storage.dart';
import 'package:login_test/data/models/user_model.dart';
import 'package:login_test/views/customs/dialog_custom.dart';
import 'package:login_test/views/login/login_screen.dart';

import '../../generated/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBiometricEnabled = false;
  final BiometricService _biometricService = BiometricService();

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final status = await SecureStorage.getBiometricStatus();
    setState(() {
      _isBiometricEnabled = status;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    final authenticated = await _biometricService.authenticate();
    if (authenticated) {
      await SecureStorage.saveBiometricStatus(value);
      setState(() {
        _isBiometricEnabled = value;
      });
    } else {
      debugPrint('Xác thực thất bại, không thay đổi cài đặt biometric');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text('home'.tr(), style: context.textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {
              showDialogCustom(
                context: context,
                title: 'confirm'.tr(),
                content: 'logout_question'.tr(),
                onCancel: () {},
                confirmText: 'confirm'.tr(),
                onConfirm: () async {
                  await SecureStorage.clearSession();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              );
            },
            icon: Assets.svgs.icExit.svg(
              colorFilter: const ColorFilter.mode(AppColors.darkOrange, BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile('username'.tr(), widget.user.username),
            const SizedBox(height: 16),
            _buildInfoTile('full_name'.tr(), widget.user.fullName),
            const SizedBox(height: 32),
            Text('setting'.tr(), style: context.textTheme.labelMedium),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: context.theme.cardColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.theme.colorScheme.outline),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Assets.svgs.icFingerprint.svg(
                        colorFilter: const ColorFilter.mode(AppColors.darkOrange, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 12),
                      Text('biometric_login'.tr(), style: context.theme.textTheme.labelMedium),
                    ],
                  ),
                  CupertinoSwitch(
                    activeTrackColor: AppColors.darkOrange,
                    value: _isBiometricEnabled,
                    onChanged: _toggleBiometric,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: context.theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
