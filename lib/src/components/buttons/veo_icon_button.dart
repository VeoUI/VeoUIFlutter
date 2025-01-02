import 'package:flutter/material.dart';

class VeoIconButtonStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final double cornerRadius;
  final TextStyle textStyle;
  final double horizontalPadding;
  final double verticalPadding;

  const VeoIconButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.cornerRadius,
    required this.textStyle,
    required this.horizontalPadding,
    required this.verticalPadding,
  });

  static const VeoIconButtonStyle standard = VeoIconButtonStyle(
    backgroundColor: Color(0x33FFFFFF),
    foregroundColor: Colors.white,
    cornerRadius: 15,
    textStyle: TextStyle(fontSize: 16),
    horizontalPadding: 16,
    verticalPadding: 8,
  );
}

class VeoIconButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final VeoIconButtonStyle style;

  const VeoIconButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.style = VeoIconButtonStyle.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(style.cornerRadius),
        child: Ink(
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(style.cornerRadius),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: style.horizontalPadding,
              vertical: style.verticalPadding,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: style.foregroundColor,
                  size: style.textStyle.fontSize! * 1.2,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: style.textStyle.copyWith(
                    color: style.foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}