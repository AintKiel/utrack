import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionHistoryService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of all transactions (both lent and owed) for the current user
  static Stream<List<Map<String, dynamic>>> getAllTransactionsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    // Combine both LentTransactions and OwedTransactions streams
    final lentStream = _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('LentTransactions')
        .snapshots();

    final owedStream = _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('OwedTransactions')
        .snapshots();

    // Combine both streams
    return lentStream.asyncMap((lentSnapshot) async {
      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('OwedTransactions')
          .get();

      List<Map<String, dynamic>> allTransactions = [];

      // Process LentTransactions (show BOTH loans AND confirmed payments only)
      for (var doc in lentSnapshot.docs) {
        final data = doc.data();
        final type = (data['type'] as String?) ?? 'loan';
        final amount = (data['amount'] ?? 0.0).toDouble();
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        final recipientName = data['recipientName'] ?? 'Unknown';

        if (type == 'repayment') {
          // This is a payment received - only show if CONFIRMED by lender
          final paymentConfirmed = data['paymentConfirmed'] as bool? ?? false;

          // Skip if payment is not confirmed yet
          if (!paymentConfirmed) continue;

          final remainingAmount = data['remainingAmount'];
          final isFullPayment = remainingAmount != null && remainingAmount <= 0.01;

          allTransactions.add({
            'name': recipientName,
            'type': 'Received Payment',
            'paymentType': isFullPayment ? 'Full Payment' : 'Partial Payment',
            'amount': amount,
            'dateTime': createdAt,
            'rawData': data,
          });
        } else {
          // This is an original loan - show as "Money Lent"
          allTransactions.add({
            'name': recipientName,
            'type': 'Money Lent',
            'paymentType': null,
            'amount': amount,
            'dateTime': createdAt,
            'rawData': data,
          });
        }
      }

      // Process OwedTransactions (show BOTH loans AND payments)
      for (var doc in owedSnapshot.docs) {
        final data = doc.data();
        final type = (data['type'] as String?) ?? 'loan';
        final amount = (data['amount'] ?? 0.0).toDouble();
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        final senderName = data['senderName'] ?? 'Unknown';

        if (type == 'repayment') {
          // This is a payment sent - show as "Payment Sent"
          final remainingAmount = data['remainingAmount'];
          final isFullPayment = remainingAmount != null && remainingAmount <= 0.01;

          allTransactions.add({
            'name': senderName,
            'type': 'Payment Sent',
            'paymentType': isFullPayment ? 'Full Payment' : 'Partial Payment',
            'amount': amount,
            'dateTime': createdAt,
            'rawData': data,
          });
        } else {
          // This is an original loan - show as "Borrowed Money"
          allTransactions.add({
            'name': senderName,
            'type': 'Borrowed Money',
            'paymentType': null,
            'amount': amount,
            'dateTime': createdAt,
            'rawData': data,
          });
        }
      }

      // Sort by date (most recent first)
      allTransactions.sort((a, b) =>
        (b['dateTime'] as DateTime).compareTo(a['dateTime'] as DateTime)
      );

      return allTransactions;
    });
  }


  /// Get transaction count for current user
  static Future<int> getTransactionCount() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return 0;

      final lentSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('LentTransactions')
          .get();

      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('OwedTransactions')
          .get();

      return lentSnapshot.docs.length + owedSnapshot.docs.length;
    } catch (e) {
      print('❌ Error getting transaction count: $e');
      return 0;
    }
  }

  /// Get transactions within a date range
  static Future<List<Map<String, dynamic>>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      final lentSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('LentTransactions')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('OwedTransactions')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      List<Map<String, dynamic>> transactions = [];

      for (var doc in lentSnapshot.docs) {
        final data = doc.data();
        final type = (data['type'] as String?) ?? 'loan';
        final amount = (data['amount'] ?? 0.0).toDouble();
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        final recipientName = data['recipientName'] ?? 'Unknown';

        if (type == 'repayment') {
          // Only show confirmed payments in lender's history
          final paymentConfirmed = data['paymentConfirmed'] as bool? ?? false;

          if (!paymentConfirmed) continue;

          final remainingAmount = data['remainingAmount'];
          final isFullPayment = remainingAmount != null && remainingAmount <= 0.01;

          transactions.add({
            'name': recipientName,
            'type': 'Received Payment',
            'paymentType': isFullPayment ? 'Full Payment' : 'Partial Payment',
            'amount': amount,
            'dateTime': createdAt,
            'rawData': data,
          });
        } else {
          transactions.add({
            'name': recipientName,
            'type': 'Money Lent',
            'paymentType': null,
            'amount': amount,
            'dateTime': createdAt,
            'rawData': data,
          });
        }
      }

      for (var doc in owedSnapshot.docs) {
        final data = doc.data();
        final type = (data['type'] as String?) ?? 'loan';
        final amount = (data['amount'] ?? 0.0).toDouble();
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        final senderName = data['senderName'] ?? 'Unknown';

        if (type == 'repayment') {
          final remainingAmount = data['remainingAmount'];
          final isFullPayment = remainingAmount != null && remainingAmount <= 0.01;

          transactions.add({
            'name': senderName,
            'type': 'Payment Sent',
            'paymentType': isFullPayment ? 'Full Payment' : 'Partial Payment',
            'amount': amount,
            'dateTime': createdAt,
            'rawData': data,
          });
        } else {
          transactions.add({
            'name': senderName,
            'type': 'Borrowed Money',
            'paymentType': null,
            'amount': amount,
            'dateTime': createdAt,
            'rawData': data,
          });
        }
      }

      transactions.sort((a, b) =>
        (b['dateTime'] as DateTime).compareTo(a['dateTime'] as DateTime)
      );

      return transactions;
    } catch (e) {
      print('❌ Error getting transactions by date range: $e');
      return [];
    }
  }
}
