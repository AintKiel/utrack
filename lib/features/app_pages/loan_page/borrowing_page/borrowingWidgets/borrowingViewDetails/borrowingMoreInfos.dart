import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../services/loan_details_service.dart';
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
  double totalLend = 0.0;
  List<Map<String, dynamic>> transactionHistory = [];
  List<Map<String, dynamic>> dueDates = [];
  String email = '';
  String phone = '';
  String address = '';
  String lenderName = '';
  String initials = '';
  String senderUid = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load data first, then show modal
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadLoanDetails();
      if (mounted) {
        _showMoreInfoPopup(context);
      }
    });
  }

  Future<void> _loadLoanDetails() async {
    final senderId = widget.lender['senderId'];
    if (senderId == null) {
      setState(() => isLoading = false);
      return;
    }

    final result = await LoanDetailsService.getLoanDetails(
      userId: senderId,
      isLending: false, // false = borrowing (they lent to you)
    );

    if (result['success'] == true) {
      setState(() {
        totalLend = result['totalOwed'] ?? 0.0;
        transactionHistory = List<Map<String, dynamic>>.from(result['transactionHistory'] ?? []);
        dueDates = List<Map<String, dynamic>>.from(result['dueDates'] ?? []);
        email = result['email'] ?? '';
        phone = result['phone'] ?? '';
        address = result['address'] ?? '';
        lenderName = result['name'] ?? 'Unknown';
        initials = _getInitials(lenderName);
        senderUid = senderId.toString();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result['error']}')),
        );
      }
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
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
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: const Color(0xFFDEE6FD),
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF365EFF),
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lenderName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              senderUid.isEmpty ? '' : 'UID: ' + senderUid,
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            if (senderUid.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18),
                                tooltip: 'Copy UID',
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(text: senderUid));
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('UID copied')),
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Contact Info
                        LenderContactInfo(email: email, phone: phone, address: address),
                        const SizedBox(height: 20),

                        // Status
                        LenderStatusCard(totalLend: totalLend),
                        const SizedBox(height: 25),

                        // Due Dates
                        DueDatesSection(
                          dueDates: dueDates,
                          lenderId: senderUid,
                          lenderName: lenderName,
                        ),
                        const SizedBox(height: 20),

                        // Transaction History
                        TransactionHistorySection(transactions: transactionHistory),
                        const SizedBox(height: 30),

                        // Pay Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showConfirmPaymentDialog(
                                context,
                                lenderId: senderUid,
                                lenderName: lenderName,
                              );
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
    // Modal is shown in initState after data loads
    return const SizedBox.shrink();
  }
}