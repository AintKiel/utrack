import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/image_strings.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/features/authentication/screens/login/login.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:utrack/utils/formatters/images.dart';

class IdValidationScreen extends StatelessWidget {
  const IdValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
            icon: const Icon(CupertinoIcons.clear),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(Usizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Image
                Image(
                  image: const AssetImage(ULogos.verifyID),
                  height: ULogoSizes.onBoardSize,
                  width: UHelperFunctions.screenWidth(context) * 0.6,
                ),
                const SizedBox(height: Usizes.spaceBtwSections),

                /// Title & Subtitle
                Text(
                  UTexts.verifyID,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Usizes.spaceBtwItems),
                Text(
                  UTexts.verifyIDsubtitle,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Usizes.spaceBtwSections * 1.2),

                /// Upload photo options
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [],
                  ),
                  child: Column(
                    children: [
                      /// Option 1 - Valid ID
                      ListTile(
                        leading: Image(image: const AssetImage(UImages.idUploadImage), height: ULogoSizes.idUploadSize),
                        title: Text(
                          "Take a picture of a valid ID",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: const Text(
                          "To check your personal information is correct",
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          // TODO: Add your upload or camera function here
                        },
                      ),
                      const Divider(height: Usizes.spaceBtwItems),

                      /// Option 2 - Selfie
                      ListTile(
                        leading:  Image(image: const AssetImage(UImages.idScanImage), height: ULogoSizes.idUploadSize),
                        title: Text(
                          "Take a selfie of yourself",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: const Text(
                          "To match your face to your ID photo",
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          // TODO: Add your selfie capture logic here
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Usizes.spaceBtwSections * 2),

                /// "Why is this needed?" link
                TextButton(
                  onPressed: () {
                    // TODO: show an info dialog or navigate to a page
                  },
                  child: const Text(
                    "Why is this needed?",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),

              ],

            )),
      ),
    );
  }
}
