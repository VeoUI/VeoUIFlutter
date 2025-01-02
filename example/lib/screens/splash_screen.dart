import 'package:flutter/material.dart';
import 'package:veoui/veoui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VeoSplash(
        title: "اسم التطبيق",
        appLogo: "assets/images/logo.png",
        onFinished: () {
          Navigator.pushNamed(context, '/onboarding');
        }
    );
  }
}
