import 'package:flutter/material.dart';
import 'BcontactInfo.dart';
import 'BdueDateSection.dart';
import 'BpaymentDialogs.dart';
import 'BstatusCard.dart';
import 'BtransactionHistory.dart';

class BorrowingMoreInfos extends StatefulWidget {
  final Map<String, dynamic> lender;

  const BorrowingMoreInfos({super.key, required this.lender});

  @override
  State<BorrowingMoreInfos> createState() => _BorrowingMoreInfosState();
}

class _BorrowingMoreInfosState extends State<BorrowingMoreInfos> {
  late double totalLend;
  late List<Map<String, dynamic>> transactionHistory;
  late List<Map<String, dynamic>> dueDates;

  @override
  void initState() {
    super.initState();

    totalLend = widget.lender['totalLend'] ?? 15500;

    transactionHistory = List<Map<String, dynamic>>.from(widget.lender['history'] ?? [
      {'date': 'Nov 3, 2025', 'amount': 2500, 'status': 'Full Payment Sent'},
      {'date': 'Oct 28, 2025', 'amount': 13000, 'status': 'Partial Payment Sent'},
    ]);

    dueDates = List<Map<String, dynamic>>.from(widget.lender['dueDates'] ?? [
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
    ]);
  }

  // ✅ show bottom sheet properly
  void _showMoreInfoPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
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
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Profile header
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFFDEE6FD),
                    child: Text(
                      'AG',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF365EFF),
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ana Garcia',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),

                  // Contact Info
                  const LenderContactInfo(),
                  const SizedBox(height: 20),

                  // Status
                  LenderStatusCard(totalLend: totalLend),
                  const SizedBox(height: 25),

                  // Due Dates
                  DueDatesSection(dueDates: dueDates),
                  const SizedBox(height: 20),

                  // Transaction History
                  TransactionHistorySection(transactions: transactionHistory),
                  const SizedBox(height: 30),

                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showConfirmPaymentDialog(context);
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Pay debt'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Show popup automatically when this page opens (just like LendingMoreInfos)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMoreInfoPopup(context);
    });

    // Empty widget (since the page is transparent)
    return const SizedBox.shrink();
  }
}
