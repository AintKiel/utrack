import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../utils/formatters/iconsNoPad.dart';

class TransactionHistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> transactionHistory;
  final NumberFormat formatter;

  const TransactionHistoryList({
    super.key,
    required this.transactionHistory,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        ...transactionHistory.map((tx) {
          final isFullyPaid = tx['status'] == 'Fully Paid';
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(
                isFullyPaid ? Icons.check_circle : Icons.payments_rounded,
                color: isFullyPaid ? Colors.green : Colors.orange,
              ),
              title: Text(tx['date']),
              subtitle: Row(
                children: [
                  UIconsNoPad.pesoSign(size: 10, color: Colors.black54),
                  const SizedBox(width: 2),
                  Text(
                    '${formatter.format(tx['amount'])} - ${tx['status']}',
                    style: TextStyle(
                      color: isFullyPaid ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
