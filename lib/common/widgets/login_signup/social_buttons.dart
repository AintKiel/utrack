import 'package:flutter/material.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/utils/constants/image_strings.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/features/authentication/controllers/authentication_controller.dart';
import 'package:get/get.dart';

class USocialButtons extends StatelessWidget {
  const USocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final _authController = AuthenticationController.instance;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: UColors.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Obx(
              () => IconButton(
            onPressed: _authController.isLoading.value
                ? null
                : () => _authController.signInWithGoogle(),
            icon: _authController.isLoading.value
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : Image.asset(
              UImages.google,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}