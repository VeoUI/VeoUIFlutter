import 'package:flutter/material.dart';

class VeoIcon extends StatelessWidget {
  final dynamic icon;
  final double size;
  final Color color;
  final FontWeight weight;
  final bool isEnabled;
  final Color? backgroundColor;
  final double backgroundOpacity;
  final double padding;
  final VoidCallback? onTap;

  const VeoIcon({
    Key? key,
    required this.icon,
    this.size = 24,
    this.color = Colors.black,
    this.weight = FontWeight.normal,
    this.isEnabled = true,
    this.backgroundColor,
    this.backgroundOpacity = 0.1,
    this.padding = 4,
    this.onTap,
  }) : super(key: key);

  factory VeoIcon.common(
      VeoCommonIcons commonIcon, {
        double size = 24,
        Color color = Colors.black,
        FontWeight weight = FontWeight.normal,
        bool isEnabled = true,
        Color? backgroundColor,
        double backgroundOpacity = 0.1,
        double padding = 4,
        VoidCallback? onTap,
      }) {
    return VeoIcon(
      icon: commonIcon,
      size: size,
      color: color,
      weight: weight,
      isEnabled: isEnabled,
      backgroundColor: backgroundColor,
      backgroundOpacity: backgroundOpacity,
      padding: padding,
      onTap: onTap,
    );
  }

  IconData _getIconData() {
    if (icon is IconData) return icon;
    if (icon is VeoCommonIcons) return icon.icon;
    throw ArgumentError('Invalid icon type');
  }

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      _getIconData(),
      size: size,
      color: isEnabled ? color : Colors.grey,
    );

    final paddedIcon = Padding(
      padding: EdgeInsets.all(padding),
      child: iconWidget,
    );

    final sizedIcon = SizedBox(
      width: size + (padding * 2),
      height: size + (padding * 2),
      child: Center(
        child: backgroundColor != null
            ? Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor!.withOpacity(backgroundOpacity),
          ),
          child: paddedIcon,
        )
            : paddedIcon,
      ),
    );

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: sizedIcon,
      ),
    );
  }
}

enum VeoCommonIcons {
  home,
  back,
  forward,
  menu,
  bell,
  logout,
  add,
  delete,
  edit,
  share,
  message,
  email,
  call,
  video,
  success,
  error,
  warning,
  info,
  photo,
  camera,
  mic,
  play,
  search,
  settings,
  user,
  calendar,
  close;

  IconData get icon {
    switch (this) {
      case VeoCommonIcons.home:
        return Icons.home_filled;
      case VeoCommonIcons.back:
        return Icons.chevron_left;
      case VeoCommonIcons.forward:
        return Icons.chevron_right;
      case VeoCommonIcons.menu:
        return Icons.menu;
      case VeoCommonIcons.bell:
        return Icons.notifications;
      case VeoCommonIcons.logout:
        return Icons.logout;
      case VeoCommonIcons.add:
        return Icons.add;
      case VeoCommonIcons.delete:
        return Icons.delete;
      case VeoCommonIcons.edit:
        return Icons.edit;
      case VeoCommonIcons.share:
        return Icons.share;
      case VeoCommonIcons.message:
        return Icons.message;
      case VeoCommonIcons.email:
        return Icons.email;
      case VeoCommonIcons.call:
        return Icons.phone;
      case VeoCommonIcons.video:
        return Icons.videocam;
      case VeoCommonIcons.success:
        return Icons.check_circle;
      case VeoCommonIcons.error:
        return Icons.error;
      case VeoCommonIcons.warning:
        return Icons.warning;
      case VeoCommonIcons.info:
        return Icons.info;
      case VeoCommonIcons.photo:
        return Icons.photo;
      case VeoCommonIcons.camera:
        return Icons.camera_alt;
      case VeoCommonIcons.mic:
        return Icons.mic;
      case VeoCommonIcons.play:
        return Icons.play_circle;
      case VeoCommonIcons.search:
        return Icons.search;
      case VeoCommonIcons.settings:
        return Icons.settings;
      case VeoCommonIcons.user:
        return Icons.person_rounded;
      case VeoCommonIcons.calendar:
        return Icons.calendar_today;
      case VeoCommonIcons.close:
        return Icons.close;
    }
  }
}