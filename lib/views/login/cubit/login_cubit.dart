import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/enums/status_enum.dart';
import '../../../data/local/secure_session_storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(const LoginState());

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
    emit(
      state.copyWith(
        showValidationErrors: true,
        faxCodeError: _validationFaxCode(state.faxCode),
        usernameError: _validationUsername(state.username),
        passwordError: _validationPassword(state.password),
      ),
    );

    if (_validationFaxCode(state.faxCode).isNotEmpty ||
        _validationUsername(state.username).isNotEmpty ||
        _validationPassword(state.password).isNotEmpty) {
      return;
    }

    emit(state.copyWith(status: StatusEnum.processing));

    try {
      final user = await authRepository.login(
        taxCode: state.faxCode.trim(),
        username: state.username.trim(),
        password: state.password.trim(),
      );

      await SecureSessionStorage.saveSession(username: user.username);

      emit(state.copyWith(status: StatusEnum.success, errorMessage: '', user: user));
    } catch (e) {
      emit(state.copyWith(status: StatusEnum.failure, errorMessage: e.toString()));
    }
  }

  String _validationFaxCode(String faxCode) {
    final value = faxCode.trim();
    if (value.isEmpty) {
      return 'fax_code_empty_error'.tr();
    }

    final regex = RegExp(r'^(?:\d{10}|\d{12}|\d{10}-\d{3})$');
    if (!regex.hasMatch(value)) {
      return 'fax_code_fail'.tr();
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

  void clearTaxCode() {
    emit(state.copyWith(faxCode: '', faxCodeError: ''));
  }

  void clearUsername() {
    emit(state.copyWith(username: '', usernameError: ''));
  }
}
