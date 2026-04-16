import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_test/views/customs/text_field_custom.dart';

import '../../../generated/assets.gen.dart';
import '../cubit/login_cubit.dart';

class TaxCodeInput extends StatefulWidget {
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  const TaxCodeInput({super.key, this.focusNode, this.onSubmitted});

  @override
  State<StatefulWidget> createState() => TaxCodeInputState();
}

class TaxCodeInputState extends State<TaxCodeInput> with SingleTickerProviderStateMixin {
  late AnimationController _animation;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    _animation = AnimationController(duration: const Duration(milliseconds: 360), vsync: this);
    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _animation, curve: Curves.easeOut));
    super.initState();
  }

  void trigger() {
    _animation.stop();
    _animation.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (p, c) => p.submitAttempt != c.submitAttempt,
      listener: (context, state) {
        if (state.showValidationErrors && state.taxCodeError.isNotEmpty) {
          trigger();
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) =>
            previous.taxCode != current.taxCode ||
            previous.taxCodeError != current.taxCodeError ||
            previous.showValidationErrors != current.showValidationErrors,
        builder: (context, state) {
          final taxCodeError = state.showValidationErrors ? state.taxCodeError : '';

          return TextFieldCustom(
            focusNode: widget.focusNode,
            inputType: TextInputType.number,
            textInputAction: TextInputAction.next,
            labelText: 'tax_code'.tr(),
            hintText: 'tax_code'.tr(),
            errorText: taxCodeError,
            onChanged: context.read<LoginCubit>().taxCodeChanged,
            onSubmitted: widget.onSubmitted,
            suffix: Assets.svgs.icCloseCircle.svg(),
            onClickSuffix: context.read<LoginCubit>().clearTaxCode,
            animation: _animation,
            offset: _offsetAnimation,
          );
        },
      ),
    );
  }
}
