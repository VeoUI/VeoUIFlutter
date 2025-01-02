import 'package:flutter/material.dart';
import '../../../veoui.dart';

class VeoAlertIcon {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Size size;

  VeoAlertIcon({
    required this.icon,
    this.color = Colors.red,
    Color? backgroundColor,
    this.size = const Size(40, 40),
  }) : backgroundColor = backgroundColor ?? color.withOpacity(0.1);

  factory VeoAlertIcon.system({
    required IconData icon,
    Color color = Colors.red,
    Color? backgroundColor,
    Size size = const Size(40, 40),
  }) {
    return VeoAlertIcon(
      icon: icon,
      color: color,
      backgroundColor: backgroundColor ?? color.withOpacity(0.1),
      size: size,
    );
  }
}

class VeoAlertButton {
  final String title;
  final VeoAlertButtonStyle style;
  final VoidCallback onPressed;

  const VeoAlertButton({
    required this.title,
    required this.style,
    required this.onPressed,
  });
}

class VeoAlertButtonStyle {
  final Color? backgroundColor;
  final Color foregroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double cornerRadius;
  final EdgeInsets padding;

  const VeoAlertButtonStyle({
    this.backgroundColor,
    required this.foregroundColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.cornerRadius = 25,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 12,
    ),
  });

  static const VeoAlertButtonStyle primary = VeoAlertButtonStyle(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  );

  static const VeoAlertButtonStyle secondary = VeoAlertButtonStyle(
    backgroundColor: null,
    foregroundColor: Colors.grey,
    fontWeight: FontWeight.normal,
  );
}

class VeoAlertContent {
  final VeoAlertIcon icon;
  final String title;
  final String message;
  final VeoAlertButton primaryButton;
  final VeoAlertButton? secondaryButton;

  const VeoAlertContent({
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryButton,
    this.secondaryButton,
  });
}

class VeoAlert extends StatefulWidget {
  final bool isShowing;
  final VoidCallback onClose;
  final VeoAlertContent content;
  final VeoAlertStyle style;

  const VeoAlert({
    Key? key,
    required this.isShowing,
    required this.onClose,
    required this.content,
    this.style = const VeoAlertStyle(),
  }) : super(key: key);

  @override
  State<VeoAlert> createState() => _VeoAlertState();
}

class _VeoAlertState extends State<VeoAlert> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    if (widget.isShowing) {
      _showAlert();
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  void _showAlert() {
    _animationController.forward();
  }

  void _hideAlert() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _hideAlert,
              child: Container(
                color: widget.style.backdropColor
                    .withOpacity(_fadeAnimation.value),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 48,
                      ),
                      decoration: BoxDecoration(
                        color: widget.style.backgroundColor,
                        borderRadius: BorderRadius.circular(
                          widget.style.cornerRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: widget.style.padding,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.content.icon.backgroundColor,
                              ),
                              child: Center(
                                child: Icon(
                                  widget.content.icon.icon,
                                  size: widget.content.icon.size.width,
                                  color: widget.content.icon.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            VeoText(
                              widget.content.title,
                              style: VeoTextStyle.title
                            ),
                            const SizedBox(height: 8),

                            VeoText(
                              widget.content.message,
                              style: VeoTextStyle.subtitle,
                              color: Colors.grey
                            ),
                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.content.secondaryButton != null) ...[
                                  _buildButton(
                                    widget.content.secondaryButton!,
                                    isSecondary: true,
                                  ),
                                  const SizedBox(width: 16),
                                ],
                                _buildButton(widget.content.primaryButton),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton(VeoAlertButton button, {bool isSecondary = false}) {
    return TextButton(
      onPressed: () {
        _hideAlert();
        Future.delayed(
          const Duration(milliseconds: 300),
          button.onPressed,
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: button.style.backgroundColor,
        padding: button.style.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(button.style.cornerRadius),
        ),
      ),
      child: Text(
        button.title,
        style: TextStyle(
          color: button.style.foregroundColor,
          fontSize: button.style.fontSize,
          fontWeight: button.style.fontWeight,
          fontFamily: VeoUI.mainFont,
        ),
      ),
    );
  }
}

class VeoAlertStyle {
  final Color backgroundColor;
  final double cornerRadius;
  final EdgeInsets padding;
  final double spacing;
  final TextStyle titleStyle;
  final TextStyle messageStyle;
  final Color backdropColor;

  const VeoAlertStyle({
    this.backgroundColor = Colors.white,
    this.cornerRadius = 20,
    this.padding = const EdgeInsets.all(24),
    this.spacing = 16,
    this.titleStyle = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    this.messageStyle = const TextStyle(
      fontSize: 16,
    ),
    this.backdropColor = const Color(0x66000000),
  });
}