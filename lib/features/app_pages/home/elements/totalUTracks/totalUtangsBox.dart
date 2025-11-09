import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/formatters/iconsNoPad.dart';
import '../../../loan_page/borrowing_page/borrowing_page.dart';
import '../../../loan_page/lending_page/lending_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UtangSummarySection extends StatefulWidget {
  const UtangSummarySection({super.key});

  @override
  State<UtangSummarySection> createState() => _UtangSummarySectionState();
}

class _UtangSummarySectionState extends State<UtangSummarySection> {
  double _scale1 = 1.0;
  double _scale2 = 1.0;
  double totalLent = 0.0;
  double totalOwed = 0.0;
  int borrowerCount = 0;
  int lenderCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() => isLoading = false);
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        final paymentStats = userDoc.data()?['paymentStats'] as Map<String, dynamic>?;
        setState(() {
          totalLent = (paymentStats?['totalLent'] ?? 0.0).toDouble();
          totalOwed = (paymentStats?['totalOwed'] ?? 0.0).toDouble();
          borrowerCount = (paymentStats?['borrowerCount'] ?? 0).toInt();
          lenderCount = (paymentStats?['lenderCount'] ?? 0).toInt();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('❌ Error loading payment stats: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Responsive box height & padding
    final boxHeight = isSmallScreen ? 70.0 : 83.0;
    final horizontalPadding = isSmallScreen ? 6.0 : 10.0;
    final fontSizeTitle = isSmallScreen ? 12.0 : 13.0;
    final fontSizeAmount = isSmallScreen ? 16.0 : 18.0;

    return Padding(
      padding: EdgeInsets.only(
        top: screenWidth * 0.6, // responsive spacing from top
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          // 🔹 Total Lent Box
          Expanded(
            child: GestureDetector(
              onTapDown: (_) => setState(() => _scale1 = 0.97),
              onTapUp: (_) {
                setState(() => _scale1 = 1.0);
                final navController = Get.find<NavigationController>();
                navController.selectedIndex.value = 1;
              },
              onTapCancel: () => setState(() => _scale1 = 1.0),
              child: AnimatedScale(
                scale: _scale1,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  height: boxHeight,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: UColors.lendBg.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: UColors.lendBorder, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIconsNoPad.lendIcon(
                                color: UColors.lendFont, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              UTexts.totalLent,
                              style: TextStyle(
                                color: UColors.lendFont,
                                fontWeight: FontWeight.w600,
                                fontSize: fontSizeTitle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIconsNoPad.pesoSign(
                                color: UColors.lendFont, size: 18),
                            const SizedBox(width: 3),
                            isLoading
                                ? SizedBox(
                                    width: 50,
                                    height: 18,
                                    child: LinearProgressIndicator(
                                      backgroundColor: UColors.lendFont.withOpacity(0.3),
                                      valueColor: AlwaysStoppedAnimation<Color>(UColors.lendFont),
                                    ),
                                  )
                                : Text(
                                    totalLent.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), ''),
                                    style: TextStyle(
                                      color: UColors.lendFont,
                                      fontSize: fontSizeAmount,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            const SizedBox(width: 9),
                            UIconsNoPad.visibilityOn(
                              color: UColors.lendFont,
                              size: 18,
                            ),
                          ],
                        ),
                        // Footer
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: borrowerCount.toString(),
                                style: TextStyle(
                                    color: UColors.lendFont,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: UTexts.borrower,
                                style: TextStyle(
                                    color: UColors.lendFont,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🔸 Total Owed Box
          Expanded(
            child: GestureDetector(
              onTapDown: (_) => setState(() => _scale2 = 0.97),
              onTapUp: (_) {
                setState(() => _scale2 = 1.0);

                final controller = Get.find<NavigationController>();
                controller.selectedIndex.value = 1; // Go to Loan tab
                controller.loanPageIndex.value = 1; // Show BorrowingPage
              },
              onTapCancel: () => setState(() => _scale2 = 1.0),
              child: AnimatedScale(
                scale: _scale2,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  height: boxHeight,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: UColors.borrowBg.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: UColors.borrowBorder, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIconsNoPad.borrowIcon(
                                color: UColors.borrowFont, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              UTexts.totalOwed,
                              style: TextStyle(
                                color: UColors.borrowFont,
                                fontWeight: FontWeight.w600,
                                fontSize: fontSizeTitle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIconsNoPad.pesoSign(
                                color: UColors.borrowFont, size: 18),
                            const SizedBox(width: 3),
                            isLoading
                                ? SizedBox(
                                    width: 50,
                                    height: 18,
                                    child: LinearProgressIndicator(
                                      backgroundColor: UColors.borrowFont.withOpacity(0.3),
                                      valueColor: AlwaysStoppedAnimation<Color>(UColors.borrowFont),
                                    ),
                                  )
                                : Text(
                                    totalOwed.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), ''),
                                    style: TextStyle(
                                      color: UColors.borrowFont,
                                      fontSize: fontSizeAmount,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            const SizedBox(width: 9),
                            UIconsNoPad.visibilityOn(
                              color: UColors.borrowFont,
                              size: 18,
                            ),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: lenderCount.toString(),
                                style: TextStyle(
                                    color: UColors.borrowFont,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: UTexts.lender,
                                style: TextStyle(
                                    color: UColors.borrowFont,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}