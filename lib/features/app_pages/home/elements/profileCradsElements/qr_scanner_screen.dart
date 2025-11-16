import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../services/paymongo_service.dart';
import '../../../../../services/payment_tracking_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool hasScanned = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        centerTitle: true,
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && !hasScanned) {
            final String scannedQr = barcodes.first.rawValue ?? '';
            print('✅ Scanned QR: $scannedQr');

            if (scannedQr.contains('utrack://user/')) {
              hasScanned = true;
              cameraController.stop();
              _handleQrScan(scannedQr);
            }
          }
        },
      ),
    );
  }

  Future<void> _handleQrScan(String qrData) async {
    try {
      print('📊 Full QR Data: $qrData');

      // Extract user ID from QR
      // Format: utrack://user/{userId}
      String userId = '';

      if (qrData.contains('utrack://user/')) {
        // Remove the prefix and get everything after it
        userId = qrData.replaceFirst('utrack://user/', '');
        // Remove any query parameters if they exist
        if (userId.contains('?')) {
          userId = userId.split('?')[0];
        }
      }

      print('🔍 Extracted user ID: $userId');

      if (userId.isEmpty) {
        _showError('Invalid QR Code format');
        return;
      }

      // Fetch user details from Firebase
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        _showError('User not found in database');
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      print(
          '👤 User found: ${userData['firstName']} ${userData['lastName']}');

      // Navigate to payment screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              recipientId: userId,
              recipientData: userData,
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Error: $e');
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => hasScanned = false);
        cameraController.start();
      }
    });
  }
}

/// Payment Screen - Enter amount and proceed
class PaymentScreen extends StatefulWidget {
  final String recipientId;
  final Map<String, dynamic> recipientData;
  final bool isRepaymentMode;
  final double? initialAmount;

  const PaymentScreen({
    super.key,
    required this.recipientId,
    required this.recipientData,
    this.isRepaymentMode = false,
    this.initialAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null) {
      amountController.text = widget.initialAmount!.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Payment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient Info
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Send to:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.recipientData['firstName']} ${widget.recipientData['lastName']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phone: ${widget.recipientData['phoneNumber']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Address: ${widget.recipientData['address']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Amount Input
              const Text(
                'Enter Amount (PHP)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '₱ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
              const SizedBox(height: 30),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isRepaymentMode ? Colors.green : Colors.blue,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    widget.isRepaymentMode ? 'Repay via PayMongo' : 'Proceed to Payment',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    final amount = amountController.text.trim();

    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Create payment link with PayMongo
      final paymentLink = await PayMongoService.createPaymentLink(
        amount: double.parse(amount),
        recipientId: widget.recipientId,
        recipientName:
        '${widget.recipientData['firstName']} ${widget.recipientData['lastName']}',
      );

      if (paymentLink != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentCheckoutScreen(
              paymentLink: paymentLink.checkoutUrl,
              paymentLinkId: paymentLink.id,
              recipientId: widget.recipientId,
              recipientName: '${widget.recipientData['firstName']} ${widget.recipientData['lastName']}',
              amount: double.parse(amount),
              isRepaymentMode: widget.isRepaymentMode,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}

/// Payment Checkout Screen
/// Payment Checkout Screen
class PaymentCheckoutScreen extends StatefulWidget {
  final String paymentLink;
  final String paymentLinkId;
  final String recipientId;
  final String recipientName;
  final double amount;
  final bool isRepaymentMode;

  const PaymentCheckoutScreen({
    super.key,
    required this.paymentLink,
    required this.paymentLinkId,
    required this.recipientId,
    required this.recipientName,
    required this.amount,
    this.isRepaymentMode = false,
  });

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  bool _paymentCompleted = false;
  bool _verifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Checkout'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.payment,
                size: 60,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                '₱${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Click the button below to proceed to payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _paymentCompleted ? null : () async {
                  final Uri url = Uri.parse(widget.paymentLink);
                  try {
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );

                      // Show confirmation dialog after opening payment
                      if (mounted) {
                        _showPaymentConfirmation();
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('No browser app available')),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(
                  _paymentCompleted
                      ? 'Payment Recorded ✓'
                      : _verifying
                          ? 'Verifying...'
                          : 'Go to Payment',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (_paymentCompleted) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => NavigationMenu());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            title: const Text('Payment Confirmation'),
            content: const Text('Did you complete the payment?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No, Go Back'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _confirmViaPayMongo();
                },
                child: const Text('Yes, Confirm Payment'),
              ),
            ],
          ),
    );
  }

  Future<void> _confirmViaPayMongo() async {
    setState(() => _verifying = true);
    try {
      final isPaid = await PayMongoService.verifyPaymentStatus(widget.paymentLinkId);
      if (!isPaid) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PayMongo has not marked this link as paid yet.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      await _recordTransaction();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _verifying = false);
      }
    }
  }

  Future<void> _recordTransaction() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      // Call the PaymentTrackingService method
      bool success;
      if (widget.isRepaymentMode) {
        success = await PaymentTrackingService.recordRepayment(
          senderId: currentUser.uid,
          recipientId: widget.recipientId,
          recipientName: widget.recipientName,
          amount: widget.amount,
          paymentMethod: 'paymongo',
        );
      } else {
        success = await PaymentTrackingService.recordPayment(
          senderId: currentUser.uid,
          recipientId: widget.recipientId,
          recipientName: widget.recipientName,
          amount: widget.amount,
          paymentMethod: 'paymongo',
        );
      }

      if (success) {
        // Update contact counts
        await PaymentTrackingService.updateContactCounts(currentUser.uid);

        setState(() => _paymentCompleted = true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.isRepaymentMode ? 'Repayment recorded successfully!' : 'Payment recorded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to record payment'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}