import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

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
        InkWell(
          onTap: () => _launchPhone('09123456789', context),
          child: const ListTile(dense: true, leading: Icon(Icons.phone, size: 20), title: Text('09123456789')),
        ),
        InkWell(
          onTap: () => _launchEmail('ana.garcia@email.com', context),
          child: const ListTile(dense: true, leading: Icon(Icons.email, size: 20), title: Text('ana.garcia@email.com')),
        ),
        InkWell(
          onTap: () => _launchMap('Manila, Philippines', context),
          child: const ListTile(dense: true, leading: Icon(Icons.location_on, size: 20), title: Text('Manila, Philippines')),
        ),
      ],
    );
  }
}
