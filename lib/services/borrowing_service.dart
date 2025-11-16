import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'notification_service.dart';

class BorrowingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get total amount owed by current user
  static Future<double> getTotalOwed() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return 0.0;

      final userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      if (!userDoc.exists) return 0.0;

      final paymentStats = userDoc.data()?['paymentStats'] as Map<String, dynamic>?;
      return (paymentStats?['totalOwed'] ?? 0.0).toDouble();
    } catch (e) {
      print('❌ Error getting total owed: $e');
      return 0.0;
    }
  }

  /// Get number of lenders
  static Future<int> getLenderCount() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return 0;

      final userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      if (!userDoc.exists) return 0;

      final paymentStats = userDoc.data()?['paymentStats'] as Map<String, dynamic>?;
      return (paymentStats?['lenderCount'] ?? 0).toInt();
    } catch (e) {
      print('❌ Error getting lender count: $e');
      return 0;
    }
  }

  /// Stream of owed transactions grouped by lender
  static Stream<List<Map<String, dynamic>>> getLendersStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('OwedTransactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      // Group transactions by sender (lender)
      Map<String, Map<String, dynamic>> lenderMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final senderId = data['senderId'] as String?;
        final senderName = data['senderName'] as String? ?? 'Unknown';
        final amount = (data['amount'] ?? 0.0).toDouble();
        final createdAt = data['createdAt'] as Timestamp?;
        final status = data['status'] as String? ?? 'Unpaid';
        final type = (data['type'] as String?) ?? 'loan';
        final signedAmount = type == 'repayment' ? -amount : amount;

        if (senderId != null) {
          if (lenderMap.containsKey(senderId)) {
            // Add to existing lender's total
            lenderMap[senderId]!['rawAmount'] =
                (lenderMap[senderId]!['rawAmount'] as double) + signedAmount;
          } else {
            // Create new lender entry
            lenderMap[senderId] = {
              'senderId': senderId,
              'name': senderName,
              'rawAmount': signedAmount,
              'date': createdAt?.toDate() ?? DateTime.now(),
              'status': status,
              'initials': _getInitials(senderName),
            };
          }
        }
      }

      // Convert to list and format
      return lenderMap.values.map((lender) {
        final balance = (lender['rawAmount'] as double);
        final displayAmount = balance <= 0 ? 0.0 : balance;
        return {
          'senderId': lender['senderId'],
          'name': lender['name'],
          'amount': displayAmount
              .toStringAsFixed(2)
              .replaceAll(RegExp(r'\.00$'), ''),
          'date': _formatDate(lender['date']),
          'status': lender['status'],
          'color': _getStatusColor(lender['status']),
          'initials': lender['initials'],
        };
      }).toList();
    });
  }

  /// Helper: Get initials from name
  static String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }
    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  /// Helper: Format date
  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  /// Helper: Get status color
  static dynamic _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return const Color(0xFF4CAF50); // Green
      case 'overdue':
        return const Color(0xFFF44336); // Red
      case 'unpaid':
      case 'pending':
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  /// Send a cash repayment notification to the lender so they can confirm it later.
  static Future<bool> notifyCashRepaymentRequest({
    required String lenderId,
    required double amount,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final borrowerDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      final borrowerName = borrowerDoc.data()?['firstName'] ?? borrowerDoc.data()?['email'] ?? 'Borrower';

      await NotificationService.createNotification(
        userId: lenderId,
        type: 'cashRepayment',
        title: 'Cash Repayment Pending',
        message: '$borrowerName wants to repay ₱${amount.toStringAsFixed(2)} in cash.',
        data: {
          'amount': amount,
          'borrowerName': borrowerName,
          'borrowerId': currentUser.uid,
          'paymentMethod': 'cash',
        },
      );

      return true;
    } catch (e) {
      print('❌ Error notifying cash repayment: $e');
      return false;
    }
  }

  /// Helper to fetch a user's profile map (used for direct e-wallet payments)
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('Users').doc(userId).get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      return null;
    }
  }
}
