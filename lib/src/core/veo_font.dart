import 'dart:ui';

import 'package:veoui/src/core/veoui.dart';

class VeoFont {

  static const double largeTitleSize = 34;
  static const double title1Size = 28;
  static const double title2Size = 22;
  static const double title3Size = 20;
  static const double headlineSize = 17;
  static const double subheadlineSize = 15;
  static const double bodySize = 14;
  static const double calloutSize = 16;
  static const double caption1Size = 12;
  static const double caption2Size = 11;
  static const double footnoteSize = 13;

  static TextStyle _baseStyle({
    required double size,
    FontWeight weight = FontWeight.normal,
    FontStyle? fontStyle,
    bool? smallCaps,
    bool monospacedDigits = false,
  }) {
    String fontFamily = VeoUI.mainFont;

    switch (weight) {
      case FontWeight.w200:
        fontFamily = VeoUI.lightFont ?? fontFamily;
        break;
      case FontWeight.w400:
        fontFamily = VeoUI.regularFont ?? fontFamily;
        break;
      case FontWeight.w500:
        fontFamily = VeoUI.mediumFont ?? fontFamily;
        break;
      case FontWeight.w700:
        fontFamily = VeoUI.boldFont ?? fontFamily;
        break;
    }

    if (fontStyle == FontStyle.italic && VeoUI.italicFont != null) {
      fontFamily = VeoUI.italicFont!;
    }

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      fontStyle: fontStyle,
      fontFeatures: [
        if (smallCaps == true)
          const FontFeature.enable('smcp'),
        if (monospacedDigits)
          const FontFeature.tabularFigures(),
      ],
    );
  }

  static TextStyle largeTitle({
    FontWeight weight = FontWeight.bold,
    FontStyle? fontStyle,
    bool? smallCaps,
    bool monospacedDigits = false,
  }) {
    return _baseStyle(
      size: largeTitleSize,
      weight: weight,
      fontStyle: fontStyle,
      smallCaps: smallCaps,
      monospacedDigits: monospacedDigits,
    );
  }

  static TextStyle title1({
    FontWeight weight = FontWeight.bold,
    FontStyle? fontStyle,
    bool? smallCaps,
    bool monospacedDigits = false,
  }) {
    return _baseStyle(
      size: title1Size,
      weight: weight,
      fontStyle: fontStyle,
      smallCaps: smallCaps,
      monospacedDigits: monospacedDigits,
    );
  }

  static TextStyle title2({
    FontWeight weight = FontWeight.bold,
    FontStyle? fontStyle,
    bool? smallCaps,
    bool monospacedDigits = false,
  }) {
    return _baseStyle(
      size: title2Size,
      weight: weight,
      fontStyle: fontStyle,
      smallCaps: smallCaps,
      monospacedDigits: monospacedDigits,
    );
  }

  static TextStyle title3({
    FontWeight weight = FontWeight.w600,
    FontStyle? fontStyle,
    bool? smallCaps,
    bool monospacedDigits = false,
  }) {
    return _baseStyle(
      size: title3Size,
      weight: weight,
      fontStyle: fontStyle,
      smallCaps: smallCaps,
      monospacedDigits: monospacedDigits,
    );
  }

  static TextStyle headline({
    FontWeight weight = FontWeight.w600,
    FontStyle? fontStyle,
    bool? smallCaps,
    bool monospacedDigits = false,
  }) {
    return _baseStyle(
      size: headlineSize,
      weight: weight,
      fontStyle: fontStyle,
      smallCaps: smallCaps,
      monospacedDigits: monospacedDigits,
    );
  }

  static TextStyle body({
    FontWeight weight = FontWeight.normal,
    FontStyle? fontStyle,
    bool? smallCaps,
    bool monospacedDigits = false,
  }) {
    return _baseStyle(
      size: bodySize,
      weight: weight,
      fontStyle: fontStyle,
      smallCaps: smallCaps,
      monospacedDigits: monospacedDigits,
    );
  }
}