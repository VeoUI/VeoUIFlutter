import 'package:flutter/material.dart';
import 'package:veoui/veoui.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VeoResetPassword(
      appName: "اسم التطبيق",
      appLogo: "assets/images/logo.png",
      title: "استعادة كلمة المرور",
      subtitle: "أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور",
      emailPlaceholder: "البريد الإلكتروني",
      resetButtonTitle: "إرسال رابط الاستعادة",
      backToLoginButtonTitle: "العودة لتسجيل الدخول",
      showToast: true,
      pleaseFillEmailMessage: "يرجى إدخال البريد الإلكتروني!",
      onResetTapped: (String email) async {
        print("تم طلب استعادة كلمة المرور للبريد: $email");
        await Future.delayed(const Duration(seconds: 2));
      },
      onBackToLoginTapped: () {
        Navigator.pop(context);
      },
      onResetSuccess: () {
        print("تم إرسال رابط استعادة كلمة المرور بنجاح");
      },
      onResetError: (String error) {
        print("خطأ في استعادة كلمة المرور: $error");
      },
    );
  }
}
