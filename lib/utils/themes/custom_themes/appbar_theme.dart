import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';

class UAppBarTheme {
  UAppBarTheme._();

  // 🌤️ Light AppBar Theme
  static const LightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: UColors.black, size: Usizes.iconMd,),
    actionsIconTheme: IconThemeData(color: UColors.black, size: Usizes.iconMd,),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: UColors.black,),
  );

  // 🌙 Dark AppBar Theme
  static const DarkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: UColors.white, size: Usizes.iconMd,),
    actionsIconTheme: IconThemeData(color: UColors.white, size: Usizes.iconMd,),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: UColors.white,),
  );
}
