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
import '../../../../../services/profile_service.dart';
import 'activityTransaction/activitySection.dart';
import 'contacts/contactsSection.dart';
import 'header/account_header.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: ProfileService.getUserProfileStream(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  const Text('Error loading profile'),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // No data state
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No user data found'),
            );
          }

          final userData = snapshot.data!;
          final fullName = userData['fullName'] ?? 'User';
          final uid = userData['uid'] ?? '';
          final email = userData['email'] ?? '';
          final phone = userData['phone'] ?? '';
          final address = userData['address'] ?? '';
          final profilePicUrl = userData['profilePicUrl'] ?? '';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------
                // HEADER
                // ---------------------------
                UTertiaryHeaderContainer(
                  height: 230,
                  child: AccountHeader(
                    fullName: fullName,
                    userId: uid,
                    profilePicUrl: profilePicUrl.isEmpty ? null : profilePicUrl,
                  ),
                ),

                const SizedBox(height: 10),

                // ---------------------------
                // TRANSACTION SUMMARY
                // ---------------------------
                FutureBuilder<Map<String, dynamic>>(
                  future: ProfileService.getUserActivityStats(),
                  builder: (context, activitySnapshot) {
                    if (activitySnapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final activityData = activitySnapshot.data ?? {
                      'totalTransactions': 0,
                      'completedTransactions': 0,
                    };

                    return ActivityCard(
                      totalTransactions: activityData['totalTransactions'] ?? 0,
                      completed: activityData['completedTransactions'] ?? 0,
                    );
                  },
                ),

                const SizedBox(height: 22),

                // ---------------------------
                // CONTACT INFO (CARD STYLE)
                // ---------------------------
                ContactInfoCard(
                  email: email,
                  phone: phone,
                  address: address,
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: UColors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}