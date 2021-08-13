import 'dart:convert';

import 'package:equatable/equatable.dart';

class TrackUserSettings extends Equatable {
  int track_id;
  int m_u_freq;
  int u_first_fill;
  int u_last_fill;
  int u_num_fills;
  double u_habit_score;
  int u_active_state;
  int u_pause_open_ts;
  int ts_reminder_state;
  String ts_reminder_text;
  String ts_reminder_sub_text;
  List<int> ts_reminder_week_day;
  int ts_reminder_interval_days;
  int ts_reminder_day_state;
  int ts_reminder_day_start_ts;
  int ts_reminder_day_end_ts;
  int u_last_reminded_ts;
  int ts_realtime_id;
  int u_last_autofill_ts;
  int saved_ts;
  TrackUserSettings({
    this.track_id = 0,
    this.m_u_freq = 0,
    this.u_first_fill = 0,
    this.u_last_fill = 0,
    this.u_num_fills = 0,
    this.u_habit_score = 0.0,
    this.u_active_state = 0,
    this.u_pause_open_ts = 0,
    this.ts_reminder_state = 0,
    this.ts_reminder_text = '',
    this.ts_reminder_sub_text = '',
    this.ts_reminder_week_day = const [],
    this.ts_reminder_interval_days = 0,
    this.ts_reminder_day_state = 0,
    this.ts_reminder_day_start_ts = 0,
    this.ts_reminder_day_end_ts = 0,
    this.u_last_reminded_ts = 0,
    this.ts_realtime_id = 0,
    this.u_last_autofill_ts = 0,
    this.saved_ts = 0,
  });

  TrackUserSettings copyWith({
    int track_id,
    int m_u_freq,
    int u_first_fill,
    int u_last_fill,
    int u_num_fills,
    double u_habit_score,
    int u_active_state,
    int u_pause_open_ts,
    int ts_reminder_state,
    String ts_reminder_text,
    String ts_reminder_sub_text,
    List<int> ts_reminder_week_day,
    int ts_reminder_interval_days,
    int ts_reminder_day_state,
    int ts_reminder_day_start_ts,
    int ts_reminder_day_end_ts,
    int u_last_reminded_ts,
    int ts_realtime_id,
    int u_last_autofill_ts,
    int saved_ts,
  }) {
    return TrackUserSettings(
      track_id: track_id ?? this.track_id,
      m_u_freq: m_u_freq ?? this.m_u_freq,
      u_first_fill: u_first_fill ?? this.u_first_fill,
      u_last_fill: u_last_fill ?? this.u_last_fill,
      u_num_fills: u_num_fills ?? this.u_num_fills,
      u_habit_score: u_habit_score ?? this.u_habit_score,
      u_active_state: u_active_state ?? this.u_active_state,
      u_pause_open_ts: u_pause_open_ts ?? this.u_pause_open_ts,
      ts_reminder_state: ts_reminder_state ?? this.ts_reminder_state,
      ts_reminder_text: ts_reminder_text ?? this.ts_reminder_text,
      ts_reminder_sub_text: ts_reminder_sub_text ?? this.ts_reminder_sub_text,
      ts_reminder_week_day: ts_reminder_week_day ?? this.ts_reminder_week_day,
      ts_reminder_interval_days: ts_reminder_interval_days ?? this.ts_reminder_interval_days,
      ts_reminder_day_state: ts_reminder_day_state ?? this.ts_reminder_day_state,
      ts_reminder_day_start_ts: ts_reminder_day_start_ts ?? this.ts_reminder_day_start_ts,
      ts_reminder_day_end_ts: ts_reminder_day_end_ts ?? this.ts_reminder_day_end_ts,
      u_last_reminded_ts: u_last_reminded_ts ?? this.u_last_reminded_ts,
      ts_realtime_id: ts_realtime_id ?? this.ts_realtime_id,
      u_last_autofill_ts: u_last_autofill_ts ?? this.u_last_autofill_ts,
      saved_ts: saved_ts ?? this.saved_ts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'track_id': track_id,
      'm_u_freq': m_u_freq,
      'u_first_fill': u_first_fill,
      'u_last_fill': u_last_fill,
      'u_num_fills': u_num_fills,
      'u_habit_score': u_habit_score,
      'u_active_state': u_active_state,
      'u_pause_open_ts': u_pause_open_ts,
      'ts_reminder_state': ts_reminder_state,
      'ts_reminder_text': ts_reminder_text,
      'ts_reminder_sub_text': ts_reminder_sub_text,
      'ts_reminder_week_day': ts_reminder_week_day,
      'ts_reminder_interval_days': ts_reminder_interval_days,
      'ts_reminder_day_state': ts_reminder_day_state,
      'ts_reminder_day_start_ts': ts_reminder_day_start_ts,
      'ts_reminder_day_end_ts': ts_reminder_day_end_ts,
      'u_last_reminded_ts': u_last_reminded_ts,
      'ts_realtime_id': ts_realtime_id,
      'u_last_autofill_ts': u_last_autofill_ts,
      'saved_ts': saved_ts,
    };
  }

  factory TrackUserSettings.fromMap(Map<String, dynamic> map) {
    return TrackUserSettings(
      track_id: map['track_id'] ?? 0,
      m_u_freq: map['m_u_freq'] ?? 0,
      u_first_fill: map['u_first_fill'] ?? 0,
      u_last_fill: map['u_last_fill'] ?? 0,
      u_num_fills: map['u_num_fills'] ?? 0,
      u_habit_score: map['u_habit_score'] ?? 0.0,
      u_active_state: map['u_active_state'] ?? 0,
      u_pause_open_ts: map['u_pause_open_ts'] ?? 0,
      ts_reminder_state: map['ts_reminder_state'] ?? 0,
      ts_reminder_text: map['ts_reminder_text'] ?? '',
      ts_reminder_sub_text: map['ts_reminder_sub_text'] ?? '',
      ts_reminder_week_day: List<int>.from(map['ts_reminder_week_day'] ?? const []),
      ts_reminder_interval_days: map['ts_reminder_interval_days'] ?? 0,
      ts_reminder_day_state: map['ts_reminder_day_state'] ?? 0,
      ts_reminder_day_start_ts: map['ts_reminder_day_start_ts'] ?? 0,
      ts_reminder_day_end_ts: map['ts_reminder_day_end_ts'] ?? 0,
      u_last_reminded_ts: map['u_last_reminded_ts'] ?? 0,
      ts_realtime_id: map['ts_realtime_id'] ?? 0,
      u_last_autofill_ts: map['u_last_autofill_ts'] ?? 0,
      saved_ts: map['saved_ts'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackUserSettings.fromJson(String source) =>
      TrackUserSettings.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      track_id,
      m_u_freq,
      u_first_fill,
      u_last_fill,
      u_num_fills,
      u_habit_score,
      u_active_state,
      u_pause_open_ts,
      ts_reminder_state,
      ts_reminder_text,
      ts_reminder_sub_text,
      ts_reminder_week_day,
      ts_reminder_interval_days,
      ts_reminder_day_state,
      ts_reminder_day_start_ts,
      ts_reminder_day_end_ts,
      u_last_reminded_ts,
      ts_realtime_id,
      u_last_autofill_ts,
      saved_ts,
    ];
  }
}
