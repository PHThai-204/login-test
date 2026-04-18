import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_test/core/services/biometric_service.dart';
import 'package:login_test/data/enums/status_enum.dart';
import 'package:login_test/data/local/secure_storage.dart';
import 'package:login_test/data/models/user_model.dart';
import 'package:login_test/data/repositories/auth_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository authRepository;
  final BiometricService biometricService;

  SplashCubit({required this.authRepository, BiometricService? biometricService})
    : biometricService = biometricService ?? BiometricService(),
      super(const SplashState());

  Future<void> syncData() async {
    try {
      await authRepository.syncLocalUpdatesToFirebase();
    } catch (e) {
      debugPrint('Sync Data Error: ${e.toString()}');
    }
  }

  Future<void> checkSession() async {
    emit(state.copyWith(status: StatusEnum.processing));
    try {
      final user = await authRepository.getCurrentSessionUser();

      if (user != null) {
        final isBiometricEnabled = await SecureStorage.getBiometricStatus();

        if (isBiometricEnabled) {
          final authenticated = await biometricService.authenticate();
          if (authenticated) {
            emit(state.copyWith(user: user, status: StatusEnum.success));
          } else {
            emit(state.copyWith(user: null, status: StatusEnum.failure));
          }
        } else {
          emit(state.copyWith(user: null, status: StatusEnum.success));
        }
      } else {
        emit(state.copyWith(user: null, status: StatusEnum.success));
      }
    } catch (e) {
      emit(state.copyWith(status: StatusEnum.failure));
      debugPrint('Session check error: ${e.toString()}');
    }
  }
}
