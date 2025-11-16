import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecalculateStatsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Recalculate and update payment stats from actual transactions
  static Future<Map<String, dynamic>> recalculatePaymentStats() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      print('🔄 Starting recalculation for user: ${currentUser.uid}');

      // 1. Get global loan transactions created by the current user (lender)
      final globalTransactionsSnapshot = await _firestore
          .collection('Transactions')
          .where('senderId', isEqualTo: currentUser.uid)
          .get();

      // 2. Get all OwedTransactions (as borrower)
      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('OwedTransactions')
          .get();

      // 3. Calculate totals from actual transactions
      double totalLent = 0.0;
      Set<String> uniqueBorrowers = {};

      for (var doc in globalTransactionsSnapshot.docs) {
        final data = doc.data();
        final entryType = (data['type'] ?? 'loan').toString().toLowerCase();
        if (entryType != 'loan') continue;

        final amount = (data['amount'] ?? 0.0).toDouble();
        final remaining = (data['remainingAmount'] ?? amount).toDouble();
        final recipientId = data['recipientId'] as String?;
        final status = (data['status'] ?? 'active').toString().toLowerCase();
        final isCleared = status == 'paid' || status == 'completed' || status == 'fully paid';

        totalLent += isCleared ? 0 : remaining;
        if (recipientId != null && recipientId.isNotEmpty) {
          uniqueBorrowers.add(recipientId);
        }

        print('  📤 Lent: ₱$amount (remaining ₱${(isCleared ? 0 : remaining).toStringAsFixed(2)}) to ${data['recipientName']}');
      }

      double totalOwed = 0.0;
      Set<String> uniqueLenders = {};

      for (var doc in owedSnapshot.docs) {
        final data = doc.data();
        final entryType = (data['type'] ?? 'loan').toString().toLowerCase();
        if (entryType != 'loan') continue;

        final amount = (data['amount'] ?? 0.0).toDouble();
        final remaining = (data['remainingAmount'] ?? amount).toDouble();
        final senderId = data['senderId'] as String?;
        final status = (data['status'] ?? 'active').toString().toLowerCase();
        final isCleared = status == 'paid' || status == 'completed' || status == 'fully paid';

        totalOwed += isCleared ? 0 : remaining;
        if (senderId != null && senderId.isNotEmpty) {
          uniqueLenders.add(senderId);
        }

        print('  📥 Owed: ₱$amount (remaining ₱${(isCleared ? 0 : remaining).toStringAsFixed(2)}) from ${data['senderName']}');
      }

      print('\n📊 Calculated Stats:');
      print('  Total Lent: ₱$totalLent');
      print('  Total Owed: ₱$totalOwed');
      print('  Borrower Count: ${uniqueBorrowers.length}');
      print('  Lender Count: ${uniqueLenders.length}');

      // 4. Update paymentStats in user document
      await _firestore.collection('Users').doc(currentUser.uid).set({
        'paymentStats': {
          'totalLent': totalLent,
          'totalOwed': totalOwed,
          'borrowerCount': uniqueBorrowers.length,
          'lenderCount': uniqueLenders.length,
          'lastUpdated': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      print('✅ Payment stats updated successfully!');

      return {
        'success': true,
        'totalLent': totalLent,
        'totalOwed': totalOwed,
        'borrowerCount': uniqueBorrowers.length,
        'lenderCount': uniqueLenders.length,
      };
    } catch (e) {
      print('❌ Error recalculating stats: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Get detailed breakdown of transactions
  static Future<void> printTransactionBreakdown() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ No user logged in');
        return;
      }

      print('\n📋 TRANSACTION BREAKDOWN\n');

      // Lent Transactions
      final lentSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('LentTransactions')
          .orderBy('createdAt', descending: true)
          .get();

      print('💰 LENT TRANSACTIONS (${lentSnapshot.docs.length} total):');
      print('─' * 60);
      
      double lentTotal = 0.0;
      for (var doc in lentSnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] ?? 0.0).toDouble();
        final recipientName = data['recipientName'] ?? 'Unknown';
        final createdAt = data['createdAt'] as Timestamp?;
        final date = createdAt?.toDate().toString().split(' ')[0] ?? 'N/A';
        
        lentTotal += amount;
        print('  ₱${amount.toStringAsFixed(2)} → $recipientName (${date})');
      }
      print('  TOTAL: ₱${lentTotal.toStringAsFixed(2)}');

      // Owed Transactions
      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('OwedTransactions')
          .orderBy('createdAt', descending: true)
          .get();

      print('\n💸 OWED TRANSACTIONS (${owedSnapshot.docs.length} total):');
      print('─' * 60);
      
      double owedTotal = 0.0;
      for (var doc in owedSnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] ?? 0.0).toDouble();
        final senderName = data['senderName'] ?? 'Unknown';
        final createdAt = data['createdAt'] as Timestamp?;
        final date = createdAt?.toDate().toString().split(' ')[0] ?? 'N/A';
        
        owedTotal += amount;
        print('  ₱${amount.toStringAsFixed(2)} ← $senderName (${date})');
      }
      print('  TOTAL: ₱${owedTotal.toStringAsFixed(2)}');
      print('─' * 60);
    } catch (e) {
      print('❌ Error printing breakdown: $e');
    }
  }
}
