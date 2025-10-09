import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/features/authentication/controllers/authentication_controller.dart';

class USignup_Form extends StatefulWidget {
  const USignup_Form({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  State<USignup_Form> createState() => _USignup_FormState();
}

class _USignup_FormState extends State<USignup_Form> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.put(AuthenticationController());

  bool _acceptTerms = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (!_acceptTerms) {
      Get.snackbar(
        'Terms Required',
        'Please accept the terms and conditions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _authController.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        phoneNumber: _phoneController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// Name fields (First & Last)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: UTexts.firstName,
                    prefixIcon: UIcons.user(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: UColors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: UColors.light.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Usizes.spaceBtwInputField),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: UTexts.lastName,
                    prefixIcon: UIcons.user(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: UColors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: UColors.light.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Usizes.spaceBtwInputField * 1.1),

          /// Username
          TextFormField(
            controller: _usernameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: UTexts.username,
              prefixIcon: UIcons.userEdit(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: UColors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: UColors.light.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: UTexts.email,
              prefixIcon: UIcons.mail(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: UColors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: UColors.light.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Phone Number
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: UTexts.phoneNo,
              prefixIcon: UIcons.phone(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: UColors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: UColors.light.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwInputField),

          /// Password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: UTexts.password,
              prefixIcon: UIcons.password(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: UColors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: UColors.light.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwSections),

          /// Terms and Conditions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: Usizes.spaceBtwItems),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${UTexts.iAgreeto} ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? UColors.grey
                              : UColors.darkGrey,
                        ),
                      ),
                      TextSpan(
                        text: UTexts.privacyPolicy,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: widget.dark
                              ? UColors.dark.primary
                              : UColors.light.accent,
                          decoration: TextDecoration.underline,
                          decorationColor: widget.dark
                              ? UColors.dark.primary
                              : UColors.light.accent,
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
                        text: UTexts.termsOfUse,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: widget.dark
                              ? UColors.dark.primary
                              : UColors.light.accent,
                          decoration: TextDecoration.underline,
                          decorationColor: widget.dark
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
          Obx(
                () => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _authController.isLoading.value
                    ? null
                    : _handleSignup,
                style: ElevatedButton.styleFrom(
                  foregroundColor: UColors.light.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _authController.isLoading.value
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(UTexts.createAccount),
              ),
            ),
          ),
          const SizedBox(height: Usizes.spaceBtwSections),
        ],
      ),
    );
  }
}