import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';

class LenderStatusCard extends StatelessWidget {
  final double totalLend;

  const LenderStatusCard({super.key, required this.totalLend});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // LEFT SIDE — STATUS
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Current Status:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Active', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
          const Spacer(),
          // RIGHT SIDE — TOTAL LEND
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Total Lend',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  UIconsNoPad.pesoSign(size: 16, color: Colors.black87),
                  Text(
                    formatter.format(totalLend),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}