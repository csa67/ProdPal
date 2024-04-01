import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // Color scheme
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.orange;

  // Text styles
  static final TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static final TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

// Add more styles as needed
}
