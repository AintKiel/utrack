import 'package:flutter/material.dart';

class UCreditScore extends StatelessWidget {
  const UCreditScore({
    super.key,
    required this.creditScore,
  });

  final double creditScore;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -40,
      right: -30,
      child: GestureDetector(
        onTap: () {
          // Handle onTap for credit score
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular score indicator
            SizedBox(
              width: 120, // 👈 slightly smaller to balance avatar
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: creditScore / 100,
                    strokeWidth: 5,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      creditScore >= 80
                          ? Colors.lightGreenAccent
                          : creditScore >= 60
                          ? Colors.yellowAccent
                          : Colors.redAccent,
                    ),
                  ),
                  Text(
                    "${creditScore.toInt()}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // 👇 Pull label closer using Transform
            Transform.translate(
              offset: const Offset(0, -37), // move upward by 6px (adjust as needed)
              child: const Text(
                "Credit Score",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}