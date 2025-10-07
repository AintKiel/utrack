import 'package:flutter/material.dart';

class UColors {
  // Light Theme
  static final light = _LightColors();

  // Dark Theme
  static final dark = _DarkColors();

  // Neutral Greys (usable in both modes)
  static const Color grey = Color(0xFF9E9E9E);      // Standard grey
  static const Color darkGrey = Color(0xFF424242);  // Darker grey
}

class _LightColors {
  final Color background = const Color(0xFFDDF4E7);
  final Color primary = const Color(0xFF26667F);
  final Color secondary = const Color(0xFF67C090);
  final Color accent = const Color(0xFF124170);
  final Color text = Colors.black87;
}

class _DarkColors {
  final Color background = const Color(0xFF124170);
  final Color primary = const Color(0xFF26667F);
  final Color secondary = const Color(0xFF67C090);
  final Color accent = const Color(0xFFDDF4E7);
  final Color text = Colors.white70;
}
