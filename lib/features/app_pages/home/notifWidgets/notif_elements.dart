import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/features/app_pages/home/notifWidgets/notif_detail.dart';
import '../../../../utils/constants/text_strings.dart';
import 'notif_cards.dart';

class SampleNotifCards {
  /// ---------- PAYMENT RELATED ----------

  static Widget overduePayment({
    required String borrowerName,
    required double amount,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.overduePaymentBody.replaceAll("{loanTitle}", "$borrowerName's loan");
    List<String> parts = body.split("{amount}");

    return NotificationCard(
      borderColor: Colors.redAccent,
      icon: Icons.warning_amber_rounded,
      title: UTexts.overduePaymentTitle,
      message: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: parts[0]),
          ],
        ),
        style: const TextStyle(height: 1.4),
      ),
      subtitle: Text("₱${amount.toStringAsFixed(2)} • $borrowerName"),
      time: "2 hours ago",
      onDelete: onDelete,
    );
  }

  static Widget paymentReminder({
    required String borrowerName,
    required double amount,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.paymentReminderBody.replaceAll("{loanTitle}", "$borrowerName's loan");
    List<String> parts = body.split("{amount}");

    return NotificationCard(
      borderColor: Colors.orangeAccent,
      icon: Icons.notifications_active_rounded,
      title: UTexts.paymentReminderTitle,
      message: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: parts[0]),
          ],
        ),
        style: const TextStyle(height: 1.4),
      ),
      subtitle: Text("₱${amount.toStringAsFixed(2)} • $borrowerName"),
      time: "1 day ago",
      onDelete: onDelete,
    );
  }

  static Widget paymentReceived({
    required String borrowerName,
    required double amount,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.paymentReceivedBody
        .replaceAll("{borrowerName}", borrowerName)
        .replaceAll("{amount}", "{amount}");
    List<String> parts = body.split("{amount}");

    return NotificationCard(
      borderColor: Colors.teal,
      icon: Icons.attach_money_rounded,
      title: UTexts.paymentReceivedTitle,
      message: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: parts[0]),
          ],
        ),
        style: const TextStyle(height: 1.4),
      ),
      subtitle: Text("₱${amount.toStringAsFixed(2)} • $borrowerName"),
      time: "3 hours ago",
      onDelete: onDelete,
    );
  }

  static Widget paymentSent({
    required String lenderName,
    required double amount,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.paymentSentBody
        .replaceAll("{lenderName}", lenderName)
        .replaceAll("{amount}", "{amount}");
    List<String> parts = body.split("{amount}");

    return NotificationCard(
      borderColor: Colors.green,
      icon: Icons.check_circle_outline,
      title: UTexts.paymentSentTitle,
      message: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: parts[0]),
          ],
        ),
        style: const TextStyle(height: 1.4),
      ),
      subtitle: Text("₱${amount.toStringAsFixed(2)} • $lenderName"),
      time: "1 day ago",
      onDelete: onDelete,
    );
  }

  static Widget upcomingPayment({
    required String borrowerName,
    required double amount,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.upcomingPaymentBody.replaceAll("{loanTitle}", "$borrowerName's loan");
    List<String> parts = body.split("{amount}");

    return NotificationCard(
      borderColor: Colors.blueAccent,
      icon: Icons.schedule_rounded,
      title: UTexts.upcomingPaymentTitle,
      message: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: parts[0]),
          ],
        ),
        style: const TextStyle(height: 1.4),
      ),
      subtitle: Text("₱${amount.toStringAsFixed(2)} • $borrowerName"),
      time: "Tomorrow",
      onDelete: onDelete,
    );
  }

  /// ---------- CREDIT SCORE RELATED ----------

  static Widget creditScoreIncrease({
    required double percentage,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.creditScoreIncreaseBody.replaceAll("{percentage}", "$percentage");

    return NotificationCard(
      borderColor: Colors.lightBlueAccent,
      icon: Icons.trending_up_rounded,
      title: UTexts.creditScoreIncreaseTitle,
      message: Text(body),
      subtitle: Text("+${percentage.toStringAsFixed(1)}% Credit Score"),
      time: "3 days ago",
      onDelete: onDelete,
    );
  }

  static Widget creditScoreDecrease({
    required double percentage,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.creditScoreDecreaseBody.replaceAll("{percentage}", "$percentage");

    return NotificationCard(
      borderColor: Colors.redAccent,
      icon: Icons.trending_down_rounded,
      title: UTexts.creditScoreDecreaseTitle,
      message: Text(body),
      subtitle: Text("-${percentage.toStringAsFixed(1)}% Credit Score"),
      time: "3 days ago",
      onDelete: onDelete,
    );
  }

  /// ---------- BORROWING / LENDING ----------

  static Widget newBorrowRequest({
    required String borrowerName,
    required double amount,
    required VoidCallback onDelete,
    required BuildContext context,
  }) {
    String body = UTexts.newBorrowRequestBody
        .replaceAll("{borrowerName}", borrowerName)
        .replaceAll("{amount}", "{amount}");
    List<String> parts = body.split("{amount}");

    return NotificationCard(
      borderColor: Colors.purple,
      icon: Icons.request_page_rounded,
      title: UTexts.newBorrowRequestTitle,
      message: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: parts[0]),
          ],
        ),
        style: const TextStyle(height: 1.4),
      ),
      subtitle: Text("₱${amount.toStringAsFixed(2)} • $borrowerName"),
      time: "2 days ago",
      buttonLabel: "View More",
      buttonColor: Colors.purple,
      onButtonPressed: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 1, vertical: 14),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 360,
                  maxHeight: 550, // 👈 limit dialog height
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // White popup background
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: ViewDetailNotif(
                        borrowerName: borrowerName,
                        amount: amount,
                        repaymentType: "Single Repayment",
                        dueDate: "20/11/2025",
                        notes: "Borrow",
                        requestedDate: "11/9/2025",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      onDelete: onDelete,
    );
  }


  static Widget requestApproved({
    required String lenderName,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.requestApprovedBody.replaceAll("{lenderName}", lenderName);

    return NotificationCard(
      borderColor: Colors.green,
      icon: Icons.check_circle_rounded,
      title: UTexts.requestApprovedTitle,
      message: Text(body),
      subtitle: Text("Approved by $lenderName"),
      time: "Today",
      onDelete: onDelete,
    );
  }

  static Widget requestRejected({
    required String lenderName,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.requestRejectedBody.replaceAll("{lenderName}", lenderName);

    return NotificationCard(
      borderColor: Colors.redAccent,
      icon: Icons.cancel_outlined,
      title: UTexts.requestRejectedTitle,
      message: Text(body),
      subtitle: Text("Declined by $lenderName"),
      time: "Today",
      onDelete: onDelete,
    );
  }

  static Widget loanFullyRepaid({
    required String borrowerName,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.loanFullyRepaidBody.replaceAll("{borrowerName}", borrowerName);

    return NotificationCard(
      borderColor: Colors.teal,
      icon: Icons.done_all_rounded,
      title: UTexts.loanFullyRepaidTitle,
      message: Text(body),
      subtitle: Text("Loan cleared by $borrowerName"),
      time: "5 days ago",
      onDelete: onDelete,
    );
  }

  static Widget loanDueSoon({
    required String borrowerName,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.loanDueSoonBody.replaceAll("{borrowerName}", borrowerName);

    return NotificationCard(
      borderColor: Colors.amber,
      icon: Icons.access_time_rounded,
      title: UTexts.loanDueSoonTitle,
      message: Text(body),
      subtitle: Text("Due Tomorrow • $borrowerName"),
      time: "Today",
      onDelete: onDelete,
    );
  }

  /// ---------- INTEREST RELATED ----------

  static Widget interestAdded({
    required double interestPercent,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.interestAddedBody.replaceAll("{interestPercent}", "$interestPercent");

    return NotificationCard(
      borderColor: Colors.orangeAccent,
      icon: Icons.percent_rounded,
      title: UTexts.interestAddedTitle,
      message: Text(body),
      subtitle: Text("+${interestPercent.toStringAsFixed(1)}% Interest Added"),
      time: "Just now",
      onDelete: onDelete,
    );
  }
}
