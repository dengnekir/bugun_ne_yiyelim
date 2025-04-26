import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable()
class Food {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final String category;
  final String culture;
  final String mealType;
  final bool isQuick;
  final bool isHealthy;
  final bool isHighProtein;
  final bool isLowCalorie;
  final int preparationTime; // dakika cinsinden
  final int calories;
  final String imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.category,
    required this.culture,
    required this.mealType,
    required this.isQuick,
    required this.isHealthy,
    required this.isHighProtein,
    required this.isLowCalorie,
    required this.preparationTime,
    required this.calories,
    required this.imageUrl,
  });

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}
