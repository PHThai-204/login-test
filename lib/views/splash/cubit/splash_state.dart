part of 'splash_cubit.dart';

class SplashState {
  final StatusEnum status;
  final UserModel? user;

  const SplashState({this.user, this.status = StatusEnum.initial});

  SplashState copyWith({UserModel? user, StatusEnum? status}) {
    return SplashState(user: user ?? this.user, status: status ?? this.status);
  }
}
