// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Food _$FoodFromJson(Map<String, dynamic> json) => Food(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recipe:
          (json['recipe'] as List<dynamic>).map((e) => e as String).toList(),
      category: json['category'] as String,
      culture: json['culture'] as String,
      mode: json['mode'] as String,
      mealType: json['mealType'] as String,
      environment: json['environment'] as String,
      isQuick: json['isQuick'] as bool,
      isHealthy: json['isHealthy'] as bool,
      isHighProtein: json['isHighProtein'] as bool,
      isLowCalorie: json['isLowCalorie'] as bool,
      preparationTime: (json['preparationTime'] as num).toInt(),
      calories: Food._doubleFromJson(json['calories']),
      servings: (json['servings'] as num).toInt(),
      protein: Food._doubleFromJson(json['protein']),
      carbs: Food._doubleFromJson(json['carbs']),
      fat: Food._doubleFromJson(json['fat']),
      fiber: Food._doubleFromJson(json['fiber']),
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'recipe': instance.recipe,
      'category': instance.category,
      'culture': instance.culture,
      'mode': instance.mode,
      'mealType': instance.mealType,
      'environment': instance.environment,
      'isQuick': instance.isQuick,
      'isHealthy': instance.isHealthy,
      'isHighProtein': instance.isHighProtein,
      'isLowCalorie': instance.isLowCalorie,
      'preparationTime': instance.preparationTime,
      'calories': Food._doubleToJson(instance.calories),
      'servings': instance.servings,
      'protein': Food._doubleToJson(instance.protein),
      'carbs': Food._doubleToJson(instance.carbs),
      'fat': Food._doubleToJson(instance.fat),
      'fiber': Food._doubleToJson(instance.fiber),
      'imageUrl': instance.imageUrl,
    };
