import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:utrack/utils/formatters/images.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/constants/image_strings.dart';
import 'package:utrack/features/authentication/screens/login/login.dart';

class NewPasswordCreated extends StatelessWidget {
  const NewPasswordCreated ({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))]
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Usizes.defaultSpace),
        child: Column(
          children: [
            ///Image
            Image(image: AssetImage(UImages.createdImage), width: UHelperFunctions.screenWidth(context) * 0.6, height: ULogoSizes.onBoardSize,),
            const SizedBox(height: Usizes.spaceBtwSections * 1.3),

            ///Title & SubTitle
            Text(UTexts.passwordUpdated, style: Theme.of(context).textTheme.headlineSmall,),
            const SizedBox(height: Usizes.spaceBtwItems),
            Text(UTexts.createdSuccessfullySub, style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: dark ? UColors.grey : UColors.black) ),
            const SizedBox(height: Usizes.spaceBtwSections * 2.5),

            ///Buttons
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Get.to(() => const LoginScreen()),
              style: ElevatedButton.styleFrom(foregroundColor: UColors.light.background, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: Text("Continue"),),),
          ],
        )
      ),
    );
  }
}
