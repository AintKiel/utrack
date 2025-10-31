import 'package:flutter/material.dart';
import 'package:utrack/features/app_pages/home/qr_screen.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/formatters/icons.dart';
import '../../notifWidgets/manual_utang.dart';
import '../../scan_utang_form.dart';


class UScanQrButton extends StatelessWidget {
  const UScanQrButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -27,
      left: 40,
      right: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // My QR Code button
          SizedBox(
            width: 110,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.6),
                  builder: (context) => const MyQrPopup(),
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
                padding: EdgeInsets.zero, // 👈 removes default internal padding
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIcons.qrCode(color: UColors.black, size: 35),
                  const SizedBox(width: 1),
                  const Text(
                    UTexts.myQr,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width: 42,
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
                padding: const EdgeInsets.all(0), // Adjust for button size
              ),
              child: const Icon(Icons.add, size: 25, color: Colors.white,),
            ),
          ),

          // Record Utang button
          SizedBox(
            width: 110,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: UColors.white.withOpacity(0.8),
                foregroundColor: Colors.black,
                elevation: 6,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.zero, // 👈 keeps inner content centered
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIcons.scanQR(color: UColors.black, size: 35),
                  const SizedBox(width: 1),
                  const Text(
                    UTexts.scan,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
