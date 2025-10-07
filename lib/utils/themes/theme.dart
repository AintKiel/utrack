import 'package:flutter/material.dart';
import 'package:utrack/utils/themes/custom_themes/appbar_theme.dart';
import 'package:utrack/utils/themes/custom_themes/bottom_sheet_theme.dart';
import 'package:utrack/utils/themes/custom_themes/checkbox_theme.dart';
import 'package:utrack/utils/themes/custom_themes/chip_theme.dart';
import 'package:utrack/utils/themes/custom_themes/elevated_button_theme.dart';
import 'package:utrack/utils/themes/custom_themes/text_field_theme.dart';
import 'package:utrack/utils/themes/custom_themes/outline_button_theme.dart';
import 'package:utrack/utils/themes/custom_themes/text_theme.dart';

class UAppTheme {
  UAppTheme._();

  /// 🌞 Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    // Custom Themes
    appBarTheme: UAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: UBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: UCheckboxTheme.lightCheckboxTheme,
    chipTheme: UChipTheme.lightChipTheme,
    elevatedButtonTheme: UElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: UOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: UTextFieldTheme.lightInputDecorationTheme,
    textTheme: UTextTheme.lightTextTheme,
    useMaterial3: true,
  );

  /// 🌙 Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    // Custom Themes
    appBarTheme: UAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: UBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: UCheckboxTheme.darkCheckboxTheme,
    chipTheme: UChipTheme.darkChipTheme,
    elevatedButtonTheme: UElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: UOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: UTextFieldTheme.darkInputDecorationTheme,
    textTheme: UTextTheme.darkTextTheme,
    useMaterial3: true,
  );
}
