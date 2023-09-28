import 'package:flutter/material.dart';

class UI with ChangeNotifier {
  bool isDark = false;

  set setDarkMode(newValue) {
    isDark = newValue;
    notifyListeners();
  }

  bool get darkMode => isDark;
}
