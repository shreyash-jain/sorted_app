import 'dart:convert';


import 'package:equatable/equatable.dart';
import 'package:sorted/features/PLANNER/data/models/day_workout.dart';

class WorkoutPlanEntitiy extends Equatable {
  int planLength;
  String planName;
  int id;

  int startDate;
  String planImage;
  List<DayWorkout> dayWorkouts;
  WorkoutPlanEntitiy({
    this.planLength = 0,
    this.planName = '',
    this.id = 0,
    this.startDate = 0,
    this.planImage = '',
    this.dayWorkouts = const [],
  });

  WorkoutPlanEntitiy copyWith({
    int planLength,
    String planName,
    int id,
    int startDate,
    String planImage,
    List<DayWorkout> dayWorkouts,
  }) {
    return WorkoutPlanEntitiy(
      planLength: planLength ?? this.planLength,
      planName: planName ?? this.planName,
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      planImage: planImage ?? this.planImage,
      dayWorkouts: dayWorkouts ?? this.dayWorkouts,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      planLength,
      planName,
      id,
      startDate,
      planImage,
      dayWorkouts,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'planLength': planLength,
      'planName': planName,
      'id': id,
      'startDate': startDate,
      'planImage': planImage,
      'dayWorkouts': dayWorkouts?.map((x) => x.toMap())?.toList(),
    };
  }

  factory WorkoutPlanEntitiy.fromMap(Map<String, dynamic> map) {
    return WorkoutPlanEntitiy(
      planLength: map['planLength'] ?? 0,
      planName: map['planName'] ?? '',
      id: map['id'] ?? 0,
      startDate: map['startDate'] ?? 0,
      planImage: map['planImage'] ?? '',
      dayWorkouts: List<DayWorkout>.from(map['dayWorkouts']?.map((x) => DayWorkout.fromMap(x) ?? DayWorkout()) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutPlanEntitiy.fromJson(String source) => WorkoutPlanEntitiy.fromMap(json.decode(source));
}
