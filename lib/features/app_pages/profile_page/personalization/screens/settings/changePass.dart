import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/features/authentication/screens/login/forgetpass/sendCodePass.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';

class ChangePassEmail extends StatefulWidget {
  const ChangePassEmail({super.key});

  @override
  State<ChangePassEmail> createState() => _ChangePassEmailState();
}

class _ChangePassEmailState extends State<ChangePassEmail> {
  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Usizes.defaultSpace),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Headings
              Text(UTexts.changePasswordTitle, style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: Usizes.spaceBtwItems),
              Text(UTexts.changePasswordSubtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: dark ? UColors.grey : UColors.black) ),
              const SizedBox(height: Usizes.spaceBtwSections * 1.5),
              /// Text field
              TextFormField(
                  decoration: InputDecoration(
                      labelText: UTexts.email, prefixIcon: UIcons.mail())
              ),
              const SizedBox(height: Usizes.spaceBtwSections,),

              /// Submit Button
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Get.to(() => const ForgetPassVerifyEmailScreen()),
                style: ElevatedButton.styleFrom(foregroundColor: UColors.light.background, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                child: Text(UTexts.submit),),),
            ]
        ),
      ),
    );
  }
}
