import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../../services/borrowing_service.dart';
import '../../../../../../services/payment_tracking_service.dart';
import '../../../../../../utils/formatters/iconsNoPad.dart';
import 'package:utrack/features/app_pages/home/elements/profileCradsElements/qr_scanner_screen.dart';

void showPaymentMethodDialog(
  BuildContext context,
  Map<String, dynamic> due, {
  required String lenderId,
  required String lenderName,
}) {
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
          onPressed: () async {
            final amount = (due['amount'] is num) ? (due['amount'] as num).toDouble() : null;
            Navigator.pop(context);

            Future.microtask(() {
              showConfirmPaymentDialog(
                context,
                lenderId: lenderId,
                lenderName: lenderName,
                suggestedAmount: amount,
                initialPaymentMethod: selectedPayment,
              );
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Confirm'),
        )
      ],
    ),
  );
}

void showConfirmPaymentDialog(
  BuildContext context, {
  required String lenderId,
  required String lenderName,
  double? suggestedAmount,
  String initialPaymentMethod = 'Cash',
}) {
  final TextEditingController amountController = TextEditingController(
    text: suggestedAmount != null ? suggestedAmount.toStringAsFixed(2) : '',
  );
  String selectedPayment = initialPaymentMethod;
  bool isSubmitting = false;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Pay debt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter the amount you will repay.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              RadioListTile<String>(
                title: const Text('Cash', style: TextStyle(fontSize: 13)),
                value: 'Cash',
                groupValue: selectedPayment,
                activeColor: Colors.green,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) => setState(() => selectedPayment = value!),
              ),
              RadioListTile<String>(
                title: const Text('E-Wallet', style: TextStyle(fontSize: 13)),
                value: 'E-Wallet',
                groupValue: selectedPayment,
                activeColor: Colors.green,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) => setState(() => selectedPayment = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      final amountText = amountController.text.trim();
                      final parsedAmount = double.tryParse(amountText);
                      if (parsedAmount == null || parsedAmount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid amount.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      setState(() => isSubmitting = true);

                      try {
                        if (selectedPayment == 'Cash') {
                          await _handleCashRepayment(context,
                              amount: parsedAmount,
                              lenderId: lenderId,
                              lenderName: lenderName);
                          if (context.mounted) Navigator.pop(context);
                        } else {
                          await _handleWalletRepayment(context,
                              amount: parsedAmount,
                              lenderId: lenderId,
                              lenderName: lenderName);
                        }
                      } finally {
                        if (context.mounted) {
                          setState(() => isSubmitting = false);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Confirm'),
            ),
          ],
        );
      },
    ),
  );
}

Future<void> _handleCashRepayment(
  BuildContext context, {
  required double amount,
  required String lenderId,
  required String lenderName,
}) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You must be logged in to record a repayment.')),
    );
    return;
  }

  final success = await PaymentTrackingService.recordRepayment(
    senderId: currentUser.uid,
    recipientId: lenderId,
    recipientName: lenderName,
    amount: amount,
    paymentMethod: 'cash',
  );

  if (success) {
    await BorrowingService.notifyCashRepaymentRequest(lenderId: lenderId, amount: amount);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cash repayment recorded for $lenderName'),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to record repayment. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> _handleWalletRepayment(
  BuildContext context, {
  required double amount,
  required String lenderId,
  required String lenderName,
  bool closeCurrentDialog = true,
}) async {
  final lenderProfile = await BorrowingService.getUserProfile(lenderId);
  if (lenderProfile == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not load $lenderName\'s profile for payment.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return;
  }

  if (context.mounted) {
    if (closeCurrentDialog && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          recipientId: lenderId,
          recipientData: lenderProfile,
          isRepaymentMode: true,
          initialAmount: amount,
        ),
      ),
    );
  }
}

