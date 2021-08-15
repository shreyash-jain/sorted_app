import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sorted/features/TRACKERS/COMMON/models/activity_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_log.dart';

class ActivityLogSummary extends Equatable {
  List<ActivityLog> activities;
  DateTime last_log;
  String calorieBurnt;
  ActivityLogSummary({
    this.activities = const [],
    this.last_log,
    this.calorieBurnt = '',
  });

  ActivityLogSummary copyWith({
    List<ActivityLog> activities,
    DateTime last_log,
    String calorieBurnt,
  }) {
    return ActivityLogSummary(
      activities: activities ?? this.activities,
      last_log: last_log ?? this.last_log,
      calorieBurnt: calorieBurnt ?? this.calorieBurnt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activities': activities?.map((x) => x.toMap())?.toList(),
      'last_log': last_log.toIso8601String(),
      'calorieBurnt': calorieBurnt,
    };
  }

  factory ActivityLogSummary.fromMap(Map<String, dynamic> map) {

    return ActivityLogSummary(
      activities: List<ActivityLog>.from(map['activities']?.map((x) {
            var z = Map<String, dynamic>.from(x);
            return ActivityLog.fromMap(z) ?? ActivityLog();
          }) ??
          const []),
      last_log: DateTime.parse((map['last_log'])),
      calorieBurnt: map['calorieBurnt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityLogSummary.fromJson(String source) =>
      ActivityLogSummary.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [activities, last_log, calorieBurnt];
}
