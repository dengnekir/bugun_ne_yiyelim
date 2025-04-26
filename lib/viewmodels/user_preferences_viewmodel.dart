import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bugun_ne_yiyelim/models/user_preferences.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';

class UserPreferencesViewModel extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _favoriteIdsKey = 'favoriteIds';
  static const String _dailyNotificationsKey = 'dailyNotifications';
  static const String _specialDayNotificationsKey = 'specialDayNotifications';

  UserPreferences? _userPreferences;
  bool _isLoading = true;
  Set<String> _favoriteIds = {};
  bool _dailyNotifications = true;
  bool _specialDayNotifications = true;

  UserPreferencesViewModel(this._prefs) {
    _loadPreferences();
  }

  UserPreferences? get userPreferences => _userPreferences;
  bool get isLoading => _isLoading;
  Set<String> get favoriteIds => _favoriteIds;
  bool get dailyNotifications => _dailyNotifications;
  bool get specialDayNotifications => _specialDayNotifications;

  Future<void> initialize() async {
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

    final favoriteIdsString = _prefs.getStringList(_favoriteIdsKey);
    if (favoriteIdsString != null) {
      _favoriteIds = Set<String>.from(favoriteIdsString);
    }

    _dailyNotifications = _prefs.getBool(_dailyNotificationsKey) ?? true;
    _specialDayNotifications =
        _prefs.getBool(_specialDayNotificationsKey) ?? true;
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
    _favoriteIds.addAll(favorites);
    notifyListeners();
  }

  void _saveFavorites() {
    _prefs.setStringList('favorites', _favoriteIds.toList());
  }

  bool isFavorite(String foodId) {
    return _favoriteIds.contains(foodId);
  }

  Future<void> toggleFavorite(String foodId) async {
    if (_favoriteIds.contains(foodId)) {
      _favoriteIds.remove(foodId);
    } else {
      _favoriteIds.add(foodId);
    }
    await _prefs.setStringList(_favoriteIdsKey, _favoriteIds.toList());
    notifyListeners();
  }

  Future<void> updateDailyNotifications(bool value) async {
    _dailyNotifications = value;
    await _prefs.setBool(_dailyNotificationsKey, value);
    notifyListeners();
  }

  Future<void> updateSpecialDayNotifications(bool value) async {
    _specialDayNotifications = value;
    await _prefs.setBool(_specialDayNotificationsKey, value);
    notifyListeners();
  }
}
