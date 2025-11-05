import 'package:flutter/material.dart';

class BulletText extends StatelessWidget {
  final String text;
  const BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ",
              style:
              TextStyle(fontSize: 12, color: Colors.black54, height: 1.4)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 12, color: Colors.black87, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
