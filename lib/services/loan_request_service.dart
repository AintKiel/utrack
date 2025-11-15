import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart';

class LoanRequestService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Request a loan from another user
  /// This creates a PENDING loan request notification for the lender
  /// The lender must approve before transactions are created
  static Future<Map<String, dynamic>> requestLoan({
    required String lenderUserId, // UID of the person you're requesting from
    required double amount,
    required String repaymentType, // "Single Repayment" or "Multiple Repayment"
    String? dueDate,
    int? installmentCount,
    double? interestRate,
    String? notes,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      // Get borrower's (current user) info
      final borrowerDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      if (!borrowerDoc.exists) {
        return {'success': false, 'error': 'Borrower profile not found'};
      }
      final borrowerName = borrowerDoc.data()?['firstName'] ?? 'Unknown';

      // Get lender's info
      final lenderDoc = await _firestore.collection('Users').doc(lenderUserId).get();
      if (!lenderDoc.exists) {
        return {'success': false, 'error': 'Lender not found. Please check the User ID.'};
      }
      final lenderName = lenderDoc.data()?['firstName'] ?? 'Unknown';

      print('🔔 Creating loan request notification...');
      print('  Borrower: $borrowerName (${currentUser.uid})');
      print('  Lender: $lenderName ($lenderUserId)');
      print('  Amount: ₱$amount');

      final requestId = _firestore.collection('LoanRequests').doc().id;

      // 1. Create loan request notification for the LENDER
      await _firestore
          .collection('Users')
          .doc(lenderUserId)
          .collection('LoanRequests')
          .doc(requestId)
          .set({
        'requestId': requestId,
        'borrowerId': currentUser.uid,
        'borrowerName': borrowerName,
        'lenderId': lenderUserId,
        'lenderName': lenderName,
        'amount': amount,
        'repaymentType': repaymentType,
        'dueDate': dueDate,
        'installmentCount': installmentCount,
        'interestRate': interestRate,
        'notes': notes,
        'status': 'pending', // pending, approved, rejected
        'type': 'loan_request',
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Also create a notification in the Notifications collection for the lender
      await NotificationService.createNotification(
        userId: lenderUserId,
        type: 'newBorrowRequest',
        title: 'New Borrow Request',
        message: '$borrowerName wants to borrow ₱${amount.toStringAsFixed(2)}',
        data: {
          'amount': amount,
          'borrowerName': borrowerName,
          'borrowerId': currentUser.uid,
          'requestId': requestId,
          'repaymentType': repaymentType,
          'dueDate': dueDate,
          'notes': notes,
        },
      );

      print('✅ Loan request notification sent!');
      print('📬 Notification created in lender\'s Notifications collection');
      return {
        'success': true,
        'requestId': requestId,
        'lenderName': lenderName,
        'amount': amount,
      };
    } catch (e) {
      print('❌ Error creating loan request: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Approve a loan request (called by the lender)
  static Future<Map<String, dynamic>> approveLoanRequest(String requestId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      // Get the loan request
      final requestDoc = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('LoanRequests')
          .doc(requestId)
          .get();

      if (!requestDoc.exists) {
        return {'success': false, 'error': 'Loan request not found'};
      }

      final requestData = requestDoc.data()!;
      final borrowerId = requestData['borrowerId'] as String;
      final borrowerName = requestData['borrowerName'] as String;
      final lenderName = requestData['lenderName'] as String;
      final amount = (requestData['amount'] as num).toDouble();

      print('✅ Approving loan request...');
      print('  Lender: $lenderName (${currentUser.uid})');
      print('  Borrower: $borrowerName ($borrowerId)');
      print('  Amount: ₱$amount');

      final batch = _firestore.batch();
      final transactionId = _firestore.collection('Transactions').doc().id;

      // 1. Create transaction in global Transactions collection
      final transactionRef = _firestore.collection('Transactions').doc(transactionId);
      batch.set(transactionRef, {
        'transactionId': transactionId,
        'senderId': currentUser.uid,
        'senderName': lenderName,
        'recipientId': borrowerId,
        'recipientName': borrowerName,
        'amount': amount,
        'repaymentType': requestData['repaymentType'],
        'dueDate': requestData['dueDate'],
        'installmentCount': requestData['installmentCount'],
        'interestRate': requestData['interestRate'],
        'notes': requestData['notes'],
        'status': 'active',
        'type': 'loan',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Add to LENDER's LentTransactions
      await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('LentTransactions')
          .add({
        'transactionId': transactionId,
        'recipientId': borrowerId,
        'recipientName': borrowerName,
        'senderName': lenderName,
        'amount': amount,
        'repaymentType': requestData['repaymentType'],
        'dueDate': requestData['dueDate'],
        'installmentCount': requestData['installmentCount'],
        'interestRate': requestData['interestRate'],
        'notes': requestData['notes'],
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Add to BORROWER's OwedTransactions
      await _firestore
          .collection('Users')
          .doc(borrowerId)
          .collection('OwedTransactions')
          .add({
        'transactionId': transactionId,
        'senderId': currentUser.uid,
        'senderName': lenderName,
        'recipientId': borrowerId,
        'recipientName': borrowerName,
        'amount': amount,
        'repaymentType': requestData['repaymentType'],
        'dueDate': requestData['dueDate'],
        'installmentCount': requestData['installmentCount'],
        'interestRate': requestData['interestRate'],
        'notes': requestData['notes'],
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 4. Update LENDER's stats
      final lenderRef = _firestore.collection('Users').doc(currentUser.uid);
      batch.update(lenderRef, {
        'paymentStats.totalLent': FieldValue.increment(amount),
        'paymentStats.lastUpdated': FieldValue.serverTimestamp(),
      });

      // 5. Update BORROWER's stats
      final borrowerRef = _firestore.collection('Users').doc(borrowerId);
      batch.update(borrowerRef, {
        'paymentStats.totalOwed': FieldValue.increment(amount),
        'paymentStats.lastUpdated': FieldValue.serverTimestamp(),
      });

      // 6. Update the loan request status to approved
      final requestRef = _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('LoanRequests')
          .doc(requestId);
      batch.update(requestRef, {
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      // Update contact counts
      await _updateContactCounts(currentUser.uid);
      await _updateContactCounts(borrowerId);

      // Send notification to borrower that request was APPROVED
      print('📬 Sending approval notification to borrower: $borrowerId');
      await NotificationService.notifyRequestApproved(
        borrowerId: borrowerId,
        lenderName: lenderName,
        amount: amount,
      );

      print('✅ Loan request approved and transactions created!');
      print('📬 Approval notification sent to borrower: $borrowerName');
      return {
        'success': true,
        'transactionId': transactionId,
        'borrowerName': borrowerName,
        'amount': amount,
      };
    } catch (e) {
      print('❌ Error approving loan request: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Reject a loan request (called by the lender)
  static Future<Map<String, dynamic>> rejectLoanRequest(String requestId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      // Get the loan request data before rejecting
      final requestDoc = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('LoanRequests')
          .doc(requestId)
          .get();

      if (!requestDoc.exists) {
        return {'success': false, 'error': 'Loan request not found'};
      }

      final requestData = requestDoc.data()!;
      final borrowerId = requestData['borrowerId'] as String;
      final borrowerName = requestData['borrowerName'] as String;
      final lenderName = requestData['lenderName'] as String;
      final amount = (requestData['amount'] as num).toDouble();

      // Update the loan request status to rejected
      await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('LoanRequests')
          .doc(requestId)
          .update({
        'status': 'rejected',
        'rejectedAt': FieldValue.serverTimestamp(),
      });

      // Send notification to borrower that request was REJECTED
      print('📬 Sending rejection notification to borrower: $borrowerId');
      await NotificationService.notifyRequestRejected(
        borrowerId: borrowerId,
        lenderName: lenderName,
        amount: amount,
      );

      print('✅ Loan request rejected');
      print('📬 Rejection notification sent to borrower: $borrowerName');
      return {'success': true};
    } catch (e) {
      print('❌ Error rejecting loan request: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Get pending loan requests for current user (as lender)
  static Stream<List<Map<String, dynamic>>> getLoanRequestsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    print('📥 Listening for loan requests for user: ${currentUser.uid}');
    
    return _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('LoanRequests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      print('📬 Found ${snapshot.docs.length} pending loan requests');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'requestId': doc.id,
          'borrowerId': data['borrowerId'],
          'borrowerName': data['borrowerName'],
          'amount': data['amount'],
          'repaymentType': data['repaymentType'],
          'dueDate': data['dueDate'],
          'installmentCount': data['installmentCount'],
          'interestRate': data['interestRate'],
          'notes': data['notes'],
          'createdAt': data['createdAt'],
          'read': data['read'] ?? false,
        };
      }).toList();
    });
  }

  /// Update lender/borrower count for a user
  static Future<void> _updateContactCounts(String userId) async {
    try {
      // Get unique lenders
      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('OwedTransactions')
          .get();

      Set<String> uniqueLenders = {};
      for (var doc in owedSnapshot.docs) {
        final senderId = doc.data()['senderId'] as String?;
        if (senderId != null && senderId.isNotEmpty) {
          uniqueLenders.add(senderId);
        }
      }

      // Get unique borrowers
      final lentSnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('LentTransactions')
          .get();

      Set<String> uniqueBorrowers = {};
      for (var doc in lentSnapshot.docs) {
        final recipientId = doc.data()['recipientId'] as String?;
        if (recipientId != null && recipientId.isNotEmpty) {
          uniqueBorrowers.add(recipientId);
        }
      }

      // Update counts
      await _firestore.collection('Users').doc(userId).update({
        'paymentStats.lenderCount': uniqueLenders.length,
        'paymentStats.borrowerCount': uniqueBorrowers.length,
      });

      print('✅ Contact counts updated for $userId');
    } catch (e) {
      print('❌ Error updating contact counts: $e');
    }
  }

  /// Get notifications for current user (as borrower - approved/rejected notifications)
  static Stream<List<Map<String, dynamic>>> getBorrowerNotificationsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('Notifications')
        .where('type', whereIn: ['loan_approved', 'loan_rejected'])
        .snapshots()
        .map((snapshot) {
      print('📬 Found ${snapshot.docs.length} borrower notifications');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'notificationId': doc.id,
          'type': data['type'],
          'title': data['title'],
          'message': data['message'],
          'lenderName': data['lenderName'],
          'lenderId': data['lenderId'],
          'amount': data['amount'],
          'transactionId': data['transactionId'],
          'read': data['read'] ?? false,
          'createdAt': data['createdAt'],
        };
      }).toList();
    });
  }

  /// Mark notification as read
  static Future<void> markNotificationAsRead(String notificationId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('Notifications')
        .doc(notificationId)
        .update({'read': true});
  }

  /// Validate if a user ID exists
  static Future<Map<String, dynamic>> validateUserId(String userId) async {
    try {
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        return {
          'exists': true,
          'name': data?['firstName'] ?? 'Unknown',
          'email': data?['email'] ?? '',
        };
      }
      return {'exists': false};
    } catch (e) {
      print('❌ Error validating user ID: $e');
      return {'exists': false, 'error': e.toString()};
    }
  }
}
