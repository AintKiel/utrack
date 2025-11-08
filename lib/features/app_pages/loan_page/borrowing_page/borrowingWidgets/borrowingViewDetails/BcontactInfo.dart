import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LenderContactInfo extends StatelessWidget {
  const LenderContactInfo({super.key});

  void _showCannotOpenSnack(BuildContext context, String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open $what.')),
    );
  }

  Future<void> _launchPhone(BuildContext context, String phone) async {
    try {
      final uri = Uri(scheme: 'tel', path: phone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showCannotOpenSnack(context, 'dialer');
      }
    } catch (e) {
      _showCannotOpenSnack(context, 'dialer');
    }
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    try {
      final uri = Uri(scheme: 'mailto', path: email);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showCannotOpenSnack(context, 'email client');
      }
    } catch (e) {
      _showCannotOpenSnack(context, 'email client');
    }
  }

  Future<void> _launchMap(BuildContext context, String address) async {
    try {
      final encoded = Uri.encodeComponent(address);
      final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showCannotOpenSnack(context, 'maps');
      }
    } catch (e) {
      _showCannotOpenSnack(context, 'maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: const Icon(Icons.phone, size: 20),
          title: const Text('09123456789'),
          onTap: () => _launchPhone(context, '09123456789'),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.email, size: 20),
          title: const Text('ana.garcia@email.com'),
          onTap: () => _launchEmail(context, 'ana.garcia@email.com'),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.location_on, size: 20),
          title: const Text('Manila, Philippines'),
          onTap: () => _launchMap(context, 'Manila, Philippines'),
        ),
      ],
    );
  }
}
