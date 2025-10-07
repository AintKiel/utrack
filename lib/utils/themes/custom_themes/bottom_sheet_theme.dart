import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';

class UBottomSheetTheme {
  UBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: UColors.light.background,
    modalBackgroundColor: UColors.light.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Usizes.borderRadiusLg)),
    ),
  );

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: UColors.dark.background,
    modalBackgroundColor: UColors.dark.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Usizes.borderRadiusLg)),
    ),
  );
}
