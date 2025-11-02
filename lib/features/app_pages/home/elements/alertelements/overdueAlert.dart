import 'package:flutter/material.dart';
import 'package:utrack/utils/formatters/icons.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class OverdueAlert extends StatelessWidget {
  const OverdueAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -30,
      top: 115,
      child: Container(
        width: 280,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.redAccent.shade200,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              /// --- Left Side: Icon ---
              UIcons.warningSign(color: UColors.black, size: 35),
              const SizedBox(width: 1),

              /// --- Texts ---
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      UTexts.overdue,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${UTexts.youHave} ', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w500),),
                                TextSpan( /// utang to be paid
                                  text: UTexts.total, style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w500),),
                                TextSpan(
                                  text: UTexts.youHavecon, style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  minimumSize: const Size(40, 24),
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: Colors.white, // for splash color
                  overlayColor: Colors.white.withOpacity(0.2), // light overlay on tap
                ),
                child: const Text(
                  UTexts.paynow,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
