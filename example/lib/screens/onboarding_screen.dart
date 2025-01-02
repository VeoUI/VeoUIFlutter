import 'package:flutter/material.dart';
import 'package:veoui/veoui.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VeoOnboarding(
      items: [
        OnboardingItem(
          title: "مرحباً بك في تطبيقنا",
          description:
              "نحن سعداء بانضمامك إلينا، دعنا نتعرف على المميزات الرئيسية للتطبيق",
          image: "assets/images/onboarding1.png",
        ),
        OnboardingItem(
          title: "تصفح بسهولة",
          description:
              "واجهة سهلة الاستخدام تمكنك من الوصول إلى جميع الخدمات بكل سلاسة",
          image: "assets/images/onboarding2.png",
        ),
        OnboardingItem(
          title: "خدمات متكاملة",
          description:
              "نقدم لك مجموعة متكاملة من الخدمات المصممة خصيصاً لتلبية احتياجاتك",
          image: "assets/images/onboarding3.png",
        ),
        OnboardingItem(
          title: "ابدأ رحلتك معنا",
          description: "كل شيء جاهز الآن! دعنا نبدأ هذه الرحلة المميزة معاً",
          image: "assets/images/onboarding4.png",
        ),
      ],
      skipButtonText: "تخطي",
      nextButtonText: "التالي",
      getStartedButtonText: "ابدأ الآن",
      onFinish: () {
        // SharedPreferences.setBool('hasCompletedOnboarding', true);
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}
