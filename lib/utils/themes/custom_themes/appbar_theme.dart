import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';

class UAppBarTheme {
  UAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    elevation: 0,
    backgroundColor: UColors.light.background,
    foregroundColor: UColors.light.text,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: UColors.light.text,
      fontSize: Usizes.fontSizeLg,
      fontWeight: FontWeight.w600,
    ),
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    elevation: 0,
    backgroundColor: UColors.dark.background,
    foregroundColor: UColors.dark.text,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: UColors.dark.text,
      fontSize: Usizes.fontSizeLg,
      fontWeight: FontWeight.w600,
    ),
  );
}
