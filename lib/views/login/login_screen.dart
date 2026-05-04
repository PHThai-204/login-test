import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:login_test/core/di/injection.dart';
import 'package:login_test/data/enums/status_enum.dart';
import 'package:login_test/views/customs/dialog_custom.dart';
import 'package:login_test/views/home/home_screen.dart';

import '../../core/themes/app_text_style.dart';
import '../../core/themes/app_theme.dart';
import '../../generated/assets.gen.dart';
import 'components/password_input.dart';
import 'components/tax_code_input.dart';
import 'components/username_input.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginState();
}

class _LoginState extends State<LoginView> {
  late final FocusNode _taxFocusNode;
  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _taxFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => current.status != previous.status,
          listener: (context, state) {
            if (state.status.isSuccess) {
              if (state.user != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen(user: state.user!)),
                );
              }
            } else if (state.status.isFailure) {
              showDialogCustom(
                context: context,
                title: 'Thông báo',
                content: state.errorMessage,
                confirmText: 'close'.tr(),
                onConfirm: () {
                  Navigator.of(context).pop();
                },
              );
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AutofillGroup(
                child: Column(
                  children: [
                    const SizedBox(height: 34),
                    Align(alignment: Alignment.centerLeft, child: Assets.images.imgLogo.image()),
                    const SizedBox(height: 24),
                    TaxCodeInput(
                      focusNode: _taxFocusNode,
                      onSubmitted: (_) => FocusScope.of(context).requestFocus(_usernameFocusNode),
                    ),
                    const SizedBox(height: 10),
                    UsernameInput(
                      focusNode: _usernameFocusNode,
                      onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                    ),
                    const SizedBox(height: 10),
                    PasswordInput(
                      focusNode: _passwordFocusNode,
                      onSubmitted: (_) => context.read<LoginCubit>().login(),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (previous, current) => previous.status != current.status,
                      builder: (context, state) {
                        final isLoading = state.status.isProcessing;
                        return SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : context.read<LoginCubit>().login,
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'login'.tr(),
                                    style: AppTextStyles.style.s16.w600.whiteColor,
                                  ),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: _BottomActionItem(
                            icon: Assets.svgs.icHeadphone.svg(),
                            label: 'help'.tr(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _BottomActionItem(
                            icon: Assets.svgs.icSocialLink.svg(),
                            label: 'group'.tr(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _BottomActionItem(
                            icon: Assets.svgs.icSearchNormal.svg(),
                            label: 'search'.tr(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomActionItem extends StatelessWidget {
  final Widget icon;
  final String label;

  const _BottomActionItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.theme.colorScheme.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 6),
          Text(label, style: context.textTheme.labelSmall),
        ],
      ),
    );
  }
}
