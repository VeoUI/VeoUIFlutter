import 'package:flutter/material.dart';
import 'package:veoui/veoui.dart';
import 'package:veoui_demo_app/screens/home_screen.dart';
import 'package:veoui_demo_app/screens/login_screen.dart';
import 'package:veoui_demo_app/screens/onboarding_screen.dart';
import 'package:veoui_demo_app/screens/profile_screen.dart';
import 'package:veoui_demo_app/screens/register_screen.dart';
import 'package:veoui_demo_app/screens/reset_password_screen.dart';
import 'package:veoui_demo_app/screens/splash_screen.dart';

void main() {

  VeoUI.configure(
    mainFont: "Rubik",
    primaryColor: HexColor("#f53d1b"),
    primaryDarkColor: HexColor("#c6062e"),
    isRTL: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VeoUI App',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen()
      },
    );
  }
}