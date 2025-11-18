import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class ContactInfoCard extends StatelessWidget {
  final String email;
  final String phone;
  final String address;

  const ContactInfoCard({
    super.key,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          Text(
            "Contact Information",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          _buildContactBox(context),
        ],
      ),
    );
  }

  Widget _buildContactBox(context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: dark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          _contactItem(Icons.email_outlined, email),
          const SizedBox(height: 16),
          _contactItem(Icons.phone_outlined, phone),
          const SizedBox(height: 16),
          _contactItem(Icons.location_on_outlined, address),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: UColors.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}