import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final Color? color;
  final Color borderColor;
  final IconData icon;
  final String title;
  final Widget message;
  final Widget subtitle;
  final String time;
  final String? buttonLabel;
  final Color? buttonColor;
  final VoidCallback? onDelete;
  final VoidCallback? onButtonPressed;

  const NotificationCard({
    super.key,
    this.color,
    required this.borderColor,
    required this.icon,
    required this.title,
    required this.message,
    required this.subtitle,
    required this.time,
    this.buttonLabel,
    this.buttonColor,
    this.onDelete,
    this.onButtonPressed,
  });

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Notification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onDelete != null) onDelete!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header with delete icon ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: borderColor, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                onPressed: () => _showDeleteConfirmationDialog(context),
                tooltip: 'Remove notification',
              ),
            ],
          ),
          const SizedBox(height: 2),

          // --- Message ---
          DefaultTextStyle(
            style: TextStyle(color: Colors.grey[800], fontSize: 13, height: 1.2),
            child: message,
          ),
          const SizedBox(height: 6),

          // --- Subtitle ---
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            child: subtitle,
          ),
          const SizedBox(height: 6),

          // --- Footer ---
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
              if (buttonLabel != null && buttonColor != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onButtonPressed,
                  child: Text(
                    buttonLabel!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (onDelete != null && (buttonLabel == null || buttonColor == null))
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Colors.grey[600],
                ),
            ],
          ),
        ],
      ),
    );
  }
}