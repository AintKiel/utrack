import 'package:flutter/material.dart';
import '../../../../../../utils/formatters/iconsNoPad.dart';

void showPaymentMethodDialog(BuildContext context, Map<String, dynamic> due) {
  String selectedPayment = 'Cash';

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Select Payment Method'),
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose your mode of payment for this due.'),
            RadioListTile<String>(
              title: const Text('Cash'),
              value: 'Cash',
              groupValue: selectedPayment,
              activeColor: Colors.green,
              onChanged: (value) => setState(() => selectedPayment = value!),
            ),
            RadioListTile<String>(
              title: const Text('E-Wallet'),
              value: 'E-Wallet',
              groupValue: selectedPayment,
              activeColor: Colors.green,
              onChanged: (value) => setState(() => selectedPayment = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment marked as $selectedPayment!')),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Confirm'),
        )
      ],
    ),
  );
}

void showConfirmPaymentDialog(BuildContext context) {
  final TextEditingController amountController = TextEditingController();
  String selectedPayment = 'Cash';

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Pay debt'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter the amount received for this payment.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          // Amount TextField
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
          const SizedBox(height: 20),
          const Text(
            'Mode of Payment',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          StatefulBuilder(
            builder: (context, setState) {
              return Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Cash', style: TextStyle(fontSize: 13)),
                      value: 'Cash',
                      groupValue: selectedPayment,
                      activeColor: Colors.green,
                      dense: true,
                      onChanged: (value) => setState(() => selectedPayment = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('E-Wallet', style: TextStyle(fontSize: 13)),
                      value: 'E-Wallet',
                      groupValue: selectedPayment,
                      activeColor: Colors.green,
                      dense: true,
                      onChanged: (value) => setState(() => selectedPayment = value!),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final amountText = amountController.text.trim();
            if (amountText.isEmpty || double.tryParse(amountText) == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid amount.'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment confirmed!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}

