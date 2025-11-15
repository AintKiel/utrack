import 'package:flutter/material.dart';
import 'package:utrack/features/app_pages/home/creditSWidgets/whiteBG_credit.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../services/enhanced_credit_service.dart';
import 'circle_Credit.dart';

class CreditScoreScreen extends StatefulWidget {
  const CreditScoreScreen({super.key});

  @override
  State<CreditScoreScreen> createState() => _CreditScoreScreenState();
}

class _CreditScoreScreenState extends State<CreditScoreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  double? progress; // Will be updated from enhanced credit data
  String? creditTier;
  String? tierEmoji;
  
  late Stream<DocumentSnapshot> _userDataStream;

  @override
  void initState() {
    super.initState();
    _waveController =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    
    // Initialize Firestore stream for real-time data
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userDataStream = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .snapshots();
      
      // Initialize enhanced credit data and load credit score
      _initializeEnhancedCreditData(user.uid);
      _initializeCreditData(user.uid);
    }
  }
  
  /// Initialize enhanced credit data and load credit score
  Future<void> _initializeEnhancedCreditData(String userId) async {
    try {
      await EnhancedCreditService.initializeEnhancedCreditData(userId);
      
      // Load current credit score and tier
      final creditInfo = await EnhancedCreditService.getEnhancedCreditScore(userId);
      
      if (mounted) {
        setState(() {
          progress = (creditInfo['creditScore'] ?? 100.0) / 100.0; // Convert percentage to progress (0-1)
          creditTier = creditInfo['tier'] ?? 'Excellent';
          tierEmoji = creditInfo['tierEmoji'] ?? '🟢';
        });
      }
      
      // Process any overdue loans
      await EnhancedCreditService.processOverdueLoans();
      
    } catch (e) {
      print('❌ Error initializing enhanced credit data: $e');
    }
  }
  
  /// Initialize creditData field in Firestore if it doesn't exist
  Future<void> _initializeCreditData(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        
        // Check if creditData field exists
        if (!data.containsKey('creditData')) {
          // Add creditData with default values
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .update({
            'creditData': {
              'latePaymentsCount': 0,
              'borrowingsPerWeek': 0,
            }
          });
          print('✅ Credit data initialized for user: $userId');
        }
      }
    } catch (e) {
      print('❌ Error initializing credit data: $e');
    }
  }

  /// Build credit tier display card
  Widget _buildCreditTierCard() {
    Color tierColor;
    String tierDescription;
    
    switch (creditTier) {
      case 'Excellent':
        tierColor = Colors.green;
        tierDescription = 'Trusted borrower';
        break;
      case 'Good':
        tierColor = Colors.orange;
        tierDescription = 'Reliable, minor delays';
        break;
      case 'Fair':
        tierColor = Colors.amber;
        tierDescription = 'Often delayed';
        break;
      case 'Poor':
        tierColor = Colors.red;
        tierDescription = 'High risk borrower';
        break;
      default:
        tierColor = Colors.grey;
        tierDescription = 'Unknown status';
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tierColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: tierColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            tierEmoji ?? '🟢',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${creditTier ?? 'Excellent'} Tier',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: tierColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tierDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress ?? 1.0,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(tierColor),
                ),
                const SizedBox(height: 4),
                Text(
                  '${((progress ?? 1.0) * 100).toStringAsFixed(1)}% Credit Score',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ===== Blue Header with Circle =====
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: 305,
                  decoration: const BoxDecoration(
                    color: UColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Your credit score",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        UTexts.creditSubTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating circle overlapping - scrolls with content
                Positioned(
                  bottom: -80,
                  child: CircleCreditScore(
                    waveController: _waveController,
                    progress: progress ?? 1.0,
                  ),
                ),
              ],
            ),

            // ===== White body content (scrollable) =====
            const SizedBox(height: 100),
            
            // Credit Tier Display
            if (progress != null && creditTier != null && tierEmoji != null) ...[
              _buildCreditTierCard(),
              const SizedBox(height: 16),
            ],
            
            // Real-time data from Firestore
            StreamBuilder<DocumentSnapshot>(
              stream: _userDataStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final paymentStats = userData['paymentStats'] ?? {};
                final creditData = userData['creditData'] ?? {};

                // Extract real data
                double totalOwed = (paymentStats['totalOwed'] ?? 0.0).toDouble();
                int latePayments = (creditData['latePaymentsCount'] ?? 0) as int;
                // Use borrowerCount as borrowing frequency indicator
                int borrowerCount = (paymentStats['borrowerCount'] ?? 0) as int;
                
                // Get last updated timestamp
                DateTime? lastUpdated;
                if (paymentStats['lastUpdated'] != null) {
                  lastUpdated = (paymentStats['lastUpdated'] as Timestamp).toDate();
                }

                return WhiteCreditDetails(
                  latePaymentsCount: latePayments,
                  totalOutstandingDebts: totalOwed,
                  borrowingsPerWeek: borrowerCount, // Using borrowerCount as frequency
                  lastUpdated: lastUpdated,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ================= Wave Painter =================
class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final double progress;

  WavePainter({required this.animation, required this.progress})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final path = Path();
    final double waveHeight = 6;
    final double baseHeight = size.height * (1 - progress);

    for (double x = 0; x <= size.width; x++) {
      double y = math.sin(
          (x / size.width * 2 * math.pi) +
              (animation.value * 2 * math.pi)) *
          waveHeight +
          baseHeight;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
