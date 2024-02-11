import 'package:flutter/material.dart';
import 'package:music_padi/themes/dark_theme.dart';
import 'package:music_padi/themes/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  //initially set light mode
  ThemeData _themeData = lightMode;

  //get theeme
  ThemeData get themeData => _themeData;

  //is dark mode
  bool get isDarkMode => _themeData == darkMode;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
