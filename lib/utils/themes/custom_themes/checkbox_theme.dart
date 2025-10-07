import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';

class UCheckboxTheme {
  UCheckboxTheme._();

  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.all(UColors.light.primary),
    checkColor: MaterialStateProperty.all(UColors.light.accent),
  );

  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.all(UColors.dark.primary),
    checkColor: MaterialStateProperty.all(UColors.dark.accent),
  );
}
