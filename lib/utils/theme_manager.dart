import 'package:flutter/material.dart';

/// Manages the theme settings for the application.
class ThemeManager with ChangeNotifier {
  bool _isDarkMode = false;
  MaterialColor _primaryColor = Colors.blue;

  bool get isDarkMode => _isDarkMode;
  MaterialColor get primaryColor => _primaryColor;

  /// Returns the current ThemeData based on the dark mode and primary color settings.
  ThemeData get themeData {
    return ThemeData(
      primarySwatch: _primaryColor,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    );
  }

  /// Toggles between light and dark mode.
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  /// Changes the primary color of the theme.
  void changePrimaryColor(MaterialColor color) {
    _primaryColor = color;
    notifyListeners();
  }
}
