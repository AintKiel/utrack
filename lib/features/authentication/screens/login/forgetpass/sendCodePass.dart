import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:utrack/features/authentication/screens/login/forgetpass/forgetPassValidEmail.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/constants/image_strings.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/features/authentication/controllers/authentication_controller.dart';

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
  final _authController = AuthenticationController.instance;
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _getCompleteCode() {
    return _controllers.map((c) => c.text).join();
  }

  Future<void> _verifyCode() async {
    String code = _getCompleteCode();

    if (code.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter all 6 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      bool isValid = await _authController.verifyPasswordResetCode(code);

      if (isValid) {
        Get.snackbar(
          'Success',
          'Code verified! Sending password reset email...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Call the new method that sends the password reset email
        // and goes to login page (no more createNewPass screen)
        await _authController.sendPasswordResetEmailAfterVerification();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Verification failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  void _clearCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    FocusScope.of(context).unfocus();
  }

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

              /// 🔐 Title & Subtitle
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
              const SizedBox(height: Usizes.spaceBtwSections),

              /// 🔢 Code Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      enabled: !_isVerifying,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: dark
                                ? UColors.dark.primary.withOpacity(0.3)
                                : UColors.light.primary.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: dark
                                ? UColors.dark.primary
                                : UColors.light.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
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
              const SizedBox(height: Usizes.spaceBtwSections * 1),

              /// ▶ Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: UColors.light.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Verify Code'),
                ),
              ),
              const SizedBox(height: Usizes.spaceBtwItems),

              /// Clear Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _isVerifying ? null : _clearCode,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(height: Usizes.spaceBtwSections),

              /// 📨 Resend Option
              TextButton(
                onPressed: _isVerifying
                    ? null
                    : () async {
                  await _authController.resendPasswordResetCode();
                  _clearCode();
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: UTexts.emailNotReceiveCode,
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: ' Send Again',
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