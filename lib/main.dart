import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:utrack/utils/themes/theme.dart';
import 'package:utrack/features/authentication/screens/login/login.dart';
import 'package:utrack/features/authentication/controllers/authentication_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FORCE LOGOUT - This is critical!
  await FirebaseAuth.instance.signOut();

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
      initialBinding: BindingsBuilder(() {
        Get.put(AuthenticationController());
      }),
      home: const LoginScreen(),
    );
  }
}