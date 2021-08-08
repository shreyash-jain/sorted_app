import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/global/models/health_profile.dart';

class MindfulGoals extends Equatable {
  int goal_control_anger;
  int goal_reduce_stress;
  int goal_sleep_more;
  int goal_control_thoughts;
  int goal_live_in_present;
  int goal_improve_will_power;
  int goal_overcome_addiction;
  MindfulGoals({
    this.goal_control_anger = 0,
    this.goal_reduce_stress = 0,
    this.goal_sleep_more = 0,
    this.goal_control_thoughts = 0,
    this.goal_live_in_present = 0,
    this.goal_improve_will_power = 0,
    this.goal_overcome_addiction = 0,
  });

  MindfulGoals copyWith({
    int goal_control_anger,
    int goal_reduce_stress,
    int goal_sleep_more,
    int goal_control_thoughts,
    int goal_live_in_present,
    int goal_improve_will_power,
    int goal_overcome_addiction,
  }) {
    return MindfulGoals(
      goal_control_anger: goal_control_anger ?? this.goal_control_anger,
      goal_reduce_stress: goal_reduce_stress ?? this.goal_reduce_stress,
      goal_sleep_more: goal_sleep_more ?? this.goal_sleep_more,
      goal_control_thoughts:
          goal_control_thoughts ?? this.goal_control_thoughts,
      goal_live_in_present: goal_live_in_present ?? this.goal_live_in_present,
      goal_improve_will_power:
          goal_improve_will_power ?? this.goal_improve_will_power,
      goal_overcome_addiction:
          goal_overcome_addiction ?? this.goal_overcome_addiction,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goal_control_anger': goal_control_anger,
      'goal_reduce_stress': goal_reduce_stress,
      'goal_sleep_more': goal_sleep_more,
      'goal_control_thoughts': goal_control_thoughts,
      'goal_live_in_present': goal_live_in_present,
      'goal_improve_will_power': goal_improve_will_power,
      'goal_overcome_addiction': goal_overcome_addiction,
    };
  }

  factory MindfulGoals.fromMap(Map<String, dynamic> map) {
    return MindfulGoals(
      goal_control_anger: map['goal_control_anger'] ?? 0,
      goal_reduce_stress: map['goal_reduce_stress'] ?? 0,
      goal_sleep_more: map['goal_sleep_more'] ?? 0,
      goal_control_thoughts: map['goal_control_thoughts'] ?? 0,
      goal_live_in_present: map['goal_live_in_present'] ?? 0,
      goal_improve_will_power: map['goal_improve_will_power'] ?? 0,
      goal_overcome_addiction: map['goal_overcome_addiction'] ?? 0,
    );
  }

  factory MindfulGoals.fromHealthProfile(HealthProfile healthProfile) {
    return MindfulGoals(
        goal_control_anger: healthProfile.goal_control_anger ?? 0,
        goal_reduce_stress: healthProfile.goal_reduce_stress ?? 0,
        goal_sleep_more: healthProfile.goal_sleep_more ?? 0,
        goal_control_thoughts: healthProfile.goal_control_thoughts ?? 0,
        goal_live_in_present: healthProfile.goal_live_in_present ?? 0,
        goal_improve_will_power: healthProfile.goal_improve_will_power ?? 0,
        goal_overcome_addiction: healthProfile.goal_overcome_addiction ?? 0);
  }

  HealthProfile updateHealthProfile(
      MindfulGoals fitnessGoals, HealthProfile healthProfile) {
    return healthProfile.copyWith(
        goal_control_anger: healthProfile.goal_control_anger ?? 0,
        goal_reduce_stress: healthProfile.goal_reduce_stress ?? 0,
        goal_sleep_more: healthProfile.goal_sleep_more ?? 0,
        goal_control_thoughts: healthProfile.goal_control_thoughts ?? 0,
        goal_live_in_present: healthProfile.goal_live_in_present ?? 0,
        goal_improve_will_power: healthProfile.goal_improve_will_power ?? 0,
        goal_overcome_addiction: healthProfile.goal_overcome_addiction ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory MindfulGoals.fromJson(String source) =>
      MindfulGoals.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      goal_control_anger,
      goal_reduce_stress,
      goal_sleep_more,
      goal_control_thoughts,
      goal_live_in_present,
      goal_improve_will_power,
      goal_overcome_addiction,
    ];
  }
}
