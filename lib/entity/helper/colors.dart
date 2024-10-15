import 'package:flutter/material.dart';

class HColors {
  // Static method to return a primary color
  static Color primaryColor() {
    return const Color(0xFF0C7EA5);
  }

  // You can define other helper methods for different color schemes if needed
  static Color secondaryColor() {
    return const Color(0xFF0A6E90); // Example of another color
  }

  static Color accentColor() {
    return const Color(0xFFE53935); // Example of an accent color
  }

  static Color backgroundColor() {
    return Colors.teal; // Example of a background color
  }

  // You can also define color values directly as static properties
  static const Color success = Color(0xFF28A745);
  static const Color danger = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
}

final icons = [
  'assets/images/pack.png',
  'assets/images/packagegreen.png',
  'assets/images/group.png',
  'assets/images/cart2.png',
];
final List<String> titles = [
  'ផលិតផល',
  'ប្រភេទ',
  'អ្នកប្រើប្រាស់',
  'ការលក់',
];
final calendar = [
  'assets/images/event.png',
  'assets/images/calendar1.png',
  'assets/images/remove.png',
  'assets/images/calendar2.png',
  'assets/images/calendar4.png',
  'assets/images/calendar5.png',
];
final title = [
  'ថ្ងៃនេះ',
  'ខែនេះ',
  'ខែមុន',
  '3 ខែមុន',
  '6 ខែមុន',
  'ជ្រើសរើសអំឡុងពេល',
];
