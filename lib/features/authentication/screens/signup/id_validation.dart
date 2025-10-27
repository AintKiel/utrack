import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';
import 'package:utrack/features/authentication/screens/login/login.dart';
import 'package:utrack/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';

class IdValidationScreen extends StatefulWidget {
  const IdValidationScreen({super.key});

  @override
  State<IdValidationScreen> createState() => _IdValidationScreenState();
}

class _IdValidationScreenState extends State<IdValidationScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ⭐ CLOUDINARY CONFIG - Replace with your credentials
  static const String CLOUDINARY_CLOUD_NAME = 'div39ttay'; // e.g., 'dxyz123abc'
  static const String CLOUDINARY_UPLOAD_PRESET = 'Utrack'; // e.g., 'utrack_ids'

  File? _idImage;
  bool _isUploading = false;
  bool _isScanning = false;
  Map<String, dynamic>? _extractedData;
  double _matchPercentage = 0;
  bool _isVerified = false;

  /// Take picture using camera
  Future<void> _takePicture() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _idImage = File(photo.path);
          _extractedData = null;
          _isVerified = false;
        });

        Get.snackbar(
          'Success',
          'ID photo captured! Scanning...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Auto scan after capture
        await _scanIDPhoto();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take picture: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _idImage = File(photo.path);
          _extractedData = null;
          _isVerified = false;
        });

        Get.snackbar(
          'Success',
          'ID photo selected! Scanning...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Auto scan after selection
        await _scanIDPhoto();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Scan ID photo using ML Kit
  Future<void> _scanIDPhoto() async {
    if (_idImage == null) return;

    setState(() => _isScanning = true);

    try {
      final inputImage = InputImage.fromFile(_idImage!);
      final textRecognizer = TextRecognizer();

      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

      String extractedText = recognizedText.text.toUpperCase();
      print('📄 Extracted Text: $extractedText');

      // Get user data from Firestore
      User? user = _auth.currentUser;
      if (user == null) return;

      final userDoc =
      await _firestore.collection('Users').doc(user.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;

      String firstName = (userData['firstName'] ?? '').toString().toUpperCase();
      String lastName = (userData['lastName'] ?? '').toString().toUpperCase();
      String address = (userData['address'] ?? '').toString().toUpperCase();

      print('👤 Firestore Data: $firstName $lastName, $address');

      // Check matches
      int matchCount = 0;
      int totalChecks = 3;

      if (extractedText.contains(firstName)) {
        matchCount++;
        print('✅ First name matched');
      } else {
        print('❌ First name NOT matched');
      }

      if (extractedText.contains(lastName)) {
        matchCount++;
        print('✅ Last name matched');
      } else {
        print('❌ Last name NOT matched');
      }

      if (extractedText.contains(address.split(',')[0])) {
        matchCount++;
        print('✅ Address matched');
      } else {
        print('❌ Address NOT matched');
      }

      _matchPercentage = (matchCount / totalChecks) * 100;
      bool isMatch = _matchPercentage >= 66; // 2 out of 3 matches

      setState(() {
        _extractedData = {
          'firstName': firstName,
          'lastName': lastName,
          'address': address,
          'extractedText': extractedText,
          'matchCount': matchCount,
          'totalChecks': totalChecks,
        };
        _isVerified = isMatch;
      });

      print('📊 Match Percentage: $_matchPercentage%');

      if (isMatch) {
        Get.snackbar(
          'Success',
          'ID verified! Details matched with your profile.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Warning',
          'ID details do not match your profile. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }

      textRecognizer.close();
    } catch (e) {
      print('❌ Scanning error: $e');
      Get.snackbar(
        'Error',
        'Failed to scan ID: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    setState(() => _isScanning = false);
  }

  /// ⭐ Upload verified ID to Cloudinary - NEW VERSION
  Future<void> _uploadIDVerification() async {
    if (_idImage == null || !_isVerified) {
      Get.snackbar(
        'Error',
        'Please verify your ID first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() => _isUploading = false);
        Get.snackbar(
          'Error',
          'User not logged in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      print('🔵 Starting Cloudinary upload for user: ${user.uid}');

      // Initialize Cloudinary
      final cloudinary = CloudinaryPublic(
        CLOUDINARY_CLOUD_NAME,
        CLOUDINARY_UPLOAD_PRESET,
        cache: false,
      );

      print('📤 Uploading to Cloudinary...');

      // Upload image to Cloudinary
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          _idImage!.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'id_verification/${user.uid}',
          publicId: 'id_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );

      print('✅ Upload successful!');
      print('🔗 Cloudinary URL: ${response.secureUrl}');

      // Save verification data to Firestore
      print('💾 Saving to Firestore...');
      await _firestore.collection('Users').doc(user.uid).update({
        'idVerified': true,
        'idPhotoUrl': response.secureUrl, // Cloudinary URL
        'idVerificationDate': FieldValue.serverTimestamp(),
        'idVerificationStatus': 'approved',
        'matchPercentage': _matchPercentage,
        'extractedData': _extractedData,
        'cloudinaryPublicId': response.publicId, // Save for future deletion if needed
      });

      print('✅ Firestore updated successfully');

      setState(() => _isUploading = false);

      Get.snackbar(
        'Success',
        'ID Verification completed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to login after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAll(() => const LoginScreen());
      });
    } on CloudinaryException catch (e) {
      setState(() => _isUploading = false);
      print('❌ Cloudinary error: ${e.message}');
      Get.snackbar(
        'Error',
        'Upload failed: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      print('❌ Upload error: $e');
      Get.snackbar(
        'Error',
        'Failed to upload verification: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
            icon: const Icon(CupertinoIcons.clear),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Usizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dark ? Colors.grey[800] : Colors.grey[100],
                ),
                child: Icon(
                  Icons.verified_user,
                  size: 60,
                  color: dark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: Usizes.spaceBtwSections),

              // Title
              Text(
                'Verify your identity!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Usizes.spaceBtwItems),

              // Subtitle
              Text(
                'Congratulations, your email has now been verified. Please submit your valid ID to complete verification process.',
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Usizes.spaceBtwSections * 2),

              // Option 1 - Take Picture
              if (_idImage == null)
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: dark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dark ? Colors.grey[800] : Colors.grey[100],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 28,
                            color: dark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Take a picture of a valid ID',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'To check your personal information is correct',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 18),
                      ],
                    ),
                  ),
                ),
              if (_idImage == null) const SizedBox(height: Usizes.spaceBtwSections),

              // Option 2 - Upload Picture
              if (_idImage == null)
                GestureDetector(
                  onTap: _pickImageFromGallery,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: dark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dark ? Colors.grey[800] : Colors.grey[100],
                          ),
                          child: Icon(
                            Icons.image,
                            size: 28,
                            color: dark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload photo of valid ID',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Upload an existing ID photo from your gallery',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 18),
                      ],
                    ),
                  ),
                ),

              // Show selected image if any
              if (_idImage != null)
                Column(
                  children: [
                    // Scanning indicator
                    if (_isScanning)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Scanning ID...'),
                          ],
                        ),
                      )
                    else if (_extractedData != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isVerified
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isVerified ? Colors.green : Colors.orange,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isVerified ? Icons.check_circle : Icons.warning,
                                  color: _isVerified ? Colors.green : Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isVerified ? 'Verified ✓' : 'Not Verified',
                                  style: TextStyle(
                                    color: _isVerified ? Colors.green : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Match: ${_matchPercentage.toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_extractedData!['matchCount']}/${_extractedData!['totalChecks']} details matched',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(_idImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _idImage = null;
                              _extractedData = null;
                              _isVerified = false;
                            }),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Usizes.spaceBtwSections),
                    if (_isVerified)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _uploadIDVerification,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: _isUploading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                              : const Text('Verify Identity'),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: const Text('ID Details Do Not Match'),
                        ),
                      ),
                    const SizedBox(height: Usizes.spaceBtwItems),
                    TextButton(
                      onPressed: () => setState(() {
                        _idImage = null;
                        _extractedData = null;
                        _isVerified = false;
                      }),
                      child: const Text('Retake Photo'),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Why is this needed?'),
                            content: const Text(
                              'We verify your identity to:\n\n'
                                  '• Protect your account security\n'
                                  '• Prevent fraud\n'
                                  '• Comply with regulations\n'
                                  '• Ensure a safe community',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Understood'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'Why is this needed?',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(height: Usizes.spaceBtwItems),
                    TextButton(
                      onPressed: () => Get.offAll(() => const LoginScreen()),
                      child: const Text('Skip for now'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}