import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/global/models/health_profile.dart';

class FitnessGoals extends Equatable {
  int goal_stay_fit;
  int goal_gain_muscle;
  int goal_loose_weight;
  int goal_get_more_active;
  FitnessGoals({
    this.goal_stay_fit = 0,
    this.goal_gain_muscle = 0,
    this.goal_loose_weight = 0,
    this.goal_get_more_active = 0,
  });

  FitnessGoals copyWith({
    int goal_stay_fit,
    int goal_gain_muscle,
    int goal_loose_weight,
    int goal_get_more_active,
  }) {
    return FitnessGoals(
      goal_stay_fit: goal_stay_fit ?? this.goal_stay_fit,
      goal_gain_muscle: goal_gain_muscle ?? this.goal_gain_muscle,
      goal_loose_weight: goal_loose_weight ?? this.goal_loose_weight,
      goal_get_more_active: goal_get_more_active ?? this.goal_get_more_active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goal_stay_fit': goal_stay_fit,
      'goal_gain_muscle': goal_gain_muscle,
      'goal_loose_weight': goal_loose_weight,
      'goal_get_more_active': goal_get_more_active,
    };
  }

  factory FitnessGoals.fromMap(Map<String, dynamic> map) {
    return FitnessGoals(
      goal_stay_fit: map['goal_stay_fit'] ?? 0,
      goal_gain_muscle: map['goal_gain_muscle'] ?? 0,
      goal_loose_weight: map['goal_loose_weight'] ?? 0,
      goal_get_more_active: map['goal_get_more_active'] ?? 0,
    );
  }

  factory FitnessGoals.fromHealthProfile(HealthProfile healthProfile) {
    return FitnessGoals(
      goal_stay_fit: healthProfile.goal_stay_fit ?? 0,
      goal_gain_muscle: healthProfile.goal_gain_muscle ?? 0,
      goal_loose_weight: healthProfile.goal_loose_weight ?? 0,
      goal_get_more_active: healthProfile.goal_get_more_active ?? 0,
    );
  }

  HealthProfile updateHealthProfile(
      FitnessGoals fitnessGoals, HealthProfile healthProfile) {
    return healthProfile.copyWith(
      goal_stay_fit: healthProfile.goal_stay_fit ?? 0,
      goal_gain_muscle: healthProfile.goal_gain_muscle ?? 0,
      goal_loose_weight: healthProfile.goal_loose_weight ?? 0,
      goal_get_more_active: healthProfile.goal_get_more_active ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FitnessGoals.fromJson(String source) =>
      FitnessGoals.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        goal_stay_fit,
        goal_gain_muscle,
        goal_loose_weight,
        goal_get_more_active
      ];
}
