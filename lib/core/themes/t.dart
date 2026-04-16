// import 'package:flutter/material.dart';
//
// import 'app_color.dart';
//
// class AppTheme {
//   // Light Theme
//   static ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: AppColors.primary,
//       brightness: Brightness.light,
//     ),
//     useMaterial3: true,
//     scaffoldBackgroundColor: AppColors.light,
//     primaryColor: AppColors.primary,
//
//     primaryColorLight: AppColors.greyRim,
//     primaryColorDark: AppColors.lightRim,
//     secondaryHeaderColor: AppColors.grey,
//
//     appBarTheme: AppBarTheme(
//       backgroundColor: AppColors.light,
//       foregroundColor: AppColors.black,
//       elevation: 0,
//     ),
//
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: AppColors.light,
//       selectedItemColor: AppColors.primary,
//       unselectedItemColor: AppColors.grey,
//     ),
//
//     dialogTheme: DialogTheme(
//       backgroundColor: AppColors.light,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       titleTextStyle: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: AppColors.black,
//       ),
//       contentTextStyle: TextStyle(color: AppColors.black),
//     ),
//
//     textTheme: const TextTheme(
//         bodySmall: TextStyle(color: AppColors.black),
//         bodyLarge: TextStyle(
//           color: AppColors.black,
//           fontSize: 24,
//           fontWeight: FontWeight.w900,
//         ),
//         bodyMedium: TextStyle(color: AppColors.grey)
//     ),
//
//     iconTheme: IconThemeData(color: AppColors.black, size: 24),
//
//     textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.black),
//
//     inputDecorationTheme: InputDecorationTheme(
//       errorStyle: TextStyle(color: AppColors.error, fontSize: 11, height: 0),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: AppColors.primary),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: AppColors.lightRim),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: AppColors.error),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: AppColors.error),
//       ),
//     ),
//
//     extensions: [
//       ButtonStyles(
//         primary: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(40),
//           ),
//         ),
//         secondary: OutlinedButton.styleFrom(
//           backgroundColor: AppColors.light,
//           foregroundColor: AppColors.black,
//           side: const BorderSide(color: AppColors.black),
//         ),
//         thirth: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.black,
//           foregroundColor: AppColors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(40),
//           ),
//         ),
//       ),
//     ],
//   );
//
//   // Dark Theme
//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: AppColors.primary,
//       brightness: Brightness.dark,
//     ),
//     useMaterial3: true,
//     scaffoldBackgroundColor: AppColors.dark,
//     primaryColor: AppColors.primary,
//
//     primaryColorLight: AppColors.grayRim,
//     primaryColorDark: AppColors.darkRim,
//     secondaryHeaderColor: AppColors.gray,
//
//     appBarTheme: AppBarTheme(
//       backgroundColor: AppColors.dark,
//       foregroundColor: AppColors.white,
//       elevation: 0,
//     ),
//
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: AppColors.dark,
//       selectedItemColor: AppColors.primary,
//       unselectedItemColor: AppColors.gray,
//     ),
//
//     dialogTheme: DialogTheme(
//       backgroundColor: AppColors.light,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       titleTextStyle: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: AppColors.black,
//       ),
//       contentTextStyle: TextStyle(color: AppColors.black),
//     ),
//
//     textTheme: const TextTheme(
//         bodySmall: TextStyle(color: AppColors.white),
//         bodyLarge: TextStyle(
//           color: AppColors.white,
//           fontSize: 24,
//           fontWeight: FontWeight.w900,
//         ),
//         bodyMedium: TextStyle(color: AppColors.gray)
//     ),
//
//     iconTheme: IconThemeData(color: AppColors.white, size: 24),
//
//     textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.white),
//
//     inputDecorationTheme: InputDecorationTheme(
//       errorStyle: TextStyle(color: AppColors.error, fontSize: 11, height: 0),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: AppColors.darkRim),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: AppColors.primary),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: AppColors.error),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: AppColors.error),
//       ),
//     ),
//
//     extensions: [
//       ButtonStyles(
//         primary: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.black,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(40),
//           ),
//         ),
//         secondary: OutlinedButton.styleFrom(
//           backgroundColor: AppColors.dark,
//           foregroundColor: AppColors.white,
//           side: BorderSide(color: AppColors.grey),
//         ),
//         thirth: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.white,
//           foregroundColor: AppColors.black,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(40),
//           ),
//         ),
//       ),
//     ],
//   );
// }