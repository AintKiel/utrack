import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../../services/loan_details_service.dart';
import 'LPaymentDialogs.dart';
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
  double totalOwed = 0.0;
  List<Map<String, dynamic>> transactionHistory = [];
  List<Map<String, dynamic>> dueDates = [];
  String email = '';
  String phone = '';
  String address = '';
  String debtorName = '';
  String initials = '';
  String recipientUid = '';
  bool isLoading = true;

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

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
    final recipientId = widget.debtor['recipientId'];
    if (recipientId == null) {
      setState(() => isLoading = false);
      return;
    }

    final result = await LoanDetailsService.getLoanDetails(
      userId: recipientId,
      isLending: true,
    );

    if (result['success'] == true) {
      setState(() {
        totalOwed = result['totalOwed'] ?? 0.0;
        transactionHistory = List<Map<String, dynamic>>.from(result['transactionHistory'] ?? []);
        dueDates = List<Map<String, dynamic>>.from(result['dueDates'] ?? []);
        email = result['email'] ?? '';
        phone = result['phone'] ?? '';
        address = result['address'] ?? '';
        debtorName = result['name'] ?? 'Unknown';
        initials = _getInitials(debtorName);
        recipientUid = recipientId;
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

  @override
  Widget build(BuildContext context) {
    // Modal is shown in initState after data loads
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
            child: isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Handle bar
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
                      ),
                      const SizedBox(height: 16),

                      // Profile header (name + uid)
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
                        debtorName.isEmpty ? 'Unknown' : debtorName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            recipientUid.isEmpty ? '' : 'UID: ' + recipientUid,
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          if (recipientUid.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18),
                              tooltip: 'Copy UID',
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: recipientUid));
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

                      // Sections
                      ContactInfo(email: email, phone: phone, address: address),
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