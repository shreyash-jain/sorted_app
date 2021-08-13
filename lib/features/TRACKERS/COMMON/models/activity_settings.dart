import 'dart:convert';

import 'package:equatable/equatable.dart';

class ActivityLogSettings extends Equatable {
  double calorie_burn_goal;
  ActivityLogSettings({
    this.calorie_burn_goal = 0.0,
  });

  ActivityLogSettings copyWith({
    double calorie_burn_goal,
  }) {
    return ActivityLogSettings(
      calorie_burn_goal: calorie_burn_goal ?? this.calorie_burn_goal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calorie_burn_goal': calorie_burn_goal,
    };
  }

  factory ActivityLogSettings.fromMap(Map<String, dynamic> map) {
    return ActivityLogSettings(
      calorie_burn_goal: map['calorie_burn_goal'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityLogSettings.fromJson(String source) =>
      ActivityLogSettings.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [calorie_burn_goal];
}
