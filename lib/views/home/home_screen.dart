import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:login_test/core/themes/app_color.dart';
import 'package:login_test/core/themes/app_text_style.dart';
import 'package:login_test/data/local/secure_session_storage.dart';
import 'package:login_test/data/models/user_model.dart';
import 'package:login_test/views/customs/dialog_custom.dart';
import 'package:login_test/views/login/login_screen.dart';

import '../../generated/assets.gen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'home'.tr(),
          style: AppTextStyles.style.s18.w700.darkGrayColor,
        ),
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
                  await SecureSessionStorage.clearSession();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
              );
            },
            icon: Assets.svgs.icExit.svg(
              colorFilter: const ColorFilter.mode(
                AppColors.darkOrange,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile('username'.tr(), user.username),
            const SizedBox(height: 16),
            _buildInfoTile('full_name'.tr(), user.fullName),
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
        color: AppColors.lightGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.style.s14.w400.orchalColor),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.style.s16.w600.darkGrayColor),
        ],
      ),
    );
  }
}
