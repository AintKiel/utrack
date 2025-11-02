import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:utrack/features/authentication/screens/signup/verify_email.dart';
import 'package:utrack/features/authentication/screens/login/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/signup/complete_profile_screen.dart';
import '../screens/signup/id_validation.dart';
import 'package:utrack/navigation_menu.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add this instance variable with your other Firebase instances
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Observable variables
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final isLoading = false.obs;
  final hidePassword = true.obs;

  // Store signup data temporarily until email is verified
  Map<String, String>? _pendingSignupData;
  String? _currentVerificationCode;

  // Store forgot password data temporarily
  Map<String, String>? _pendingForgotPasswordData;
  String? _currentForgotPasswordCode;

  // Brevo (Sendinblue) - Free API for sending emails
  static const String BREVO_API_KEY = "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";
  static const String BREVO_SENDER_EMAIL = "alcarazpaul4@gmail.com";

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  /// Set initial screen based on authentication state
  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      // User is logged in: enforce ID verification gate globally
      _firestore.collection('Users').doc(user.uid).get().then((doc) {
        final data = (doc.data() ?? {}) as Map<String, dynamic>;
        final bool verified = (data['idVerified'] ?? false) == true;
        if (!verified) {
          Get.offAll(() => const IdValidationScreen());
        } else {
          // User is verified, navigate to home
          Get.offAll(() => NavigationMenu());
        }
      }).catchError((_) {
        // If fetch fails, default to requiring verification for safety
        Get.offAll(() => const IdValidationScreen());
      });
    }
  }

  /// Generate random 6-digit code
  String _generateVerificationCode() {
    Random random = Random();
    int code = 100000 + random.nextInt(900000);
    return code.toString();
  }

  /// Send verification code via Brevo API (FREE)
  Future<bool> _sendVerificationCodeByEmail(
      String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.brevo.com/v3/smtp/email'),
        headers: {
          'accept': 'application/json',
          'api-key': BREVO_API_KEY,
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'sender': {
            'name': 'UTrack',
            'email': BREVO_SENDER_EMAIL,
          },
          'to': [
            {
              'email': email,
            }
          ],
          'subject': 'Your UTrack Email Verification Code',
          'htmlContent': '''
            <html>
              <body style="font-family: Arial, sans-serif; padding: 20px;">
                <h2 style="color: #0066CC;">Email Verification</h2>
                <p>Hello,</p>
                <p>Your verification code is:</p>
                <div style="background-color: #f0f0f0; padding: 20px; border-radius: 8px; text-align: center; margin: 20px 0;">
                  <h1 style="color: #0066CC; font-size: 36px; letter-spacing: 8px; margin: 0;">
                    $code
                  </h1>
                </div>
                <p><strong>This code will expire in 10 minutes.</strong></p>
                <p>If you didn't request this code, please ignore this email.</p>
                <hr>
                <p>Best regards,<br><strong>UTrack Team</strong></p>
              </body>
            </html>
          ''',
        }),
      );

      if (response.statusCode == 201) {
        print('✅ Email sent successfully to: $email');
        return true;
      } else {
        print('❌ Failed to send email');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending email: $e');
      return false;
    }
  }

  /// Prepare signup - Store data WITHOUT creating Firebase account yet
  Future<void> prepareSignUpWithEmailAndPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
    required String address,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Check if email already exists in Firestore Users collection
      final existingUserSnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (existingUserSnapshot.docs.isNotEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'This email is already registered. Please use a different email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Generate 6-digit verification code
      _currentVerificationCode = _generateVerificationCode();

      // Store signup data temporarily (account will be created after email verification)
      _pendingSignupData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNo': phoneNo,
        'address': address,
        'password': password,
      };

      // Save verification code to Firestore temporarily
      await _firestore.collection('VerificationCodes').doc(email).set({
        'code': _currentVerificationCode,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': DateTime.now().add(Duration(minutes: 10)),
      });

      // Send verification code via email
      bool emailSent =
      await _sendVerificationCodeByEmail(email, _currentVerificationCode!);

      isLoading.value = false;

      if (emailSent) {
        Get.snackbar(
          'Success',
          'Verification code sent to your email!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate to email verification screen
        Get.to(() => const VerifyEmailScreen());
      } else {
        Get.snackbar(
          'Warning',
          'Email sending failed. Check console for code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Print code for testing
        print('🔐 VERIFICATION CODE (for testing): $_currentVerificationCode');

        Get.to(() => const VerifyEmailScreen());
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Verify the 6-digit code entered by user (signup)
  Future<bool> verifyCodeFromUser(String userCode) async {
    try {
      if (_currentVerificationCode == null) {
        Get.snackbar(
          'Error',
          'No verification code found. Please sign up again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Check if code matches
      if (userCode == _currentVerificationCode) {
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Invalid verification code. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Verification failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  /// Save pending user data after email verification - NOW CREATE FIREBASE ACCOUNT
  Future<void> savePendingUserDataAfterVerification() async {
    try {
      if (_pendingSignupData != null) {
        String email = _pendingSignupData!['email']!;
        String password = _pendingSignupData!['password']!;

        // NOW create Firebase account after email is verified
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String uid = userCredential.user!.uid;

        // Update user display name
        await userCredential.user?.updateDisplayName(
          '${_pendingSignupData!['firstName']} ${_pendingSignupData!['lastName']}',
        );

        // Save user data to Firestore
        await _saveUserDataToFirestore(
          uid: uid,
          firstName: _pendingSignupData!['firstName']!,
          lastName: _pendingSignupData!['lastName']!,
          email: email,
          phoneNo: _pendingSignupData!['phoneNo']!,
          address: _pendingSignupData!['address']!,
        );

        // Clear the pending data
        _pendingSignupData = null;
        _currentVerificationCode = null;

        // Delete verification code from Firestore
        await _firestore
            .collection('VerificationCodes')
            .doc(email)
            .delete()
            .catchError((_) {
          // Ignore if already deleted
        });

        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create account: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Save user data to Firestore
  /// Save user data to Firestore WITH QR CODE GENERATION
  Future<void> _saveUserDataToFirestore({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
    required String address,
  }) async {
    try {
      String qrData = 'utrack://user/$uid?email=$email';

      await _firestore.collection('Users').doc(uid).set({
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNo,
        'address': address,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'emailVerified': true,
        'qrCode': 'utrack://user/$uid?email=$email',
        'qrCreatedAt': FieldValue.serverTimestamp(),
        // ADD THESE LINES:
        'paymentStats': {
          'totalLent': 0.0,
          'totalOwed': 0.0,
          'lenderCount': 0,
          'borrowerCount': 0,
          'lastUpdated': FieldValue.serverTimestamp(),
        }
      });

      print('✅ User created with QR code: $qrData');
    } catch (e) {
      print('Error saving user data to Firestore: $e');
      throw e;
    }
  }

  /// Resend verification code (signup)
  Future<void> resendVerificationCode() async {
    try {
      if (_pendingSignupData != null) {
        String email = _pendingSignupData!['email']!;

        // Generate new code
        _currentVerificationCode = _generateVerificationCode();

        // Update code in Firestore
        await _firestore.collection('VerificationCodes').doc(email).update({
          'code': _currentVerificationCode,
          'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': DateTime.now().add(Duration(minutes: 10)),
        });

        // Send new code via email
        await _sendVerificationCodeByEmail(email, _currentVerificationCode!);

        Get.snackbar(
          'Success',
          'Verification code sent again to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend code: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Send password reset code via email
  Future<bool> sendPasswordResetCode({required String email}) async {
    try {
      isLoading.value = true;

      // Check if email exists in Firestore
      final userSnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'No account found with this email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false; // Return false - don't proceed
      }

      // Generate 6-digit code
      _currentForgotPasswordCode = _generateVerificationCode();

      // Store email for later use
      _pendingForgotPasswordData = {
        'email': email,
      };

      // Save reset code to Firestore temporarily
      await _firestore.collection('PasswordResetCodes').doc(email).set({
        'code': _currentForgotPasswordCode,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': DateTime.now().add(Duration(minutes: 10)),
      });

      // Send code via email
      bool emailSent = await _sendVerificationCodeByEmail(
        email,
        _currentForgotPasswordCode!,
      );

      isLoading.value = false;

      if (emailSent) {
        Get.snackbar(
          'Success',
          'Reset code sent to your email!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return true; // Return true - proceed
      } else {
        Get.snackbar(
          'Warning',
          'Email sending failed. Check console for code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        print('🔐 PASSWORD RESET CODE (for testing): $_currentForgotPasswordCode');
        return true; // Still proceed even if email failed
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Return false - don't proceed
    }
  }

  /// Verify password reset code (from email verification screen)
  Future<bool> verifyPasswordResetCode(String userCode) async {
    try {
      if (_currentForgotPasswordCode == null) {
        Get.snackbar(
          'Error',
          'No reset code found. Please request a new one.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      if (userCode == _currentForgotPasswordCode) {
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Invalid reset code. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Verification failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  /// After email verification, send Firebase password reset email
  /// Then go straight to login page
  Future<void> sendPasswordResetEmailAfterVerification() async {
    try {
      isLoading.value = true;

      if (_pendingForgotPasswordData == null) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Session expired. Please request a new reset code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String email = _pendingForgotPasswordData!['email']!;

      // Verify user exists in Firestore
      final userSnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'User not found.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      try {
        print('📧 Sending Firebase password reset email to $email');

        // Send Firebase password reset email
        await _auth.sendPasswordResetEmail(email: email);

        print('✅ Firebase password reset email sent successfully!');

        // Clear the reset data
        _pendingForgotPasswordData = null;
        _currentForgotPasswordCode = null;

        // Delete reset code from Firestore
        await _firestore
            .collection('PasswordResetCodes')
            .doc(email)
            .delete()
            .catchError((_) {});

        isLoading.value = false;

        Get.snackbar(
          'Success',
          'Password reset link sent to your email. Click the link to set your new password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );

        // Navigate to login page after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const LoginScreen());
        });
      } catch (e) {
        isLoading.value = false;
        print('❌ Error sending password reset email: $e');
        Get.snackbar(
          'Error',
          'Failed to send reset email: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      print('❌ Error: $e');
      Get.snackbar(
        'Error',
        'Failed to process password reset: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Resend password reset code
  Future<void> resendPasswordResetCode() async {
    try {
      if (_pendingForgotPasswordData != null) {
        String email = _pendingForgotPasswordData!['email']!;

        // Generate new code
        _currentForgotPasswordCode = _generateVerificationCode();

        // Update code in Firestore
        await _firestore.collection('PasswordResetCodes').doc(email).update({
          'code': _currentForgotPasswordCode,
          'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': DateTime.now().add(Duration(minutes: 10)),
        });

        // Send new code via email
        await _sendVerificationCodeByEmail(email, _currentForgotPasswordCode!);

        Get.snackbar(
          'Success',
          'Reset code sent again to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend code: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  /// Updated signInWithGoogle() method
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      print('🔵 Starting Google Sign-In...');

      // Sign out first to show account picker
      await _googleSignIn.signOut();

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        print('⚠️ User cancelled Google Sign-In');
        return;
      }

      print('✅ Google user signed in: ${googleUser.email}');

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔐 Creating Firebase credential...');

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        print('✅ Firebase Sign-In successful: ${user.email}');

        // Check if user exists in Firestore
        final userSnapshot = await _firestore
            .collection('Users')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        bool isNewUser = userSnapshot.docs.isEmpty;

        if (isNewUser) {
          // New user - save to Firestore with basic info
          print('👤 New user detected, saving to Firestore...');

          await _firestore.collection('Users').doc(user.uid).set({
            'uid': user.uid,
            'firstName': user.displayName?.split(' ')[0] ?? 'User',
            'lastName': user.displayName?.split(' ').skip(1).join(' ') ?? '',
            'email': user.email,
            'phoneNumber': 'Not set',
            'address': 'Not set',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'emailVerified': true,
            'signInMethod': 'google',
            // ADD THESE LINES:
            'paymentStats': {
              'totalLent': 0.0,
              'totalOwed': 0.0,
              'lenderCount': 0,
              'borrowerCount': 0,
              'lastUpdated': FieldValue.serverTimestamp(),
            }
          });

          print('✅ New Google user saved to Firestore');
        }else {
          // Existing user - update last login
          print('👤 Existing user, updating login time...');

          await _firestore
              .collection('Users')
              .doc(user.uid)
              .update({
            'updatedAt': FieldValue.serverTimestamp(),
          }).catchError((e) {
            print('⚠️ Error updating user: $e');
          });

          print('✅ Existing user updated');
        }

        isLoading.value = false;

        if (isNewUser) {
          // Show profile completion screen for new users
          Get.snackbar(
            'Welcome!',
            'Please complete your profile',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          // Navigate to profile completion screen
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAll(() => CompleteProfileScreen(
              userId: user.uid,
              email: user.email ?? '',
              firstName: user.displayName?.split(' ')[0] ?? 'User',
              lastName: user.displayName?.split(' ').skip(1).join(' ') ?? '',
            ));
          });
        } else {
          // Existing user - require ID verification if not verified
          final doc = await _firestore.collection('Users').doc(user.uid).get();
          final data = (doc.data() ?? {}) as Map<String, dynamic>;
          final bool verified = (data['idVerified'] ?? false) == true;
          if (!verified) {
            Get.snackbar(
              'Action required',
              'Please verify your ID to continue',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
            Future.delayed(const Duration(milliseconds: 400), () {
              Get.offAll(() => const IdValidationScreen());
            });
          } else {
            Get.snackbar(
              'Success',
              'Logged in with Google!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        }

        print('✅ Google Sign-In complete!');
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      _handleAuthException(e);
    } catch (e) {
      isLoading.value = false;
      print('❌ Google Sign-In Error: $e');
      Get.snackbar(
        'Error',
        'Google Sign-In failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Google Sign-Out
  Future<void> googleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print('✅ Google Sign-Out successful');
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      print('❌ Error signing out: $e');
      Get.snackbar(
        'Error',
        'Sign out failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  /// Simple login
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user exists in Firestore
      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('Users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final bool verified = (userData['idVerified'] ?? false) == true;

          isLoading.value = false;

          Get.snackbar(
            'Success',
            'Login successful!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Navigate based on ID verification status
          if (!verified) {
            // User needs to verify ID
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.offAll(() => const IdValidationScreen());
            });
          } else {
            // User is fully verified, go to home
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.offAll(() => NavigationMenu());
            });
          }
        } else {
          isLoading.value = false;
          Get.snackbar(
            'Error',
            'User profile not found. Please contact support.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      _handleAuthException(e);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  /// Update password after code verification
  /// Just delete the old account and create new one with new password
  Future<void> updatePasswordDirectly({
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;

      if (_pendingForgotPasswordData == null) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Session expired. Please request a new reset code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String email = _pendingForgotPasswordData!['email']!;

      // Get the user from Firestore
      final userSnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'User not found.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String uid = userSnapshot.docs.first.id;
      final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      try {
        // Step 1: Delete the old Firebase Auth account
        // First, we need to sign in with old password to get auth context
        // But we don't have the old password...

        // BETTER APPROACH: Use Firebase's sendPasswordResetEmail
        // and tell user to click the link to set new password
        await _auth.sendPasswordResetEmail(email: email);

        print('✅ Password reset email sent to $email');

        // Clear the reset data
        _pendingForgotPasswordData = null;
        _currentForgotPasswordCode = null;

        // Delete reset code from Firestore
        await _firestore
            .collection('PasswordResetCodes')
            .doc(email)
            .delete()
            .catchError((_) {});

        isLoading.value = false;

        Get.snackbar(
          'Success',
          'Password reset email sent to your inbox. Click the link to set your new password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );

        // Navigate to login after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const LoginScreen());
        });
      } catch (e) {
        isLoading.value = false;
        print('❌ Error: $e');
        Get.snackbar(
          'Error',
          'Failed to send reset email: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      print('❌ Error in updatePasswordDirectly: $e');
      Get.snackbar(
        'Error',
        'Failed to update password: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  /// Update password after code verification
  Future<void> updatePasswordAfterCodeVerification({
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;

      if (_pendingForgotPasswordData == null) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Session expired. Please request a new reset code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String email = _pendingForgotPasswordData!['email']!;

      try {
        // Use Firebase's sendPasswordResetEmail to generate a reset link
        // Then update password via that link
        // But since we want direct update, we use a different approach:

        // Create a temporary user credential using email and a temporary password
        // Then update to the new password

        // Actually, the best approach: send password reset link via Firebase
        await _auth.sendPasswordResetEmail(email: email);

        // Clear the reset data
        _pendingForgotPasswordData = null;
        _currentForgotPasswordCode = null;

        // Delete reset code from Firestore
        await _firestore
            .collection('PasswordResetCodes')
            .doc(email)
            .delete()
            .catchError((_) {});

        isLoading.value = false;

        Get.snackbar(
          'Success',
          'Password reset link sent to your email! Click the link to set your new password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate to login
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const LoginScreen());
        });
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        _handleAuthException(e);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to update password: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Send password reset email (old method - you can remove this)
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      isLoading.value = true;

      await _auth.sendPasswordResetEmail(email: email);

      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Password reset email sent. Check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      _handleAuthException(e);
    }
  }

  /// Sign out / Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message ?? 'Failed to sign out');
    }
  }

  /// Logout (alias for signOut)
  Future<void> logout() async {
    await signOut();
  }

  /// Get current user data from Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
        await _firestore.collection('Users').doc(user.uid).get();

        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        } else {
          return {
            'uid': user.uid,
            'email': user.email,
            'firstName': user.displayName?.split(' ')[0] ?? 'N/A',
            'lastName': user.displayName?.split(' ').skip(1).join(' ') ?? 'N/A',
            'username': user.displayName ?? 'N/A',
            'phoneNumber': user.phoneNumber ?? 'Not set',
          };
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      Get.snackbar('Error', 'Failed to fetch user data');
      return null;
    }
  }

  /// Update user data in Firestore
  Future<void> updateUserData({
    required String firstName,
    required String lastName,
    required String phoneNo,
    required String address,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('Users').doc(user.uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNo,
          'address': address,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Handle Firebase Auth exceptions
  void _handleAuthException(FirebaseAuthException e) {
    String message = 'An error occurred';

    switch (e.code) {
      case 'weak-password':
        message = 'Password is too weak. Use 6+ characters with letters & numbers.';
        break;
      case 'email-already-in-use':
        message = 'This email is already registered.';
        break;
      case 'invalid-email':
        message = 'Invalid email format.';
        break;
      case 'user-not-found':
        message = 'No account found with this email.';
        break;
      case 'wrong-password':
        message = 'Incorrect password.';
        break;
      case 'too-many-requests':
        message = 'Too many failed attempts. Try again later.';
        break;
      default:
        message = e.message ?? 'Authentication failed';
    }

    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }
}