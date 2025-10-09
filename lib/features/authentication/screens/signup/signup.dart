import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/common/widgets/login_signup/form_divider.dart';
import 'package:utrack/common/widgets/login_signup/social_buttons.dart';
import 'package:utrack/features/authentication/screens/signup/signup_widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Usizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                UTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: Usizes.spaceBtwSections),

              /// Form
              USignup_Form(dark: dark),

              /// Divider
              UFormDivider(dividerText: UTexts.orSignInWith.capitalize),
              const SizedBox(height: Usizes.spaceBtwSections),

              /// Social Buttons
              const USocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}



extension StringCasingExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

