import 'package:flutter/material.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';

class ThemeViewModel extends ChangeNotifier {
  String _currentMode = AppConstants.modeNormal;

  String get currentMode => _currentMode;
  Color get currentModeColor =>
      AppTheme.modeColors[_currentMode] ?? AppTheme.primaryColor;

  void updateMode(String mode) {
    _currentMode = mode;
    notifyListeners();
  }
}
