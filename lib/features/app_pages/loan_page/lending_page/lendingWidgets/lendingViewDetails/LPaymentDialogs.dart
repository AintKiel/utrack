import 'package:flutter/material.dart';
import '../../../../../../utils/formatters/iconsNoPad.dart';

class ConfirmPaymentDialog extends StatefulWidget {
  const ConfirmPaymentDialog({super.key});

  @override
  State<ConfirmPaymentDialog> createState() => _ConfirmPaymentDialogState();
}

class _ConfirmPaymentDialogState extends State<ConfirmPaymentDialog> {
  final TextEditingController amountController = TextEditingController();
  String selectedPayment = 'Cash';

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _confirmPayment() {
    final amountText = amountController.text.trim();
    if (amountText.isEmpty || double.tryParse(amountText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount'), duration: Duration(seconds: 2)),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment confirmed!'), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Confirm Payment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter the amount received for this payment.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 4),
                child: UIconsNoPad.pesoSign(size: 14, color: Colors.black54),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _confirmPayment,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}