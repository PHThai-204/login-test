part of 'login_cubit.dart';

class LoginState {
  final String taxCode;
  final String username;
  final String password;
  final bool isPasswordVisible;
  final bool showValidationErrors;
  final String taxCodeError;
  final String usernameError;
  final String passwordError;
  final StatusEnum status;
  final String errorMessage;
  final UserModel? user;

  const LoginState({
    this.taxCode = '',
    this.username = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.showValidationErrors = false,
    this.taxCodeError = '',
    this.usernameError = '',
    this.passwordError = '',
    this.status = StatusEnum.initial,
    this.errorMessage = '',
    this.user,
  });

  LoginState copyWith({
    String? taxCode,
    String? username,
    String? password,
    bool? isPasswordVisible,
    bool? showValidationErrors,
    String? taxCodeError,
    String? usernameError,
    String? passwordError,
    StatusEnum? status,
    String? errorMessage,
    UserModel? user,
  }) {
    return LoginState(
      taxCode: taxCode ?? this.taxCode,
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      taxCodeError: taxCodeError ?? this.taxCodeError,
      usernameError: usernameError ?? this.usernameError,
      passwordError: passwordError ?? this.passwordError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}
