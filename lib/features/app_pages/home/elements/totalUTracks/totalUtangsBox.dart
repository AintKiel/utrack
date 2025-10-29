import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/features/app_pages/lending_page/lending_page.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/formatters/iconsNoPad.dart';
import '../../../borrowing_page/borrowing_page.dart';

class UtangSummarySection extends StatefulWidget {
  const UtangSummarySection({super.key});

  @override
  State<UtangSummarySection> createState() => _UtangSummarySectionState();
}

class _UtangSummarySectionState extends State<UtangSummarySection> {
  double _scale1 = 1.0;
  double _scale2 = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 250, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Total Lent Box
          Expanded(
            child: GestureDetector(
              onTapDown: (_) => setState(() => _scale1 = 0.97),
              onTapUp: (_) {
                setState(() => _scale1 = 1.0);
                Get.to(() => const LendingPage());
              },
              onTapCancel: () => setState(() => _scale1 = 1.0),
              child: AnimatedScale(
                scale: _scale1,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  height: 83,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIconsNoPad.lendIcon(color: UColors.lendFont, size: 18),
                            const SizedBox(width: 5),
                            const Text(
                              UTexts.totalLent,
                              style: TextStyle(
                                color: UColors.lendFont,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIconsNoPad.pesoSign(color: UColors.lendFont, size: 18),
                            const SizedBox(width: 3),
                            const Text(
                              UTexts.totalLend,
                              style: TextStyle(
                                color: UColors.lendFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 9),
                            GestureDetector(
                              onTap: () {},
                              child: UIconsNoPad.visibilityOn(
                                color: UColors.lendFont,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: UTexts.sumBorrower,
                                style: TextStyle(color: UColors.lendFont, fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: UTexts.borrower,
                                style: TextStyle(color: UColors.lendFont, fontSize: 10, fontWeight: FontWeight.w600),
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
                Get.to(() => const BorrowingPage());
              },
              onTapCancel: () => setState(() => _scale2 = 1.0),
              child: AnimatedScale(
                scale: _scale2,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  height: 83,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIconsNoPad.borrowIcon(color: UColors.borrowFont, size: 18),
                            const SizedBox(width: 5),
                            const Text(
                              UTexts.totalOwed,
                              style: TextStyle(
                                color: UColors.borrowFont,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIconsNoPad.pesoSign(color: UColors.borrowFont, size: 18),
                            const SizedBox(width: 3),
                            const Text(
                              UTexts.totalBorrowed,
                              style: TextStyle(
                                color: UColors.borrowFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 9),
                            GestureDetector(
                              onTap: () {},
                              child: UIconsNoPad.visibilityOn(
                                color: UColors.borrowFont,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: UTexts.sumLender,
                                style: TextStyle(color: UColors.borrowFont, fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: UTexts.lender,
                                style: TextStyle(color: UColors.borrowFont, fontSize: 10, fontWeight: FontWeight.w600),
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
