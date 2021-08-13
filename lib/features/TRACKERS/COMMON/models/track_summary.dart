import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';

class TrackSummary extends Equatable {
  int property_id;
  int track_id;
  List<TrackLog> track_logs;
  double habit_score;
  DateTime last_log;
  String currentValue;
  int type;
  TrackSummary({
    this.property_id = 0,
    this.track_id = 0,
    this.track_logs = const [],
    this.habit_score = 0.0,
    this.last_log,
    this.currentValue = '',
    this.type = 0,
  });

  TrackSummary copyWith({
    int property_id,
    int track_id,
    List<TrackLog> track_logs,
    double habit_score,
    DateTime last_log,
    String currentValue,
    int type,
  }) {
    return TrackSummary(
      property_id: property_id ?? this.property_id,
      track_id: track_id ?? this.track_id,
      track_logs: track_logs ?? this.track_logs,
      habit_score: habit_score ?? this.habit_score,
      last_log: last_log ?? this.last_log,
      currentValue: currentValue ?? this.currentValue,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'property_id': property_id,
      'track_id': track_id,
      'track_logs': track_logs?.map((x) => x.toMap())?.toList(),
      'habit_score': habit_score,
      'last_log': last_log.toIso8601String(),
      'currentValue': currentValue,
      'type': type,
    };
  }

   factory TrackSummary.fromMap(Map<String, dynamic> map) {
    return TrackSummary(
      property_id: map['property_id'] ?? 0,
      track_id: map['track_id'] ?? 0,
      track_logs: List<TrackLog>.from(map['track_logs']?.map((x) {
            var z = Map<String, dynamic>.from(x);
            return TrackLog.fromMap(z) ?? TrackLog();
          }) ??
          const []),
      habit_score: map['habit_score'] ?? 0.0,
      last_log: DateTime.parse(map['last_log']),
      currentValue: map['currentValue'] ?? '',
        type: map['type'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackSummary.fromJson(String source) =>
      TrackSummary.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      property_id,
      track_id,
      track_logs,
      habit_score,
      last_log,
      currentValue,
      type,
    ];
  }
}
