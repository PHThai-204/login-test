import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/biometric_service.dart';
import '../../../data/enums/status_enum.dart';
import '../../../data/local/secure_storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final biometric = BiometricService();

  LoginCubit({required this.authRepository}) : super(const LoginState());

  void taxCodeChanged(String taxCode) {
    final taxCodeError = _validationTaxCode(taxCode);
    emit(state.copyWith(taxCode: taxCode, taxCodeError: taxCodeError));
  }

  void onUsernameChanged(String username) {
    final usernameError = _validationUsername(username);
    emit(state.copyWith(username: username, usernameError: usernameError));
  }

  void onPasswordChanged(String password) {
    final passwordError = _validationPassword(password);
    emit(state.copyWith(password: password, passwordError: passwordError));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login() async {
    emit(
      state.copyWith(
        submitAttempt: state.submitAttempt + 1,
        showValidationErrors: true,
        taxCodeError: _validationTaxCode(state.taxCode),
        usernameError: _validationUsername(state.username),
        passwordError: _validationPassword(state.password),
      ),
    );

    debugPrint('BBB: ${state.taxCode}');

    if (state.taxCodeError.trim().isNotEmpty ||
        state.usernameError.trim().isNotEmpty ||
        state.passwordError.trim().isNotEmpty) {
      return;
    }

    emit(state.copyWith(status: StatusEnum.processing));
    try {
      final user = await authRepository.login(
        taxCode: state.taxCode.trim(),
        username: state.username.trim(),
        password: state.password.trim(),
      );

      await SecureStorage.saveSession(username: user.username);

      emit(state.copyWith(status: StatusEnum.success, errorMessage: '', user: user));
    } catch (e) {
      emit(state.copyWith(status: StatusEnum.failure, errorMessage: e.toString()));
    }
  }

  String _validationTaxCode(String taxCode) {
    final value = taxCode.trim();
    if (value.isEmpty) {
      return 'tax_code_empty_error'.tr();
    }

    final regex = RegExp(r'^(?:\d{10}|\d{12}|\d{10}-\d{3})$');
    if (!regex.hasMatch(value)) {
      return 'tax_code_fail'.tr();
    }

    return '';
  }

  String _validationUsername(String username) {
    final value = username.trim();
    if (value.isEmpty) {
      return 'username_empty_error'.tr();
    } else {
      return '';
    }
  }

  String _validationPassword(String password) {
    final value = password.trim();
    if (value.isEmpty) {
      return 'password_empty_error'.tr();
    } else if (value.length > 50) {
      return 'password_fail'.tr();
    } else if (value.length < 6) {
      return 'password_fail'.tr();
    } else {
      return '';
    }
  }

  void clearTaxCode() {
    emit(state.copyWith(taxCode: '', taxCodeError: ''));
  }

  void clearUsername() {
    emit(state.copyWith(username: '', usernameError: ''));
  }

  void authenticate() async {
    final authenticated = await biometric.authenticate();
    if (authenticated) {
      debugPrint('BBB: OK');
    } else {
      debugPrint('BBB: Fail');
    }
  }
}
