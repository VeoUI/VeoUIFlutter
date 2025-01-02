import 'package:flutter/material.dart';
import 'dart:math';
import '../../../veoui.dart';

class VeoSplash extends StatefulWidget {
  final String title;
  final List<Color> backgroundGradient;
  final Alignment startPoint;
  final Alignment endPoint;
  final IconData? iconData;
  final Size? iconSize;
  final String? appLogo;
  final double titleSize;
  final Color titleColor;
  final double fadeAnimationDuration;
  final double springAnimationDuration;
  final double springDampingFraction;
  final double springBlendDuration;
  final double screenDuration;
  final double spacing;
  final VoidCallback? onFinished;

  const VeoSplash({
    Key? key,
    required this.title,
    this.backgroundGradient = const [],
    this.startPoint = Alignment.topCenter,
    this.endPoint = Alignment.bottomCenter,
    this.iconData,
    this.iconSize = const Size(140, 140),
    this.appLogo,
    this.titleSize = 68,
    this.titleColor = Colors.white,
    this.fadeAnimationDuration = 1.0,
    this.springAnimationDuration = 1.0,
    this.springDampingFraction = 0.5,
    this.springBlendDuration = 1.0,
    this.screenDuration = 3,
    this.spacing = 20,
    this.onFinished,
  }) : super(key: key);

  @override
  State<VeoSplash> createState() => _VeoSplashState();
}

class _VeoSplashState extends State<VeoSplash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.springAnimationDuration * 1000).round()),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          widget.fadeAnimationDuration / widget.springAnimationDuration,
          curve: Curves.easeIn,
        ),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  void _startAnimations() {
    _controller.forward().then((_) {
      if (widget.onFinished != null) {
        Future.delayed(
          Duration(seconds: widget.screenDuration.round()),
          widget.onFinished,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> get _gradientColors {
    if (widget.backgroundGradient.isEmpty) {
      return [VeoUI.primaryColor, VeoUI.primaryDarkColor];
    }
    return widget.backgroundGradient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _gradientColors,
            begin: widget.startPoint,
            end: widget.endPoint,
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.appLogo != null)
                        VeoImage(
                          assetName: widget.appLogo!,
                          maxWidth: 120,
                          maxHeight: 120,
                        )
                      else if (widget.iconData != null)
                        Icon(
                          widget.iconData,
                          size: widget.iconSize?.width ?? 140,
                          color: widget.titleColor,
                        ),
                      SizedBox(height: widget.spacing),
                      VeoText(
                        widget.title,
                        style: VeoTextStyle.title,
                        color: widget.titleColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}