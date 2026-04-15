import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_test/core/di/injection.dart';
import 'package:login_test/data/enums/status_enum.dart';

import '../../core/themes/app_color.dart';
import '../../generated/assets.gen.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(authRepository: getIt())
        ..syncData()
        ..checkSession(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isProcessing) {
            return;
          }
          if (state.user != null && state.user!.enabled && state.status.isSuccess) {
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(user: state.user!)));
          } else if (state.status.isSuccess || state.status.isFailure) {
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Center(child: Assets.images.imgLogo.image()),
        ),
      ),
    );
  }
}
