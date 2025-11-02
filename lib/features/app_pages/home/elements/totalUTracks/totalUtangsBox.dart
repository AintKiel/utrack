import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  late Stream<DocumentSnapshot> _paymentStatsStream;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _paymentStatsStream = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 220, left: 20, right: 20),
      child: StreamBuilder<DocumentSnapshot>(
        stream: _paymentStatsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final paymentStats = userData['paymentStats'] ?? {
            'totalLent': 0.0,
            'totalOwed': 0.0,
            'lenderCount': 0,
            'borrowerCount': 0,
          };

          double totalLent = (paymentStats['totalLent'] ?? 0.0).toDouble();
          double totalOwed = (paymentStats['totalOwed'] ?? 0.0).toDouble();
          int borrowerCount = (paymentStats['borrowerCount'] ?? 0) as int;
          int lenderCount = (paymentStats['lenderCount'] ?? 0) as int;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 📹 Total Lent Box
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
                      height: 95,
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
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UIconsNoPad.lendIcon(color: UColors.lendFont, size: 18),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      UTexts.totalLent,
                                      style: const TextStyle(
                                        color: UColors.lendFont,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UIconsNoPad.pesoSign(color: UColors.lendFont, size: 16),
                                  const SizedBox(width: 2),
                                  Flexible(
                                    child: Text(
                                      totalLent.toStringAsFixed(2),
                                      style: const TextStyle(
                                        color: UColors.lendFont,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {},
                                    child: UIconsNoPad.visibilityOn(
                                      color: UColors.lendFont,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3),
                            Flexible(
                              child: Text(
                                '$borrowerCount ${borrowerCount == 1 ? 'borrower' : 'borrowers'}',
                                style: TextStyle(
                                  color: UColors.lendFont,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 📸 Total Owed Box
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
                      height: 95,
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
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UIconsNoPad.borrowIcon(color: UColors.borrowFont, size: 18),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      UTexts.totalOwed,
                                      style: const TextStyle(
                                        color: UColors.borrowFont,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UIconsNoPad.pesoSign(color: UColors.borrowFont, size: 16),
                                  const SizedBox(width: 2),
                                  Flexible(
                                    child: Text(
                                      totalOwed.toStringAsFixed(2),
                                      style: const TextStyle(
                                        color: UColors.borrowFont,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {},
                                    child: UIconsNoPad.visibilityOn(
                                      color: UColors.borrowFont,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3),
                            Flexible(
                              child: Text(
                                '$lenderCount ${lenderCount == 1 ? 'lender' : 'lenders'}',
                                style: TextStyle(
                                  color: UColors.borrowFont,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}