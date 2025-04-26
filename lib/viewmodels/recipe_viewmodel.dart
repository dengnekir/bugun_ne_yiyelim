import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeViewModel extends ChangeNotifier {
  final RecipeService _recipeService;
  List<Recipe> recipes = [];
  bool isLoading = false;
  String error = '';

  RecipeViewModel() : _recipeService = RecipeService();

  Future<void> getRandomRecipes({int number = 10}) async {
    try {
      isLoading = true;
      error = '';
      notifyListeners();

      recipes = await _recipeService.getRandomRecipes(number: number);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchRecipes({
    required String query,
    int number = 10,
    String cuisine = '',
    String diet = '',
    String type = '',
  }) async {
    try {
      isLoading = true;
      error = '';
      notifyListeners();

      recipes = await _recipeService.searchRecipes(
        query: query,
        number: number,
        cuisine: cuisine,
        diet: diet,
        type: type,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Recipe?> getRecipeDetails(int recipeId) async {
    try {
      isLoading = true;
      error = '';
      notifyListeners();

      final recipe = await _recipeService.getRecipeDetails(recipeId);
      return recipe;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Recipe>> getSuggestedRecipes({
    required String mealType,
    required String mode,
    required String environment,
    int number = 20, // Daha fazla tarif alıp filtreleyeceğiz
  }) async {
    try {
      isLoading = true;
      error = '';
      notifyListeners();

      // API'den tarifleri al
      final allRecipes = await _recipeService.getRandomRecipes(number: number);

      // Tarifleri filtrele
      final filteredRecipes = allRecipes
          .where((recipe) =>
              recipe.isSuitableForMealType(mealType) &&
              recipe.isSuitableForMode(mode) &&
              recipe.isSuitableForEnvironment(environment))
          .toList();

      // Eğer filtrelenmiş tarif sayısı çok azsa, yeni tarifler al
      if (filteredRecipes.length < 3 && recipes.length < 60) {
        final newRecipes =
            await _recipeService.getRandomRecipes(number: number);
        filteredRecipes.addAll(newRecipes.where((recipe) =>
            recipe.isSuitableForMealType(mealType) &&
            recipe.isSuitableForMode(mode) &&
            recipe.isSuitableForEnvironment(environment)));
      }

      // Sonuçları karıştır ve en fazla 5 tarif döndür
      filteredRecipes.shuffle();
      recipes = filteredRecipes.take(5).toList();

      return recipes;
    } catch (e) {
      error = e.toString();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
