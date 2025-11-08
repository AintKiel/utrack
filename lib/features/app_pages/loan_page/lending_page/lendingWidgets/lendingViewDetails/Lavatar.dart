import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: UColors.primary.withOpacity(0.15),
          child: const Text('AG', style: TextStyle(fontWeight: FontWeight.bold, color: UColors.primary, fontSize: 22)),
        ),
        const SizedBox(height: 10),
        const Text('Ana Garcia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
