import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/utils/themes/theme.dart';
import 'package:utrack/features/authentication/screens/login/login.dart';

void main() {
  runApp(const UTrackApp());
}

class UTrackApp extends StatelessWidget {
  const UTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final light = UAppTheme.lightTheme;
    final dark = UAppTheme.darkTheme;

    return GetMaterialApp(
      title: 'UTrack',
      debugShowCheckedModeBanner: false,
      theme: light.copyWith(
        textTheme: light.textTheme.apply(fontFamily: 'Poppins'),
      ),
      darkTheme: dark.copyWith(
        textTheme: dark.textTheme.apply(fontFamily: 'Poppins'),
      ),
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}
