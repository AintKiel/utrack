import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/colors.dart';
import ' circularContainer.dart';
import '../curved_edges/curved_edges_widget.dart';

class USecondaryHeaderContainer extends StatelessWidget {
  const USecondaryHeaderContainer({
    super.key,
    required this.child,
    this.height = 350, // ✅ adjustable height
  });

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return UCurvedEdgeWidget(
      child: Container(
        color: UColors.primary,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -120,
                right: -220,
                child: UCircularContainer(
                    backgroundColor: UColors.primary.withOpacity(0.1)),
              ),
              Positioned(
                bottom: -150,
                right: -250,
                child: UCircularContainer(
                    backgroundColor: UColors.textWhite.withOpacity(0.15)),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
