import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/features/app_pages/home/home_page.dart';
import 'package:utrack/features/app_pages/loan_page/lending_page/lending_page.dart';
import 'package:utrack/utils/constants/colors.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'features/app_pages/loan_page/loan_page.dart';
import 'features/app_pages/profile_page/personalization/screens/accountScreen.dart';
import 'features/app_pages/transacHistory_page/histroryMain.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = Get.put(NavigationController(), permanent: true);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          backgroundColor: dark ? UColors.black : UColors.white,
          indicatorColor: dark ? UColors.white.withOpacity(0.1) : UColors.black.withOpacity(0.1),
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(icon: UIcons.home(size: UIcons.large, color: dark ? UColors.grey : UColors.darkGrey), label: 'Home'),
            NavigationDestination(icon: UIcons.loan(size: UIcons.large, color: dark ? UColors.grey : UColors.darkGrey), label: 'Loans'),
            NavigationDestination(icon: UIcons.history(size: UIcons.large, color: dark ? UColors.grey : UColors.darkGrey), label: 'History'),
            NavigationDestination(icon: UIcons.user(size: UIcons.large, color: dark ? UColors.grey : UColors.darkGrey), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Rx<int> loanPageIndex = 0.obs; // 0 = LendingPage, 1 = BorrowingPage

  final screens = [
    const HomePageScreen(),
    const LoanMainPage(), // This will manage Lending & Borrowing
    const HistoryMain(),
    AccountScreen(),
  ];
}