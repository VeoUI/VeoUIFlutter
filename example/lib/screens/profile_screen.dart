import 'package:flutter/material.dart';
import 'package:veoui/veoui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return VeoProfile(
      appName: "اسم التطبيق",
      appLogo: "assets/images/logo.png",
      changePhotoButtonTitle: "تغيير الصورة",
      saveButtonTitle: "حفظ",
      logoutButtonTitle: "تسجيل الخروج",
      showToast: true,
      initialData: {
        'fullName': 'أحمد علي',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'bio': 'مطور تطبيقات محترف'
      },
      onSaveProfile: (data, newAvatarPath) async {
        print('Updating profile: $data');
      },
      onLogout: () async {
        Navigator.pop(context);
      },
      onPhotoChanged: () {},
    );
  }
}
