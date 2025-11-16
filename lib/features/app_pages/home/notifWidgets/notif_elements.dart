import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utrack/features/app_pages/home/notifWidgets/notif_detail.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../services/loan_request_service.dart';
import 'notif_cards.dart';

class SampleNotifCards {
  /// ---------- PAYMENT RELATED ----------

  static Widget overduePayment({
    required String borrowerName,
    required double amount,
    required DateTime? timestamp,
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
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  static Widget paymentReminder({
    required String borrowerName,
    required double amount,
    required DateTime? timestamp,
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
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  static Widget paymentReceived({
    required String borrowerName,
    required double amount,
    required DateTime? timestamp,
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
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  static Widget paymentSent({
    required String lenderName,
    required double amount,
    required DateTime? timestamp,
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
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  static Widget upcomingPayment({
    required String borrowerName,
    required double amount,
    required DateTime? timestamp,
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
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  /// ---------- CREDIT SCORE RELATED ----------

  static Widget creditScoreIncrease({
    required double percentage,
    required DateTime? timestamp,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.creditScoreIncreaseBody.replaceAll("{percentage}", "$percentage");

    return NotificationCard(
      borderColor: Colors.lightBlueAccent,
      icon: Icons.trending_up_rounded,
      title: UTexts.creditScoreIncreaseTitle,
      message: Text(body),
      subtitle: Text("+${percentage.toStringAsFixed(1)}% Credit Score"),
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  static Widget creditScoreDecrease({
    required double percentage,
    required DateTime? timestamp,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.creditScoreDecreaseBody.replaceAll("{percentage}", "$percentage");

    return NotificationCard(
      borderColor: Colors.redAccent,
      icon: Icons.trending_down_rounded,
      title: UTexts.creditScoreDecreaseTitle,
      message: Text(body),
      subtitle: Text("-${percentage.toStringAsFixed(1)}% Credit Score"),
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  /// ---------- BORROWING / LENDING ----------

  static Widget newBorrowRequest({
    required String borrowerName,
    required double amount,
    required DateTime? timestamp,
    required VoidCallback onDelete,
    required BuildContext context,
    String? requestId,
    String? borrowerId,
    String? repaymentType,
    String? dueDate,
    String? notes,
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
      time: _formatTime(timestamp),
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
                  maxHeight: 550, // 
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
                        repaymentType: repaymentType ?? "Single Repayment",
                        dueDate: dueDate ?? "N/A",
                        notes: notes ?? "No notes provided",
                        requestedDate: DateFormat('MMM d, yyyy • h:mm a').format(timestamp ?? DateTime.now()),
                        requestId: requestId,
                        onApprove: requestId != null ? () async {
                          try {
                            print(' Approving loan request: $requestId');
                            final result = await LoanRequestService.approveLoanRequest(requestId);
                            if (result['success'] == true) {
                              print(' Loan request approved successfully');
                              // Delete the notification
                              onDelete();
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Loan request approved! ₱${amount.toStringAsFixed(2)} has been lent to $borrowerName'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              print(' Failed to approve loan request: ${result['error']}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to approve request: ${result['error']}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            print(' Error approving loan request: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error approving request. Please try again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } : null,
                        onDecline: requestId != null ? () async {
                          try {
                            print(' Declining loan request: $requestId');
                            final result = await LoanRequestService.rejectLoanRequest(requestId);
                            if (result['success'] == true) {
                              print(' Loan request declined successfully');
                              // Delete the notification
                              onDelete();
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Loan request declined'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            } else {
                              print(' Failed to decline loan request: ${result['error']}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to decline request: ${result['error']}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            print(' Error declining loan request: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error declining request. Please try again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } : null,
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
    required DateTime? timestamp,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.requestApprovedBody.replaceAll("{lenderName}", lenderName);

    return NotificationCard(
      borderColor: Colors.green,
      icon: Icons.check_circle_rounded,
      title: UTexts.requestApprovedTitle,
      message: Text(body),
      subtitle: Text("Approved by $lenderName"),
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  static Widget requestRejected({
    required String lenderName,
    required DateTime? timestamp,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.requestRejectedBody.replaceAll("{lenderName}", lenderName);

    return NotificationCard(
      borderColor: Colors.redAccent,
      icon: Icons.cancel_outlined,
      title: UTexts.requestRejectedTitle,
      message: Text(body),
      subtitle: Text("Declined by $lenderName"),
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  static Widget loanFullyRepaid({
    required String borrowerName,
    required DateTime? timestamp,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.loanFullyRepaidBody.replaceAll("{borrowerName}", borrowerName);

    return NotificationCard(
      borderColor: Colors.teal,
      icon: Icons.done_all_rounded,
      title: UTexts.loanFullyRepaidTitle,
      message: Text(body),
      subtitle: Text("Loan cleared by $borrowerName"),
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  static Widget loanDueSoon({
    required String borrowerName,
    required DateTime? timestamp,
    required VoidCallback onDelete,
  }) {
    String body = UTexts.loanDueSoonBody.replaceAll("{borrowerName}", borrowerName);

    return NotificationCard(
      borderColor: Colors.amber,
      icon: Icons.access_time_rounded,
      title: UTexts.loanDueSoonTitle,
      message: Text(body),
      subtitle: Text("Due Tomorrow • $borrowerName"),
      time: _formatTime(timestamp),
      onDelete: onDelete,
    );
  }

  static String _formatTime(DateTime? timestamp) {
    if (timestamp == null) return 'Just now';

    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return DateFormat('MMM d, yyyy').format(timestamp);
  }
}