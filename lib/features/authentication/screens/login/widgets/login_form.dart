import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/features/authentication/screens/login/forgetpass/forgetPassValidEmail.dart';
import 'package:utrack/features/authentication/screens/signup/signup.dart';
import 'package:utrack/navigation_menu.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/constants/colors.dart';

class ULoginForm extends StatelessWidget {
  const ULoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Usizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              decoration: InputDecoration(prefixIcon: UIcons.mail(), labelText: UTexts.email, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: UColors.grey),),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: UColors.light.primary, width: 2),),),),
            const SizedBox(height: Usizes.spaceBtwInputField * 1.2),

            /// Password
            TextFormField(
              decoration: InputDecoration(prefixIcon: UIcons.password(),labelText: UTexts.password,suffixIcon: UIcons.visibilityOff(),border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: UColors.grey),),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: UColors.light.primary, width: 2),),),),
            const SizedBox(height: Usizes.spaceBtwInputField / 2),

            ///Remember Me and forget pass
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///remember me
                Row(
                  children: [
                    Checkbox(value:true, onChanged: (value){}),
                    const Text(UTexts.rememberMe),
                  ],
                ),
                ///forget pass
                TextButton(onPressed: () => Get.to(() => const ForgetPassEmail()), child: Text(UTexts.forgetPassword),)
              ],
            ),
            const SizedBox(height: Usizes.spaceBtwSections),

            ///Sign In Button
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Get.to(() => const NavigationMenu()),
              style: ElevatedButton.styleFrom(foregroundColor: UColors.light.background, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: Text(UTexts.signIn),),),
            const SizedBox(height: Usizes.spaceBtwItems * 1.1),

            ///Create Account Button
            SizedBox(width: double.infinity, height: 50, child: OutlinedButton(onPressed: () => Get.to(() => const SignupScreen()),
              style: OutlinedButton.styleFrom( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: Text(UTexts.createAccount),),),

          ],
        ),
      ),
    );
  }
}