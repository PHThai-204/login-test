import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:login_test/core/themes/app_color.dart';
import 'package:login_test/core/themes/app_text_style.dart';

Future<void> showDialogCustom({
  required BuildContext context,
  required String title,
  required String content,
  required Function() onConfirm,
  String? confirmText,
  Function()? onCancel,
}) async {
  await showDialog(
    context: context,
    barrierColor: AppColors.black.withValues(alpha: 0.5),
    barrierDismissible: false,
    useSafeArea: true,
    builder: (context) => DialogCustom(
      title: title,
      content: content,
      onConfirm: onConfirm,
      confirmText: confirmText,
      onCancel: onCancel,
    ),
  );
}

class DialogCustom extends StatelessWidget {
  final String? title;
  final String? content;
  final String? confirmText;
  final Function() onConfirm;
  final VoidCallback? onCancel;

  const DialogCustom({
    super.key,
    this.title,
    this.content,
    this.confirmText,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null) ...[
            Text(
              title!,
              style: AppTextStyles.style.s18.w700.darkGrayColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
          if (content != null) ...[
            Text(
              content!,
              style: AppTextStyles.style.s16.w400.darianColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
          Row(
            children: [
              if (onCancel != null) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.lightGrey),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('cancel'.tr(), style: AppTextStyles.style.s16.w600.orchalColor),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkOrange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text(
                    confirmText ?? 'confirm'.tr(),
                    style: AppTextStyles.style.s16.w600.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
