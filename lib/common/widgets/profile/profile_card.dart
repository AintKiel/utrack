import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../features/app_pages/home/elements/profileCradsElements/avatar.dart';
import '../../../features/app_pages/home/elements/profileCradsElements/creditScore.dart';
import '../../../features/app_pages/home/elements/profileCradsElements/scanAndQrButtons.dart';
import '../../../utils/constants/colors.dart';
import '../../../services/enhanced_credit_service.dart';

class ProfileCard extends StatefulWidget {
  final double? width;
  final String userFirstName;

  const ProfileCard({
    super.key,
    this.width,
    required this.userFirstName,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  double? creditScore; // No default value
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCreditScore();
  }

  Future<void> _loadCreditScore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Force initialize enhanced credit data first
        await EnhancedCreditService.initializeEnhancedCreditData(user.uid);
        
        final creditInfo = await EnhancedCreditService.getEnhancedCreditScore(user.uid);
        print('🔍 ProfileCard creditInfo: $creditInfo');
        if (mounted) {
          setState(() {
            creditScore = (creditInfo['creditScore'] ?? 100.0).toDouble();
            isLoading = false;
          });
        }
        print('✅ ProfileCard creditScore set to: $creditScore');
      }
    } catch (e) {
      print('❌ Error loading credit score in profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ===== Profile Card =====
          Container(
            width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
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
                UAvatar(userFirstName: widget.userFirstName),

                /// Credit Score Indicator (Top-right)
                if (creditScore != null)
                  UCreditScore(creditScore: creditScore!),
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