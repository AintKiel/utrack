import 'package:cloud_firestore/cloud_firestore.dart';

class CreditTrackingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize credit data for a user if it doesn't exist
  static Future<void> initializeCreditData(String userId) async {
    try {
      final userDoc = await _firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        // Check if creditData field exists (only for late payments tracking)
        if (!data.containsKey('creditData')) {
          await _firestore.collection('Users').doc(userId).update({
            'creditData': {
              'latePaymentsCount': 0,
            }
          });
          print('✅ Credit data initialized for user: $userId');
        }
      }
    } catch (e) {
      print('❌ Error initializing credit data: $e');
    }
  }

  /// Record a late payment
  static Future<void> recordLatePayment(String userId) async {
    try {
      await _firestore.collection('Users').doc(userId).update({
        'creditData.latePaymentsCount': FieldValue.increment(1),
      });
      print('✅ Late payment recorded for user: $userId');
    } catch (e) {
      print('❌ Error recording late payment: $e');
    }
  }

  /// Record a borrowing transaction
  /// Note: borrowerCount is already tracked in paymentStats by payment_tracking_service
  /// This is just a placeholder if you need additional borrowing tracking
  static Future<void> recordBorrowing(String userId) async {
    try {
      // The borrowerCount in paymentStats is already being updated
      // by the payment_tracking_service when transactions occur
      // You can add additional tracking here if needed
      print('✅ Borrowing tracked via paymentStats.borrowerCount');
    } catch (e) {
      print('❌ Error recording borrowing: $e');
    }
  }

  /// Record an on-time payment (reduces late payment count if applicable)
  static Future<void> recordOnTimePayment(String userId) async {
    try {
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      final data = userDoc.data() as Map<String, dynamic>;
      final creditData = data['creditData'] ?? {};
      final latePayments = (creditData['latePaymentsCount'] ?? 0) as int;

      // Optionally reduce late payment count for good behavior
      // You can adjust this logic based on your requirements
      if (latePayments > 0) {
        await _firestore.collection('Users').doc(userId).update({
          'creditData.latePaymentsCount': latePayments - 1,
        });
        print('✅ Late payment count reduced for user: $userId');
      }
    } catch (e) {
      print('❌ Error recording on-time payment: $e');
    }
  }

  /// Get credit status summary
  static Future<Map<String, dynamic>> getCreditStatus(String userId) async {
    try {
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      final data = userDoc.data() as Map<String, dynamic>;
      final paymentStats = data['paymentStats'] ?? {};
      final creditData = data['creditData'] ?? {};

      return {
        'totalOwed': (paymentStats['totalOwed'] ?? 0.0).toDouble(),
        'totalLent': (paymentStats['totalLent'] ?? 0.0).toDouble(),
        'latePaymentsCount': (creditData['latePaymentsCount'] ?? 0) as int,
        'borrowerCount': (paymentStats['borrowerCount'] ?? 0) as int,
        'lenderCount': (paymentStats['lenderCount'] ?? 0) as int,
      };
    } catch (e) {
      print('❌ Error getting credit status: $e');
      return {
        'totalOwed': 0.0,
        'totalLent': 0.0,
        'latePaymentsCount': 0,
        'borrowerCount': 0,
        'lenderCount': 0,
      };
    }
  }

  /// Reset late payment count (for admin or special cases)
  static Future<void> resetLatePayments(String userId) async {
    try {
      await _firestore.collection('Users').doc(userId).update({
        'creditData.latePaymentsCount': 0,
      });
      print('✅ Late payments reset for user: $userId');
    } catch (e) {
      print('❌ Error resetting late payments: $e');
    }
  }
}
