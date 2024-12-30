import 'package:flutter/material.dart';

class VeoRadioButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? tintColor;
  final bool isEnabled;

  static const double _size = 24.0;
  static const double _innerPadding = 6.0;

  const VeoRadioButton({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.tintColor,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTintColor = tintColor ?? Theme.of(context).primaryColor;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _size,
              height: _size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: _size,
                    height: _size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? effectiveTintColor : Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  if (isSelected)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _size - _innerPadding * 2,
                      height: _size - _innerPadding * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: effectiveTintColor,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isEnabled ? Theme.of(context).textTheme.bodyLarge?.color : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}