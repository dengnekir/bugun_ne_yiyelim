// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      preferredEnvironment: json['preferredEnvironment'] as String,
      preferredMealType: json['preferredMealType'] as String,
      preferredMode: json['preferredMode'] as String,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      favoriteFoodIds: (json['favoriteFoodIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'preferredEnvironment': instance.preferredEnvironment,
      'preferredMealType': instance.preferredMealType,
      'preferredMode': instance.preferredMode,
      'notificationsEnabled': instance.notificationsEnabled,
      'favoriteFoodIds': instance.favoriteFoodIds,
    };
