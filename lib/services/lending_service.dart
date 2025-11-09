import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LendingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get total amount lent by current user
  static Future<double> getTotalLent() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return 0.0;

      final userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      if (!userDoc.exists) return 0.0;

      final paymentStats = userDoc.data()?['paymentStats'] as Map<String, dynamic>?;
      return (paymentStats?['totalLent'] ?? 0.0).toDouble();
    } catch (e) {
      print('❌ Error getting total lent: $e');
      return 0.0;
    }
  }

  /// Get number of borrowers
  static Future<int> getBorrowerCount() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return 0;

      final userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      if (!userDoc.exists) return 0;

      final paymentStats = userDoc.data()?['paymentStats'] as Map<String, dynamic>?;
      return (paymentStats?['borrowerCount'] ?? 0).toInt();
    } catch (e) {
      print('❌ Error getting borrower count: $e');
      return 0;
    }
  }

  /// Stream of lent transactions grouped by debtor
  static Stream<List<Map<String, dynamic>>> getDebtorsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('LentTransactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      // Group transactions by recipient
      Map<String, Map<String, dynamic>> debtorMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final recipientId = data['recipientId'] as String?;
        final recipientName = data['recipientName'] as String? ?? 'Unknown';
        final amount = (data['amount'] ?? 0.0).toDouble();
        final createdAt = data['createdAt'] as Timestamp?;
        final status = data['status'] as String? ?? 'Unpaid';

        if (recipientId != null) {
          if (debtorMap.containsKey(recipientId)) {
            // Add to existing debtor's total
            debtorMap[recipientId]!['amount'] += amount;
          } else {
            // Create new debtor entry
            debtorMap[recipientId] = {
              'recipientId': recipientId,
              'name': recipientName,
              'amount': amount,
              'date': createdAt?.toDate() ?? DateTime.now(),
              'status': status,
              'initials': _getInitials(recipientName),
            };
          }
        }
      }

      // Convert to list and format
      return debtorMap.values.map((debtor) {
        return {
          'recipientId': debtor['recipientId'],
          'name': debtor['name'],
          'amount': debtor['amount'].toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), ''),
          'date': _formatDate(debtor['date']),
          'status': debtor['status'],
          'color': _getStatusColor(debtor['status']),
          'initials': debtor['initials'],
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
