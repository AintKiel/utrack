import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/features/authentication/controllers/authentication_controller.dart';

class USignup_Form extends StatefulWidget {
  const USignup_Form({super.key, required this.dark});

  final bool dark;

  @override
  State<USignup_Form> createState() => _USignup_FormState();
}

class _USignup_FormState extends State<USignup_Form> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _termsAccepted = false;
  final _authController = AuthenticationController.instance;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validate name
  String? _validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  /// Validate email
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

  /// Validate phone
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Enter a valid phone number';
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
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain lowercase letters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain uppercase letters';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain numbers';
    }
    return null;
  }

  /// Validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Handle signup
  void _handleSignup() {
    if (!_termsAccepted) {
      Get.snackbar(
        'Error',
        'Please accept the terms and conditions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _authController.prepareSignUpWithEmailAndPassword(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNo: _phoneController.text.trim(),
        address: _addressController.text.trim(),
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
          /// ID Matching Notice (under the title)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All details must match your valid ID.',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: UIcons.user(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => _validateName(value, 'First name'),
                ),
              ),
              const SizedBox(width: Usizes.spaceBtwInputField),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: UIcons.user(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => _validateName(value, 'Last name'),
                ),
              ),
            ],
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Email
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: UIcons.mail(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Phone
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: UIcons.phone(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Address
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              prefixIcon: UIcons.location(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) => (value?.isEmpty ?? true) ? 'Address is required' : null,
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Password
          Obx(
                () => TextFormField(
              controller: _passwordController,
              obscureText: _authController.hidePassword.value,
              decoration: InputDecoration(
                labelText: 'Password',
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

          /// Confirm Password
          Obx(
                () => TextFormField(
              controller: _confirmPasswordController,
              obscureText: _authController.hidePassword.value,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
              validator: _validateConfirmPassword,
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwSections),

          /// Terms & Conditions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _termsAccepted,
                  onChanged: (value) {
                    setState(() => _termsAccepted = value ?? false);
                  },
                ),
              ),
              const SizedBox(width: Usizes.spaceBtwItems),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'I agree to ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? UColors.grey
                              : UColors.darkGrey,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: widget.dark
                              ? UColors.dark.primary
                              : UColors.light.accent,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? UColors.grey
                              : UColors.darkGrey,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms of Use',
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: widget.dark
                              ? UColors.dark.primary
                              : UColors.light.accent,
                          decoration: TextDecoration.underline,
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
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(
                  () => ElevatedButton(
                onPressed: _authController.isLoading.value ? null : _handleSignup,
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
                    : const Text('Create Account'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}