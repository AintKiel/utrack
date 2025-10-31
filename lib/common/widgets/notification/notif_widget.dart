import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/formatters/icons.dart';

class Notification_Widget extends StatelessWidget {
  const Notification_Widget({
    super.key,
    required this.onPressed,
    required this.iconColor,
  });

  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: UIcons.notification(size: 40, color: iconColor),
        ),
        Positioned(
          right: 11,
          top: 7,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: UColors.error,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                '2',
                style: Theme.of(context).textTheme.labelLarge!.apply(
                  color: UColors.white,
                  fontSizeFactor: 0.8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
