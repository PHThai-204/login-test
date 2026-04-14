import 'package:flutter/material.dart';
import 'package:login_test/core/themes/app_color.dart';


abstract class AppThemes {
  static OutlineInputBorder inputDefault = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.lightGrey),
    borderRadius: BorderRadius.circular(6),
  );

  static OutlineInputBorder inputFocused = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.darkOrange),
    borderRadius: BorderRadius.circular(6),
  );
}
