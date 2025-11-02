import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utrack/features/app_pages/home/elements/profileCradsElements/qr_scanner_screen.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/formatters/icons.dart';
import '../../notifWidgets/manual_utang.dart';


class UScanQrButton extends StatelessWidget {
  const UScanQrButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -27,
      left: 15,
      right: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // My QR Code button
          Flexible(
            child: SizedBox(
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.6),
                      builder: (context) => UserQrCodeDialog(userId: user.uid),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: UColors.white.withOpacity(0.8),
                  foregroundColor: Colors.black,
                  elevation: 6,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UIcons.qrCode(color: UColors.black, size: 40),
                    const SizedBox(width: 4),
                    const Text(
                      UTexts.myQr,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Floating Add button
          SizedBox(
            width: 34,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.6),
                  builder: (context) => const RequestUtangPopup(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: UColors.secondary.withOpacity(0.9),
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: Colors.black26,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
              ),
              child: const Icon(Icons.add, size: 20, color: Colors.white),
            ),
          ),

          const SizedBox(width: 8),

          // Scan button - NOW WORKING
          Flexible(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QrScannerScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: UColors.white.withOpacity(0.8),
                  foregroundColor: Colors.black,
                  elevation: 6,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UIcons.scanQR(color: UColors.black, size: 40),
                    const SizedBox(width: 4),
                    const Text(
                      UTexts.scan,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// QR Code Display Dialog
class UserQrCodeDialog extends StatefulWidget {
  final String userId;

  const UserQrCodeDialog({
    required this.userId,
  });

  @override
  State<UserQrCodeDialog> createState() => _UserQrCodeDialogState();
}

class _UserQrCodeDialogState extends State<UserQrCodeDialog> {
  late String qrData;
  bool isLoading = true;
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        firstName = data['firstName'] ?? '';
        lastName = data['lastName'] ?? '';
        phoneNumber = data['phoneNumber'] ?? '';
        address = data['address'] ?? '';

        qrData = 'utrack://user/${widget.userId}';

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.userId)
            .update({
          'qrCode': qrData,
          'qrCreatedAt': FieldValue.serverTimestamp(),
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'My QR Code',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              if (isLoading)
                const CircularProgressIndicator()
              else
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 280,
                    gapless: false,
                  ),
                ),
              const SizedBox(height: 20),

              // User Details
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Share this code to receive payments',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildDetailRow('Name:', '$firstName $lastName'),
                    const SizedBox(height: 10),
                    _buildDetailRow('Phone:', phoneNumber),
                    const SizedBox(height: 10),
                    _buildDetailRow('Address:', address),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Share coming soon')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}