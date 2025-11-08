import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';

class TransactionHistorySection extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const TransactionHistorySection({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Transaction History',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        ...transactions.map((tx) {
          final isFullyPaid = tx['status'] == 'Full Payment Sent';
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
