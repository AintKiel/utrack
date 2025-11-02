// 📁 CREATE NEW FILE: lib/services/qr_code_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// QR Code Service - Handle QR generation and storage
class QrCodeService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate unique QR data for user
  static String generateQrData(String userId, String userEmail) {
    // Format: utrack://user/{userId}?email={email}
    return 'utrack://user/$userId?email=$userEmail';
  }

  /// Create or update user QR code in Firebase
  static Future<void> createUserQrCode(String userId, String userEmail) async {
    try {
      final qrData = generateQrData(userId, userEmail);

      await _firestore.collection('Users').doc(userId).update({
        'qrCode': qrData,
        'qrCreatedAt': FieldValue.serverTimestamp(),
      });

      print('QR Code created for user: $userId');
    } catch (e) {
      print('Error creating QR code: $e');
      rethrow;
    }
  }

  /// Get user QR data
  static Future<String?> getUserQrCode(String userId) async {
    try {
      final doc = await _firestore.collection('Users').doc(userId).get();
      return doc.data()?['qrCode'] as String?;
    } catch (e) {
      print('Error fetching QR code: $e');
      return null;
    }
  }

  /// Get user details from QR scan (userId extraction)
  static Future<Map<String, dynamic>?> getUserFromQrCode(String qrData) async {
    try {
      // Parse: utrack://user/{userId}?email={email}
      final uri = Uri.parse(qrData);
      final userId = uri.pathSegments.isNotEmpty ? uri.pathSegments[1] : null;

      if (userId == null) return null;

      final userDoc = await _firestore.collection('Users').doc(userId).get();
      return userDoc.data();
    } catch (e) {
      print('Error fetching user from QR: $e');
      return null;
    }
  }
}