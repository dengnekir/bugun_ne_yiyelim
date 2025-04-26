import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bugun_ne_yiyelim/models/user_preferences.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';

class UserPreferencesViewModel extends ChangeNotifier {
  late SharedPreferences _prefs;
  UserPreferences? _userPreferences;
  bool _isLoading = true;

  UserPreferences? get userPreferences => _userPreferences;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadPreferences();
  }

  void _loadPreferences() {
    final String? prefsJson = _prefs.getString(AppConstants.keyUserPreferences);
    if (prefsJson != null) {
      _userPreferences = UserPreferences.fromJson(jsonDecode(prefsJson));
    } else {
      _userPreferences = UserPreferences(
        preferredEnvironment: AppConstants.environmentHome,
        preferredMealType: AppConstants.mealTypeLunch,
        preferredMode: AppConstants.modeNormal,
        notificationsEnabled: true,
        favoriteFoodIds: [],
      );
      _savePreferences();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    if (_userPreferences != null) {
      await _prefs.setString(
        AppConstants.keyUserPreferences,
        jsonEncode(_userPreferences!.toJson()),
      );
    }
  }

  Future<void> updatePreferences({
    String? environment,
    String? mealType,
    String? mode,
    bool? notifications,
  }) async {
    if (_userPreferences == null) return;

    _userPreferences = _userPreferences!.copyWith(
      preferredEnvironment: environment,
      preferredMealType: mealType,
      preferredMode: mode,
      notificationsEnabled: notifications,
    );

    await _savePreferences();
    notifyListeners();
  }

  Future<void> toggleFavorite(String foodId) async {
    if (_userPreferences == null) return;

    List<String> updatedFavorites =
        List.from(_userPreferences!.favoriteFoodIds);
    if (updatedFavorites.contains(foodId)) {
      updatedFavorites.remove(foodId);
    } else {
      updatedFavorites.add(foodId);
    }

    _userPreferences = _userPreferences!.copyWith(
      favoriteFoodIds: updatedFavorites,
    );

    await _savePreferences();
    notifyListeners();
  }

  bool isFavorite(String foodId) {
    return _userPreferences?.favoriteFoodIds.contains(foodId) ?? false;
  }
}
