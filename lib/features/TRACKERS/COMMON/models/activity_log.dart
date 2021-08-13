import 'dart:convert';

import 'package:equatable/equatable.dart';

class ActivityLog extends Equatable {
  int id;
  DateTime time;
  int activityId;
  String reps;
  int caloriesBurnt;
  int muscleIndex;
  ActivityLog({
    this.id = 0,
    this.time,
    this.activityId = 0,
    this.reps = '',
    this.caloriesBurnt = 0,
    this.muscleIndex = 0,
  });

  ActivityLog copyWith({
    int id,
    DateTime time,
    int activityId,
    String reps,
    int caloriesBurnt,
    int muscleIndex,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      time: time ?? this.time,
      activityId: activityId ?? this.activityId,
      reps: reps ?? this.reps,
      caloriesBurnt: caloriesBurnt ?? this.caloriesBurnt,
      muscleIndex: muscleIndex ?? this.muscleIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.millisecondsSinceEpoch,
      'activityId': activityId,
      'reps': reps,
      'caloriesBurnt': caloriesBurnt,
      'muscleIndex': muscleIndex,
    };
  }

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      id: map['id'] ?? 0,
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      activityId: map['activityId'] ?? 0,
      reps: map['reps'] ?? '',
      caloriesBurnt: map['caloriesBurnt'] ?? 0,
      muscleIndex: map['muscleIndex'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityLog.fromJson(String source) => ActivityLog.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      time,
      activityId,
      reps,
      caloriesBurnt,
      muscleIndex,
    ];
  }
}
