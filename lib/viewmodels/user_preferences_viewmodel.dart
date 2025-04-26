import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bugun_ne_yiyelim/models/user_preferences.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';

class UserPreferencesViewModel extends ChangeNotifier {
  late SharedPreferences _prefs;
  UserPreferences? _userPreferences;
  bool _isLoading = true;
  final Set<String> _favoriteFoodIds = {};

  UserPreferences? get userPreferences => _userPreferences;
  bool get isLoading => _isLoading;
  Set<String> get favoriteFoodIds => _favoriteFoodIds;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadPreferences();
    _loadFavorites();
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

  void _loadFavorites() {
    final favorites = _prefs.getStringList('favorites') ?? [];
    _favoriteFoodIds.addAll(favorites);
    notifyListeners();
  }

  void _saveFavorites() {
    _prefs.setStringList('favorites', _favoriteFoodIds.toList());
  }

  bool isFavorite(String foodId) {
    return _favoriteFoodIds.contains(foodId);
  }

  void toggleFavorite(String foodId) {
    if (_favoriteFoodIds.contains(foodId)) {
      _favoriteFoodIds.remove(foodId);
    } else {
      _favoriteFoodIds.add(foodId);
    }
    _saveFavorites();
    notifyListeners();
  }
}
