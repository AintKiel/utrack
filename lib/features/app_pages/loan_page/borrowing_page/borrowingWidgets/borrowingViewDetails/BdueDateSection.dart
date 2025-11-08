import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';
import 'BpaymentDialogs.dart';

class DueDatesSection extends StatelessWidget {
  final List<Map<String, dynamic>> dueDates;

  const DueDatesSection({super.key, required this.dueDates});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Due Dates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        ...dueDates.map((due) => Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Due: ${due['date']}',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        UIconsNoPad.pesoSign(size: 13, color: Colors.black87),
                        const SizedBox(width: 2),
                        Text(
                          NumberFormat('#,###').format(due['amount']),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(width: 20),
                        Text('Interest: ${due['interest']}%', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
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
                        const SizedBox(width: 27),
                        Row(
                          children: [
                            const Text('Initial: ', style: TextStyle(fontSize: 12)),
                            UIconsNoPad.pesoSign(size: 10, color: Colors.black87),
                            const SizedBox(width: 2),
                            Text(
                              NumberFormat('#,###').format(due['original']),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // RIGHT SIDE
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      due['repaymentType'],
                      style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => showPaymentMethodDialog(context, due),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(70, 30),
                    ),
                    child: const Text('Pay', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }
}
