/// App Logos & Social Media Icons
class ULogos {
  // App Logos
  static const String logoDark = "assets/logos/logo_dark_theme.png";
  static const String logoLight = "assets/logos/logo_light_theme.png";

  // Social Media
  static const String google = "assets/images/google.png";
  static const String facebook = "assets/images/facebook.png";
  static const String sendEmail = "assets/images/send_email.png";
  static const String verifyID = "assets/images/id_verify.png";
}

/// Logo Sizes (for consistent scaling)
class ULogoSizes {
  // App Logos
  static const double appLogoLarge = 150;   // For splashscreen / home (big logo)
  static const double appLogoSmall = 60;    // For AppBar / header (small logo)

  // Social Media
  static const double socialLogoSize = 48;  // For Google / Facebook buttons

  // Send Email Logo (like splashscreen size)
  static const double onBoardSize = 250;
  static const double idUploadSize = 32;
}

/// Example Usage
///
/// ```dart
/// // AppBar Logo
/// Image.asset(
///   ULogos.logoLight,
///   height: ULogoSizes.appLogoSmall,
/// )
///
/// // Splashscreen / Home Logo
/// Image.asset(
///   ULogos.logoDark,
///   height: ULogoSizes.appLogoLarge,
/// )
///
/// // Social Login Buttons
/// Image.asset(
///   ULogos.google,
///   height: ULogoSizes.socialLogoSize,
/// )
/// ```
