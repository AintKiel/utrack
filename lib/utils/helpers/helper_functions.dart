/// This file should be located at: lib/utils/helpers/helper_functions.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UHelperFunctions {
  /// Check if device is in dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get device screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get device screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get device pixel ratio
  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get the safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.fromLTRB(
      padding.left,
      padding.top,
      padding.right,
      padding.bottom,
    );
  }

  /// Get the safe area height
  static double getSafeAreaHeight(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return screenHeight(context) - padding.top - padding.bottom;
  }

  /// Get the safe area width
  static double getSafeAreaWidth(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return screenWidth(context) - padding.left - padding.right;
  }

  /// Get device keyboard height
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  /// Format date time
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(dateTime);
  }

  /// Format currency
  static String formatCurrency(double amount) {
    final NumberFormat formatter =
    NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return formatter.format(amount);
  }

  /// Show snackbar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Show alert dialog
  static void showAlert(
      BuildContext context,
      String title,
      String message, {
        VoidCallback? onPressed,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Navigate to screen
  static void navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  /// Navigate and replace
  static void navigateToReplace(BuildContext context, Widget screen) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  /// Remove focus
  static void removeFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Check if email is valid
  static bool isEmailValid(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Check if phone number is valid
  static bool isPhoneNumberValid(String phoneNumber) {
    final phoneRegex = RegExp(r'^\+?1?\d{9,15}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  /// Get platform using BuildContext
  static String getPlatform(BuildContext context) {
    return Theme.of(context).platform.toString();
  }
}