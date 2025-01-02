import 'package:flutter/material.dart';
import '../../../veoui.dart';
import '../display/veo_icon.dart';

class VeoAppBar extends StatelessWidget {
  final String appName;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onLogoutTap;

  const VeoAppBar({
    Key? key,
    required this.appName,
    required this.onMenuTap,
    required this.onNotificationTap,
    required this.onLogoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        textDirection: VeoUI.isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          VeoIcon(
            icon: Icons.menu,
            color: Colors.white,
            onTap: onMenuTap,
          ),
          const SizedBox(width: 16),
          VeoText(
            appName,
            style: VeoTextStyle.title,
            color: Colors.white,
          ),
          const Spacer(),
          VeoIcon(
            icon: Icons.notifications,
            color: Colors.white,
            onTap: onNotificationTap,
          ),
          const SizedBox(width: 16),
          VeoIcon(
            icon: Icons.logout,
            color: Colors.white,
            onTap: onLogoutTap,
          ),
        ],
      ),
    );
  }
}