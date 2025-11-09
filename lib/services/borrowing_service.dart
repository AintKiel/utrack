import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

        if (senderId != null) {
          if (lenderMap.containsKey(senderId)) {
            // Add to existing lender's total
            lenderMap[senderId]!['amount'] += amount;
          } else {
            // Create new lender entry
            lenderMap[senderId] = {
              'senderId': senderId,
              'name': senderName,
              'amount': amount,
              'date': createdAt?.toDate() ?? DateTime.now(),
              'status': status,
              'initials': _getInitials(senderName),
            };
          }
        }
      }

      // Convert to list and format
      return lenderMap.values.map((lender) {
        return {
          'senderId': lender['senderId'],
          'name': lender['name'],
          'amount': lender['amount'].toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), ''),
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
}
