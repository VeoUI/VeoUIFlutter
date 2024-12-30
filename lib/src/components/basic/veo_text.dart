import 'package:flutter/material.dart';
import '../../../veoui.dart';

class VeoText extends StatelessWidget {
  final String text;
  final VeoTextStyle style;
  final TextAlign? alignment;
  final int? maxLines;
  final Color? color;
  final TextOverflow overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final String? fontFamily;
  final bool selectable;

  const VeoText(
      this.text, {
        Key? key,
        this.style = VeoTextStyle.body,
        this.alignment,
        this.maxLines,
        this.color = Colors.black,
        this.overflow = TextOverflow.ellipsis,
        this.softWrap,
        this.textDirection,
        this.fontFamily,
        this.selectable = false,
      }) : super(key: key);

  TextStyle _getFont() {
    final baseFont = fontFamily ?? VeoUI.mainFont;
    final defaultTextStyle = TextStyle(fontFamily: baseFont);

    switch (style) {
      case VeoTextStyle.title:
        return defaultTextStyle.copyWith(
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
        );
      case VeoTextStyle.subtitle:
        return defaultTextStyle.copyWith(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        );
      case VeoTextStyle.body:
        return defaultTextStyle.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        );
      case VeoTextStyle.caption:
        return defaultTextStyle.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        );
    }
  }

  Color _getColor(BuildContext context) {
    if (color != null) return color!;
    return VeoUI.isDarkMode ? Colors.white : Colors.black;
  }

  TextAlign _getAlignment() {
    if (alignment != null) return alignment!;
    return VeoUI.isRTL ? TextAlign.right : TextAlign.left;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = _getFont().copyWith(
      color: _getColor(context),
    );

    if (selectable) {
      return SelectableText(
        text,
        style: textStyle,
        textAlign: _getAlignment(),
        maxLines: maxLines,
        textDirection: textDirection ?? (VeoUI.isRTL ? TextDirection.rtl : TextDirection.ltr),
      );
    }

    return Text(
      text,
      style: textStyle,
      textAlign: _getAlignment(),
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection ?? (VeoUI.isRTL ? TextDirection.rtl : TextDirection.ltr),
    );
  }
}

enum VeoTextStyle {
  title,
  subtitle,
  body,
  caption,
}