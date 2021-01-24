import 'dart:convert';

import 'package:equatable/equatable.dart';

class PhysicalHealthProfile extends Equatable {
  double weight_kg;
  int weight_unit;
  double height_cm;
  int height_unit;
  int is_w_h_private;

  int do_walk;
  int ride_cycle;
  int do_exercise;
  int do_yoga;
  int play_sports;
  int do_dance;

  int is_health_activity_private;

  int have_health_condition;
  int goal_stay_fit;
  int goal_gain_muscle;
  int goal_loose_weight;
  int goal_get_more_active;

  int make_goal_private;
  double target_weight_kg;
  PhysicalHealthProfile({
    this.weight_kg = 0.0,
    this.weight_unit = 0,
    this.height_cm = 0.0,
    this.height_unit = 0,
    this.is_w_h_private = 0,
    this.do_walk = 0,
    this.ride_cycle = 0,
    this.do_exercise = 0,
    this.do_yoga = 0,
    this.play_sports = 0,
    this.do_dance = 0,
    this.is_health_activity_private = 0,
    this.have_health_condition = 0,
    this.goal_stay_fit = 0,
    this.goal_gain_muscle = 0,
    this.goal_loose_weight = 0,
    this.goal_get_more_active = 0,
    this.make_goal_private = 0,
    this.target_weight_kg = 0.0,
  });

  PhysicalHealthProfile copyWith({
    double weight_kg,
    int weight_unit,
    double height_cm,
    int height_unit,
    int is_w_h_private,
    int do_walk,
    int ride_cycle,
    int do_exercise,
    int do_yoga,
    int play_sports,
    int do_dance,
    int is_health_activity_private,
    int have_health_condition,
    int goal_stay_fit,
    int goal_gain_muscle,
    int goal_loose_weight,
    int goal_get_more_active,
    int make_goal_private,
    double target_weight_kg,
  }) {
    return PhysicalHealthProfile(
      weight_kg: weight_kg ?? this.weight_kg,
      weight_unit: weight_unit ?? this.weight_unit,
      height_cm: height_cm ?? this.height_cm,
      height_unit: height_unit ?? this.height_unit,
      is_w_h_private: is_w_h_private ?? this.is_w_h_private,
      do_walk: do_walk ?? this.do_walk,
      ride_cycle: ride_cycle ?? this.ride_cycle,
      do_exercise: do_exercise ?? this.do_exercise,
      do_yoga: do_yoga ?? this.do_yoga,
      play_sports: play_sports ?? this.play_sports,
      do_dance: do_dance ?? this.do_dance,
      is_health_activity_private:
          is_health_activity_private ?? this.is_health_activity_private,
      have_health_condition:
          have_health_condition ?? this.have_health_condition,
      goal_stay_fit: goal_stay_fit ?? this.goal_stay_fit,
      goal_gain_muscle: goal_gain_muscle ?? this.goal_gain_muscle,
      goal_loose_weight: goal_loose_weight ?? this.goal_loose_weight,
      goal_get_more_active: goal_get_more_active ?? this.goal_get_more_active,
      make_goal_private: make_goal_private ?? this.make_goal_private,
      target_weight_kg: target_weight_kg ?? this.target_weight_kg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weight_kg': weight_kg,
      'weight_unit': weight_unit,
      'height_cm': height_cm,
      'height_unit': height_unit,
      'is_w_h_private': is_w_h_private,
      'do_walk': do_walk,
      'ride_cycle': ride_cycle,
      'do_exercise': do_exercise,
      'do_yoga': do_yoga,
      'play_sports': play_sports,
      'do_dance': do_dance,
      'is_health_activity_private': is_health_activity_private,
      'have_health_condition': have_health_condition,
      'goal_stay_fit': goal_stay_fit,
      'goal_gain_muscle': goal_gain_muscle,
      'goal_loose_weight': goal_loose_weight,
      'goal_get_more_active': goal_get_more_active,
      'make_goal_private': make_goal_private,
      'target_weight_kg': target_weight_kg,
    };
  }

  factory PhysicalHealthProfile.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PhysicalHealthProfile(
      weight_kg: map['weight_kg'],
      weight_unit: map['weight_unit'],
      height_cm: map['height_cm'],
      height_unit: map['height_unit'],
      is_w_h_private: map['is_w_h_private'],
      do_walk: map['do_walk'],
      ride_cycle: map['ride_cycle'],
      do_exercise: map['do_exercise'],
      do_yoga: map['do_yoga'],
      play_sports: map['play_sports'],
      do_dance: map['do_dance'],
      is_health_activity_private: map['is_health_activity_private'],
      have_health_condition: map['have_health_condition'],
      goal_stay_fit: map['goal_stay_fit'],
      goal_gain_muscle: map['goal_gain_muscle'],
      goal_loose_weight: map['goal_loose_weight'],
      goal_get_more_active: map['goal_get_more_active'],
      make_goal_private: map['make_goal_private'],
      target_weight_kg: map['target_weight_kg'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PhysicalHealthProfile.fromJson(String source) =>
      PhysicalHealthProfile.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      weight_kg,
      weight_unit,
      height_cm,
      height_unit,
      is_w_h_private,
      do_walk,
      ride_cycle,
      do_exercise,
      do_yoga,
      play_sports,
      do_dance,
      is_health_activity_private,
      have_health_condition,
      goal_stay_fit,
      goal_gain_muscle,
      goal_loose_weight,
      goal_get_more_active,
      make_goal_private,
      target_weight_kg,
    ];
  }
}
