import 'package:flutter/material.dart';

class VeoBannerStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final double cornerRadius;
  final TextStyle textStyle;
  final EdgeInsets padding;

  const VeoBannerStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.cornerRadius,
    required this.textStyle,
    required this.padding,
  });

  static const VeoBannerStyle standard = VeoBannerStyle(
    backgroundColor: Color(0x662196F3),
    foregroundColor: Colors.white,
    cornerRadius: 12,
    textStyle: TextStyle(fontSize: 14),
    padding: EdgeInsets.all(16),
  );
}

class VeoInfoBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final VeoBannerStyle style;

  const VeoInfoBanner({
    Key? key,
    required this.icon,
    required this.message,
    this.style = VeoBannerStyle.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(style.cornerRadius),
      ),
      padding: style.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: style.foregroundColor,
            size: style.textStyle.fontSize! * 1.5,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: style.textStyle.copyWith(
                color: style.foregroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}