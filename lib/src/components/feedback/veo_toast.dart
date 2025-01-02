import 'dart:async';
import 'package:flutter/material.dart';
import '../../../veoui.dart';

enum VeoToastPosition {
  top,
  bottom,
  topLeading,
  topTrailing,
  bottomLeading,
  bottomTrailing;

  Alignment get alignment {
    switch (this) {
      case VeoToastPosition.top:
        return Alignment.topCenter;
      case VeoToastPosition.bottom:
        return Alignment.bottomCenter;
      case VeoToastPosition.topLeading:
        return Alignment.topLeft;
      case VeoToastPosition.topTrailing:
        return Alignment.topRight;
      case VeoToastPosition.bottomLeading:
        return Alignment.bottomLeft;
      case VeoToastPosition.bottomTrailing:
        return Alignment.bottomRight;
    }
  }

  bool get isTop => this == VeoToastPosition.top ||
      this == VeoToastPosition.topLeading ||
      this == VeoToastPosition.topTrailing;

  Offset get initialOffset {
    if (isTop) return const Offset(0, -1);
    return const Offset(0, 1);
  }
}

enum VeoToastStyle {
  success,
  error,
  warning,
  info,
  custom;

  Color getBackgroundColor(BuildContext context, {Color? customColor}) {
    switch (this) {
      case VeoToastStyle.success:
        return VeoUI.successColor;
      case VeoToastStyle.error:
        return VeoUI.dangerColor;
      case VeoToastStyle.warning:
        return VeoUI.warningColor;
      case VeoToastStyle.info:
        return VeoUI.infoColor;
      case VeoToastStyle.custom:
        return customColor ?? VeoUI.primaryColor;
    }
  }

  Color getForegroundColor({Color? customColor}) {
    return customColor ?? Colors.white;
  }

  IconData get icon {
    switch (this) {
      case VeoToastStyle.success:
        return Icons.check_circle;
      case VeoToastStyle.error:
        return Icons.error;
      case VeoToastStyle.warning:
        return Icons.warning;
      case VeoToastStyle.info:
        return Icons.info;
      case VeoToastStyle.custom:
        return Icons.info;
    }
  }
}

class VeoToastConfig {
  static final VeoToastConfig shared = VeoToastConfig();

  VeoToastPosition defaultPosition = VeoToastPosition.top;
  double defaultDuration = 3.0;
  VeoToastStyle defaultStyle = VeoToastStyle.info;
  bool defaultIsClosable = true;
  double iconSize = 20.0;
  FontWeight fontWeight = FontWeight.w500;
  Duration animationDuration = const Duration(milliseconds: 300);
}

class VeoToastMessage {
  final String id;
  final String message;
  final VeoToastStyle? style;
  final VeoToastPosition? position;
  final double? duration;
  final bool? isClosable;
  final Color? customBackgroundColor;
  final Color? customForegroundColor;

  VeoToastMessage({
    required this.message,
    this.style,
    this.position,
    this.duration,
    this.isClosable,
    this.customBackgroundColor,
    this.customForegroundColor,
  }) : id = UniqueKey().toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is VeoToastMessage && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class VeoToast extends StatefulWidget {
  final VeoToastMessage? currentToast;
  final ValueChanged<VeoToastMessage?> onToastChanged;

  const VeoToast({
    super.key,
    required this.currentToast,
    required this.onToastChanged,
  });

  @override
  State<VeoToast> createState() => _VeoToastState();
}

class _VeoToastState extends State<VeoToast> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _hideTimer;
  bool _isAnimatingOut = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    if (widget.currentToast != null) {
      _showToast();
    }
  }

  @override
  void didUpdateWidget(VeoToast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentToast != oldWidget.currentToast) {
      _showToast();
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: VeoToastConfig.shared.animationDuration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    final position = widget.currentToast?.position ??
        VeoToastConfig.shared.defaultPosition;

    _slideAnimation = Tween<Offset>(
      begin: position.initialOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  void _showToast() {
    _hideTimer?.cancel();
    _hideTimer = null;

    if (_isAnimatingOut) {
      _isAnimatingOut = false;
    }

    _animationController.forward(from: 0.0);
    _setupAutoDismiss();
  }

  void _setupAutoDismiss() {
    final duration = widget.currentToast?.duration ??
        VeoToastConfig.shared.defaultDuration;

    _hideTimer = Timer(Duration(seconds: duration.round()), () {
      dismiss();
    });
  }

  void dismiss() {
    if (_isAnimatingOut) return;
    _isAnimatingOut = true;

    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onToastChanged(null);
        _isAnimatingOut = false;
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentToast == null) return const SizedBox.shrink();

    final position = widget.currentToast?.position ??
        VeoToastConfig.shared.defaultPosition;
    final style = widget.currentToast?.style ??
        VeoToastConfig.shared.defaultStyle;
    final isClosable = widget.currentToast?.isClosable ??
        VeoToastConfig.shared.defaultIsClosable;

    return SafeArea(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Positioned(
            left: 16,
            right: 16,
            top: position.isTop ? 16 : null,
            bottom: !position.isTop ? 16 : null,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildToastContent(style, isClosable),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToastContent(VeoToastStyle style, bool isClosable) {
    return Material(
      elevation: VeoUI.defaultElevation,
      borderRadius: BorderRadius.circular(VeoUI.defaultCornerRadius),
      color: style.getBackgroundColor(
        context,
        customColor: widget.currentToast?.customBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              style.icon,
              size: VeoToastConfig.shared.iconSize,
              color: style.getForegroundColor(
                customColor: widget.currentToast?.customForegroundColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: VeoText(
                widget.currentToast?.message ?? '',
                style: VeoTextStyle.body,
                color: style.getForegroundColor(
                  customColor: widget.currentToast?.customForegroundColor,
                ),
              ),
            ),
            if (isClosable) ...[
              const SizedBox(width: 12),
              GestureDetector(
                onTap: dismiss,
                child: Icon(
                  Icons.close,
                  size: VeoToastConfig.shared.iconSize,
                  color: style.getForegroundColor(
                    customColor: widget.currentToast?.customForegroundColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}