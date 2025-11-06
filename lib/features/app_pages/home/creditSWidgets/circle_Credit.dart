import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../utils/constants/colors.dart';

class CircleCreditScore extends StatelessWidget {
  const CircleCreditScore({
    super.key,
    required AnimationController waveController,
    required this.progress,
  }) : _waveController = waveController;

  final AnimationController _waveController;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        print('🎯 CIRCLE TAPPED!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credit circle tapped! 🎉'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      },
      onTapDown: (details) {
        print('👆 Tap down on circle at ${details.localPosition}');
      },
      onTapUp: (details) {
        print('👆 Tap up on circle at ${details.localPosition}');
      },
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          color: UColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(13),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 8),
          ),
          child: ClipOval(
            child: CustomPaint(
              painter: WavePainter(
                animation: _waveController,
                progress: progress,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Progress Today",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
              (x / size.width * 2 * math.pi) + (animation.value * 2 * math.pi)) *
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