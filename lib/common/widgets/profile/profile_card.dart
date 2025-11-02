import 'package:flutter/material.dart';
import '../../../features/app_pages/home/elements/profileCradsElements/avatar.dart';
import '../../../features/app_pages/home/elements/profileCradsElements/creditScore.dart';
import '../../../features/app_pages/home/elements/profileCradsElements/scanAndQrButtons.dart';
import '../../../utils/constants/colors.dart';


class ProfileCard extends StatelessWidget {
  final double? width;
  final double creditScore;
  final String userFirstName;

  const ProfileCard({
    super.key,
    this.width,
    this.creditScore = 85,
    required this.userFirstName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ===== Profile Card =====
          Container(
            width: width ?? MediaQuery.of(context).size.width * 0.9,
            height: 152,
            margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 40),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: UColors.accent.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                /// Profile content
                UAvatar(userFirstName: userFirstName),

                /// Credit Score Indicator (Top-right)
                UCreditScore(creditScore: creditScore),
              ],
            ),
          ),
          /// ===== Floating Buttons =====
          UScanQrButton(),
        ],
      ),
    );
  }
}