import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';

class UOutlinedButtonTheme {
  UOutlinedButtonTheme._();

  static OutlinedButtonThemeData lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: UColors.light.primary,
      side: BorderSide(color: UColors.light.primary),
      minimumSize: Size(Usizes.buttonWidth, Usizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Usizes.buttonRadius),
      ),
    ),
  );

  static OutlinedButtonThemeData darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: UColors.dark.primary,
      side: BorderSide(color: UColors.dark.primary),
      minimumSize: Size(Usizes.buttonWidth, Usizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Usizes.buttonRadius),
      ),
    ),
  );
}
