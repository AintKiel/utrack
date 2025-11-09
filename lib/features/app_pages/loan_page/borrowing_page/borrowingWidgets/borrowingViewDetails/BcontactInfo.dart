import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LenderContactInfo extends StatelessWidget {
  final String email;
  final String phone;
  final String address;

  const LenderContactInfo({
    super.key,
    required this.email,
    required this.phone,
    required this.address,
  });

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
        if (phone.isNotEmpty)
          ListTile(
            dense: true,
            leading: const Icon(Icons.phone, size: 20),
            title: Text(phone),
            onTap: () => _launchPhone(context, phone),
          ),
        if (email.isNotEmpty)
          ListTile(
            dense: true,
            leading: const Icon(Icons.email, size: 20),
            title: Text(email),
            onTap: () => _launchEmail(context, email),
          ),
        if (address.isNotEmpty)
          ListTile(
            dense: true,
            leading: const Icon(Icons.location_on, size: 20),
            title: Text(address),
            onTap: () => _launchMap(context, address),
          ),
        if (phone.isEmpty && email.isEmpty && address.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No contact information available', style: TextStyle(color: Colors.grey)),
          ),
      ],
    );
  }
}