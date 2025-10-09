import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';

class UChipTheme {
  UChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    backgroundColor: UColors.light.secondary.withOpacity(0.2),
    labelStyle: TextStyle(color: UColors.light.text, fontSize: Usizes.fontSizeSm),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Usizes.borderRadiusSm)),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    backgroundColor: UColors.dark.secondary.withOpacity(0.2),
    labelStyle: TextStyle(color: UColors.dark.text, fontSize: Usizes.fontSizeSm),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Usizes.borderRadiusSm)),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  );
}
