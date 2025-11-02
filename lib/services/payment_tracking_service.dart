import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentTrackingService {
  // Define Firestore instance
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Record a payment transaction and update both sender & recipient stats
  static Future<bool> recordPayment({

    required String senderId,
    required String recipientId,
    required String recipientName,
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      final batch = _firestore.batch();
      final transactionId = _firestore.collection('Transactions').doc().id;

      // Get sender's name from Firestore
      final senderDoc = await _firestore.collection('Users').doc(senderId).get();
      final senderName = senderDoc.data()?['firstName'] ?? 'Unknown';

      // 1. Create transaction record
      final transactionRef = _firestore.collection('Transactions').doc(transactionId);
      batch.set(transactionRef, {
        'transactionId': transactionId,
        'senderId': senderId,
        'senderName': senderName,
        'recipientId': recipientId,
        'recipientName': recipientName,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. Update sender's stats (they lent money)
      final senderRef = _firestore.collection('Users').doc(senderId);
      batch.update(senderRef, {
        'paymentStats.totalLent': FieldValue.increment(amount),
        'paymentStats.lastUpdated': FieldValue.serverTimestamp(),
      });

      // 3. Update recipient's stats (they owe money)
      final recipientRef = _firestore.collection('Users').doc(recipientId);
      batch.update(recipientRef, {
        'paymentStats.totalOwed': FieldValue.increment(amount),
        'paymentStats.lastUpdated': FieldValue.serverTimestamp(),
      });

      // 4. Add to sender's lent history
      await _firestore
          .collection('Users')
          .doc(senderId)
          .collection('LentTransactions')
          .add({
        'recipientId': recipientId,
        'recipientName': recipientName,
        'senderName': senderName,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 5. Add to recipient's owed history
      await _firestore
          .collection('Users')
          .doc(recipientId)
          .collection('OwedTransactions')
          .add({
        'senderId': senderId,
        'senderName': senderName,
        'recipientId': recipientId,
        'recipientName': recipientName,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Commit batch
      await batch.commit();

      print('✅ Payment recorded and stats updated successfully');
      return true;
    } catch (e) {
      print('❌ Error recording payment: $e');
      return false;
    }
  }

  /// Get user's payment stats
  static Future<Map<String, dynamic>?> getUserPaymentStats(String userId) async {
    try {
      final doc = await _firestore.collection('Users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['paymentStats'] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('❌ Error fetching payment stats: $e');
      return null;
    }
  }

  /// Get user's lent transactions
  static Future<List<Map<String, dynamic>>> getUserLentTransactions(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('LentTransactions')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('❌ Error fetching lent transactions: $e');
      return [];
    }
  }

  /// Get user's owed transactions
  static Future<List<Map<String, dynamic>>> getUserOwedTransactions(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('OwedTransactions')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('❌ Error fetching owed transactions: $e');
      return [];
    }
  }

  /// Update lender/borrower count
  static Future<void> updateContactCounts(String userId) async {
    try {
      // Get unique lenders
      final lentSnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('OwedTransactions')
          .get();

      Set<String> uniqueLenders = {};
      for (var doc in lentSnapshot.docs) {
        uniqueLenders.add(doc['senderId'] ?? '');
      }

      // Get unique borrowers
      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('LentTransactions')
          .get();

      Set<String> uniqueBorrowers = {};
      for (var doc in owedSnapshot.docs) {
        uniqueBorrowers.add(doc['recipientId'] ?? '');
      }

      // Update counts
      await _firestore.collection('Users').doc(userId).update({
        'paymentStats.lenderCount': uniqueLenders.length,
        'paymentStats.borrowerCount': uniqueBorrowers.length,
      });

      print('✅ Contact counts updated');
    } catch (e) {
      print('❌ Error updating contact counts: $e');
    }
  }
  /// Record a repayment (when you send money back to someone who lent you)
  // Add this method to your PaymentTrackingService class

  /// Record a repayment (when you send money back to someone who lent you)
  static Future<bool> recordRepayment({
    required String senderId,        // Person sending money back (you)
    required String recipientId,     // Person who originally lent you money
    required String recipientName,
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      final batch = _firestore.batch();

      // Get sender's name
      final senderDoc = await _firestore.collection('Users').doc(senderId).get();
      final senderName = senderDoc.data()?['firstName'] ?? 'Unknown';

      // 1. Add to sender's OWED history (they're paying back what they owe)
      await _firestore
          .collection('Users')
          .doc(senderId)
          .collection('OwedTransactions')  // ✅ CHANGED: Now goes to OwedTransactions
          .add({
        'senderId': recipientId,  // ✅ CHANGED: Original lender is the "sender"
        'senderName': recipientName,
        'recipientId': senderId,  // ✅ CHANGED: You are the recipient of this obligation
        'recipientName': senderName,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'completed',
        'type': 'repayment',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Add to recipient's LENT history (they're being paid back)
      await _firestore
          .collection('Users')
          .doc(recipientId)
          .collection('LentTransactions')  // ✅ CHANGED: Now goes to LentTransactions
          .add({
        'recipientId': senderId,  // ✅ CHANGED: You are the recipient
        'recipientName': senderName,
        'senderName': recipientName,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'completed',
        'type': 'repayment',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Update sender's stats (they paid back money)
      final senderRef = _firestore.collection('Users').doc(senderId);
      batch.update(senderRef, {
        'paymentStats.totalOwed': FieldValue.increment(-amount),  // DECREASE totalOwed
        'paymentStats.lastUpdated': FieldValue.serverTimestamp(),
      });

      // 4. Update recipient's stats (they received payment back)
      final recipientRef = _firestore.collection('Users').doc(recipientId);
      batch.update(recipientRef, {
        'paymentStats.totalLent': FieldValue.increment(-amount),  // DECREASE totalLent
        'paymentStats.lastUpdated': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      print('✅ Repayment recorded successfully');
      return true;
    } catch (e) {
      print('❌ Error recording repayment: $e');
      return false;
    }
  }
}