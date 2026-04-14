import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/themes/app_color.dart';
import '../login/cubit/login_cubit.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => BlocProvider(create: (context) => LoginCubit(), child: const LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/img_logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
