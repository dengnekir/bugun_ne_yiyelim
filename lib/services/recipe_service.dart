import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/recipe_model.dart';
import '../models/food.dart';

class RecipeService {
  List<Food> _localFoods = [];
  List<Recipe> _allRecipes = [];

  RecipeService() {
    _loadLocalFoods();
  }

  Future<void> _loadLocalFoods() async {
    try {
      final String response =
          await rootBundle.loadString('lib/data/foods.json');
      final data = await json.decode(response);
      _localFoods =
          (data['foods'] as List).map((food) => Food.fromJson(food)).toList();
      print('Yerel JSON dosyasından ${_localFoods.length} tarif yüklendi');
    } catch (e) {
      print('Yerel JSON dosyası yüklenirken hata: $e');
      _localFoods = [];
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    if (_allRecipes.isEmpty) {
      _allRecipes = _localFoods
          .map((food) => Recipe(
                id: int.parse(food.id),
                title: food.name,
                image: food.imageUrl,
                readyInMinutes: food.preparationTime,
                servings: food.servings,
                healthScore: food.isHealthy ? 80 : 50,
                calories: food.calories.toDouble(),
                protein: food.protein,
                carbs: food.carbs,
                fat: food.fat,
                fiber: food.fiber,
                ingredients: food.ingredients,
                instructions: food.recipe,
                cuisines: food.culture != null ? [food.culture!] : [],
                dishTypes: food.category != null ? [food.category!] : [],
                diets: [],
              ))
          .toList();
    }
    return _allRecipes;
  }

  Future<List<Recipe>> getRecipesByMode(String mode) async {
    final recipes = await getAllRecipes();

    switch (mode.toLowerCase()) {
      case 'pratik':
        return recipes.where((recipe) => recipe.readyInMinutes <= 30).toList();
      case 'sağlıklı':
        return recipes.where((recipe) => recipe.healthScore >= 70).toList();
      case 'spor':
        return recipes.where((recipe) => recipe.protein >= 20).toList();
      case 'kültür':
        return recipes
            .where((recipe) => recipe.cuisines.any((c) =>
                c.toLowerCase().contains('turkish') ||
                c.toLowerCase().contains('mediterranean')))
            .toList();
      case 'diyet':
        return recipes
            .where(
                (recipe) => recipe.healthScore >= 70 && recipe.calories < 500)
            .toList();
      default:
        return recipes;
    }
  }

  Future<List<Recipe>> getRecipesByMealType(String mealType) async {
    final recipes = await getAllRecipes();

    switch (mealType.toLowerCase()) {
      case 'kahvaltı':
        return recipes
            .where((recipe) => recipe.dishTypes.any((type) =>
                type.toLowerCase().contains('breakfast') ||
                type.toLowerCase().contains('kahvaltı')))
            .toList();
      case 'öğle yemeği':
        return recipes
            .where((recipe) => recipe.dishTypes.any((type) =>
                type.toLowerCase().contains('lunch') ||
                type.toLowerCase().contains('main course') ||
                type.toLowerCase().contains('öğle')))
            .toList();
      case 'akşam yemeği':
        return recipes
            .where((recipe) => recipe.dishTypes.any((type) =>
                type.toLowerCase().contains('dinner') ||
                type.toLowerCase().contains('akşam')))
            .toList();
      case 'atıştırmalık':
        return recipes
            .where((recipe) => recipe.dishTypes.any((type) =>
                type.toLowerCase().contains('snack') ||
                type.toLowerCase().contains('appetizer') ||
                type.toLowerCase().contains('atıştırmalık')))
            .toList();
      default:
        return recipes;
    }
  }

  Future<List<Recipe>> searchRecipesByName(String query) async {
    final recipes = await getAllRecipes();

    if (query.isEmpty) return recipes;

    return recipes
        .where((recipe) =>
            recipe.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void clearCache() {
    _allRecipes.clear();
    _localFoods.clear();
    _loadLocalFoods();
  }
}
