import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'notif_elements.dart';
import 'notif_empty.dart';

class UNotificationScreen extends StatefulWidget {
  const UNotificationScreen({super.key});

  @override
  State<UNotificationScreen> createState() => _UNotificationScreenState();
}

class _UNotificationScreenState extends State<UNotificationScreen> {
  List<Map<String, dynamic>> notifications = [
    // ---------- PAYMENT RELATED ----------
    {"type": "overdue", "borrower": "Carmen Lopez", "amount": 1500.0},
    {"type": "paymentReminder", "borrower": "Rosa Martinez", "amount": 2000.0},
    {"type": "paymentReceived", "borrower": "M. Torres", "amount": 1200.0},
    {"type": "paymentSent", "lender": "Anna Cruz", "amount": 800.0},
    {"type": "upcomingPayment", "borrower": "Juan Dela Cruz", "amount": 1800.0},

    // ---------- CREDIT SCORE RELATED ----------
    {"type": "creditIncrease", "percentage": 5.0},
    {"type": "creditDecrease", "percentage": 3.0},

    // ---------- BORROWING / LENDING ----------
    {"type": "newBorrowRequest", "borrower": "Miguel Santos", "amount": 5000.0},
    {"type": "requestApproved", "lender": "J. Dela Cruz"},
    {"type": "requestRejected", "lender": "Maria Reyes"},
    {"type": "loanFullyRepaid", "borrower": "M. Torres"},
    {"type": "loanDueSoon", "borrower": "Rosa Martinez"},

    // ---------- INTEREST RELATED ----------
    {"type": "interestAdded", "interestPercent": 2.5},
  ];

  void _removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

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
            if (notifications.isNotEmpty)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  notifications.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        centerTitle: false,
      ),
      body: notifications.isEmpty
          ? const EmptyNotificationWidget()
          : Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final n = notifications[index];
            switch (n["type"]) {
            // -------- PAYMENT RELATED --------
              case "overdue":
                return SampleNotifCards.overduePayment(
                  borrowerName: n["borrower"],
                  amount: (n["amount"] as num).toDouble(),
                  onDelete: () => _removeNotification(index),
                );
              case "paymentReminder":
                return SampleNotifCards.paymentReminder(
                  borrowerName: n["borrower"],
                  amount: (n["amount"] as num).toDouble(),
                  onDelete: () => _removeNotification(index),
                );
              case "paymentReceived":
                return SampleNotifCards.paymentReceived(
                  borrowerName: n["borrower"],
                  amount: (n["amount"] as num).toDouble(),
                  onDelete: () => _removeNotification(index),
                );
              case "paymentSent":
                return SampleNotifCards.paymentSent(
                  lenderName: n["lender"],
                  amount: (n["amount"] as num).toDouble(),
                  onDelete: () => _removeNotification(index),
                );
              case "upcomingPayment":
                return SampleNotifCards.upcomingPayment(
                  borrowerName: n["borrower"],
                  amount: (n["amount"] as num).toDouble(),
                  onDelete: () => _removeNotification(index),
                );

            // -------- CREDIT SCORE --------
              case "creditIncrease":
                return SampleNotifCards.creditScoreIncrease(
                  percentage: (n["percentage"] as num).toDouble(),
                  onDelete: () => _removeNotification(index),
                );
              case "creditDecrease":
                return SampleNotifCards.creditScoreDecrease(
                  percentage: (n["percentage"] as num).toDouble(),
                  onDelete: () => _removeNotification(index),
                );

            // -------- BORROWING / LENDING --------
              case "newBorrowRequest":
                return SampleNotifCards.newBorrowRequest(
                  borrowerName: n["borrower"],
                  amount: (n["amount"] as num).toDouble(),
                  onDelete: () => _removeNotification(index),
                  context: context, // 👈 Add this line
                );
              case "requestApproved":
                return SampleNotifCards.requestApproved(
                  lenderName: n["lender"],
                  onDelete: () => _removeNotification(index),
                );
              case "requestRejected":
                return SampleNotifCards.requestRejected(
                  lenderName: n["lender"],
                  onDelete: () => _removeNotification(index),
                );
              case "loanFullyRepaid":
                return SampleNotifCards.loanFullyRepaid(
                  borrowerName: n["borrower"],
                  onDelete: () => _removeNotification(index),
                );
              case "loanDueSoon":
                return SampleNotifCards.loanDueSoon(
                  borrowerName: n["borrower"],
                  onDelete: () => _removeNotification(index),
                );

            // -------- INTEREST --------
              case "interestAdded":
                return SampleNotifCards.interestAdded(
                  interestPercent: (n["interestPercent"] as num).toDouble(),
                  onDelete: () => _removeNotification(index),
                );

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
