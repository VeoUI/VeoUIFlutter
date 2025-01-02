import 'package:flutter/material.dart';

class VeoSwitch extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onChanged;
  final String label;
  final Color? tintColor;
  final bool isEnabled;

  static const double _switchWidth = 50.0;
  static const double _switchHeight = 30.0;
  static const double _toggleSize = 24.0;
  static const double _togglePadding = 3.0;
  static const Duration _animationDuration = Duration(milliseconds: 200);

  const VeoSwitch({
    Key? key,
    required this.isOn,
    required this.onChanged,
    required this.label,
    this.tintColor,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTintColor = tintColor ?? Theme.of(context).primaryColor;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GestureDetector(
          onTap: isEnabled
              ? () {
            onChanged(!isOn);
          }
              : null,
          child: Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isEnabled
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : Colors.grey,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: _switchWidth,
                height: _switchHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: _animationDuration,
                      width: _switchWidth,
                      height: _switchHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_switchHeight / 2),
                        color: isOn
                            ? effectiveTintColor
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    AnimatedAlign(
                      duration: _animationDuration,
                      curve: Curves.easeInOut,
                      alignment: isOn
                          ? const Alignment(0.8, 0.0)
                          : const Alignment(-0.8, 0.0),
                      child: Container(
                        width: _toggleSize,
                        height: _toggleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 1,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}