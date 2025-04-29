// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      image: json['image'] as String,
      readyInMinutes: (json['readyInMinutes'] as num?)?.toInt() ?? 30,
      servings: (json['servings'] as num?)?.toInt() ?? 4,
      healthScore: (json['healthScore'] as num?)?.toDouble() ?? 50.0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      cuisines: (json['cuisines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      dishTypes: (json['dishTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      diets:
          (json['diets'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'readyInMinutes': instance.readyInMinutes,
      'servings': instance.servings,
      'healthScore': instance.healthScore,
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'cuisines': instance.cuisines,
      'dishTypes': instance.dishTypes,
      'diets': instance.diets,
    };
