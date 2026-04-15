import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_test/views/customs/text_field_custom.dart';

import '../../../core/themes/app_text_style.dart';
import '../../../generated/assets.gen.dart';
import '../cubit/login_cubit.dart';

class TaxInput extends StatelessWidget {
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const TaxInput({super.key, this.focusNode, this.textInputAction, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.faxCode != current.faxCode ||
          previous.faxCodeError != current.faxCodeError ||
          previous.showValidationErrors != current.showValidationErrors,
      builder: (context, state) {
        final faxCodeError = state.showValidationErrors ? state.faxCodeError : '';

        return TextFieldCustom(
          focusNode: focusNode,
          inputType: TextInputType.number,
          textInputAction: textInputAction,
          labelText: 'fax_code'.tr(),
          hintText: 'fax_code'.tr(),
          errorText: faxCodeError,
          onChanged: context.read<LoginCubit>().faxCodeChanged,
          onSubmitted: onSubmitted,
          textStyle: AppTextStyles.style.w600.s16.darianColor,
          suffix: Assets.svgs.icCloseCircle.svg(),
          onClickSuffix: context.read<LoginCubit>().clearTaxCode,
        );
      },
    );
  }
}
