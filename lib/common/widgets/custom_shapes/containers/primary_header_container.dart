import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circularContainer.dart';

class UPrimaryHeaderContainer extends StatelessWidget {
  const UPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UCurvedEdgeWidget(
      child: Container(
        color: UColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 400,
          width: double.infinity,
          child: Container(
            color: UColors.primary,

            child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(top: -150, right: -250,
                      child: UCircularContainer(backgroundColor: UColors.primary.withOpacity(0.1))),
                  Positioned(top: 100, right: -300,
                      child: UCircularContainer(backgroundColor: UColors.textWhite)),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: child,
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
