import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';

class UElevatedButtonTheme {
  UElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: UColors.light.primary,
      foregroundColor: UColors.light.accent,
      elevation: Usizes.buttonElevation,
      minimumSize: Size(Usizes.buttonWidth, Usizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Usizes.buttonRadius),
      ),
    ),
  );

  static ElevatedButtonThemeData darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: UColors.dark.primary,
      foregroundColor: UColors.dark.accent,
      elevation: Usizes.buttonElevation,
      minimumSize: Size(Usizes.buttonWidth, Usizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Usizes.buttonRadius),
      ),
    ),
  );
}
