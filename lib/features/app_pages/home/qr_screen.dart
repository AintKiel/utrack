import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import '../../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class MyQrPopup extends StatelessWidget {
  const MyQrPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 110),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? UColors.black
              : UColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Close Button
              Stack(
                alignment: Alignment.center,
                children: [
                  // Centered Title
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        UTexts.qrCode,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? UColors.white
                              : UColors.black,),
                      ),
                    ),
                  ),

                  // Close Button (Top Right)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(icon: const Icon(Icons.close_rounded, color: Colors.black54),
                      onPressed: () => Navigator.of(context).pop(),),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// QR Code Display
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blueGrey[100]?.withOpacity(0.9)
                        : Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: 'user123',
                      version: QrVersions.auto,
                      size: 180,
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                    const SizedBox(height: 12),
                    const Text(UTexts.nameExample,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(UTexts.addressExample,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.5, color: Colors.black87),
                    ),
                    const Text(UTexts.phoneExample,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.5, color: Colors.black87),
                    ),
                    const Text(
                      "${UTexts.userID} ${UTexts.userIDex}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.5, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: UColors.primary, borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: UColors.primary, borderRadius: BorderRadius.circular(20),),
                        child: const Text(
                          "Credit Score: 85%",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: UColors.white
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blueGrey[100]?.withOpacity(0.9)
                      : Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      UTexts.qrUse,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.5, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _QrActionButton(icon: Icons.copy, label: "Copy Data",),
                  _QrActionButton(icon: Icons.download, label: "Download"),
                  _QrActionButton(icon: Icons.share, label: "Share"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QrActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22, color: Colors.blueGrey[700]),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12,  color: Colors.blueGrey[700],)),
      ],
    );
  }
}
