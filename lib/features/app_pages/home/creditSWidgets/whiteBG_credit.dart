import 'package:flutter/material.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import 'package:utrack/features/app_pages/home/creditSWidgets/creditTips.dart';

class WhiteCreditDetails extends StatelessWidget {
  const WhiteCreditDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Last Update",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ex: November 2, 2025",
            style: TextStyle(fontSize: 14, color: UColors.darkGrey),
          ),
          const SizedBox(height: 20),

          // cards
          _creditTaskCard(
            icon: UIconsNoPad.paid(color: Colors.black87, size: 28),
            color: Colors.blue.shade50,
            title: UTexts.creditTitle1,
            subTitle: UTexts.creditSubTitle1,
            progress: 0.6,
          ),
          const SizedBox(height: 16),

          _creditTaskCard(
            icon: UIconsNoPad.borrowIcon(color: Colors.black87, size: 28),
            color: Colors.lightBlue.shade50,
            title: UTexts.creditTitle2,
            subTitle: UTexts.creditSubTitle2,
            progress: 0.75,
          ),
          const SizedBox(height: 16),

          _creditTaskCard(
            icon: UIconsNoPad.lendIcon(color: Colors.black87, size: 28),
            color: Colors.red.shade50,
            title: UTexts.creditTitle3,
            subTitle: UTexts.creditSubTitle3,
            progress: 0.3,
          ),
          const SizedBox(height: 16),

          // ===== Tips Box =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.shade100, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline,
                    color: Colors.amber.shade700, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        UTexts.creditTipTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      BulletText(UTexts.creditTip1),
                      const SizedBox(height: 7),
                      BulletText(UTexts.creditTip2),
                      const SizedBox(height: 7),
                      BulletText(UTexts.creditTip3),
                      const SizedBox(height: 7),
                      BulletText(UTexts.creditTip4),
                      const SizedBox(height: 7),
                       BulletText(UTexts.creditTip5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _creditTaskCard({
    required Widget icon,
    required Color color,
    required String title,
    required String subTitle,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(subTitle,
                      style: const TextStyle(
                          fontSize: 12, color: UColors.darkGrey)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _getLabelColor(progress),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getLabelText(progress),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLabelText(double progress) {
    if (progress >= 0.7) return "Positive";
    if (progress <= 0.3) return "Negative";
    return "Neutral";
  }

  Color _getLabelColor(double progress) {
    if (progress >= 0.7) return Colors.green;
    if (progress <= 0.3) return Colors.redAccent;
    return Colors.amber;
  }
}

