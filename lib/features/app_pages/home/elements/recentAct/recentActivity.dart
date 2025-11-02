import 'package:flutter/material.dart';
import 'package:utrack/features/app_pages/home/elements/recentAct/recentActItems.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.transparent
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- Header ---
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.green, size: 22),
              SizedBox(width: 8),
              Text(
                "Recent Activity",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? UColors.white
                      : UColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// --- Activity List ---
          RecentActItems(initials: "AG", name: "Ana Garcia", time: "2 hours ago", amount: "+2,000", amountColor: Colors.green, icon: UIconsNoPad.paid(color: Colors.green, size: 14), iconColor: Colors.green),
          const SizedBox(height: 10),
          RecentActItems(initials: "PR", name: "Pedro Reyes", time: "1 day ago", amount: "-500", amountColor: Colors.blue, icon: UIconsNoPad.lendIcon(color: Colors.blue, size: 14), iconColor: Colors.blue),
          const SizedBox(height: 10),
          RecentActItems(initials: "RM", name: "Rosa Martinez", time: "2 days ago", amount: "1,500", amountColor: Colors.red, icon: UIconsNoPad.borrowIcon(color: Colors.orange, size: 14), iconColor: Colors.orange),
        ],
      ),
    );
  }

}
