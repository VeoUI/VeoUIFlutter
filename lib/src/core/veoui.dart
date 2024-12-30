import 'package:flutter/material.dart';

class VeoUI {

  static Color primaryColor = HexColor("#1abc9c");
  static Color primaryDarkColor = HexColor("#16a085");
  static Color? secondaryColor;
  static Color? tertiaryColor;
  static Color successColor = HexColor("#2ecc71");
  static Color infoColor = HexColor("#3498db");
  static Color warningColor = HexColor("#f1c40f");
  static Color dangerColor = HexColor("#e74c3c");

  static bool isDarkMode = false;

  static String mainFont = "SFUI";
  static String? lightFont;
  static String? regularFont;
  static String? mediumFont;
  static String? boldFont;
  static String? italicFont;

  static double defaultCornerRadius = 24;
  static double defaultElevation = 2;
  static bool isRTL = false;

  static void configure({
    Color? primaryColor,
    Color? primaryDarkColor,
    Color? secondaryColor,
    Color? infoColor,
    Color? warningColor,
    Color? dangerColor,
    Color? tertiaryColor,
    bool? isRTL,
    String? mainFont,
    String? lightFont,
    String? regularFont,
    String? mediumFont,
    String? boldFont,
    String? italicFont,
    bool? isDarkMode,
    double? defaultCornerRadius,
    double? defaultElevation,
  }) {
    if (primaryColor != null) VeoUI.primaryColor = primaryColor;
    if (primaryDarkColor != null) VeoUI.primaryDarkColor = primaryDarkColor;
    if (secondaryColor != null) VeoUI.secondaryColor = secondaryColor;
    if (infoColor != null) VeoUI.infoColor = infoColor;
    if (warningColor != null) VeoUI.warningColor = warningColor;
    if (dangerColor != null) VeoUI.dangerColor = dangerColor;
    if (tertiaryColor != null) VeoUI.tertiaryColor = tertiaryColor;
    if (mainFont != null) VeoUI.mainFont = mainFont;
    if (lightFont != null) VeoUI.lightFont = lightFont;
    if (regularFont != null) VeoUI.regularFont = regularFont;
    if (mediumFont != null) VeoUI.mediumFont = mediumFont;
    if (italicFont != null) VeoUI.italicFont = italicFont;
    if (boldFont != null) VeoUI.boldFont = boldFont;
    if (isDarkMode != null) VeoUI.isDarkMode = isDarkMode;
    if (defaultCornerRadius != null) VeoUI.defaultCornerRadius = defaultCornerRadius;
    if (defaultElevation != null) VeoUI.defaultElevation = defaultElevation;
    if (isRTL != null) VeoUI.isRTL = isRTL;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}