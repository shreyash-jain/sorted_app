import 'dart:convert';

import 'package:equatable/equatable.dart';

class TrackPropertySettings extends Equatable {
  int track_id;
  double n_u_aim_start;
  double n_u_aim_end;
  int n_u_unfilled_autofill;
  int property_id;
  int d_u_interval_time;
  int d_u_start_time;
  double d_u_day_aim;

  TrackPropertySettings({
    this.track_id = 0,
    this.n_u_aim_start = 0.0,
    this.n_u_aim_end = 0.0,
    this.n_u_unfilled_autofill = 0,
    this.property_id = 0,
    this.d_u_interval_time = 0,
    this.d_u_start_time = 0,
    this.d_u_day_aim = 0.0,
  });

  TrackPropertySettings copyWith({
   int track_id,
    double n_u_aim_start,
    double n_u_aim_end,
    int n_u_unfilled_autofill,
    int property_id,
    int d_u_interval_time,
    int d_u_start_time,
    double d_u_day_aim,
  }) {
    return TrackPropertySettings(
      track_id: track_id ?? this.track_id,
      n_u_aim_start: n_u_aim_start ?? this.n_u_aim_start,
      n_u_aim_end: n_u_aim_end ?? this.n_u_aim_end,
      n_u_unfilled_autofill: n_u_unfilled_autofill ?? this.n_u_unfilled_autofill,
      property_id: property_id ?? this.property_id,
      d_u_interval_time: d_u_interval_time ?? this.d_u_interval_time,
      d_u_start_time: d_u_start_time ?? this.d_u_start_time,
      d_u_day_aim: d_u_day_aim ?? this.d_u_day_aim,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'track_id': track_id,
      'n_u_aim_start': n_u_aim_start,
      'n_u_aim_end': n_u_aim_end,
      'n_u_unfilled_autofill': n_u_unfilled_autofill,
      'property_id': property_id,
      'd_u_interval_time': d_u_interval_time,
      'd_u_start_time': d_u_start_time,
      'd_u_day_aim': d_u_day_aim,
    };
  }

  factory TrackPropertySettings.fromMap(Map<String, dynamic> map) {
    return TrackPropertySettings(
      track_id: map['track_id'] ?? 0,
      n_u_aim_start: map['n_u_aim_start'] ?? 0.0,
      n_u_aim_end: map['n_u_aim_end'] ?? 0.0,
      n_u_unfilled_autofill: map['n_u_unfilled_autofill'] ?? 0,
      property_id: map['property_id'] ?? 0,
      d_u_interval_time: map['d_u_interval_time'] ?? 0,
      d_u_start_time: map['d_u_start_time'] ?? 0,
      d_u_day_aim: map['d_u_day_aim'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackPropertySettings.fromJson(String source) =>
      TrackPropertySettings.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      track_id,
      n_u_aim_start,
      n_u_aim_end,
      n_u_unfilled_autofill,
      property_id,
      d_u_interval_time,
      d_u_start_time,
      d_u_day_aim,
    ];
  }
}
