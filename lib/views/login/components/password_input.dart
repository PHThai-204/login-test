import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_test/core/themes/app_text_style.dart';
import 'package:login_test/views/customs/text_field_custom.dart';

import '../../../generated/assets.gen.dart';
import '../cubit/login_cubit.dart';

class PasswordInput extends StatelessWidget {
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const PasswordInput({super.key, this.focusNode, this.textInputAction, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.isPasswordVisible != current.isPasswordVisible ||
          previous.password != current.password ||
          previous.passwordError != current.passwordError ||
          previous.showValidationErrors != current.showValidationErrors,
      builder: (context, state) {
        final passwordError = state.showValidationErrors ? state.passwordError : '';

        return TextFieldCustom(
          focusNode: focusNode,
          hintText: 'password'.tr(),
          labelText: 'password'.tr(),
          errorText: passwordError,
          inputType: state.isPasswordVisible ? TextInputType.text : TextInputType.visiblePassword,
          textInputAction: textInputAction,
          alwaysShowSuffix: true,
          isPasswordField: true,
          onChanged: (value) => context.read<LoginCubit>().onPasswordChanged(value) ,
          onSubmitted: onSubmitted,
          textStyle: AppTextStyles.style.w600.s16.darianColor,
          suffix: state.isPasswordVisible
              ? Assets.svgs.icEyeOpen.svg()
              : Assets.svgs.icEyeClose.svg(),
          onClickSuffix: context.read<LoginCubit>().togglePasswordVisibility,
        );
      },
    );
  }
}
