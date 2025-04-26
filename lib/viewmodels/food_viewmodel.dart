import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bugun_ne_yiyelim/models/food.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';

class FoodViewModel extends ChangeNotifier {
  List<Food> _allFoods = [];
  List<Food> _filteredFoods = [];
  bool _isLoading = true;

  List<Food> get allFoods => _allFoods;
  List<Food> get filteredFoods => _filteredFoods;
  bool get isLoading => _isLoading;

  FoodViewModel() {
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/data/foods.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> foodList = jsonData['foods'];

      _allFoods = foodList.map((json) => Food.fromJson(json)).toList();
      _filteredFoods = List.from(_allFoods);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Yemek verileri yüklenirken hata oluştu: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterFoods({
    required String environment,
    required String mealType,
    required String mode,
  }) {
    _filteredFoods = _allFoods.where((food) {
      bool matchesMode = true;
      switch (mode) {
        case AppConstants.modeSports:
          matchesMode = food.isHighProtein;
          break;
        case AppConstants.modeDiet:
          matchesMode = food.isLowCalorie;
          break;
        case AppConstants.modeCulture:
          matchesMode = food.culture.isNotEmpty;
          break;
      }

      return matchesMode && food.mealType == mealType;
    }).toList();

    notifyListeners();
  }

  List<Food> getFavorites(List<String> favoriteIds) {
    return _allFoods.where((food) => favoriteIds.contains(food.id)).toList();
  }

  Food? getRandomFood() {
    if (_filteredFoods.isEmpty) return null;
    final random = Random();
    return _filteredFoods[random.nextInt(_filteredFoods.length)];
  }
}
