import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoanDetailsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get detailed loan information for a specific borrower/lender
  static Future<Map<String, dynamic>> getLoanDetails({
    required String userId, // The borrower/lender's UID
    required bool isLending, // true = you lent to them, false = they lent to you
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      // Get user info (borrower/lender)
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      if (!userDoc.exists) {
        return {'success': false, 'error': 'User not found'};
      }

      final userData = userDoc.data()!;
      final name = userData['firstName'] ?? 'Unknown';
      final email = userData['email'] ?? '';
      final phone = userData['phoneNumber'] ?? '';
      final address = userData['address'] ?? '';

      late final List<QueryDocumentSnapshot<Map<String, dynamic>>> transactionDocs;

      if (isLending) {
        // Use global Transactions so lender view reflects borrower repayments immediately
        final snapshot = await _firestore
            .collection('Transactions')
            .where('senderId', isEqualTo: currentUser.uid)
            .get();

        transactionDocs = snapshot.docs
            .where((doc) => doc.data()['recipientId'] == userId)
            .toList()
          ..sort((a, b) {
            final aDate = a.data()['createdAt'];
            final bDate = b.data()['createdAt'];
            final aTs = aDate is Timestamp ? aDate : null;
            final bTs = bDate is Timestamp ? bDate : null;

            if (aTs == null && bTs == null) return 0;
            if (aTs == null) return 1;
            if (bTs == null) return -1;
            return bTs.compareTo(aTs); // descending
          });
      } else {
        final snapshot = await _firestore
            .collection('Users')
            .doc(currentUser.uid)
            .collection('OwedTransactions')
            .where('senderId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();

        transactionDocs = snapshot.docs;
      }

      double totalAmount = 0.0;
      List<Map<String, dynamic>> transactions = [];
      List<Map<String, dynamic>> dueDates = [];

      for (var doc in transactionDocs) {
        final data = doc.data();
        final amount = (data['amount'] ?? 0.0).toDouble();
        final status = data['status'] as String? ?? 'active';
        final createdAt = data['createdAt'] as Timestamp?;
        final dueDate = data['dueDate'] as String?;
        final repaymentType = data['repaymentType'] as String? ?? 'Single Repayment';
        final interestRate = (data['interestRate'] ?? 0.0).toDouble();
        final installmentCount = data['installmentCount'] as int?;
        final type = data['type'] as String? ?? 'loan';
        final remainingAmount =
            (data['remainingAmount'] ?? data['amount'] ?? 0.0).toDouble();

        if (type == 'loan') {
          totalAmount += remainingAmount;
        }

        // Add to transaction history (loan entries only)
        if (type == 'loan') {
          transactions.add({
            'transactionId': doc.id,
            'date': _formatDate(createdAt?.toDate()),
            'amount': amount,
            'status': _formatStatus(status),
          });
        }

        final normalizedStatus = status.toLowerCase();
        final bool isCleared = normalizedStatus == 'paid' ||
            normalizedStatus == 'completed' ||
            normalizedStatus == 'fully paid';

        // Add to due dates if applicable
        if (dueDate != null && !isCleared && type == 'loan') {
          dueDates.add({
            'date': dueDate,
            'amount': remainingAmount + (remainingAmount * interestRate / 100),
            'original': amount,
            'remaining': remainingAmount,
            'status': _getDueStatus(dueDate),
            'repaymentType': repaymentType,
            'interest': interestRate,
          });
        }
      }

      return {
        'success': true,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'totalOwed': totalAmount,
        'transactionHistory': transactions,
        'dueDates': dueDates,
      };
    } catch (e) {
      print('❌ Error getting loan details: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Format date
  static String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Format status
  static String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return 'Fully Paid';
      case 'partial':
        return 'Partially Paid';
      case 'active':
      case 'pending':
        return 'Pending';
      case 'overdue':
        return 'Overdue';
      default:
        return status;
    }
  }

  /// Get due status based on date
  static String _getDueStatus(String dueDateStr) {
    try {
      // Parse date string (format: "dd/mm/yyyy")
      final parts = dueDateStr.split('/');
      if (parts.length != 3) return 'Pending';
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final dueDate = DateTime(year, month, day);
      final now = DateTime.now();

      if (now.isAfter(dueDate)) {
        return 'Overdue';
      } else {
        return 'Pending';
      }
    } catch (e) {
      return 'Pending';
    }
  }
}
