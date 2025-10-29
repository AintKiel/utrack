import 'package:flutter/material.dart';

class UColors {
  // Light Theme
  static final light = _LightColors();

  // Dark Theme
  static final dark = _DarkColors();

  UColors._();

  ///  App Basic Colors
  static const Color primary = Color(0xFF26667F); // mint green
  static const Color secondary = Color(0xFF67C090); // deep teal blue
  static const Color accent = Color(0xFF124170); // navy blue

  /// 🧾 Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  /// 🌆 Background Colors
  static const Color lightbg = Color(0xFFDDF4E7); // pale mint background
  static const Color darkbg = Color(0xFF1A1A1A);
  static const Color primaryBackground = Color(0xFFF5F5F5);
  static final Color lightBlue = Colors.lightBlue[50]!;

  static const Color borderPrimary = Color(0xFFDDDDDD);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  /// ⚠️ Error & Validation Colors
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);
  static const Color percentBar = Colors.teal;

  /// 🔘 Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  /// Lend theme Colors
  static const Color lendBg = Color(0xFFE8F5E9);
  static const Color lendBorder = Color(0xFF4CAF50);
  static const Color lendFont = Color(0xFF388E3C);

  /// Borrow theme Colors
  static const Color borrowBg = Color(0xFFFFF8E1);
  static const Color borrowBorder = Color(0xFFFFB300);
  static const Color borrowFont = Color(0xFFE65100);

  /// Neutral Greys (usable in both modes)
  static const Color grey = Color(0xFF9E9E9E);      // Standard grey
  static const Color darkGrey = Color(0xFF424242);  // Darker grey
  static const Color white = Colors.white;          // white
  static const Color black = Colors.black;          // black
}

class _LightColors {
  final Color background = const Color(0xFFDDF4E7);
  final Color primary = const Color(0xFF26667F);
  final Color secondary = const Color(0xFF67C090);
  final Color accent = const Color(0xFF124170);
  final Color darkGrey = Color(0xFF424242);
  final Color container = Color(0xFFF9FAFB);
  final Color text = Colors.black87;
}

class _DarkColors {
  final Color background = const Color(0xFF124170);
  final Color primary = const Color(0xFF26667F);
  final Color secondary = const Color(0xFF67C090);
  final Color accent = const Color(0xFFDDF4E7);
  final Color grey = Color(0xFF9E9E9E);
  final Color container = Colors.white10;
  final Color text = Colors.white70;
}
