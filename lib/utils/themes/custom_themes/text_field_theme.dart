import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';

class UTextFieldTheme {
  UTextFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    filled: false,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Usizes.inputFieldRadius),
      borderSide: BorderSide(color: UColors.light.primary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Usizes.inputFieldRadius),
      borderSide: BorderSide(color: UColors.light.accent, width: 2),
    ),
    labelStyle: TextStyle(color: UColors.light.text, fontSize: Usizes.fontSizeSm),
    hintStyle: TextStyle(color: UColors.light.text.withOpacity(0.6)),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    filled: false,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Usizes.inputFieldRadius),
      borderSide: BorderSide(color: UColors.dark.primary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Usizes.inputFieldRadius),
      borderSide: BorderSide(color: UColors.dark.accent, width: 2),
    ),
    labelStyle: TextStyle(color: UColors.dark.text, fontSize: Usizes.fontSizeSm),
    hintStyle: TextStyle(color: UColors.dark.text.withOpacity(0.6)),
  );
}
