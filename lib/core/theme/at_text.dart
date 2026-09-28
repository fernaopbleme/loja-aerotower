import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'at_colors.dart';

/// Caprasimo nos títulos, Figtree no corpo.
/// Corpo base 15px / line-height 1.55; títulos line-height 1.12,
/// letter-spacing -0.015em.
class AtText {
  static TextStyle heading(double size, {Color? color, double? height}) =>
      GoogleFonts.caprasimo(
        fontSize: size,
        fontWeight: FontWeight.w400,
        height: height ?? 1.12,
        letterSpacing: size * -0.015,
        color: color ?? AtColors.text,
      );

  static TextStyle body(
    double size, {
    Color? color,
    FontWeight weight = FontWeight.w400,
    double height = 1.55,
    double? letterSpacing,
  }) =>
      GoogleFonts.figtree(
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color ?? AtColors.text,
      );

  static TextStyle get h1 => heading(42);
  static TextStyle get h2 => heading(32);
  static TextStyle get h3 => heading(25);
  static TextStyle get h4 => heading(20);
  static TextStyle get h5 => heading(16);

  /// h6: 13px, uppercase, tracking 0.08em.
  static TextStyle h6({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: 13 * 0.08,
        color: color ?? AtColors.text,
      );

  static TextStyle get bodyBase => body(15);
}
