import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  bool _isDarkMode = false;
  MaterialColor _primaryColor = Colors.blue;

  bool get isDarkMode => _isDarkMode;
  MaterialColor get primaryColor => _primaryColor;

  ThemeData get themeData {
    return ThemeData(
      primarySwatch: _primaryColor,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void changePrimaryColor(MaterialColor color) {
    _primaryColor = color;
    notifyListeners();
  }
}
