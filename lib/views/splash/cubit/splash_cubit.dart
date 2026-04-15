import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_test/data/enums/status_enum.dart';
import 'package:login_test/data/models/user_model.dart';
import 'package:login_test/data/repositories/auth_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository authRepository;

  SplashCubit({required this.authRepository}) : super(const SplashState());

  Future<void> syncData() async {
    try {
      await authRepository.syncLocalUpdatesToFirebase();
    } catch (e) {
      debugPrint('Lỗi sync data: ${e.toString()}');
    }
  }

  Future<void> checkSession() async {
    emit(state.copyWith(status: StatusEnum.processing));
    try {
      final user = await authRepository.getCurrentSessionUser();
      emit(state.copyWith(user: user, status: StatusEnum.success));
    } catch (e) {
      emit(state.copyWith(status: StatusEnum.failure));
      debugPrint('Lỗi check sesstion: ${e.toString()}');
    }
  }
}
