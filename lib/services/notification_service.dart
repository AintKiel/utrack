import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get real-time notifications for the current user
  static Stream<List<Map<String, dynamic>>> getNotificationsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('Notifications')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      final notifications = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      
      print('📱 Notifications stream: Found ${notifications.length} notifications');
      for (var notif in notifications) {
        print('   - ${notif['type']}: ${notif['title']}');
      }
      
      return notifications;
    });
  }

  /// Create a notification
  static Future<void> createNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      print('🔔 Creating notification: $type - $title');
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .add({
        'type': type,
        'title': title,
        'message': message,
        'data': data ?? {},
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
      print('✅ Notification created successfully');
    } catch (e) {
      print('❌ Error creating notification: $e');
    }
  }

  /// Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('Notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('❌ Error marking notification as read: $e');
    }
  }

  /// Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('Notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('❌ Error deleting notification: $e');
    }
  }

  /// Generate notifications based on loan data
  static Future<void> generateLoanNotifications() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('❌ No current user for notifications');
      return;
    }

    try {
      print('🔄 Starting notification generation for user: ${currentUser.uid}');
      
      // Check for overdue loans
      print('🔍 Checking for overdue loans...');
      await _checkOverdueLoans(currentUser.uid);
      
      // Check for upcoming due dates
      print('🔍 Checking for upcoming due dates...');
      await _checkUpcomingDueDates(currentUser.uid);
      
      // Check for new loan requests
      print('🔍 Checking for new loan requests...');
      await _checkNewLoanRequests(currentUser.uid);
      
      print('✅ Notification generation completed - duplicates prevented');
      
    } catch (e) {
      print('❌ Error generating loan notifications: $e');
    }
  }

  /// Check for overdue loans and create notifications
  static Future<void> _checkOverdueLoans(String userId) async {
    final now = DateTime.now();
    
    // Check owed transactions (money I owe)
    final owedSnapshot = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('OwedTransactions')
        .where('status', isEqualTo: 'active')
        .get();

    for (var doc in owedSnapshot.docs) {
      final data = doc.data();
      final dueDateStr = data['dueDate'] as String?;
      if (dueDateStr != null) {
        final dueDate = _parseDateString(dueDateStr);
        if (dueDate != null && now.isAfter(dueDate)) {
          
          final transactionId = doc.id;
          
          // Check if we already have a notification for this overdue payment
          final existingNotification = await _firestore
              .collection('Users')
              .doc(userId)
              .collection('Notifications')
              .where('type', isEqualTo: 'overdue')
              .where('data.transactionId', isEqualTo: transactionId)
              .get();

          // Only create notification if one doesn't exist for this transaction
          if (existingNotification.docs.isEmpty) {
            print('   Creating overdue payment notification for transaction: $transactionId');
            await createNotification(
              userId: userId,
              type: 'overdue',
              title: 'Payment Overdue',
              message: 'Your payment to ${data['lenderName'] ?? 'Unknown'} is overdue',
              data: {
                'amount': data['amount'],
                'lenderName': data['lenderName'],
                'dueDate': dueDateStr,
                'transactionId': transactionId,
              },
            );
          } else {
            print('   Overdue payment notification already exists for transaction: $transactionId');
          }
        }
      }
    }
  }

  /// Check for upcoming due dates (within 3 days)
  static Future<void> _checkUpcomingDueDates(String userId) async {
    final now = DateTime.now();
    final threeDaysFromNow = now.add(const Duration(days: 3));
    
    // Check owed transactions
    final owedSnapshot = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('OwedTransactions')
        .where('status', isEqualTo: 'active')
        .get();

    for (var doc in owedSnapshot.docs) {
      final data = doc.data();
      final dueDateStr = data['dueDate'] as String?;
      if (dueDateStr != null) {
        final dueDate = _parseDateString(dueDateStr);
        if (dueDate != null && 
            dueDate.isAfter(now) && 
            dueDate.isBefore(threeDaysFromNow)) {
          
          final transactionId = doc.id;
          
          // Check if we already have a notification for this upcoming payment
          final existingNotification = await _firestore
              .collection('Users')
              .doc(userId)
              .collection('Notifications')
              .where('type', isEqualTo: 'upcomingPayment')
              .where('data.transactionId', isEqualTo: transactionId)
              .get();

          // Only create notification if one doesn't exist for this transaction
          if (existingNotification.docs.isEmpty) {
            print('   Creating upcoming payment notification for transaction: $transactionId');
            await createNotification(
              userId: userId,
              type: 'upcomingPayment',
              title: 'Payment Due Soon',
              message: 'Payment to ${data['lenderName'] ?? 'Unknown'} is due in ${dueDate.difference(now).inDays} days',
              data: {
                'amount': data['amount'],
                'lenderName': data['lenderName'],
                'dueDate': dueDateStr,
                'transactionId': transactionId,
              },
            );
          } else {
            print('   Upcoming payment notification already exists for transaction: $transactionId');
          }
        }
      }
    }
  }

  /// Check for new loan requests (only for lenders, not borrowers)
  static Future<void> _checkNewLoanRequests(String userId) async {
    print('🔍 Checking for new loan requests for user: $userId');
    
    // Check LoanRequests collection for pending requests WHERE USER IS THE LENDER
    final loanRequestsSnapshot = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('LoanRequests')
        .where('status', isEqualTo: 'pending')
        .where('lenderId', isEqualTo: userId) // Only requests where current user is the lender
        .get();

    print('📬 Found ${loanRequestsSnapshot.docs.length} pending loan requests where user is lender');

    for (var doc in loanRequestsSnapshot.docs) {
      final data = doc.data();
      final requestId = doc.id;
      final borrowerId = data['borrowerId'] as String;
      
      print('📋 Processing loan request: $requestId');
      print('   Borrower: ${data['borrowerName']} ($borrowerId)');
      print('   Lender: ${data['lenderName']} (${data['lenderId']})');
      print('   Current User: $userId');
      
      // Only create notification if current user is the lender (not the borrower)
      if (data['lenderId'] == userId && borrowerId != userId) {
        // Check if we already have a notification for this request
        final existingNotification = await _firestore
            .collection('Users')
            .doc(userId)
            .collection('Notifications')
            .where('type', isEqualTo: 'newBorrowRequest')
            .where('data.requestId', isEqualTo: requestId)
            .get();

        print('   Existing notifications: ${existingNotification.docs.length}');

        if (existingNotification.docs.isEmpty) {
          print('   Creating notification for lender...');
          await createNotification(
            userId: userId,
            type: 'newBorrowRequest',
            title: 'New Borrow Request',
            message: '${data['borrowerName'] ?? 'Someone'} wants to borrow ₱${data['amount']}',
            data: {
              'amount': data['amount'],
              'borrowerName': data['borrowerName'],
              'borrowerId': data['borrowerId'],
              'requestId': data['requestId'],
              'repaymentType': data['repaymentType'],
              'dueDate': data['dueDate'],
            },
          );
          print('✅ Created notification for loan request: $requestId');
        } else {
          print('ℹ️ Notification already exists for loan request: $requestId');
        }
      } else {
        print('ℹ️ Skipping notification - user is borrower, not lender');
      }
    }
    
    print('🏁 Finished checking loan requests');
  }

  /// Parse date string (dd/mm/yyyy) to DateTime
  static DateTime? _parseDateString(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Invalid date format
    }
    return null;
  }

  /// Create payment received notification
  static Future<void> notifyPaymentReceived({
    required String lenderId,
    required String borrowerName,
    required double amount,
  }) async {
    await createNotification(
      userId: lenderId,
      type: 'paymentReceived',
      title: 'Payment Received',
      message: '$borrowerName has paid ₱${amount.toStringAsFixed(2)}',
      data: {
        'amount': amount,
        'borrowerName': borrowerName,
      },
    );
  }

  /// Create payment sent notification
  static Future<void> notifyPaymentSent({
    required String borrowerId,
    required String lenderName,
    required double amount,
  }) async {
    await createNotification(
      userId: borrowerId,
      type: 'paymentSent',
      title: 'Payment Sent',
      message: 'You have paid ₱${amount.toStringAsFixed(2)} to $lenderName',
      data: {
        'amount': amount,
        'lenderName': lenderName,
      },
    );
  }

  /// Create loan request approved notification
  static Future<void> notifyRequestApproved({
    required String borrowerId,
    required String lenderName,
    required double amount,
  }) async {
    await createNotification(
      userId: borrowerId,
      type: 'requestApproved',
      title: 'Request Approved',
      message: '$lenderName has approved your loan request of ₱${amount.toStringAsFixed(2)}',
      data: {
        'amount': amount,
        'lenderName': lenderName,
      },
    );
  }

  /// Create loan request rejected notification
  static Future<void> notifyRequestRejected({
    required String borrowerId,
    required String lenderName,
    required double amount,
  }) async {
    await createNotification(
      userId: borrowerId,
      type: 'requestRejected',
      title: 'Request Rejected',
      message: '$lenderName has rejected your loan request of ₱${amount.toStringAsFixed(2)}',
      data: {
        'amount': amount,
        'lenderName': lenderName,
      },
    );
  }

  /// Create credit score change notification
  static Future<void> notifyCreditScoreChange({
    required String userId,
    required double oldScore,
    required double newScore,
  }) async {
    final difference = newScore - oldScore;
    final isIncrease = difference > 0;
    
    await createNotification(
      userId: userId,
      type: isIncrease ? 'creditIncrease' : 'creditDecrease',
      title: isIncrease ? 'Credit Score Increased' : 'Credit Score Decreased',
      message: 'Your credit score ${isIncrease ? 'increased' : 'decreased'} by ${difference.abs().toStringAsFixed(1)}%',
      data: {
        'oldScore': oldScore,
        'newScore': newScore,
        'difference': difference.abs(),
      },
    );
  }
}
