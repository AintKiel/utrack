import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'LPaymentDialogs.dart';
import 'Lavatar.dart';
import 'LcontactInfo.dart';
import 'LdueDateSection.dart';
import 'LstatusCard.dart';
import 'LtransactionHistory.dart';

class LendingMoreInfos extends StatefulWidget {
  final Map<String, dynamic> debtor;

  const LendingMoreInfos({super.key, required this.debtor});

  @override
  State<LendingMoreInfos> createState() => _LendingMoreInfosState();
}

class _LendingMoreInfosState extends State<LendingMoreInfos> {
  late double totalOwed;
  late List<Map<String, dynamic>> transactionHistory;
  late List<Map<String, dynamic>> dueDates;

  @override
  void initState() {
    super.initState();

    // Use sample data if no data is provided
    totalOwed = widget.debtor['totalOwed'] ?? 15500;

    transactionHistory = List<Map<String, dynamic>>.from(
      widget.debtor['history'] ??
          [
            {'date': 'Nov 3, 2025', 'amount': 2500, 'status': 'Fully Paid'},
            {'date': 'Oct 28, 2025', 'amount': 13000, 'status': 'Partially Paid'},
          ],
    );

    dueDates = List<Map<String, dynamic>>.from(
      widget.debtor['dueDates'] ??
          [
            {
              'date': 'Mar 20, 2025',
              'amount': 2040,
              'status': 'Overdue',
              'repaymentType': 'Multiple Repayment',
              'interest': 2,
              'original': 2000
            },
            {
              'date': 'Apr 11, 2025',
              'amount': 2000,
              'status': 'Pending',
              'repaymentType': 'Single Repayment',
              'interest': 0,
              'original': 2000
            },
            {
              'date': 'Apr 20, 2025',
              'amount': 2040,
              'status': 'Pending',
              'repaymentType': 'Multiple Repayment',
              'interest': 2,
              'original': 2000
            },
          ],
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMoreInfoPopup(context);
    });
    return const SizedBox.shrink();
  }

  void _showMoreInfoPopup(BuildContext context) {
    final formatter = NumberFormat('#,###');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Handle bar
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
                ),
                const SizedBox(height: 16),

                // Sections
                const ProfileInfo(),
                const SizedBox(height: 16),
                const ContactInfo(),
                const SizedBox(height: 20),
                StatusTotalOwed(totalOwed: totalOwed, formatter: formatter),
                const SizedBox(height: 25),
                DueDatesList(dueDates: dueDates, formatter: formatter),
                const SizedBox(height: 20),
                TransactionHistoryList(transactionHistory: transactionHistory, formatter: formatter),
                const SizedBox(height: 30),

                // Confirm Payment Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ConfirmPaymentDialog(),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Confirm Payment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
