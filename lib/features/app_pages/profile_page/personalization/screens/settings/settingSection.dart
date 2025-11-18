import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class SettingsListCard extends StatelessWidget {
  final VoidCallback onNotifications;
  final VoidCallback onPrivacy;
  final VoidCallback onHelp;
  final VoidCallback onTerms;

  const SettingsListCard({
    super.key,
    required this.onNotifications,
    required this.onPrivacy,
    required this.onHelp,
    required this.onTerms,
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
            "Settings",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
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
                _buildItem(
                  icon: Icons.notifications_active_outlined,
                  title: "Notifications",
                  subtitle: "Manage alerts and notifications",
                  onTap: onNotifications,
                ),

                const Divider(height: 0),

                _buildItem(
                  icon: Icons.lock_outline,
                  title: "Passwords",
                  subtitle: "Change your password",
                  onTap: onPrivacy,
                ),

                const Divider(height: 0),

                _buildItem(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  subtitle: "FAQs and contact support",
                  onTap: onHelp,
                ),

                const Divider(height: 0),

                _buildItem(
                  icon: Icons.description_outlined,
                  title: "Terms & Conditions",
                  subtitle: "Legal agreements",
                  onTap: onTerms,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable ListTile builder (GCash style)
  Widget _buildItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: UColors.primary),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}