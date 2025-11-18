import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notification_service.dart';

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

      await _applyRepaymentToOutstandingLoans(
        borrowerId: recipientId,
        lenderId: senderId,
        amount: amount,
        paymentMethod: paymentMethod,
      );

      // Notify both parties
      await NotificationService.notifyPaymentSent(
        borrowerId: senderId,
        lenderName: recipientName,
        amount: amount,
      );
      await NotificationService.notifyPaymentReceived(
        lenderId: recipientId,
        borrowerName: senderName,
        amount: amount,
      );

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
  static Future<bool> recordRepayment({
    required String senderId, // Person sending money back (you)
    required String recipientId, // Person who originally lent you money
    required String recipientName,
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      final batch = _firestore.batch();

      // Get sender's name
      final senderDoc = await _firestore.collection('Users').doc(senderId).get();
      final senderName = senderDoc.data()?['firstName'] ?? 'Unknown';

      // Calculate remaining amount after this payment
      final remainingResult = await _calculateRemainingAmount(
        borrowerId: senderId,
        lenderId: recipientId,
        paymentAmount: amount,
      );

      // 1. Add to sender's OWED history (they're paying back what they owe)
      await _firestore
          .collection('Users')
          .doc(senderId)
          .collection('OwedTransactions') // CHANGED: Now goes to OwedTransactions
          .add({
        'senderId': recipientId, // CHANGED: Original lender is the "sender"
        'senderName': recipientName,
        'recipientId': senderId, // CHANGED: You are the recipient of this obligation
        'recipientName': senderName,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'completed',
        'type': 'repayment',
        'remainingAmount': remainingResult['remaining'], // Add remaining amount for badge
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Add to recipient's LENT history (they're being paid back)
      // NOTE: paymentConfirmed is FALSE - lender must confirm before it shows in their history
      await _firestore
          .collection('Users')
          .doc(recipientId)
          .collection('LentTransactions') // CHANGED: Now goes to LentTransactions
          .add({
        'recipientId': senderId, // CHANGED: You are the recipient
        'recipientName': senderName,
        'senderName': recipientName,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'pending_confirmation', // Waiting for lender to confirm
        'paymentConfirmed': false, // Must be confirmed by lender
        'type': 'repayment',
        'remainingAmount': remainingResult['remaining'], // Add remaining amount for badge
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Update sender's stats (they paid back money)
      final senderRef = _firestore.collection('Users').doc(senderId);
      batch.update(senderRef, {
        'paymentStats.totalOwed': FieldValue.increment(-amount), // DECREASE totalOwed
        'paymentStats.lastUpdated': FieldValue.serverTimestamp(),
      });

      // 4. Update recipient's stats (they received payment back)
      final recipientRef = _firestore.collection('Users').doc(recipientId);
      batch.update(recipientRef, {
        'paymentStats.totalLent': FieldValue.increment(-amount), // DECREASE totalLent
        'paymentStats.lastUpdated': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      await _applyRepaymentToOutstandingLoans(
        borrowerId: senderId,
        lenderId: recipientId,
        amount: amount,
        paymentMethod: paymentMethod,
      );

      // Notify both parties
      await NotificationService.notifyPaymentSent(
        borrowerId: senderId,
        lenderName: recipientName,
        amount: amount,
      );
      await NotificationService.notifyPaymentReceived(
        lenderId: recipientId,
        borrowerName: senderName,
        amount: amount,
      );

      print('✅ Repayment recorded successfully');
      return true;
    } catch (e) {
      print('❌ Error recording repayment: $e');
      return false;
    }
  }

  /// Calculate remaining amount after a payment
  static Future<Map<String, dynamic>> _calculateRemainingAmount({
    required String borrowerId,
    required String lenderId,
    required double paymentAmount,
  }) async {
    try {
      // Get all outstanding loans from this lender to this borrower
      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(borrowerId)
          .collection('OwedTransactions')
          .where('senderId', isEqualTo: lenderId)
          .get();

      // Calculate total outstanding amount
      double totalOutstanding = 0.0;
      for (final doc in owedSnapshot.docs) {
        final data = doc.data();
        final entryType = (data['type'] ?? 'loan').toString();
        if (entryType != 'loan') continue; // Only count original loans

        final double currentRemaining =
            (data['remainingAmount'] ?? data['amount'] ?? 0.0).toDouble();
        totalOutstanding += currentRemaining;
      }

      // Calculate remaining after this payment
      final remaining = totalOutstanding - paymentAmount;
      final sanitizedRemaining = remaining <= 0.01 ? 0.0 : remaining;

      return {
        'totalOutstanding': totalOutstanding,
        'remaining': sanitizedRemaining,
        'isFullPayment': sanitizedRemaining <= 0.01,
      };
    } catch (e) {
      print('❌ Error calculating remaining amount: $e');
      return {
        'totalOutstanding': 0.0,
        'remaining': 0.0,
        'isFullPayment': false,
      };
    }
  }

  static Future<void> _applyRepaymentToOutstandingLoans({
    required String borrowerId,
    required String lenderId,
    required double amount,
    required String paymentMethod,
  }) async {
    print('');
    print('💸 ============ APPLYING REPAYMENT ============');
    print('   Borrower: $borrowerId');
    print('   Lender: $lenderId');
    print('   Amount: ₱$amount');
    print('   Payment Method: $paymentMethod');
    print('================================================');

    double remainingToApply = amount;

    final owedSnapshot = await _firestore
        .collection('Users')
        .doc(borrowerId)
        .collection('OwedTransactions')
        .where('senderId', isEqualTo: lenderId)
        .get();

    print('📋 Found ${owedSnapshot.docs.length} owed transactions to process');

    final docs = List.from(owedSnapshot.docs)
      ..sort((a, b) {
        final aDate = a.data()['createdAt'];
        final bDate = b.data()['createdAt'];

        final aTs = aDate is Timestamp ? aDate : null;
        final bTs = bDate is Timestamp ? bDate : null;

        if (aTs == null && bTs == null) return 0;
        if (aTs == null) return 1;
        if (bTs == null) return -1;
        return aTs.compareTo(bTs);
      });

    List<QueryDocumentSnapshot<Map<String, dynamic>>> lenderLoanDocs = [];
    final Map<String, QueryDocumentSnapshot<Map<String, dynamic>>>
        lenderDocsByTransactionId = {};
    final Set<String> consumedLenderDocIds = {};
    bool canUpdateLenderLoans = false;

    try {
      print('🔍 Attempting to fetch lender loans for lenderId: $lenderId, borrowerId: $borrowerId');

      final lenderLoansSnapshot = await _firestore
          .collection('Users')
          .doc(lenderId)
          .collection('LentTransactions')
          .where('recipientId', isEqualTo: borrowerId)
          .get();

      print('📋 Found ${lenderLoansSnapshot.docs.length} lender loan documents');

      lenderLoanDocs = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
        lenderLoansSnapshot.docs,
      )..sort((a, b) {
          final aDate = a.data()['createdAt'];
          final bDate = b.data()['createdAt'];
          final aTs = aDate is Timestamp ? aDate : null;
          final bTs = bDate is Timestamp ? bDate : null;

          if (aTs == null && bTs == null) return 0;
          if (aTs == null) return 1;
          if (bTs == null) return -1;
          return aTs.compareTo(bTs);
        });

      for (final doc in lenderLoanDocs) {
        final txId = doc.data()['transactionId'];
        final amount = doc.data()['amount'];
        final remaining = doc.data()['remainingAmount'];
        final type = doc.data()['type'];
        print('   📄 Lender loan doc: txId=$txId, amount=$amount, remaining=$remaining, type=$type');
        if (txId is String && txId.isNotEmpty) {
          lenderDocsByTransactionId[txId] = doc;
        }
      }

      print('✅ Successfully loaded ${lenderDocsByTransactionId.length} lender loans indexed by transactionId');
      canUpdateLenderLoans = true;
    } catch (e) {
      print(
        '⚠️ Unable to load lender loan entries for syncing repayments (likely due to permissions): $e',
      );
    }

    QueryDocumentSnapshot<Map<String, dynamic>>? findLenderLoan(
      String? transactionId,
    ) {
      if (!canUpdateLenderLoans) return null;

      if (transactionId != null) {
        final match = lenderDocsByTransactionId[transactionId];
        if (match != null && !consumedLenderDocIds.contains(match.id)) {
          return match;
        }
      }

      for (final doc in lenderLoanDocs) {
        if (consumedLenderDocIds.contains(doc.id)) continue;
        final data = doc.data();
        final entryType = (data['type'] ?? 'loan').toString().toLowerCase();
        if (entryType != 'loan') continue;
        final double currentRemaining =
            (data['remainingAmount'] ?? data['amount'] ?? 0.0).toDouble();
        final status = (data['status'] ?? 'active').toString().toLowerCase();
        final bool isCleared = status == 'paid' ||
            status == 'completed' ||
            status == 'fully paid';
        if (isCleared || currentRemaining <= 0.01) continue;
        return doc;
      }
      return null;
    }

    for (final doc in docs) {
      if (remainingToApply <= 0) break;

      final data = doc.data();
      final entryType = (data['type'] ?? 'loan').toString();
      if (entryType != 'loan') {
        continue;
      }
      final double currentRemaining =
          (data['remainingAmount'] ?? data['amount'] ?? 0.0).toDouble();

      if (currentRemaining <= 0) continue;

      final double applied = remainingToApply < currentRemaining
          ? remainingToApply
          : currentRemaining;
      remainingToApply -= applied;

      final double updatedRemaining =
          double.parse((currentRemaining - applied).toStringAsFixed(2));
      final bool fullyPaid = updatedRemaining <= 0.01;
      final double sanitizedRemaining = fullyPaid ? 0 : updatedRemaining;

      await doc.reference.update({
        'remainingAmount': sanitizedRemaining,
        'status': fullyPaid ? 'paid' : 'partial',
        'lastPaymentAt': FieldValue.serverTimestamp(),
        'lastPaymentMethod': paymentMethod,
      });

      final transactionId = data['transactionId'] as String?;
      print('💰 Processing owed loan: txId=$transactionId, applied=$applied, remaining=$sanitizedRemaining, fullyPaid=$fullyPaid');

      if (transactionId != null) {
        final transactionRef =
            _firestore.collection('Transactions').doc(transactionId);
        try {
          await transactionRef.update({
            'remainingAmount': sanitizedRemaining,
            'status': fullyPaid ? 'completed' : 'partial',
            'updatedAt': FieldValue.serverTimestamp(),
          });
          print('   ✅ Updated global Transaction doc');
        } catch (e) {
          print('   ⚠️ Unable to update transaction $transactionId: $e');
        }

        print('   🔍 Looking for matching lender loan with txId=$transactionId');
        final lenderDoc = findLenderLoan(transactionId);
        if (lenderDoc != null) {
          print('   ✅ Found lender loan! Updating...');
          consumedLenderDocIds.add(lenderDoc.id);
          await lenderDoc.reference.update({
            'remainingAmount': sanitizedRemaining,
            'status': fullyPaid ? 'completed' : 'partial',
            'lastPaymentAt': FieldValue.serverTimestamp(),
            'lastPaymentMethod': paymentMethod,
          });
          print('   ✅ Lender loan updated successfully!');
        } else if (canUpdateLenderLoans) {
          print(
            '   ⚠️ Unable to locate lender loan entry for transaction $transactionId while applying repayment.',
          );
          print('   Available lender transactionIds: ${lenderDocsByTransactionId.keys.toList()}');
        } else {
          print('   ⚠️ Cannot update lender loans (canUpdateLenderLoans=false)');
        }
      } else {
        print('   ⚠️ No transactionId found in owed transaction');
      }
    }

    if (remainingToApply > 0) {
      print('⚠️ Repayment still has ₱$remainingToApply unapplied.');
    }
  }

  /// Confirm a payment (called by the lender)
  /// This marks the payment as confirmed so it appears in lender's history
  static Future<bool> confirmPayment({
    required String lenderId,
    required String paymentDocId, // Document ID of the repayment in LentTransactions
  }) async {
    try {
      await _firestore
          .collection('Users')
          .doc(lenderId)
          .collection('LentTransactions')
          .doc(paymentDocId)
          .update({
        'paymentConfirmed': true,
        'status': 'confirmed',
        'confirmedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Payment confirmed successfully');
      return true;
    } catch (e) {
      print('❌ Error confirming payment: $e');
      return false;
    }
  }

  /// Get pending payments waiting for lender confirmation
  static Stream<List<Map<String, dynamic>>> getPendingPaymentsStream(String lenderId) {
    return _firestore
        .collection('Users')
        .doc(lenderId)
        .collection('LentTransactions')
        .where('type', isEqualTo: 'repayment')
        .where('paymentConfirmed', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      // Sort in memory instead of using orderBy to avoid composite index requirement
      final docs = snapshot.docs.toList();
      docs.sort((a, b) {
        final aTime = (a.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
        final bTime = (b.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
        return bTime.compareTo(aTime); // Descending order (newest first)
      });

      return docs.map((doc) {
        final data = doc.data();
        return {
          'docId': doc.id,
          'recipientName': data['recipientName'] ?? 'Unknown',
          'amount': (data['amount'] ?? 0.0).toDouble(),
          'paymentMethod': data['paymentMethod'] ?? 'Unknown',
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'rawData': data,
        };
      }).toList();
    });
  }
}