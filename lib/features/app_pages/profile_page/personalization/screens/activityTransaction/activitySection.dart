import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class ActivityCard extends StatelessWidget {
  final int totalTransactions;
  final int completed;

  const ActivityCard({
    super.key,
    required this.totalTransactions,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          Text(
            "Your Activity",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          _activityBox(context),
        ],
      ),
    );
  }

  Widget _activityBox(context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: dark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _activityColumn("Total Transactions", totalTransactions.toString(), UColors.primary),
          _activityColumn("Completed", completed.toString(), UColors.secondary, alignEnd: true),
        ],
      ),
    );
  }

  Widget _activityColumn(String label, String value, Color color,
      {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment:
      alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
