import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user's profile data as a stream
  static Stream<Map<String, dynamic>?> getUserProfileStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return null;

      final data = snapshot.data() as Map<String, dynamic>;

      return {
        'uid': currentUser.uid,
        'fullName': _getFullName(data),
        'firstName': data['firstName'] ?? 'User',
        'lastName': data['lastName'] ?? '',
        'email': data['email'] ?? currentUser.email ?? '',
        'phone': data['phoneNumber'] ?? '', // Fixed: use 'phoneNumber' from Firestore
        'address': data['address'] ?? '',
        'profilePicUrl': data['profilePicUrl'] ?? '',
        'createdAt': data['createdAt'],
      };
    });
  }

  /// Get current user's profile data as a future (one-time fetch)
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final doc = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;

      return {
        'uid': currentUser.uid,
        'fullName': _getFullName(data),
        'firstName': data['firstName'] ?? 'User',
        'lastName': data['lastName'] ?? '',
        'email': data['email'] ?? currentUser.email ?? '',
        'phone': data['phoneNumber'] ?? '', // Fixed: use 'phoneNumber' from Firestore
        'address': data['address'] ?? '',
        'profilePicUrl': data['profilePicUrl'] ?? '',
        'createdAt': data['createdAt'],
      };
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      return null;
    }
  }

  /// Update user profile
  static Future<bool> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    String? profilePicUrl,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      Map<String, dynamic> updates = {};

      if (firstName != null) updates['firstName'] = firstName;
      if (lastName != null) updates['lastName'] = lastName;
      if (phone != null) updates['phoneNumber'] = phone; // Fixed: use 'phoneNumber' in Firestore
      if (address != null) updates['address'] = address;
      if (profilePicUrl != null) updates['profilePicUrl'] = profilePicUrl;

      if (updates.isEmpty) return true;

      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .update(updates);

      print('✅ Profile updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  /// Get user activity statistics
  /// Matches the history page logic - counts loans AND payments as separate transactions
  static Future<Map<String, dynamic>> getUserActivityStats() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return {
          'totalTransactions': 0,
          'completedTransactions': 0,
        };
      }

      // Get lent transactions count
      final lentSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('LentTransactions')
          .get();

      // Get owed transactions count
      final owedSnapshot = await _firestore
          .collection('Users')
          .doc(currentUser.uid)
          .collection('OwedTransactions')
          .get();

      int totalTransactions = 0;
      int completedTransactions = 0;

      // Process LentTransactions (show BOTH loans AND confirmed payments only)
      // This matches transaction_history_service.dart logic
      for (var doc in lentSnapshot.docs) {
        final data = doc.data();
        final type = (data['type'] as String?) ?? 'loan';

        if (type == 'repayment') {
          // This is a payment received - only count if CONFIRMED by lender
          final paymentConfirmed = data['paymentConfirmed'] as bool? ?? false;

          // Skip if payment is not confirmed yet (not shown in history)
          if (!paymentConfirmed) continue;

          totalTransactions++; // Count as transaction in history
          completedTransactions++; // Received payments are "completed"
        } else {
          // This is an original loan - always show as "Money Lent"
          totalTransactions++;

          // Only count as completed if fully paid
          final status = data['status'] ?? '';
          final remainingAmount = (data['remainingAmount'] ?? data['amount'] ?? 0.0).toDouble();
          if (status == 'paid' || status == 'completed' || remainingAmount <= 0.01) {
            completedTransactions++;
          }
        }
      }

      // Process OwedTransactions (show BOTH loans AND payments)
      for (var doc in owedSnapshot.docs) {
        final data = doc.data();
        final type = (data['type'] as String?) ?? 'loan';

        if (type == 'repayment') {
          // This is a payment sent - always show in history
          totalTransactions++;
          completedTransactions++; // Sent payments are "completed"
        } else {
          // This is an original loan - show as "Borrowed Money"
          totalTransactions++;

          // Only count as completed if fully paid
          final status = data['status'] ?? '';
          final remainingAmount = (data['remainingAmount'] ?? data['amount'] ?? 0.0).toDouble();
          if (status == 'paid' || status == 'completed' || remainingAmount <= 0.01) {
            completedTransactions++;
          }
        }
      }

      return {
        'totalTransactions': totalTransactions,
        'completedTransactions': completedTransactions,
      };
    } catch (e) {
      print('❌ Error fetching activity stats: $e');
      return {
        'totalTransactions': 0,
        'completedTransactions': 0,
      };
    }
  }

  /// Helper to get full name from user data
  static String _getFullName(Map<String, dynamic> data) {
    final firstName = data['firstName'] ?? '';
    final lastName = data['lastName'] ?? '';

    if (firstName.isEmpty && lastName.isEmpty) return 'User';
    if (lastName.isEmpty) return firstName;
    if (firstName.isEmpty) return lastName;

    return '$firstName $lastName';
  }
}
