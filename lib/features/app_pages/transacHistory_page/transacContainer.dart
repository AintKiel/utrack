import 'package:flutter/material.dart';
import '../../../../utils/formatters/iconsNoPad.dart';

class TransacContainer extends StatelessWidget {
  final String name;
  final String type; // Lent, Borrowed, Received, Paid
  final String status; // Completed, Pending, Failed
  final double amount;
  final String date;
  final String time;

  const TransacContainer({
    super.key,
    required this.name,
    required this.type,
    required this.status,
    required this.amount,
    required this.date,
    required this.time,
  });

  // Convert type to readable label
  String getTypeLabel() {
    switch (type.toLowerCase()) {
      case "lent":
        return "Money Lent";
      case "borrowed":
        return "Borrowed Money";
      case "paid":
        return "Payment Paid";
      case "received":
        return "Received Payment";
      default:
        return "Transaction";
    }
  }

  Color getAmountColor() {
    switch (type.toLowerCase()) {
      case "received":
        return Colors.green;
      case "lent":
        return Colors.blue;
      case "paid":
        return Colors.purple;
      case "borrowed":
        return Colors.orange;
      default:
        return Colors.black87;
    }
  }

  IconData getTypeIcon() {
    switch (type.toLowerCase()) {
      case "received":
        return Icons.arrow_downward_rounded;
      case "lent":
        return Icons.arrow_outward_rounded;
      case "paid":
        return Icons.payments_rounded;
      case "borrowed":
        return Icons.arrow_upward_rounded;
      default:
        return Icons.receipt_long;
    }
  }

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "pending":
        return Colors.grey;
      case "failed":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon circle
              CircleAvatar(
                backgroundColor: getAmountColor().withOpacity(0.15),
                radius: 20,
                child: Icon(getTypeIcon(), color: getAmountColor(), size: 24),
              ),
              const SizedBox(width: 12),

              // NAME + TYPE LABEL + DATE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      getTypeLabel(),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "$date • $time",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade500 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // AMOUNT WITH PESO ICON
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIconsNoPad.pesoSign(size: 15, color: getAmountColor()),
                  const SizedBox(width: 4),
                  Text(
                    amount.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: getAmountColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // STATUS CHIP
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: getStatusColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
