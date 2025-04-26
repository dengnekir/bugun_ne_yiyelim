import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bugun_ne_yiyelim/models/food.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';

class FoodViewModel extends ChangeNotifier {
  final List<Food> _foods = [];
  List<Food> _filteredFoods = [];
  final Random _random = Random();
  bool _isLoading = true;

  List<Food> get foods => _foods;
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

      _foods.addAll(foodList.map((json) => Food.fromJson(json)));
      _filteredFoods = List.from(_foods);

      debugPrint('Yüklenen yemek sayısı: ${_foods.length}');
      for (var food in _foods) {
        debugPrint(
            'Yemek: ${food.name}, Mode: ${food.mode}, MealType: ${food.mealType}, Environment: ${food.environment}');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Yemek verileri yüklenirken hata oluştu: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Food> filterFoods({
    required String environment,
    required String mealType,
    required String mode,
  }) {
    print('Filtreleme başlıyor:');
    print('Seçilen ortam: $environment');
    print('Seçilen öğün: $mealType');
    print('Seçilen mod: $mode');

    if (_foods.isEmpty) {
      print('Yemek listesi boş!');
      return [];
    }

    print('Toplam yemek sayısı: ${_foods.length}');

    final filteredFoods = _foods.where((food) {
      final bool environmentMatch = food.environment == environment;
      final bool mealTypeMatch = food.mealType == mealType;
      final bool modeMatch = food.mode == mode;

      print('Yemek: ${food.name}');
      print(
          'Ortam eşleşmesi: $environmentMatch (${food.environment} == $environment)');
      print('Öğün eşleşmesi: $mealTypeMatch (${food.mealType} == $mealType)');
      print('Mod eşleşmesi: $modeMatch (${food.mode} == $mode)');

      return environmentMatch && mealTypeMatch && modeMatch;
    }).toList();

    print('Filtrelenmiş yemek sayısı: ${filteredFoods.length}');
    if (filteredFoods.isNotEmpty) {
      print('Filtrelenmiş yemekler:');
      for (var food in filteredFoods) {
        print('- ${food.name}');
      }
    }

    return filteredFoods;
  }

  Food? getRandomFood() {
    if (_filteredFoods.isEmpty) {
      debugPrint('Filtrelenmiş yemek listesi boş!');
      return null;
    }
    final selectedFood = _filteredFoods[_random.nextInt(_filteredFoods.length)];
    debugPrint('Seçilen yemek: ${selectedFood.name}');
    return selectedFood;
  }

  List<Food> getFavoriteFoods(Set<String> favoriteIds) {
    return _foods.where((food) => favoriteIds.contains(food.id)).toList();
  }

  void addFood(Food food) {
    _foods.add(food);
    notifyListeners();
  }

  void removeFood(String foodId) {
    _foods.removeWhere((food) => food.id == foodId);
    notifyListeners();
  }

  void updateFood(Food food) {
    final index = _foods.indexWhere((f) => f.id == food.id);
    if (index != -1) {
      _foods[index] = food;
      notifyListeners();
    }
  }
}
