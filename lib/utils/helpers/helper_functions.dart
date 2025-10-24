import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UHelperFunctions {
  /// Check if the current theme is dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get full screen size using GetX context
  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  /// Get screen height
  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Format date with intl package
  static String getFormattedDate(DateTime date, {String format = 'dd MM yyyy'}) {
    return DateFormat(format).format(date);
  }
}
