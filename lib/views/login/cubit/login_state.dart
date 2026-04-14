part of 'login_cubit.dart';

class LoginState {
  final String faxCode;
  final String username;
  final String password;
  final bool isPasswordVisible;
  final bool showValidationErrors;
  final String faxCodeError;
  final String usernameError;
  final String passwordError;
  final StatusEnum status;
  final String errorMessage;
  final UserModel? user;

  const LoginState({
    this.faxCode = '',
    this.username = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.showValidationErrors = false,
    this.faxCodeError = '',
    this.usernameError = '',
    this.passwordError = '',
    this.status = StatusEnum.initial,
    this.errorMessage = '',
    this.user,
  });

  LoginState copyWith({
    String? faxCode,
    String? username,
    String? password,
    bool? isPasswordVisible,
    bool? showValidationErrors,
    String? faxCodeError,
    String? usernameError,
    String? passwordError,
    StatusEnum? status,
    String? errorMessage,
    UserModel? user,
  }) {
    return LoginState(
      faxCode: faxCode ?? this.faxCode,
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      faxCodeError: faxCodeError ?? this.faxCodeError,
      usernameError: usernameError ?? this.usernameError,
      passwordError: passwordError ?? this.passwordError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}
