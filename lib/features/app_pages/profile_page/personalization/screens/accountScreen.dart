import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/features/app_pages/home/notifWidgets/notif_screen.dart';
import 'package:utrack/features/app_pages/profile_page/personalization/screens/settings/changePass.dart';
import 'package:utrack/features/app_pages/profile_page/personalization/screens/settings/faqs.dart';
import 'package:utrack/features/app_pages/profile_page/personalization/screens/settings/settingSection.dart';
import 'package:utrack/features/app_pages/profile_page/personalization/screens/settings/termsConditions.dart';
import 'package:utrack/features/authentication/screens/login/login.dart';
import '../../../../../common/widgets/custom_shapes/containers/tertiary_header_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import 'activityTransaction/activitySection.dart';
import 'contacts/contactsSection.dart';
import 'header/account_header.dart';

class UserModel {
  final String fullName;
  final String id;
  final String? profilePicUrl;

  UserModel({
    required this.fullName,
    required this.id,
    this.profilePicUrl,
  });
}

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final UserModel user = UserModel(
    fullName: "Kriztel Garcia",
    id: "USER123456",
    profilePicUrl: "",
  );

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark
        ? Colors.grey.shade900 : Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------
            // HEADER
            // ---------------------------
            UTertiaryHeaderContainer(
              height: 230,
              child: AccountHeader(
                fullName: user.fullName,
                userId: user.id,
                profilePicUrl: user.profilePicUrl,
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------
            // TRANSACTION SUMMARY
            // ---------------------------
            const ActivityCard(
              totalTransactions: 43,
              completed: 23,
            ),

            const SizedBox(height: 22),

            // ---------------------------
            // CONTACT INFO (CARD STYLE)
            // ---------------------------
            ContactInfoCard(
              email: "garciakriztel24@gmail.com",
              phone: "09876543212",
              address: "babybabygidineun",
            ),

            const SizedBox(height: 22),

            // ---------------------------
            // SETTINGS CONTAINER
            // ---------------------------
            SettingsListCard(
              onNotifications: () => Get.to(() => const UNotificationScreen()),
              onPrivacy: () => Get.to(() => const ChangePassEmail()),
              onHelp: () => Get.to(() => const HelpCenterScreen()),
              onTerms: () => Get.to(() => const TermsConditions()),
            ),

            const SizedBox(height: 30),

            // ---------------------------
            // LOGOUT BUTTON
            // ---------------------------
            Center(
              child: SizedBox(
                width: 330,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () => Get.to(() => const LoginScreen()),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: UColors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
