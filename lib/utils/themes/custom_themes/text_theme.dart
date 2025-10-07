import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';

// Custom Class for Light & Dark Text Themes
class UTextTheme {
  UTextTheme._(); // to avoid creating instances

  /// Light Theme
  static TextTheme darkTextTheme = TextTheme(
    // Headlines
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: UColors.dark.text,),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: UColors.dark.text,),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: UColors.dark.text,),

    // Titles
    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: UColors.dark.text,),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: UColors.dark.text,),
    titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: UColors.dark.text,),

    // Body
    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: UColors.dark.text,),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: UColors.dark.text,),
    bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: Colors.black54,),

    // Labels
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: UColors.dark.text,),
    labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: Colors.black54,),
  );

  /// Dark Theme
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: UColors.light.text,),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: UColors.light.text,),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: UColors.light.text,),

    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: UColors.light.text,),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: UColors.light.text,),
    titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: UColors.light.text,),

    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: UColors.light.text,),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: UColors.light.text,),
    bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: Colors.white70,),

    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: UColors.light.text,),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: Colors.white70,),
  );
}
