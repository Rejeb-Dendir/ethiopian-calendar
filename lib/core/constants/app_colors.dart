import 'package:flutter/material.dart';

/// Centralized color palette inspired by the Ethiopian flag.
///
/// Keeping colors in one place makes theme updates predictable and
/// prevents scattered hard-coded values across widgets.
abstract final class AppColors {
  static const Color primaryGreen = Color(0xFF078930);
  static const Color accentYellow = Color(0xFFFCDD09);
  static const Color accentRed = Color(0xFFDA121A);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color onSurfaceVariant = Color(0xFF5F6368);
  static const Color divider = Color(0xFFE8EAED);
}
