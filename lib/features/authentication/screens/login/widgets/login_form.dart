import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/features/authentication/screens/signup/signup.dart';
import 'package:utrack/features/authentication/screens/login/forgetpass/forgetPassValidEmail.dart';
import 'package:utrack/features/authentication/controllers/authentication_controller.dart';

class ULoginForm extends StatefulWidget {
  const ULoginForm({super.key});

  @override
  State<ULoginForm> createState() => _ULoginFormState();
}

class _ULoginFormState extends State<ULoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = AuthenticationController.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validate email format
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

  /// Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Handle login
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _authController.loginWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// Email Field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: UTexts.email,
              prefixIcon: UIcons.mail(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Password Field
          Obx(
                () => TextFormField(
              controller: _passwordController,
              obscureText: _authController.hidePassword.value,
              decoration: InputDecoration(
                labelText: UTexts.password,
                prefixIcon: UIcons.password(),
                suffixIcon: IconButton(
                  onPressed: () => _authController.togglePasswordVisibility(),
                  icon: Icon(
                    _authController.hidePassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: _validatePassword,
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text('Remember Me'),
                ],
              ),
              TextButton(
                onPressed: () => Get.to(() => const ForgetPassEmail()),
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
          const SizedBox(height: Usizes.spaceBtwSections),

          /// Login Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(
                  () => ElevatedButton(
                onPressed: _authController.isLoading.value ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  foregroundColor: UColors.light.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _authController.isLoading.value
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Sign In'),
              ),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwItems),

          /// Sign Up Link
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const SignupScreen()),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Create Account'),
            ),
          ),
        ],
      ),
    );
  }
}