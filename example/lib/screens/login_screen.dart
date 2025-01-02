import 'package:flutter/material.dart';
import 'package:veoui/veoui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return VeoLogin(
      appName: "اسم التطبيق",
      appLogo: "assets/images/logo.png",
      title: "تسجيل الدخول",
      emailPlaceholder: "البريد الإلكتروني",
      passwordPlaceholder: "كلمة المرور",
      loginButtonTitle: "دخول",
      forgotPasswordButtonTitle: "هل نسيت كلمة المرور؟",
      dontHaveAccountButtonTitle: "ليس لديك حساب؟ سجل الآن!",
      showToast: true,
      pleaseFillInAllFieldsToastMessage: "يرجى ملء جميع الحقول!",
      onLoginTapped: (email, password) async {
        debugPrint("تم الضغط على تسجيل الدخول بالبريد: $email وكلمة المرور: $password");
        await _simulateDelay();
      },
      onRegisterTapped: () {
        Navigator.pushNamed(context, '/register');
      },
      onForgotPasswordTapped: () {
        Navigator.pushNamed(context, '/reset-password');
      },
      onLoginSuccess: () {
        Navigator.pushReplacementNamed(context, '/profile');
      },
      onLoginError: (error) {
        debugPrint("خطأ في تسجيل الدخول: $error");
      },
    );
  }
}
