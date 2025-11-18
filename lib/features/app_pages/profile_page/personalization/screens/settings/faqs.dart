import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/formatters/images.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchPhone(String phone) async {
  final Uri url = Uri(scheme: 'tel', path: phone);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}

void _launchEmail(String email) async {
  final Uri url = Uri(
    scheme: 'mailto',
    path: email,
  );
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23232E) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        title: Text(
          "Help Center",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 100),

            /// ----------------- CENTER LOGO -----------------
            Center(
              child: SizedBox(
                height: ULogoSizes.onBoardSize,
                child: Image.asset(
                  ULogos.helpCenter,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const Spacer(),

            /// ----------------- ACTION BUTTONS -----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  _HelpCircleButton(
                    icon: Icons.phone_rounded,
                    label: "Call us",
                    dark: isDark,
                    onTap: () => showCallSheet(context),
                  ),

                  _HelpCircleButton(
                    icon: Icons.mail_rounded,
                    label: "Email us",
                    dark: isDark,
                    onTap: () => showEmailSheet(context),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

/// Circle button widget
class _HelpCircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool dark;
  final VoidCallback onTap;

  const _HelpCircleButton({
    required this.icon,
    required this.label,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(80),
          onTap: onTap,
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF444450) : UColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: dark ? Colors.white : Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            color: dark ? Colors.white : Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

void showCallSheet(BuildContext context) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// CALL BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _launchPhone("098765");
                },
                child: const Text("Call 098765",),
              ),
            ),

            const SizedBox(height: 10),

            /// CANCEL BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF444450) : Colors.grey.shade300,
                  foregroundColor: isDark ? Colors.white :Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
      );
    },
  );
}


void showEmailSheet(BuildContext context) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// SEND EMAIL BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _launchEmail("utrack@gmail.com");
                },
                child: const Text("Send email to utrack@gmail.com"),
              ),
            ),

            const SizedBox(height: 10),

            /// CANCEL BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF444450) : Colors.grey.shade300,
                  foregroundColor: isDark ? Colors.white :Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
      );
    },
  );
}