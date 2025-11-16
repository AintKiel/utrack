import 'dart:convert';

import 'package:http/http.dart' as http;

class PayMongoLink {
  final String id;
  final String checkoutUrl;

  const PayMongoLink({
    required this.id,
    required this.checkoutUrl,
  });
}

class PayMongoService {
  static const String _baseUrl = 'https://api.paymongo.com/v1/links';
  static const String _defaultTestKey = 'sk_test_iPMMyqzCWCjikF6fcXRzNzBg';
  static const String _secretKey = String.fromEnvironment(
    'PAYMONGO_SECRET_KEY',
    defaultValue: _defaultTestKey,
  );

  /// Creates a PayMongo payment link and returns the checkout URL.
  ///
  /// Pass PAYMONGO_SECRET_KEY via --dart-define at build/run time to avoid
  /// shipping credentials in source. Example:
  /// flutter run --dart-define=PAYMONGO_SECRET_KEY=sk_test_xxx
  static Future<PayMongoLink?> createPaymentLink({
    required double amount,
    required String recipientId,
    required String recipientName,
    String? description,
  }) async {
    if (_secretKey.isEmpty) {
      throw Exception(
        'PAYMONGO_SECRET_KEY is not configured. Provide it via --dart-define.',
      );
    }

    final payload = {
      'data': {
        'attributes': {
          'amount': (amount * 100).round(),
          'currency': 'PHP',
          'description': description ?? 'Payment for $recipientName',
          'remarks': 'utrack:$recipientId',
          'metadata': {
            'recipient_id': recipientId,
            'recipient_name': recipientName,
          },
          'redirect': {
            'success': 'utrack://payments/success',
            'failed': 'utrack://payments/failed',
          },
        },
      },
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_secretKey:'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      final attributes = data?['attributes'] as Map<String, dynamic>?;
      final id = data?['id'] as String?;
      final checkoutUrl = attributes?['checkout_url'] as String?;
      if (id != null && checkoutUrl != null) {
        return PayMongoLink(id: id, checkoutUrl: checkoutUrl);
      }
      return null;
    }

    final Map<String, dynamic>? errorBody =
        response.body.isNotEmpty ? jsonDecode(response.body) as Map<String, dynamic>? : null;
    final errorMessage = errorBody?['errors'] is List && (errorBody?['errors'] as List).isNotEmpty
        ? (errorBody?['errors'] as List).first['detail']
        : 'Unexpected PayMongo response';
    throw Exception('PayMongo error (${response.statusCode}): $errorMessage');
  }

  /// Returns true if PayMongo reports the payment link as paid.
  static Future<bool> verifyPaymentStatus(String linkId) async {
    if (_secretKey.isEmpty) {
      throw Exception(
        'PAYMONGO_SECRET_KEY is not configured. Provide it via --dart-define.',
      );
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$linkId'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_secretKey:'))}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      final attributes = body['data']?['attributes'] as Map<String, dynamic>?;
      final status = (attributes?['status'] as String? ?? '').toLowerCase();
      return status == 'paid';
    }

    final Map<String, dynamic>? errorBody =
        response.body.isNotEmpty ? jsonDecode(response.body) as Map<String, dynamic>? : null;
    final errorMessage = errorBody?['errors'] is List && (errorBody?['errors'] as List).isNotEmpty
        ? (errorBody?['errors'] as List).first['detail']
        : 'Unexpected PayMongo response';
    throw Exception('PayMongo status error (${response.statusCode}): $errorMessage');
  }
}
