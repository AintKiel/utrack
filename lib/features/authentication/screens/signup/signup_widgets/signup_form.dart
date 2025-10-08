import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/features/authentication/screens/signup/verify_email.dart';


class USignup_Form extends StatelessWidget {
  const USignup_Form({
    super.key, required this.dark
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          /// Name fields (First & Last)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: InputDecoration(labelText: UTexts.firstName, prefixIcon: UIcons.user(),
                  ),
                ),
              ),
              const SizedBox(width: Usizes.spaceBtwInputField),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: InputDecoration(labelText: UTexts.lastName, prefixIcon: UIcons.user(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Usizes.spaceBtwInputField * 1.1),

          /// Username
          TextFormField(
            expands: false,
            decoration: InputDecoration(labelText: UTexts.username, prefixIcon: UIcons.userEdit(),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Email
          TextFormField(
            expands: false,
            decoration: InputDecoration(labelText: UTexts.email, prefixIcon: UIcons.mail(),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Phone Number
          TextFormField(
            expands: false,
            decoration: InputDecoration(labelText: UTexts.phoneNo, prefixIcon: UIcons.phone(),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Password
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(labelText: UTexts.password, prefixIcon: UIcons.password(), suffixIcon: UIcons.visibilityOff(),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwSections),

          /// Terms and Conditions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 24, height: 24, child: Checkbox(value: true, onChanged: (value) {}),
              ),
              const SizedBox(width: Usizes.spaceBtwItems),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${UTexts.iAgreeto} ', style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.dark
                              ? UColors.grey
                              : UColors.darkGrey,
                        ),
                      ),
                      TextSpan(
                        text: UTexts.privacyPolicy, style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: dark
                              ? UColors.dark.primary
                              : UColors.light.accent,
                          decoration: TextDecoration.underline,
                          decorationColor: dark
                              ? UColors.dark.primary
                              : UColors.light.accent,
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.dark
                              ? UColors.grey
                              : UColors.darkGrey,
                        ),
                      ),
                      TextSpan(
                        text: UTexts.termsOfUse,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: dark
                              ? UColors.dark.primary
                              : UColors.light.accent,
                          decoration: TextDecoration.underline,
                          decorationColor: dark
                              ? UColors.dark.primary
                              : UColors.light.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Usizes.spaceBtwSections),

          /// Sign Up Button
          SizedBox(width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const VerifyEmailScreen()),
              style: ElevatedButton.styleFrom(foregroundColor: UColors.light.background, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(UTexts.createAccount),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwSections),
        ],
      ),
    );
  }
}