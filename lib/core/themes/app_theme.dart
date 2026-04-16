import 'package:flutter/material.dart';
import 'package:login_test/core/themes/app_color.dart';

import 'app_text_style.dart';

abstract class AppThemes {
  static OutlineInputBorder inputDefault = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.lightGrey),
    borderRadius: BorderRadius.circular(6),
  );

  static OutlineInputBorder inputFocused = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.darkOrange),
    borderRadius: BorderRadius.circular(6),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.darkOrange,
    cardColor: AppColors.white,
    colorScheme: ColorScheme.light(
      primary: AppColors.darkOrange,
      outline: AppColors.lightGrey,
    ),
    textTheme: TextTheme(
      labelMedium: AppTextStyles.style.s16.w700.darkGrayColor,

      /// label
      titleSmall: AppTextStyles.style.s16.w600.darianColor,

      /// text
      titleMedium: AppTextStyles.style.s16.w600.whiteColor,

      /// hint
      displayMedium: AppTextStyles.style.s16.w600.orchalColor,

      /// error Text
      displaySmall: AppTextStyles.style.s12.w400.redColor,

      /// label small
      labelSmall: AppTextStyles.style.s12.w600.blackColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        disabledBackgroundColor: Colors.grey[400],
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
    primaryColor: AppColors.darkOrange,
    cardColor: AppColors.black,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkOrange,
      outline: AppColors.white,
    ),
    textTheme: TextTheme(
      labelMedium: AppTextStyles.style.s16.w700.whiteColor,
      titleSmall: AppTextStyles.style.s16.w600.lightGreyColor,
      titleMedium: AppTextStyles.style.s16.w600.blackColor,
      displayMedium: AppTextStyles.style.s16.w600.smokeWhiteColor,
      displaySmall: AppTextStyles.style.s12.w400.redColor,
      labelSmall: AppTextStyles.style.s12.w600.smokeWhiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        disabledBackgroundColor: Colors.grey[400],
      ),
    ),
  );
}

extension ThemeHelper on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);
}
