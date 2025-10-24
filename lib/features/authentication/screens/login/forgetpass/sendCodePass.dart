import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:utrack/features/authentication/screens/login/forgetpass/createNewPass.dart';
import 'package:utrack/features/authentication/screens/login/forgetpass/forgetPassValidEmail.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/formatters/images.dart';
import 'package:utrack/utils/constants/colors.dart';

class ForgetPassVerifyEmailScreen extends StatefulWidget {
  const ForgetPassVerifyEmailScreen({super.key});

  @override
  State<ForgetPassVerifyEmailScreen> createState() =>
      _ForgetPassVerifyEmailScreenState();
}

class _ForgetPassVerifyEmailScreenState
    extends State<ForgetPassVerifyEmailScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const ForgetPassEmail()),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Usizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 📩 Image Section
              Image.asset(
                ULogos.sendEmail,
                height: ULogoSizes.onBoardSize,
                width: UHelperFunctions.screenWidth(context) * 0.6,
              ),
              const SizedBox(height: Usizes.spaceBtwSections),

              /// 📝 Title & Subtitle
              Text(
                UTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Usizes.spaceBtwItems),
              Text(
                UTexts.confirmEmailSentCode,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Usizes.spaceBtwItems * 0.5),
              Text(
                'kemekeme@gmail.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Usizes.spaceBtwSections),

              /// 🔢 Code Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: Usizes.spaceBtwSections),

              /// ▶ Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const CreateNewPassEmail()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark
                        ? UColors.dark.primary
                        : UColors.light.primary,
                    foregroundColor: UColors.light.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Continue"),
                ),
              ),
              const SizedBox(height: Usizes.spaceBtwSections),

              /// 🔁 Resend Option
              TextButton(
                onPressed: () {
                  // TODO: Add resend email logic
                },
                child: RichText(
                  text: TextSpan(
                    text: "${UTexts.emailNotReceiveCode} ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Send Again',
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
        ),
      ),
    );
  }
}
