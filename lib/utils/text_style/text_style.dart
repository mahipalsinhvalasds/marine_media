// ignore_for_file: implementation_imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:google_fonts/google_fonts.dart';

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';

  String get allInCaps => toUpperCase();

  String get capitalizeFirstofEach => split(
    " ",
  ).map((str) => str[0].toUpperCase() + str.substring(1)).join(" ");
}

class CommonStyle {
  static const double headerFontSize = 23;

  static TextStyle getRalewayFont({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double? height,
    List<Shadow>? shadows,
    double? letterSpacing,
    MaterialColor? decorationColor,
  }) {
    return GoogleFonts.raleway(
      textStyle: TextStyle(
        color: color  ?? Colors.white,
        letterSpacing: letterSpacing ?? 0.3,
        decoration: decoration ?? TextDecoration.none,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle ?? FontStyle.normal,
        decorationColor: decorationColor,
        height: height,
        shadows: shadows,
      ),
    );
  }

  // static TextStyle getPtSansFont({
  //   Color? color,
  //   double? fontSize,
  //   FontWeight? fontWeight,
  //   FontStyle? fontStyle,
  //   TextDecoration? decoration,
  //   double? height,
  //   List<Shadow>? shadows,
  //   double? letterSpacing,
  //   MaterialColor? decorationColor,
  // }) {
  //   return GoogleFonts.ptSans(
  //     textStyle: TextStyle(
  //       color: color ?? Colors.white,
  //       letterSpacing: letterSpacing ?? 0.3,
  //       decoration: decoration ?? TextDecoration.none,
  //       fontSize: fontSize,
  //       fontWeight: fontWeight,
  //       fontStyle: fontStyle ?? FontStyle.normal,
  //       decorationColor: decorationColor,
  //       height: height,
  //       shadows: shadows,
  //     ),
  //   );
  // }
}
