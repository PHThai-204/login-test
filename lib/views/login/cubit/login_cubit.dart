import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/remote/services/auth_service.dart';
import '../../../data/enums/status_enum.dart';
import '../../../data/models/user_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService authService;

  LoginCubit({AuthService? authService})
      : authService = authService ?? AuthService(),
        super(const LoginState());

  void faxCodeChanged(String faxCode) {
    final faxCodeError = _validationFaxCode(faxCode);
    emit(state.copyWith(faxCode: faxCode, faxCodeError: faxCodeError));
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
    // Validate all fields first
    emit(
      state.copyWith(
        showValidationErrors: true,
        faxCodeError: _validationFaxCode(state.faxCode),
        usernameError: _validationUsername(state.username),
        passwordError: _validationPassword(state.password),
      ),
    );

    // If any validation failed, stop here
    if (_validationFaxCode(state.faxCode).isNotEmpty ||
        _validationUsername(state.username).isNotEmpty ||
        _validationPassword(state.password).isNotEmpty) {
      return;
    }

    // All validations passed, proceed to login
    emit(state.copyWith(status: StatusEnum.processing));

    try {
      final user = await authService.login(
        taxCode: state.faxCode,
        username: state.username,
        password: state.password,
      );

      emit(state.copyWith(
        status: StatusEnum.success,
        errorMessage: '',
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StatusEnum.failure,
        errorMessage: e.toString(),
      ));
    }
  }

   String _validationFaxCode(String faxCode) {
    final value = faxCode.trim();
    if (value.isEmpty) {
      return 'email_empty_error'.tr();
    } else if (value.length > 50) {
      return 'email_too_long_error'.tr();
    } else if (value.length < 6) {
      return 'email_too_short_error'.tr();
    } else {
      return '';
    }
  }

  String _validationUsername(String username) {
    final value = username.trim();
    if (value.isEmpty) {
      return 'username_empty_error'.tr();
    } else {
      return '';
    }
  }

  String _validationPassword(String email) {
    final value = email.trim();
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
}
