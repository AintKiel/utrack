import 'package:flutter/material.dart';
import '../../../../utils/formatters/iconsNoPad.dart';

class TransacContainer extends StatelessWidget {
  final String name;
  final String type; // Money Lent, Borrowed Money, Payment Sent, Received Payment
  final String? paymentType; // Partial Payment, Full Payment (only for payments)
  final double amount;
  final String date;
  final String time;

  const TransacContainer({
    super.key,
    required this.name,
    required this.type,
    this.paymentType,
    required this.amount,
    required this.date,
    required this.time,
  });

  // Type label is the type itself
  String getTypeLabel() {
    return type; // Money Lent, Borrowed Money, Payment Sent, Received Payment
  }

  Color getAmountColor() {
    switch (type.toLowerCase()) {
      case "received payment":
        return Colors.green;
      case "money lent":
        return Colors.blue;
      case "payment sent":
        return Colors.purple;
      case "borrowed money":
        return Colors.orange;
      default:
        return Colors.black87;
    }
  }

  IconData getTypeIcon() {
    switch (type.toLowerCase()) {
      case "received payment":
        return Icons.arrow_downward_rounded;
      case "money lent":
        return Icons.arrow_outward_rounded;
      case "payment sent":
        return Icons.payments_rounded;
      case "borrowed money":
        return Icons.arrow_upward_rounded;
      default:
        return Icons.receipt_long;
    }
  }

  Color getPaymentTypeColor() {
    if (paymentType == null) return Colors.transparent;

    switch (paymentType!.toLowerCase()) {
      case "full payment":
        return Colors.green;
      case "partial payment":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
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

          // PAYMENT TYPE CHIP (only for payment transactions)
          if (paymentType != null)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: getPaymentTypeColor().withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  paymentType!,
                  style: TextStyle(
                    color: getPaymentTypeColor(),
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