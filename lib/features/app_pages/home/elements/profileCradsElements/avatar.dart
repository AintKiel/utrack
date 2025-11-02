import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class UAvatar extends StatelessWidget {
  const UAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    final avatarSize = isSmallScreen ? 45.0 : 55.0;
    final nameFont = isSmallScreen ? 18.0 : 20.0;
    final welcomeFont = isSmallScreen ? 14.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circle Avatar
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: const BoxDecoration(
                  color: UColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  UTexts.avatar,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 16 : 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),

              // Name + subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        UTexts.welcome,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: welcomeFont,
                          color: UColors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Juan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: nameFont,
                          color: UColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    UTexts.personalAccount,
                    style: TextStyle(
                      color: UColors.buttonDisabled,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40), // space before the next widget
        ],
      ),
    );
  }
}
