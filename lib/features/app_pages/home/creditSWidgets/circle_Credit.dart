import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import 'creditS_screen.dart';

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
    return Positioned(
      top: 207,
      child: Container(
        height: 138,
        width: 138,
        decoration: const BoxDecoration(
            color: UColors.primary,
            shape: BoxShape.circle
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
                          fontWeight: FontWeight.bold
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