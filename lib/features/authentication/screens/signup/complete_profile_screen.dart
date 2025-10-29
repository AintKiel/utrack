import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import '../login/login.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:utrack/features/authentication/controllers/authentication_controller.dart';
import 'package:utrack/features/authentication/screens/signup/id_validation.dart';



class CompleteProfileScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;

  const CompleteProfileScreen({
    Key? key,
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authController = AuthenticationController.instance;

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 7) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    if (value.length < 5) {
      return 'Address is too short';
    }
    return null;
  }

  Future<void> _completeProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Update Firestore with phone and address
        await _authController.updateUserData(
          firstName: widget.firstName,
          lastName: widget.lastName,
          phoneNo: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );

        Get.snackbar(
          'Success',
          'Profile completed successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Require ID verification next
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAll(() => const IdValidationScreen());
        });
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to complete profile: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Usizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Complete Your Profile',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: Usizes.spaceBtwItems),
              Text(
                'We need some additional information to complete your profile',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: dark ? UColors.grey : UColors.black,
                ),
              ),
              const SizedBox(height: Usizes.spaceBtwSections),

              // Pre-filled info (read-only)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: dark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: ${widget.email}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Name: ${widget.firstName} ${widget.lastName}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Usizes.spaceBtwSections),

              // Phone Number Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              const SizedBox(height: Usizes.spaceBtwItems),

              // Address Field
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                validator: _validateAddress,
              ),
              const SizedBox(height: Usizes.spaceBtwSections * 2),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                      () => ElevatedButton(
                    onPressed: _authController.isLoading.value
                        ? null
                        : _completeProfile,
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
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Complete Profile'),
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