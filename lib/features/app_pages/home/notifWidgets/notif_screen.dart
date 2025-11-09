import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import '../../../../services/loan_request_service.dart';
import 'loan_request_notifications.dart';
import 'notif_cards.dart';

class UNotificationScreen extends StatelessWidget {
  const UNotificationScreen({super.key});

  Widget _buildBorrowerNotificationCard(BuildContext context, Map<String, dynamic> notif) {
    final isApproved = notif['type'] == 'loan_approved';
    final color = isApproved ? Colors.green : Colors.red;
    final icon = isApproved ? Icons.check_circle : Icons.cancel;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          // Mark as read when tapped
          await LoanRequestService.markNotificationAsRead(notif['notificationId']);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif['title'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif['message'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: StreamBuilder<List<Map<String, dynamic>>>(
          stream: LoanRequestService.getLoanRequestsStream(),
          builder: (context, snapshot) {
            final requestCount = snapshot.data?.length ?? 0;
            
            return Row(
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
                if (requestCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$requestCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ],
            );
          },
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

            /// --- Loan Requests Section (for lenders) ---
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: LoanRequestService.getLoanRequestsStream(),
              builder: (context, snapshot) {
                final requests = snapshot.data ?? [];
                
                if (requests.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.request_page, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Loan Requests',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${requests.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...requests.map((request) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LoanRequestCard(request: request),
                    )),
                    const Divider(height: 32),
                  ],
                );
              },
            ),

            /// --- Borrower Notifications Section (approved/rejected) ---
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: LoanRequestService.getBorrowerNotificationsStream(),
              builder: (context, snapshot) {
                final notifications = snapshot.data ?? [];
                final unreadNotifications = notifications.where((n) => n['read'] == false).toList();
                
                if (unreadNotifications.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Your Loan Status',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${unreadNotifications.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...unreadNotifications.map((notif) => _buildBorrowerNotificationCard(context, notif)),
                    const Divider(height: 32),
                    Text(
                      'Other Notifications',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),

            /// --- Other Notification Cards ---
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