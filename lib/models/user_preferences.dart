import 'package:json_annotation/json_annotation.dart';

part 'user_preferences.g.dart';

@JsonSerializable()
class UserPreferences {
  final String preferredEnvironment; // ev, iş, dışarı
  final String preferredMealType; // kahvaltı, öğle, akşam, atıştırmalık
  final String preferredMode; // normal, spor, diyet, kültür
  final bool notificationsEnabled;
  final List<String> favoriteFoodIds;

  UserPreferences({
    required this.preferredEnvironment,
    required this.preferredMealType,
    required this.preferredMode,
    this.notificationsEnabled = true,
    required this.favoriteFoodIds,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    String? preferredEnvironment,
    String? preferredMealType,
    String? preferredMode,
    bool? notificationsEnabled,
    List<String>? favoriteFoodIds,
  }) {
    return UserPreferences(
      preferredEnvironment: preferredEnvironment ?? this.preferredEnvironment,
      preferredMealType: preferredMealType ?? this.preferredMealType,
      preferredMode: preferredMode ?? this.preferredMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      favoriteFoodIds: favoriteFoodIds ?? this.favoriteFoodIds,
    );
  }
}
