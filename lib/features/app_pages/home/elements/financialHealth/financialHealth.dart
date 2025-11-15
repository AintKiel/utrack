import 'package:flutter/material.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../services/enhanced_credit_service.dart';

class FinancialHealth extends StatefulWidget {
  const FinancialHealth({super.key});

  @override
  State<FinancialHealth> createState() => _FinancialHealthState();
}

class _FinancialHealthState extends State<FinancialHealth> {
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
        print('🔍 FinancialHealth creditInfo: $creditInfo');
        if (mounted) {
          setState(() {
            creditScore = creditInfo['progress'] ?? 1.0;
            isLoading = false;
          });
        }
        print('✅ FinancialHealth creditScore set to: $creditScore');
      }
    } catch (e) {
      print('❌ Error loading credit score: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? UColors.lightBlue.withOpacity(0.8)
            : UColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
                Row(
                  children: [
                    UIconsNoPad.wallet(color: UColors.percentBar, size: 25),
                    const SizedBox(width: 10),
                    Text(
                      UTexts.financialHealth,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // --- Credit Score ---
                _buildProgressRow(UTexts.creditScore, creditScore ?? 1.0),

                const SizedBox(height: 10),

                // --- Payment History ---
                _buildProgressRow(UTexts.paymentHistory, 0.92),

                const SizedBox(height: 10),

                // --- Trust Rating ---
                _buildProgressRow(UTexts.trustRating, 0.88),
              ],
            ),
    );
  }

  /// Helper widget builder for each progress item
  Widget _buildProgressRow(String title, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            Text(
              "${(value * 100).toInt()}%",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.teal[100],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}