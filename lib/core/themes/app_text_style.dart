import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_test/core/themes/app_color.dart';


abstract class AppTextStyles {
  static TextStyle style = GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
}

extension FontWeightCustom on TextStyle {
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);

  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);

  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);

  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);

  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);

  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);

  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);
}

extension FontSizeCustom on TextStyle {
  TextStyle get s10 => copyWith(fontSize: 10);

  TextStyle get s11 => copyWith(fontSize: 11);

  TextStyle get s12 => copyWith(fontSize: 12);

  TextStyle get s13 => copyWith(fontSize: 13);

  TextStyle get s14 => copyWith(fontSize: 14);

  TextStyle get s15 => copyWith(fontSize: 15);

  TextStyle get s16 => copyWith(fontSize: 16);

  TextStyle get s17 => copyWith(fontSize: 17);

  TextStyle get s18 => copyWith(fontSize: 18);

  TextStyle get s19 => copyWith(fontSize: 19);  
}

extension FontColorCustom on TextStyle {
  TextStyle get whiteColor => copyWith(color: AppColors.white);

  TextStyle get blackColor => copyWith(color: AppColors.black);

  TextStyle get darkGrayColor => copyWith(color: AppColors.darkGrey);

  TextStyle get orchalColor => copyWith(color: AppColors.orchal);

  TextStyle get darianColor => copyWith(color: AppColors.darian);
}