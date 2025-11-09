import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../navigation_menu.dart';
import 'borrowing_page/borrowing_page.dart';
import 'lending_page/lending_page.dart';

class LoanMainPage extends StatelessWidget {
  const LoanMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Obx(() {
      return controller.loanPageIndex.value == 0
          ? const LendingPage()
          : const BorrowingPage();
    });
  }
}