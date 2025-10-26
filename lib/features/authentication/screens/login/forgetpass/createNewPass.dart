import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/features/authentication/screens/login/forgetpass/newPassCreated.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';

class CreateNewPassEmail extends StatefulWidget {
  const CreateNewPassEmail({super.key});

  @override
  State<CreateNewPassEmail> createState() => _CreateNewPassEmailState();
}

class _CreateNewPassEmailState extends State<CreateNewPassEmail> {
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
              Text(UTexts.enterNewPass, style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: Usizes.spaceBtwItems),
              Text(UTexts.enterNewPassSubTitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: dark ? UColors.grey : UColors.black) ),
              const SizedBox(height: Usizes.spaceBtwSections),
              /// Text field
              TextFormField(
                  decoration: InputDecoration(
                      labelText: UTexts.newPassword, prefixIcon: UIcons.password())
              ),
              const SizedBox(height: Usizes.spaceBtwItems,),
              TextFormField(
                  decoration: InputDecoration(
                      labelText: UTexts.confirmPassword, prefixIcon: UIcons.password())
              ),
              const SizedBox(height: Usizes.spaceBtwSections,),

              /// Submit Button
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Get.to(() => const NewPasswordCreated()),
                style: ElevatedButton.styleFrom(foregroundColor: UColors.light.background, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                child: Text(UTexts.savePass),),),
            ]
        ),
      ),
    );
  }
}
