import 'package:flutter/foundation.dart';

class Food {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> recipe;
  final int preparationTime;
  final int calories;
  final int servings;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final String mode;
  final String mealType;
  final String environment;
  final String category;
  final String? culture;
  final bool isQuick;
  final bool isHealthy;
  final bool isHighProtein;
  final bool isLowCalorie;
  final String? imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.recipe,
    required this.preparationTime,
    required this.calories,
    required this.servings,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.mode,
    required this.mealType,
    required this.environment,
    required this.category,
    this.culture,
    required this.isQuick,
    required this.isHealthy,
    required this.isHighProtein,
    required this.isLowCalorie,
    this.imageUrl,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ingredients: List<String>.from(json['ingredients']),
      recipe: List<String>.from(json['recipe']),
      preparationTime: json['preparationTime'] as int,
      calories: json['calories'] as int,
      servings: json['servings'] as int,
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      mode: json['mode'] as String,
      mealType: json['mealType'] as String,
      environment: json['environment'] as String,
      category: json['category'] as String,
      culture: json['culture'] as String?,
      isQuick: json['isQuick'] as bool,
      isHealthy: json['isHealthy'] as bool,
      isHighProtein: json['isHighProtein'] as bool,
      isLowCalorie: json['isLowCalorie'] as bool,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'recipe': recipe,
      'preparationTime': preparationTime,
      'calories': calories,
      'servings': servings,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'mode': mode,
      'mealType': mealType,
      'environment': environment,
      'category': category,
      'culture': culture,
      'isQuick': isQuick,
      'isHealthy': isHealthy,
      'isHighProtein': isHighProtein,
      'isLowCalorie': isLowCalorie,
      'imageUrl': imageUrl,
    };
  }
}
