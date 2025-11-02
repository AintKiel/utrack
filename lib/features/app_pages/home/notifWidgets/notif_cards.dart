import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';

class NotificationCard extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final IconData icon;
  final String title;
  final String message;
  final String subtitle;
  final String time;
  final String buttonLabel;
  final Color buttonColor;

  const NotificationCard({
    super.key,
    required this.color,
    required this.borderColor,
    required this.icon,
    required this.title,
    required this.message,
    required this.subtitle,
    required this.time,
    required this.buttonLabel,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // smaller padding
      decoration: BoxDecoration(
        color: UColors.white,
        border: Border.all(color: borderColor.withOpacity(0.3), width: 0.8),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- Title Row ---
          Row(
            children: [
              Icon(icon, color: borderColor, size: 20), // slightly smaller icon
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // slightly smaller
                  ),
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            message,
            style: TextStyle(color: Colors.grey[800], fontSize: 13, height: 1.2),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),

          /// --- Bottom Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11.5,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // removes extra height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  buttonLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}