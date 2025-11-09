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
    final hasTransactions = transactionHistory.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),

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
                    'Once your borrowers start repaying, their activity will appear here!',
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
        else
          ...transactionHistory.map((tx) {
            final isFullyPaid = tx['status'] == 'Fully Paid';
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