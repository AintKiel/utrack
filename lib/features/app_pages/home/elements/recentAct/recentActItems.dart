import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class RecentActItems extends StatelessWidget {
  const RecentActItems({
    super.key,
    required this.initials,
    required this.name,
    required this.time,
    required this.amount,
    required this.amountColor,
    required this.icon,
    required this.iconColor,
  });

  final String initials;
  final String name;
  final String time;
  final String amount;
  final Color amountColor;
  final Widget icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar circle with initials
          CircleAvatar(
            backgroundColor:Theme.of(context).brightness == Brightness.dark
                ? UColors.darkGrey
                : UColors.grey.withOpacity(0.6),
            radius: 20,
            child: Text(
              initials,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? UColors.white
                    : UColors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name + Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    icon,
                    const SizedBox(width: 4),
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? UColors.white
                            : UColors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
