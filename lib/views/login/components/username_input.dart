import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_test/views/customs/text_field_custom.dart';

import '../../../core/themes/app_text_style.dart';
import '../../../generated/assets.gen.dart';
import '../cubit/login_cubit.dart';

class UsernameInput extends StatelessWidget {
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const UsernameInput({super.key, this.focusNode, this.textInputAction, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.username != current.username ||
          previous.usernameError != current.usernameError ||
          previous.showValidationErrors != current.showValidationErrors,
      builder: (context, state) {
        final usernameError = state.showValidationErrors ? state.usernameError : '';

        return TextFieldCustom(
          focusNode: focusNode,
          hintText: 'account'.tr(),
          labelText: 'account'.tr(),
          errorText: usernameError,
          onChanged: context.read<LoginCubit>().onUsernameChanged,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          textStyle: AppTextStyles.style.w600.s16.darianColor,
          suffix: Assets.svgs.icCloseCircle.svg(),
          onClickSuffix: context.read<LoginCubit>().clearUsername,
        );
      }
    );
  }
}
