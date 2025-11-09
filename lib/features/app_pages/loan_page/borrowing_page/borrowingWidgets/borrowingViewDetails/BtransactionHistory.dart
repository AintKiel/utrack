import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';

class TransactionHistorySection extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const TransactionHistorySection({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final hasTransactions = transactions.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),

        // ====== EMPTY STATE ======
        if (!hasTransactions)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.receipt_long_rounded,
                      color: Colors.grey, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    'No transactions yet.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Start making payments to build a good credit record!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          )

        // ====== TRANSACTION LIST ======
        else
          ...transactions.map((tx) {
            final isFullyPaid = tx['status'] == 'Full Payment Sent';
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(
                  isFullyPaid
                      ? Icons.check_circle_rounded
                      : Icons.payments_rounded,
                  color: isFullyPaid ? Colors.green : Colors.orange,
                ),
                title: Text(
                  tx['date'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
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