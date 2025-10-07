import 'package:flutter/material.dart';
import 'package:utrack/features/authentication/screens/login/widgets/login_header.dart';
import 'package:utrack/features/authentication/screens/login/widgets/login_form.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/common/style/spacing_styles.dart';
import '../../../../utils/constants/text_strings.dart';
import 'package:utrack/common/widgets/login_signup/form_divider.dart';
import 'package:utrack/common/widgets/login_signup/social_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: USpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title, & Subtitle
              const ULoginHeader(),

              /// Form
              const ULoginForm(),

              ///Divider
              UFormDivider(dividerText: UTexts.orSignInWith.capitalize),
              const SizedBox(height: Usizes.spaceBtwSections,),

              ///Footer
              USocialButtons()
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

