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

class Cart with ChangeNotifier {
  GoogleSignInAccount? _account;
  set isDark(newValue) {
    isDark = newValue;
    notifyListeners();
  }

  set account(newValue) {
    _account = newValue;
    notifyListeners();
  }

  GoogleSignInAccount? get account => _account;
}

class SelectedDate with ChangeNotifier {
  DateTime? _fromdate;
  DateTime? _todate;

  set fromdate(DateTime newValue) {
    _fromdate = newValue;
    notifyListeners();
  }

  set todate(DateTime newValue) {
    _todate = newValue;
    notifyListeners();
  }

  DateTime? get getfromdate => _fromdate;
  DateTime? get gettodate => _todate;
}
