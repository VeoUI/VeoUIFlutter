import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../veoui.dart';

enum VeoButtonStyle {
  primary,
  secondary,
  info,
  warning,
  danger,
  tertiary,
}

enum VeoButtonShape {
  square,
  rounded,
  circle,
  custom,
}

class VeoButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final VeoButtonStyle style;
  final VeoButtonShape shape;
  final double elevation;
  final List<Color>? gradientColors;
  final TextAlign textDirection;
  final bool isEnabled;
  final double? customRadius;

  const VeoButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.style = VeoButtonStyle.primary,
    this.shape = VeoButtonShape.rounded,
    this.elevation = 4.0,
    this.gradientColors,
    this.textDirection = TextAlign.center,
    this.isEnabled = true,
    this.customRadius,
  }) : super(key: key);

  Color? get backgroundColor {
    switch (style) {
      case VeoButtonStyle.primary:
        return VeoUI.primaryColor;
      case VeoButtonStyle.secondary:
        return VeoUI.secondaryColor;
      case VeoButtonStyle.info:
        return VeoUI.infoColor;
      case VeoButtonStyle.warning:
        return VeoUI.warningColor;
      case VeoButtonStyle.danger:
        return VeoUI.dangerColor;
      case VeoButtonStyle.tertiary:
        return VeoUI.tertiaryColor;
    }
  }

  double get cornerRadius {
    switch (shape) {
      case VeoButtonShape.square:
        return 0;
      case VeoButtonShape.rounded:
        return VeoUI.defaultCornerRadius;
      case VeoButtonShape.circle:
        return 25;
      case VeoButtonShape.custom:
        return customRadius ?? 8;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Material(
          elevation: elevation,
          shadowColor: backgroundColor?.withOpacity(0.3),
          borderRadius: BorderRadius.circular(cornerRadius),
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(cornerRadius),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cornerRadius),
                gradient: gradientColors != null
                    ? LinearGradient(
                  colors: gradientColors!,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
                    : null,
                color: gradientColors == null ? backgroundColor : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: VeoUI.mainFont,
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: textDirection,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
