import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

@JsonSerializable()
class Recipe {
  final int id;
  final String title;
  final String image;
  @JsonKey(name: 'readyInMinutes', defaultValue: 30)
  final int readyInMinutes;
  @JsonKey(defaultValue: 4)
  final int servings;
  @JsonKey(defaultValue: 50.0)
  final double healthScore;
  @JsonKey(defaultValue: 0.0)
  final double calories;
  @JsonKey(defaultValue: 0.0)
  final double protein;
  @JsonKey(defaultValue: 0.0)
  final double carbs;
  @JsonKey(defaultValue: 0.0)
  final double fat;
  @JsonKey(defaultValue: 0.0)
  final double fiber;
  @JsonKey(defaultValue: [])
  final List<String> ingredients;
  @JsonKey(defaultValue: [])
  final List<String> instructions;
  @JsonKey(defaultValue: [])
  final List<String> cuisines;
  @JsonKey(defaultValue: [])
  final List<String> dishTypes;
  @JsonKey(defaultValue: [])
  final List<String> diets;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.healthScore,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.ingredients,
    required this.instructions,
    required this.cuisines,
    required this.dishTypes,
    required this.diets,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  bool isSuitableForMealType(String mealType) {
    final lowerMealType = mealType.toLowerCase();
    final lowerDishTypes = dishTypes.map((t) => t.toLowerCase()).toList();

    switch (lowerMealType) {
      case 'kahvaltı':
        return lowerDishTypes
            .any((t) => t.contains('breakfast') || t.contains('kahvaltı'));
      case 'öğle yemeği':
        return lowerDishTypes.any((t) =>
            t.contains('lunch') ||
            t.contains('main course') ||
            t.contains('öğle'));
      case 'akşam yemeği':
        return lowerDishTypes.any((t) =>
            t.contains('dinner') ||
            t.contains('main course') ||
            t.contains('akşam'));
      case 'atıştırmalık':
        return lowerDishTypes.any((t) =>
            t.contains('snack') ||
            t.contains('appetizer') ||
            t.contains('atıştırmalık'));
      default:
        return true;
    }
  }

  bool isSuitableForMode(String mode) {
    final lowerMode = mode.toLowerCase();

    switch (lowerMode) {
      case 'pratik':
        return readyInMinutes <= 30;
      case 'sağlıklı':
        return healthScore >= 70;
      case 'spor':
        return protein >= 20;
      case 'kültür':
        return cuisines.any((c) =>
            c.toLowerCase().contains('turkish') ||
            c.toLowerCase().contains('mediterranean'));
      case 'diyet':
        return healthScore >= 70 && calories < 500;
      default:
        return true;
    }
  }

  bool isSuitableForEnvironment(String environment) {
    final lowerEnv = environment.toLowerCase();

    switch (lowerEnv) {
      case 'evde':
        return true;
      case 'işyerinde':
        return readyInMinutes <= 45 &&
            !instructions.any((step) =>
                step.toLowerCase().contains('fırın') ||
                step.toLowerCase().contains('oven'));
      case 'dışarıda':
        return true;
      default:
        return true;
    }
  }
}
