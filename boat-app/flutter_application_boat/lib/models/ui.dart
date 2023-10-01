import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UI with ChangeNotifier {
  final bool _isDark = false;
  GoogleSignInAccount? _account;
  set isDark(newValue) {
    isDark = newValue;
    notifyListeners();
  }

  set account(newValue) {
    _account = newValue;
    notifyListeners();
  }

  bool get darkMode => _isDark;
  GoogleSignInAccount? get account => _account;
}
