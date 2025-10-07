import 'package:flutter/material.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/constants/image_strings.dart';
import 'package:utrack/utils/constants/text_strings.dart';

class ULoginHeader extends StatelessWidget {
  const ULoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Image(
            height: 140,
            image: AssetImage(
              dark ? UImages.lightAppLogo : UImages.darkAppLogo,
            ),
          ),
        ),
        const SizedBox(height: Usizes.sm),
        Text(
          UTexts.loginTitle,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Usizes.sm),
        Text(
          UTexts.loginSubTitle,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
