import 'package:flutter/material.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';
import 'package:intl/intl.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import 'package:utrack/features/app_pages/home/creditSWidgets/creditTips.dart';

class WhiteCreditDetails extends StatelessWidget {
  final int latePaymentsCount;
  final double totalOutstandingDebts;
  final int borrowingsPerWeek;
  final DateTime? lastUpdated;

  const WhiteCreditDetails({
    super.key,
    this.latePaymentsCount = 0,
    this.totalOutstandingDebts = 0.0,
    this.borrowingsPerWeek = 0,
    this.lastUpdated,
  });

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
          Text(
            _formatLastUpdate(),
            style: const TextStyle(fontSize: 14, color: UColors.darkGrey),
          ),
          const SizedBox(height: 20),

          // cards
          _creditTaskCard(
            icon: UIconsNoPad.paid(color: Colors.black87, size: 28),
            color: Colors.blue.shade50,
            title: UTexts.creditTitle1,
            subTitle: UTexts.creditSubTitle1,
            status: _getRepaymentStatus(latePaymentsCount),
          ),
          const SizedBox(height: 16),

          _creditTaskCard(
            icon: UIconsNoPad.borrowIcon(color: Colors.black87, size: 28),
            color: Colors.lightBlue.shade50,
            title: UTexts.creditTitle2,
            subTitle: UTexts.creditSubTitle2,
            status: _getOutstandingDebtsStatus(totalOutstandingDebts),
          ),
          const SizedBox(height: 16),

          _creditTaskCard(
            icon: UIconsNoPad.lendIcon(color: Colors.black87, size: 28),
            color: Colors.red.shade50,
            title: UTexts.creditTitle3,
            subTitle: UTexts.creditSubTitle3,
            status: _getBorrowingFrequencyStatus(borrowingsPerWeek),
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
                    children: [
                      const Text(
                        UTexts.creditTipTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const BulletText(UTexts.creditTip1),
                      const SizedBox(height: 7),
                      const BulletText(UTexts.creditTip2),
                      const SizedBox(height: 7),
                      const BulletText(UTexts.creditTip3),
                      const SizedBox(height: 7),
                      const BulletText(UTexts.creditTip4),
                      const SizedBox(height: 7),
                      const BulletText(UTexts.creditTip5),
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
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
              const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: UColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getLabelColorByStatus(status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
        ],
      ),
    );
  }

  // Repayment Behavior Status
  String _getRepaymentStatus(int latePayments) {
    if (latePayments <= 2) return "Good";
    if (latePayments <= 4) return "Neutral";
    return "Bad";
  }

  // Outstanding Debts Status
  String _getOutstandingDebtsStatus(double totalDebts) {
    if (totalDebts < 5000) return "Good";
    if (totalDebts < 10000) return "Neutral";
    return "Bad";
  }

  // Borrowing Frequency Status
  String _getBorrowingFrequencyStatus(int borrowingsPerWeek) {
    if (borrowingsPerWeek <= 2) return "Good";
    if (borrowingsPerWeek == 3) return "Neutral";
    return "Bad";
  }

  // Get color based on status
  Color _getLabelColorByStatus(String status) {
    switch (status) {
      case "Good":
        return Colors.green;
      case "Bad":
        return Colors.redAccent;
      case "Neutral":
      default:
        return Colors.amber;
    }
  }

  // Format last update date
  String _formatLastUpdate() {
    if (lastUpdated == null) {
      return DateFormat('MMMM d, yyyy').format(DateTime.now());
    }
    return DateFormat('MMMM d, yyyy').format(lastUpdated!);
  }
}
