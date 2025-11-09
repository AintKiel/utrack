import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfo extends StatelessWidget {
  final String email;
  final String phone;
  final String address;

  const ContactInfo({
    super.key,
    required this.email,
    required this.phone,
    required this.address,
  });

  Future<void> _launchPhone(String phone, BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open dialer')));
    }
  }

  Future<void> _launchEmail(String email, BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open email client')));
    }
  }

  Future<void> _launchMap(String address, BuildContext context) async {
    final encoded = Uri.encodeComponent(address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open maps')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (phone.isNotEmpty)
          InkWell(
            onTap: () => _launchPhone(phone, context),
            child: ListTile(dense: true, leading: const Icon(Icons.phone, size: 20), title: Text(phone)),
          ),
        if (email.isNotEmpty)
          InkWell(
            onTap: () => _launchEmail(email, context),
            child: ListTile(dense: true, leading: const Icon(Icons.email, size: 20), title: Text(email)),
          ),
        if (address.isNotEmpty)
          InkWell(
            onTap: () => _launchMap(address, context),
            child: ListTile(dense: true, leading: const Icon(Icons.location_on, size: 20), title: Text(address)),
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