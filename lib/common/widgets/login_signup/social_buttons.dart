import 'package:flutter/material.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/constants/image_strings.dart';
import 'package:utrack/utils/constants/colors.dart';

class USocialButtons extends StatelessWidget {
  const USocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: UColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: Usizes.iconMd,
              height: Usizes.iconMd,
              image: AssetImage(UImages.googleLogo),
            ),
          ),
        ),
        const SizedBox(width: Usizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(border: Border.all(color: UColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: Usizes.iconMd,
              height: Usizes.iconMd,
              image: AssetImage(UImages.facebookLogo),
            ),
          ),
        ),
      ],
    );
  }
}
