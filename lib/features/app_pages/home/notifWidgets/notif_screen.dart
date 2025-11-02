import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'notif_cards.dart';

class UNotificationScreen extends StatelessWidget {
  const UNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.notifications_outlined, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              UTexts.notif,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "2",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              UTexts.noteSubtitle,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),

            /// --- Notification Cards ---
            NotificationCard(
              color: Colors.redAccent.shade100.withOpacity(0.2),
              borderColor: Colors.redAccent,
              icon: Icons.warning_amber_rounded,
              title: UTexts.overduePaymentTitle,
              message: UTexts.overduePaymentBody,
              subtitle: "₱1,000  •   Carmen Lopez",
              time: "2 hours ago",
              buttonLabel: UTexts.paynow,
              buttonColor: Colors.redAccent,
            ),
            NotificationCard(
              color: Colors.orangeAccent.shade100.withOpacity(0.2),
              borderColor: Colors.orangeAccent,
              icon: Icons.notifications_active_outlined,
              title: UTexts.paymentReminderTitle,
              message: UTexts.paymentReminderBody,
              subtitle: "₂,000  •   Rosa Martinez",
              time: "1 day ago",
              buttonLabel: UTexts.paynow,
              buttonColor: Colors.orangeAccent,
            ),
            NotificationCard(
              color: Colors.red.shade100.withOpacity(0.2),
              borderColor: Colors.red,
              icon: Icons.trending_down,
              title: UTexts.creditScoreDecreaseTitle,
              message: UTexts.creditScoreDecreaseBody,
              subtitle: "-3% Credit Score",
              time: "2 days ago",
              buttonLabel: UTexts.viewDetails,
              buttonColor: Colors.redAccent,
            ),
            NotificationCard(
              color: Colors.greenAccent.shade100.withOpacity(0.2),
              borderColor: Colors.green,
              icon: Icons.check_circle_outline,
              title: UTexts.paymentSentTitle,
              message: UTexts.paymentSentBody,
              subtitle: "₱800  •  to Anna Cruz",
              time: "3 days ago",
              buttonLabel: UTexts.viewDetails,
              buttonColor: Colors.green,
            ),

            NotificationCard(
              color: Colors.blueAccent.shade100.withOpacity(0.2),
              borderColor: Colors.blueAccent,
              icon: Icons.thumb_up_alt_outlined,
              title: UTexts.requestApprovedTitle,
              message: UTexts.requestApprovedBody,
              subtitle: "₱5,000  •  Approved by J. Dela Cruz",
              time: "5 days ago",
              buttonLabel: UTexts.viewDetails,
              buttonColor: Colors.blueAccent,
            ),

            NotificationCard(
              color: Colors.tealAccent.shade100.withOpacity(0.2),
              borderColor: Colors.teal,
              icon: Icons.attach_money_rounded,
              title: UTexts.loanFullyRepaidTitle,
              message: UTexts.loanFullyRepaidBody,
              subtitle: "₱3,000  •  from M. Torres",
              time: "1 week ago",
              buttonLabel: UTexts.viewDetails,
              buttonColor: Colors.teal,
            ),

            NotificationCard(
              color: Colors.purpleAccent.shade100.withOpacity(0.2),
              borderColor: Colors.purple,
              icon: Icons.schedule_outlined,
              title: UTexts.loanDueSoonTitle,
              message: UTexts.loanDueSoonBody,
              subtitle: "₱2,500  •  due tomorrow",
              time: "1 week ago",
              buttonLabel: UTexts.remind,
              buttonColor: Colors.purple,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}