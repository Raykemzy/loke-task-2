import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  bool get isSmallScreen {
    double screenWidth = MediaQuery.of(this).size.width;
    return screenWidth < 600;
  }
}