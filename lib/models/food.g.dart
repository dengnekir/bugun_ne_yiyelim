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
      category: json['category'] as String,
      culture: json['culture'] as String,
      mealType: json['mealType'] as String,
      isQuick: json['isQuick'] as bool,
      isHealthy: json['isHealthy'] as bool,
      isHighProtein: json['isHighProtein'] as bool,
      isLowCalorie: json['isLowCalorie'] as bool,
      preparationTime: (json['preparationTime'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'category': instance.category,
      'culture': instance.culture,
      'mealType': instance.mealType,
      'isQuick': instance.isQuick,
      'isHealthy': instance.isHealthy,
      'isHighProtein': instance.isHighProtein,
      'isLowCalorie': instance.isLowCalorie,
      'preparationTime': instance.preparationTime,
      'calories': instance.calories,
      'imageUrl': instance.imageUrl,
    };
