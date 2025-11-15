import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart';

class EnhancedCreditService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Credit score limits
  static const double MAX_CREDIT_SCORE = 100.0;
  static const double MIN_CREDIT_SCORE = 0.0;
  static const double DAILY_PENALTY = -0.3;
  static const double DAILY_BONUS = 0.3;
  static const double MAX_DAILY_BONUS = 2.0;
  static const double LENDER_REWARD = 2.0;
  static const double LENDER_EARLY_BONUS = 0.3;
  static const double RECOVERY_BONUS = 3.0;
  static const double MAX_PENALTY_LIMIT = -15.0;

  /// Initialize enhanced credit data for a user
  static Future<void> initializeEnhancedCreditData(String userId) async {
    try {
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        
        if (!data.containsKey('enhancedCreditData')) {
          await _firestore.collection('Users').doc(userId).update({
            'enhancedCreditData': {
              'creditScore': 100.0, // Start with perfect score for new accounts
              'paymentHistory': [],
              'consecutiveOnTimePayments': 0,
              'totalPenaltyDeductions': 0.0,
              'lastScoreUpdate': FieldValue.serverTimestamp(),
              'tier': 'Excellent',
              'activeLoanIds': [],
              'overdueLoans': [],
            }
          });
          print('✅ Enhanced credit data initialized for user: $userId');
        }
      }
    } catch (e) {
      print('❌ Error initializing enhanced credit data: $e');
    }
  }

  /// Get credit tier based on score
  static String getCreditTier(double score) {
    if (score >= 90) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 50) return 'Fair';
    return 'Poor';
  }

  /// Get tier emoji
  static String getTierEmoji(String tier) {
    switch (tier) {
      case 'Excellent': return '🟢';
      case 'Good': return '🟡';
      case 'Fair': return '🟠';
      case 'Poor': return '🔴';
      default: return '⚪';
    }
  }

  /// Record a payment (on-time, early, or late)
  static Future<void> recordPayment({
    required String userId,
    required String loanId,
    required String status, // 'on_time', 'early', 'late'
    required double amount,
    int? daysEarly,
    int? daysLate,
  }) async {
    try {
      await initializeEnhancedCreditData(userId);
      
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      final data = userDoc.data() as Map<String, dynamic>;
      final creditData = data['enhancedCreditData'] ?? {};
      
      double currentScore = (creditData['creditScore'] ?? 100.0).toDouble();
      List<dynamic> paymentHistory = List.from(creditData['paymentHistory'] ?? []);
      int consecutiveOnTime = (creditData['consecutiveOnTimePayments'] ?? 0) as int;
      double totalPenalties = (creditData['totalPenaltyDeductions'] ?? 0.0).toDouble();
      
      // Record payment in history
      paymentHistory.add({
        'loanId': loanId,
        'status': status,
        'amount': amount,
        'timestamp': FieldValue.serverTimestamp(),
        'daysEarly': daysEarly,
        'daysLate': daysLate,
      });

      double scoreChange = 0.0;

      switch (status) {
        case 'early':
          // Early payment bonus: +0.3% per day, max +2% per cycle
          if (daysEarly != null) {
            scoreChange = (daysEarly * DAILY_BONUS).clamp(0, MAX_DAILY_BONUS);
            consecutiveOnTime++;
          }
          break;
          
        case 'on_time':
          // No penalty, no bonus, but counts towards consecutive payments
          consecutiveOnTime++;
          break;
          
        case 'late':
          // Late payment penalty: -0.3% per day
          if (daysLate != null) {
            double penalty = daysLate * DAILY_PENALTY;
            // Check if we haven't exceeded the max penalty limit
            if (totalPenalties + penalty.abs() >= MAX_PENALTY_LIMIT.abs()) {
              penalty = -(MAX_PENALTY_LIMIT.abs() - totalPenalties);
            }
            scoreChange = penalty;
            totalPenalties += penalty.abs();
            consecutiveOnTime = 0; // Reset consecutive counter
          }
          break;
      }

      // Check for automatic recovery (3 consecutive on-time payments)
      if (consecutiveOnTime >= 3 && consecutiveOnTime % 3 == 0) {
        scoreChange += RECOVERY_BONUS;
        print('🎉 Credit recovery bonus applied: +$RECOVERY_BONUS%');
      }

      // Apply score change with limits
      currentScore = (currentScore + scoreChange).clamp(MIN_CREDIT_SCORE, MAX_CREDIT_SCORE);
      
      // Update Firestore
      await _firestore.collection('Users').doc(userId).update({
        'enhancedCreditData.creditScore': currentScore,
        'enhancedCreditData.paymentHistory': paymentHistory,
        'enhancedCreditData.consecutiveOnTimePayments': consecutiveOnTime,
        'enhancedCreditData.totalPenaltyDeductions': totalPenalties,
        'enhancedCreditData.tier': getCreditTier(currentScore),
        'enhancedCreditData.lastScoreUpdate': FieldValue.serverTimestamp(),
      });

      print('✅ Payment recorded: $status, Score change: $scoreChange, New score: $currentScore');
      
    } catch (e) {
      print('❌ Error recording payment: $e');
    }
  }

  /// Apply daily overdue penalties
  static Future<void> applyDailyOverduePenalties(String userId, String loanId, int daysOverdue) async {
    try {
      await initializeEnhancedCreditData(userId);
      
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      final data = userDoc.data() as Map<String, dynamic>;
      final creditData = data['enhancedCreditData'] ?? {};
      
      double currentScore = (creditData['creditScore'] ?? 100.0).toDouble();
      double totalPenalties = (creditData['totalPenaltyDeductions'] ?? 0.0).toDouble();
      
      // Calculate penalty for overdue days
      double penalty = daysOverdue * DAILY_PENALTY;
      
      // Check penalty limit
      if (totalPenalties + penalty.abs() >= MAX_PENALTY_LIMIT.abs()) {
        penalty = -(MAX_PENALTY_LIMIT.abs() - totalPenalties);
      }
      
      if (penalty < 0) {
        double oldScore = currentScore;
        currentScore = (currentScore + penalty).clamp(MIN_CREDIT_SCORE, MAX_CREDIT_SCORE);
        totalPenalties += penalty.abs();
        
        await _firestore.collection('Users').doc(userId).update({
          'enhancedCreditData.creditScore': currentScore,
          'enhancedCreditData.totalPenaltyDeductions': totalPenalties,
          'enhancedCreditData.tier': getCreditTier(currentScore),
          'enhancedCreditData.lastScoreUpdate': FieldValue.serverTimestamp(),
        });
        
        // Create notification for credit score decrease
        if ((oldScore - currentScore).abs() >= 1.0) {
          await NotificationService.notifyCreditScoreChange(
            userId: userId,
            oldScore: oldScore,
            newScore: currentScore,
          );
        }
        
        print('⚠️ Daily overdue penalty applied: $penalty%, New score: $currentScore');
      }
      
    } catch (e) {
      print('❌ Error applying overdue penalty: $e');
    }
  }

  /// Apply interest after 30 days overdue
  static Future<void> applyOverdueInterest(String loanId, double currentAmount) async {
    try {
      // Add 1% interest to loan balance (compounded)
      double newAmount = currentAmount * 1.01;
      
      // Update the loan amount in all relevant collections
      await _firestore.collection('Transactions').doc(loanId).update({
        'amount': newAmount,
        'interestApplied': FieldValue.increment(1.0),
        'lastInterestDate': FieldValue.serverTimestamp(),
      });
      
      print('💰 Overdue interest applied: +1%, New amount: ₱${newAmount.toStringAsFixed(2)}');
      
    } catch (e) {
      print('❌ Error applying overdue interest: $e');
    }
  }

  /// Reward lender for borrower's failure to repay
  static Future<void> rewardLenderForBorrowerDefault(String lenderId) async {
    try {
      await initializeEnhancedCreditData(lenderId);
      
      final userDoc = await _firestore.collection('Users').doc(lenderId).get();
      final data = userDoc.data() as Map<String, dynamic>;
      final creditData = data['enhancedCreditData'] ?? {};
      
      double currentScore = (creditData['creditScore'] ?? 100.0).toDouble();
      currentScore = (currentScore + LENDER_REWARD).clamp(MIN_CREDIT_SCORE, MAX_CREDIT_SCORE);
      
      await _firestore.collection('Users').doc(lenderId).update({
        'enhancedCreditData.creditScore': currentScore,
        'enhancedCreditData.tier': getCreditTier(currentScore),
        'enhancedCreditData.lastScoreUpdate': FieldValue.serverTimestamp(),
      });
      
      print('🎁 Lender reward applied: +$LENDER_REWARD%, New score: $currentScore');
      
    } catch (e) {
      print('❌ Error rewarding lender: $e');
    }
  }

  /// Reward lender for early repayment partnership
  static Future<void> rewardLenderForEarlyRepayment(String lenderId) async {
    try {
      await initializeEnhancedCreditData(lenderId);
      
      final userDoc = await _firestore.collection('Users').doc(lenderId).get();
      final data = userDoc.data() as Map<String, dynamic>;
      final creditData = data['enhancedCreditData'] ?? {};
      
      double currentScore = (creditData['creditScore'] ?? 100.0).toDouble();
      currentScore = (currentScore + LENDER_EARLY_BONUS).clamp(MIN_CREDIT_SCORE, MAX_CREDIT_SCORE);
      
      await _firestore.collection('Users').doc(lenderId).update({
        'enhancedCreditData.creditScore': currentScore,
        'enhancedCreditData.tier': getCreditTier(currentScore),
        'enhancedCreditData.lastScoreUpdate': FieldValue.serverTimestamp(),
      });
      
      print('🤝 Lender partnership reward: +$LENDER_EARLY_BONUS%, New score: $currentScore');
      
    } catch (e) {
      print('❌ Error rewarding lender for partnership: $e');
    }
  }

  /// Get enhanced credit score and tier (for UI display)
  static Future<Map<String, dynamic>> getEnhancedCreditScore(String userId) async {
    try {
      await initializeEnhancedCreditData(userId);
      
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      final data = userDoc.data() as Map<String, dynamic>;
      final creditData = data['enhancedCreditData'] ?? {};
      
      double creditScore = (creditData['creditScore'] ?? 100.0).toDouble();
      String tier = getCreditTier(creditScore);
      
      print('🔍 EnhancedCreditService returning: creditScore=$creditScore, tier=$tier');
      
      return {
        'creditScore': creditScore,
        'tier': tier,
        'tierEmoji': getTierEmoji(tier),
        'progress': creditScore / 100.0, // For progress indicator
      };
      
    } catch (e) {
      print('❌ Error getting enhanced credit score: $e');
      return {
        'creditScore': 100.0,
        'tier': 'Excellent',
        'tierEmoji': '🟢',
        'progress': 1.0,
      };
    }
  }

  /// Check and process overdue loans (should be called daily via cloud function or app startup)
  static Future<void> processOverdueLoans() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Get all active loans for current user
      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('OwedTransactions')
          .where('status', isEqualTo: 'active')
          .get();

      for (var doc in owedSnapshot.docs) {
        final data = doc.data();
        final dueDate = data['dueDate'] as String?;
        final loanId = data['transactionId'] as String;
        final amount = (data['amount'] ?? 0.0).toDouble();
        final lenderId = data['senderId'] as String;
        
        if (dueDate != null) {
          final parsedDueDate = _parseDateString(dueDate);
          if (parsedDueDate != null) {
            final now = DateTime.now();
            final daysDifference = now.difference(parsedDueDate).inDays;
            
            if (daysDifference > 0) {
              // Loan is overdue
              await applyDailyOverduePenalties(currentUser.uid, loanId, daysDifference);
              
              // After 30 days, apply interest and reward lender
              if (daysDifference >= 30) {
                await applyOverdueInterest(loanId, amount);
                await rewardLenderForBorrowerDefault(lenderId);
              }
            }
          }
        }
      }
      
    } catch (e) {
      print('❌ Error processing overdue loans: $e');
    }
  }

  /// Validate 21-day limit for single repayment loans
  static bool isValidDueDate(DateTime dueDate) {
    final daysDifference = dueDate.difference(DateTime.now()).inDays;
    return daysDifference >= 1 && daysDifference <= 21;
  }

  /// Calculate interest for multiple repayment loans
  static double calculateInstallmentInterest(int months) {
    return (months + 1).toDouble();
  }

  /// Parse date string (dd/mm/yyyy format)
  static DateTime? _parseDateString(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length != 3) return null;
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}
