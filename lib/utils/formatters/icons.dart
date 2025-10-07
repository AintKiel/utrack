import 'package:flutter/material.dart';

class UIcons {
  // Sizes
  static const double small = 20.0; // a little smaller
  static const double regular = 24.0; // default size
  static const double large = 28.0; // a little bigger

  // Generic icon builder
  static Widget _icon(
      String name, {
        double size = regular,
        Color? color,
      }) {
    return Image.asset(
      'assets/icons/$name.png',
      width: size,
      height: size,
      color: color, // color overlay if provided
    );
  }

  // icons
  static Widget borrowIcon({double size = regular, Color? color}) =>
      _icon("borrowIcon", size: size, color: color);

  static Widget darkmode({double size = regular, Color? color}) =>
      _icon("darkmode", size: size, color: color);

  static Widget editIcon({double size = regular, Color? color}) =>
      _icon("editIcon", size: size, color: color);

  static Widget helpAndSupport({double size = regular, Color? color}) =>
      _icon("helpandsupport", size: size, color: color);

  static Widget history({double size = regular, Color? color}) =>
      _icon("history", size: size, color: color);

  static Widget home({double size = regular, Color? color}) =>
      _icon("home", size: size, color: color);

  static Widget lendIcon({double size = regular, Color? color}) =>
      _icon("lendIcon", size: size, color: color);

  static Widget lightmode({double size = regular, Color? color}) =>
      _icon("lightmode", size: size, color: color);

  static Widget location({double size = regular, Color? color}) =>
      _icon("location", size: size, color: color);

  static Widget logout({double size = regular, Color? color}) =>
      _icon("logout", size: size, color: color);

  static Widget mail({double size = regular, Color? color}) =>
      _icon("mail", size: size, color: color);

  static Widget notification({double size = regular, Color? color}) =>
      _icon("notification", size: size, color: color);

  static Widget paid({double size = regular, Color? color}) =>
      _icon("paid", size: size, color: color);

  static Widget password({double size = regular, Color? color}) =>
      _icon("password", size: size, color: color);

  static Widget phone({double size = regular, Color? color}) =>
      _icon("phone", size: size, color: color);

  static Widget privacySecurity({double size = regular, Color? color}) =>
      _icon("privacySecurity", size: size, color: color);

  static Widget qrCode({double size = regular, Color? color}) =>
      _icon("qrCode", size: size, color: color);

  static Widget scanQR({double size = regular, Color? color}) =>
      _icon("scanQR", size: size, color: color);

  static Widget search({double size = regular, Color? color}) =>
      _icon("search", size: size, color: color);

  static Widget store({double size = regular, Color? color}) =>
      _icon("store", size: size, color: color);

  static Widget user({double size = regular, Color? color}) =>
      _icon("user", size: size, color: color);

  static Widget userEdit({double size = regular, Color? color}) =>
      _icon("userEdit", size: size, color: color);

  static Widget visibilityOff({double size = regular, Color? color}) =>
      _icon("visibilityOff", size: size, color: color);

  static Widget visibilityOn({double size = regular, Color? color}) =>
      _icon("visibilityOn", size: size, color: color);

  static Widget wallet({double size = regular, Color? color}) =>
      _icon("wallet", size: size, color: color);

  static Widget warningSign({double size = regular, Color? color}) =>
      _icon("warningSign", size: size, color: color);
}
