import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:utrack/utils/constants/colors.dart';

class UCircularContainer extends StatelessWidget {
  const UCircularContainer({
    super.key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.backgroundColor = UColors.white,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color? backgroundColor;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: UColors.textWhite.withOpacity(0.1)
      ),
      child: child,
    );
  }
}