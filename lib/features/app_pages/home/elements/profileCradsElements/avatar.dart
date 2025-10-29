import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class UAvatar extends StatelessWidget {
  const UAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Circle Avatar
            Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                color: UColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                UTexts.avatar,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name and subtitle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      UTexts.welcome,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: UColors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Juan', // first name of the user
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: UColors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1),
                Text(
                  UTexts.personalAccount,
                  style: TextStyle(
                    color: UColors.buttonDisabled,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 50), // space before floating buttons
      ],
    );

  }
}

