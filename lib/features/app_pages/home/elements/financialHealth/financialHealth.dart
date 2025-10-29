import 'package:flutter/material.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class FinancialHealth extends StatelessWidget {
  const FinancialHealth({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? UColors.lightBlue.withOpacity(0.8)
            : UColors.lightBlue, // sky blue background
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
          // --- Header ---
          Row(
            children: [
              UIconsNoPad.wallet(color: UColors.percentBar, size: 25),
              SizedBox(width: 10),
              Text(
                UTexts.financialHealth,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // --- Credit Score ---
          _buildProgressRow(UTexts.creditScore, 0.85),

          const SizedBox(height: 10),

          // --- Payment History ---
          _buildProgressRow(UTexts.paymentHistory, 0.92),

          const SizedBox(height: 10),

          // --- Trust Rating ---
          _buildProgressRow(UTexts.trustRating, 0.88),
        ],
      ),
    );
  }

  /// Helper widget builder for each progress item
  static Widget _buildProgressRow(String title, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            Text(
              "${(value * 100).toInt()}%",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.teal[100],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
