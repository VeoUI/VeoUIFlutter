import 'package:flutter/material.dart';

class VeoCheckBox extends StatelessWidget {
  final String title;
  final bool isChecked;
  final VoidCallback onTap;
  final Color? tintColor;
  final bool isEnabled;

  static const double _size = 24.0;

  const VeoCheckBox({
    Key? key,
    required this.title,
    required this.isChecked,
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isChecked ? effectiveTintColor : Colors.grey,
                  width: 2,
                ),
                color: isChecked ? effectiveTintColor : Colors.transparent,
              ),
              child: isChecked
                  ? Icon(
                Icons.check,
                size: 18,
                color: Colors.white,
              )
                  : null,
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