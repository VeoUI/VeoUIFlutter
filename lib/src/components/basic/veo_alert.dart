import 'package:flutter/material.dart';

class AlertIcon {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Size size;

  const AlertIcon({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    this.size = const Size(40, 40),
  });

  static AlertIcon system({
    required IconData icon,
    Color color = Colors.red,
    Color? backgroundColor,
    Size size = const Size(40, 40),
  }) {
    return AlertIcon(
      icon: icon,
      color: color,
      backgroundColor: backgroundColor ?? color.withOpacity(0.1),
      size: size,
    );
  }
}

class AlertButtonStyle {
  final Color? backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final double cornerRadius;
  final EdgeInsets padding;

  const AlertButtonStyle({
    this.backgroundColor,
    required this.foregroundColor,
    required this.textStyle,
    required this.cornerRadius,
    required this.padding,
  });

  static const primary = AlertButtonStyle(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    cornerRadius: 25,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
  );

  static const secondary = AlertButtonStyle(
    backgroundColor: null,
    foregroundColor: Colors.grey,
    textStyle: TextStyle(fontSize: 16),
    cornerRadius: 25,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}

class AlertButton {
  final String title;
  final AlertButtonStyle style;
  final VoidCallback onPressed;

  const AlertButton({
    required this.title,
    required this.style,
    required this.onPressed,
  });
}

class AlertContent {
  final AlertIcon icon;
  final String title;
  final String message;
  final AlertButton primaryButton;
  final AlertButton? secondaryButton;

  const AlertContent({
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryButton,
    this.secondaryButton,
  });
}

class AlertStyle {
  final Color backgroundColor;
  final double cornerRadius;
  final EdgeInsets padding;
  final double spacing;
  final TextStyle titleStyle;
  final TextStyle messageStyle;
  final Color backdropColor;

  const AlertStyle({
    required this.backgroundColor,
    required this.cornerRadius,
    required this.padding,
    required this.spacing,
    required this.titleStyle,
    required this.messageStyle,
    required this.backdropColor,
  });

  static const standard = AlertStyle(
    backgroundColor: Colors.white,
    cornerRadius: 20,
    padding: EdgeInsets.all(24),
    spacing: 16,
    titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    messageStyle: TextStyle(fontSize: 16),
    backdropColor: Color(0x66000000),
  );
}

class VeoAlert extends StatefulWidget {
  final bool isPresented;
  final ValueChanged<bool> onDismiss;
  final AlertContent content;
  final AlertStyle style;

  const VeoAlert({
    Key? key,
    required this.isPresented,
    required this.onDismiss,
    required this.content,
    this.style = AlertStyle.standard,
  }) : super(key: key);

  @override
  State<VeoAlert> createState() => _VeoAlertState();
}

class _VeoAlertState extends State<VeoAlert> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    if (widget.isPresented) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(VeoAlert oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPresented != oldWidget.isPresented) {
      if (widget.isPresented) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _hideAlert() {
    _animationController.reverse().then((_) {
      widget.onDismiss(false);
    });
  }

  Widget _buildButton(AlertButton button) {
    return Material(
      color: button.style.backgroundColor,
      borderRadius: BorderRadius.circular(button.style.cornerRadius),
      child: InkWell(
        onTap: () {
          _hideAlert();
          Future.delayed(
            const Duration(milliseconds: 300),
            button.onPressed,
          );
        },
        borderRadius: BorderRadius.circular(button.style.cornerRadius),
        child: Padding(
          padding: button.style.padding,
          child: Text(
            button.title,
            style: button.style.textStyle.copyWith(
              color: button.style.foregroundColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPresented) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // Backdrop
              GestureDetector(
                onTap: _hideAlert,
                child: Container(
                  color: widget.style.backdropColor
                      .withOpacity(widget.style.backdropColor.opacity * _opacityAnimation.value),
                ),
              ),
              // Alert content
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        decoration: BoxDecoration(
                          color: widget.style.backgroundColor,
                          borderRadius: BorderRadius.circular(widget.style.cornerRadius),
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
                                  color: widget.content.icon.backgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  widget.content.icon.icon,
                                  color: widget.content.icon.color,
                                  size: widget.content.icon.size.width,
                                ),
                              ),
                              SizedBox(height: widget.style.spacing),
                              Text(
                                widget.content.title,
                                style: widget.style.titleStyle,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: widget.style.spacing * 0.5),
                              Text(
                                widget.content.message,
                                style: widget.style.messageStyle.copyWith(
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: widget.style.spacing),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.content.secondaryButton != null) ...[
                                    _buildButton(widget.content.secondaryButton!),
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
      ),
    );
  }
}