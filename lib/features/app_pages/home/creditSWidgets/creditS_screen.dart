import 'package:flutter/material.dart';
import 'package:utrack/features/app_pages/home/creditSWidgets/whiteBG_credit.dart';
import 'dart:math' as math;
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import 'circle_Credit.dart';

class CreditScoreScreen extends StatefulWidget {
  const CreditScoreScreen({super.key});

  @override
  State<CreditScoreScreen> createState() => _CreditScoreScreenState();
}

class _CreditScoreScreenState extends State<CreditScoreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  final double progress = 0.75; // 75%

  @override
  void initState() {
    super.initState();
    _waveController =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
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
            // ===== Blue Header =====
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
                  child: const Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Your credit score",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
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

                // Floating circle overlapping
                Positioned(
                  bottom: -65,
                  child: CircleCreditScore(
                    waveController: _waveController,
                    progress: progress,
                  ),
                ),
              ],
            ),

            // ===== White body content (scrollable) =====
            const SizedBox(height: 40),
            const WhiteCreditDetails(),
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
