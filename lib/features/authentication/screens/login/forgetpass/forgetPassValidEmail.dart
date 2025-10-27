import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/features/authentication/screens/login/forgetpass/sendCodePass.dart';
import 'package:utrack/features/authentication/screens/login/login.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:utrack/features/authentication/controllers/authentication_controller.dart';

class ForgetPassEmail extends StatefulWidget {
  const ForgetPassEmail({super.key});

  @override
  State<ForgetPassEmail> createState() => _ForgetPassEmailState();
}

class _ForgetPassEmailState extends State<ForgetPassEmail> {
    final _emailController = TextEditingController();
  final _authController = AuthenticationController.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  Future<void> _handlePasswordReset() async {
    if (_formKey.currentState!.validate()) {
      bool success = await _authController.sendPasswordResetCode(
        email: _emailController.text.trim(),
      );

      // Only navigate if email check was successful
      if (success) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.to(() => const ForgetPassVerifyEmailScreen());
        });
      }
    }
  }

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
            // Headings
            Text(
              UTexts.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Usizes.spaceBtwItems),
            Text(
              UTexts.forgetPasswordSubtitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: dark ? UColors.grey : UColors.black,
              ),
            ),
            const SizedBox(height: Usizes.spaceBtwSections * 1.5),

            // Email Field
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: UTexts.email,
                      prefixIcon: UIcons.mail(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: Usizes.spaceBtwSections),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(
                          () => ElevatedButton(
                        onPressed: _authController.isLoading.value
                            ? null
                            : _handlePasswordReset,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: UColors.light.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: _authController.isLoading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                            : const Text('Send Reset Code'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Usizes.spaceBtwItems),

            // Back to Login
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.offAll(() => const LoginScreen()),
                child: const Text('Back to Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}