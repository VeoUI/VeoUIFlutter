import 'package:flutter/material.dart';
import 'package:veoui/veoui.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return VeoRegister(
      appName: "اسم التطبيق",
      appLogo: "assets/images/logo.png",
      title: "إنشاء حساب",
      fullNamePlaceholder: "الاسم الكامل",
      emailPlaceholder: "البريد الإلكتروني",
      passwordPlaceholder: "كلمة المرور",
      confirmPasswordPlaceholder: "تأكيد كلمة المرور",
      registerButtonTitle: "تسجيل",
      alreadyHaveAccountButtonTitle: "لديك حساب بالفعل؟ سجل دخولك الآن",
      showToast: true,
      pleaseFillInAllFieldsToastMessage: "يرجى ملء جميع الحقول المطلوبة!",
      passwordsDontMatchMessage: "كلمات المرور غير متطابقة!",
      onRegisterTapped: (String fullName, String email, String password) async {
        print("Register tapped with name: $fullName, email: $email");
        await Future.delayed(const Duration(seconds: 2));
      },
      onLoginTapped: () {
        Navigator.pop(context);
      },
      onRegisterSuccess: () {
        Navigator.pop(context);
      },
      onRegisterError: (String error) {
        print("Registration error: $error");
      },
    );
  }
}
