import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_test/views/customs/text_field_custom.dart';

import '../../../core/themes/app_text_style.dart';
import '../../../generated/assets.gen.dart';
import '../cubit/login_cubit.dart';

class TaxCodeInput extends StatelessWidget {
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const TaxCodeInput({super.key, this.focusNode, this.textInputAction, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.taxCode != current.taxCode ||
          previous.taxCodeError != current.taxCodeError ||
          previous.showValidationErrors != current.showValidationErrors,
      builder: (context, state) {
        final taxCodeError = state.showValidationErrors ? state.taxCodeError : '';

        return TextFieldCustom(
          focusNode: focusNode,
          inputType: TextInputType.number,
          textInputAction: textInputAction,
          labelText: 'tax_code'.tr(),
          hintText: 'tax_code'.tr(),
          errorText: taxCodeError,
          onChanged: context.read<LoginCubit>().taxCodeChanged,
          onSubmitted: onSubmitted,
          suffix: Assets.svgs.icCloseCircle.svg(),
          onClickSuffix: context.read<LoginCubit>().clearTaxCode,
        );
      },
    );
  }
}
