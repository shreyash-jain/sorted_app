import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/global/models/health_profile.dart';

class UserFoodPreferences extends Equatable {
  int is_vegan;
  int is_vegetarian;
  int is_keto;
  int is_sattvik;
  UserFoodPreferences({
    this.is_vegan = 0,
    this.is_vegetarian = 0,
    this.is_keto = 0,
    this.is_sattvik = 0,
  });

  UserFoodPreferences copyWith({
    int is_vegan,
    int is_vegetarian,
    int is_keto,
    int is_sattvik,
  }) {
    return UserFoodPreferences(
      is_vegan: is_vegan ?? this.is_vegan,
      is_vegetarian: is_vegetarian ?? this.is_vegetarian,
      is_keto: is_keto ?? this.is_keto,
      is_sattvik: is_sattvik ?? this.is_sattvik,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'is_vegan': is_vegan,
      'is_vegetarian': is_vegetarian,
      'is_keto': is_keto,
      'is_sattvik': is_sattvik,
    };
  }

  factory UserFoodPreferences.fromMap(Map<String, dynamic> map) {
    return UserFoodPreferences(
      is_vegan: map['is_vegan'] ?? 0,
      is_vegetarian: map['is_vegetarian'] ?? 0,
      is_keto: map['is_keto'] ?? 0,
      is_sattvik: map['is_sattvik'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserFoodPreferences.fromHealthProfile(HealthProfile healthProfile) {
    return UserFoodPreferences(
      is_vegan: healthProfile.is_vegan ?? 0,
      is_vegetarian: healthProfile.is_vegetarian ?? 0,
      is_keto: healthProfile.is_keto ?? 0,
      is_sattvik: healthProfile.is_sattvik ?? 0,
    );
  }

  HealthProfile updateHealthProfile(
      UserFoodPreferences foodPreferences, HealthProfile healthProfile) {
    return healthProfile.copyWith(
      is_vegan: healthProfile.is_vegan ?? 0,
      is_vegetarian: healthProfile.is_vegetarian ?? 0,
      is_keto: healthProfile.is_keto ?? 0,
      is_sattvik: healthProfile.is_sattvik ?? 0,
    );
  }

  factory UserFoodPreferences.fromJson(String source) =>
      UserFoodPreferences.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [is_vegan, is_vegetarian, is_keto, is_sattvik];
}
