import 'dart:convert';

import 'package:equatable/equatable.dart';

class DietLogSettings extends Equatable {
  double calorie_goal;
  double calorie_goal_type;
  double protien_goal;
  double protien_goal_type;
  DietLogSettings({
    this.calorie_goal = 0.0,
    this.calorie_goal_type = 0.0,
    this.protien_goal = 0.0,
    this.protien_goal_type = 0.0,
  });

  DietLogSettings copyWith({
    double calorie_goal,
    double calorie_goal_type,
    double protien_goal,
    double protien_goal_type,
  }) {
    return DietLogSettings(
      calorie_goal: calorie_goal ?? this.calorie_goal,
      calorie_goal_type: calorie_goal_type ?? this.calorie_goal_type,
      protien_goal: protien_goal ?? this.protien_goal,
      protien_goal_type: protien_goal_type ?? this.protien_goal_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calorie_goal': calorie_goal,
      'calorie_goal_type': calorie_goal_type,
      'protien_goal': protien_goal,
      'protien_goal_type': protien_goal_type,
    };
  }

  factory DietLogSettings.fromMap(Map<String, dynamic> map) {
    return DietLogSettings(
      calorie_goal: map['calorie_goal'] ?? 0.0,
      calorie_goal_type: map['calorie_goal_type'] ?? 0.0,
      protien_goal: map['protien_goal'] ?? 0.0,
      protien_goal_type: map['protien_goal_type'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DietLogSettings.fromJson(String source) => DietLogSettings.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [calorie_goal, calorie_goal_type, protien_goal, protien_goal_type];
}
