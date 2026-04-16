import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_test/views/customs/text_field_custom.dart';

import '../../../generated/assets.gen.dart';
import '../cubit/login_cubit.dart';

class PasswordInput extends StatefulWidget {
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  const PasswordInput({super.key, this.focusNode, this.onSubmitted});

  @override
  State<StatefulWidget> createState() => PasswordInputState();
}

class PasswordInputState extends State<PasswordInput> with SingleTickerProviderStateMixin {
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
        if (state.showValidationErrors && state.passwordError.isNotEmpty) {
          trigger();
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) =>
            previous.isPasswordVisible != current.isPasswordVisible ||
            previous.password != current.password ||
            previous.passwordError != current.passwordError ||
            previous.showValidationErrors != current.showValidationErrors,
        builder: (context, state) {
          final passwordError = state.showValidationErrors ? state.passwordError : '';

          return TextFieldCustom(
            focusNode: widget.focusNode,
            hintText: 'password'.tr(),
            labelText: 'password'.tr(),
            errorText: passwordError,
            inputType: state.isPasswordVisible ? TextInputType.text : TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            alwaysShowSuffix: true,
            isPasswordField: true,
            autofillHints: const [AutofillHints.password],
            onChanged: (value) => context.read<LoginCubit>().onPasswordChanged(value),
            onSubmitted: widget.onSubmitted,
            suffix: state.isPasswordVisible
                ? Assets.svgs.icEyeOpen.svg()
                : Assets.svgs.icEyeClose.svg(),
            onClickSuffix: context.read<LoginCubit>().togglePasswordVisibility,
            animation: _animation,
            offset: _offsetAnimation,
          );
        },
      ),
    );
  }
}
