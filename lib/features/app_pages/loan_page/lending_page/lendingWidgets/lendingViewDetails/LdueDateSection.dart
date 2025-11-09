import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../utils/formatters/iconsNoPad.dart';

class DueDatesList extends StatelessWidget {
  final List<Map<String, dynamic>> dueDates;
  final NumberFormat formatter;

  const DueDatesList({
    super.key,
    required this.dueDates,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Check if there are any pending or overdue items
    final pendingOrOverdue = dueDates.where((d) =>
    d['status'] == 'Pending' || d['status'] == 'Overdue').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Dates',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),

        // ✅ Show fallback message if no dues
        if (pendingOrOverdue.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                '🎉 No pending dues — all debts are settled!',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ...pendingOrOverdue.map((due) {
            final totalWithInterest =
                due['original'] + (due['original'] * due['interest'] / 100);

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT SIDE
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Due: ${due['date']}',
                            style:
                            const TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            UIconsNoPad.pesoSign(
                                size: 13, color: Colors.black87),
                            const SizedBox(width: 2),
                            Text(
                              formatter.format(due['amount']),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${due['status']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: due['status'] == 'Pending'
                                ? Colors.lightBlue
                                : due['status'] == 'Overdue'
                                ? Colors.redAccent.shade200
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // RIGHT SIDE
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Repayment type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            due['repaymentType'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Interest
                        Text(
                          'Interest: ${due['interest']}%',
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 12),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 3),

                        // Initial amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Initial: ',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 12),
                            ),
                            UIconsNoPad.pesoSign(
                                size: 10, color: Colors.black87),
                            const SizedBox(width: 2),
                            Text(
                              formatter.format(due['original']),
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
