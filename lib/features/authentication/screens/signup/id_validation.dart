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
import 'package:utrack/navigation_menu.dart';

class IdValidationScreen extends StatefulWidget {
  const IdValidationScreen({super.key});

  @override
  State<IdValidationScreen> createState() => _IdValidationScreenState();
}

class _IdValidationScreenState extends State<IdValidationScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ⭐ CLOUDINARY CONFIG
  static const String CLOUDINARY_CLOUD_NAME = 'div39ttay';
  static const String CLOUDINARY_UPLOAD_PRESET = 'Utrack';

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
          _matchPercentage = 0;
        });

        Get.snackbar(
          'Success',
          'ID photo captured!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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
          _matchPercentage = 0;
        });

        Get.snackbar(
          'Success',
          'ID photo selected!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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

  /// Scan ID photo using Google ML Kit and compare to user profile
  Future<void> _scanIDPhoto() async {
    if (_idImage == null) {
      Get.snackbar(
        'Error',
        'Please add an ID photo first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isScanning = true;
      _isVerified = false;
      _matchPercentage = 0;
    });

    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        setState(() => _isScanning = false);
        Get.snackbar(
          'Error',
          'User not logged in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Fetch expected values from Firestore
      final doc = await _firestore.collection('Users').doc(user.uid).get();
      if (!doc.exists) {
        setState(() => _isScanning = false);
        Get.snackbar(
          'Error',
          'User profile not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final data = (doc.data() ?? {}) as Map<String, dynamic>;
      final String expectedFirst = (data['firstName'] ?? '').toString();
      final String expectedLast = (data['lastName'] ?? '').toString();
      final String expectedAddress = (data['address'] ?? '').toString();

      // Run text recognition
      final inputImage = InputImage.fromFilePath(_idImage!.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      final String allText = _normalize(recognizedText.text);

      bool firstOk = _matchNameStrict(allText, expectedFirst);
      bool lastOk = _matchNameStrict(allText, expectedLast);
      bool addressOk = _addressMatches(allText, expectedAddress);

      // Names must both pass. Address is supportive only.
      int matched = (firstOk ? 1 : 0) + (lastOk ? 1 : 0) + (addressOk ? 1 : 0);
      double percent = matched / 3.0 * 100.0;

      setState(() {
        _extractedData = {
          'rawText': recognizedText.text,
          'matches': {
            'firstName': firstOk,
            'lastName': lastOk,
            'address': addressOk,
          },
        };
        _matchPercentage = percent;
        _isVerified = firstOk && lastOk; // require BOTH names to pass
        _isScanning = false;
      });

      if (_isVerified) {
        Get.snackbar(
          'Matched',
          'ID matches your profile (${percent.toStringAsFixed(0)}%). You can submit now.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Not matched',
          'We could not verify your ID. Please retake or upload a different ID.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      setState(() => _isScanning = false);
      Get.snackbar(
        'Error',
        'Scanning failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _normalize(String input) {
    final lower = input.toLowerCase();
    // Remove accents by decomposing (best-effort) and stripping non-ascii
    final noMarks = lower
        .replaceAll(RegExp(r'[\u0300-\u036f]'), '')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    return noMarks.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  List<String> _tokenize(String input) {
    return input.split(RegExp(r'[^a-z0-9]+')).where((t) => t.isNotEmpty).toList();
  }

  bool _matchNameStrict(String haystackNormalized, String expectedRaw) {
    if (expectedRaw.trim().isEmpty) return false;
    final hayTokens = _tokenize(haystackNormalized);
    final expectedTokens = _tokenize(_normalize(expectedRaw))
        .where((t) => t.length >= 3)
        .toList();
    if (expectedTokens.isEmpty) return false;

    // Every expected token must be present as a whole word or within edit distance 1
    for (final token in expectedTokens) {
      bool found = false;
      for (final hay in hayTokens) {
        if (hay == token || _levenshteinAtMostOne(hay, token)) {
          found = true;
          break;
        }
      }
      if (!found) return false;
    }
    return true;
  }

  bool _addressMatches(String haystackLower, String addressRaw) {
    final addr = _normalize(addressRaw);
    if (addr.isEmpty) return false;
    // Use key parts of address: numbers and words >= 4 chars
    final parts = addr
        .split(RegExp(r'[^a-z0-9]+'))
        .where((p) => p.length >= 4 || RegExp(r'^[0-9]{2,}$').hasMatch(p))
        .toList();
    if (parts.isEmpty) return haystackLower.contains(addr);
    int hits = 0;
    for (final p in parts.take(6)) {
      if (haystackLower.contains(p)) hits++;
    }
    return hits >= 2; // require at least 2 key parts present
  }

  bool _levenshteinAtMostOne(String a, String b) {
    if ((a.length - b.length).abs() > 1) return false;
    if (a == b) return true;
    // Ensure a is shorter or equal
    if (a.length > b.length) {
      final tmp = a; a = b; b = tmp;
    }
    int i = 0, j = 0, edits = 0;
    while (i < a.length && j < b.length) {
      if (a[i] == b[j]) {
        i++; j++;
      } else {
        edits++;
        if (edits > 1) return false;
        if (a.length == b.length) {
          i++; j++; // substitution
        } else {
          j++; // insertion in longer string
        }
      }
    }
    // Tail difference
    if (j < b.length || i < a.length) edits++;
    return edits <= 1;
  }

  /// Upload verified ID to Cloudinary
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

      final cloudinary = CloudinaryPublic(
        CLOUDINARY_CLOUD_NAME,
        CLOUDINARY_UPLOAD_PRESET,
        cache: false,
      );

      print('📤 Uploading to Cloudinary...');

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

      print('💾 Saving to Firestore...');
      await _firestore.collection('Users').doc(user.uid).update({
        'idVerified': true,
        'idPhotoUrl': response.secureUrl,
        'idVerificationDate': FieldValue.serverTimestamp(),
        'idVerificationStatus': 'approved',
        'cloudinaryPublicId': response.publicId,
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

      Future.delayed(const Duration(seconds: 2), () {
        Get.offAll(() => NavigationMenu());
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

              Text(
                'Verify your identity!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: dark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Usizes.spaceBtwItems),

              Text(
                'Congratulations, your email has now been verified. Please submit your valid ID to complete verification process.',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: dark ? Colors.grey[300] : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Usizes.spaceBtwSections * 2),

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
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'To verify your identity',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: dark ? Colors.grey[300] : Colors.black54,
                                ),
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
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Upload from your gallery',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: dark ? Colors.grey[300] : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 18),
                      ],
                    ),
                  ),
                ),

              if (_idImage != null)
                Column(
                  children: [
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
                    if (!_isVerified)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isScanning ? null : _scanIDPhoto,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: _isScanning
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Scan ID'),
                        ),
                      ),
                    if (_isVerified) const SizedBox(height: Usizes.spaceBtwItems),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Submit Verification'),
                        ),
                      ),
                    if (_idImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _isVerified
                              ? 'Match: ${_matchPercentage.toStringAsFixed(0)}%'
                              : (_isScanning ? 'Scanning...' : 'Please scan your ID'),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: dark ? Colors.grey[300] : Colors.black87,
                          ),
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