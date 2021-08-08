import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';



class DayWorkout extends Equatable {
  int id;
  List<WorkoutModel> dayActivities;
  String dayTitle;
  String daySubTitle;
  int caloriesBurnt;
  DayWorkout({
    this.id = 0,
    this.dayActivities = const [],
    this.dayTitle = '',
    this.daySubTitle = '',
    this.caloriesBurnt = 0,
  });

  DayWorkout copyWith({
    int id,
    List<WorkoutModel> dayActivities,
    String dayTitle,
    String daySubTitle,
    int caloriesBurnt,
  }) {
    return DayWorkout(
      id: id ?? this.id,
      dayActivities: dayActivities ?? this.dayActivities,
      dayTitle: dayTitle ?? this.dayTitle,
      daySubTitle: daySubTitle ?? this.daySubTitle,
      caloriesBurnt: caloriesBurnt ?? this.caloriesBurnt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayActivities': dayActivities?.map((x) => x.toMap())?.toList(),
      'dayTitle': dayTitle,
      'daySubTitle': daySubTitle,
      'caloriesBurnt': caloriesBurnt,
    };
  }

  factory DayWorkout.fromMap(Map<String, dynamic> map) {
    return DayWorkout(
      id: map['id'] ?? 0,
      dayActivities: List<WorkoutModel>.from(map['dayActivities']
              ?.map((x) => WorkoutModel.fromMap(x) ?? WorkoutModel()) ??
          const []),
      dayTitle: map['dayTitle'] ?? '',
      daySubTitle: map['daySubTitle'] ?? '',
      caloriesBurnt: map['caloriesBurnt'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DayWorkout.fromJson(String source) =>
      DayWorkout.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      dayActivities,
      dayTitle,
      daySubTitle,
      caloriesBurnt,
    ];
  }
}


class WorkoutModel extends Equatable {
  ActivityModel activity;
  int activityType;
  List<int> sequence;
  List<int> restTime;
  WorkoutModel({
    this.activity,
    this.activityType = 0,
    this.sequence = const [],
    this.restTime = const [],
  });

  WorkoutModel copyWith({
    ActivityModel activity,
    int activityType,
    List<int> setsOrTime,
    List<int> restTime,
  }) {
    return WorkoutModel(
      activity: activity ?? this.activity,
      activityType: activityType ?? this.activityType,
      sequence: setsOrTime ?? this.sequence,
      restTime: restTime ?? this.restTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activity': activity.toMap(),
      'activityType': activityType,
      'setsOrTime': sequence,
      'restTime': restTime,
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      activity: ActivityModel.fromMap(map['activity']) ?? ActivityModel(),
      activityType: map['activityType'] ?? 0,
      sequence: List<int>.from(map['setsOrTime'] ?? const []),
      restTime: List<int>.from(map['restTime'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutModel.fromJson(String source) =>
      WorkoutModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [activity, activityType, sequence, restTime];
}
