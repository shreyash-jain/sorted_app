import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// property type
///
/// 0 -> confirmation (yes no)
/// 1 -> text
/// 2 -> number
/// 3 -> rating
/// 4 -> duration
/// 5 -> image // not now
/// 6 -> rigid list // not now // this is up next
///
///
///
/// n_stat_condition
///
///
/// 0 -> last log
/// 1 -> sum day
/// 2 -> average of day
/// 3 -> use max of day
///
///
///
///
/// n_aim_type
///
///
/// 1 -> less than m1
/// 2 -> more than m1
/// 3 -> b/w m1 and m2
class TrackPropertyModel implements Equatable {
  int id;
  int track_id;
  int property_type;
  String property_name;
  String property_key;
  String property_description;
  String property_question;
  String property_icon_url;
  int priority;
  int is_required;
  int is_active;
  int is_move_ahead;
  int auto_fill_status;
  int last_autofill_ts;
  String t_hint_text;
  int n_after_decimal;
  String n_hint_text;
  double n_min;
  double n_max;
  String n_unit;
  int n_unit_val;

  int n_aim_type;
  int n_stat_condition;
  int n_possible_units_list_id;
  List<String> rl_items;
  int rl_aim_limit;
  int rl_default_aim_index;
  String rl_hint_text;
  int rl_is_multi_choice;
  int d_default_start_time;

  int d_default_interval_time;

  int d_max_duration_min;
  int d_start_time_ts;
  int d_is_realtime;

  int r_max;
  String r_max_string;
  String r_min_string;
  int r_min;

  int is_manual_fill;
  int has_goal;
  TrackPropertyModel({
    this.id = 0,
    this.track_id = 0,
    this.property_type = 0,
    this.property_name = '',
    this.property_key = '',
    this.property_description = '',
    this.property_question = '',
    this.property_icon_url = '',
    this.priority = 0,
    this.is_required = 0,
    this.is_active = 0,
    this.is_move_ahead = 0,
    this.auto_fill_status = 0,
    this.last_autofill_ts = 0,
    this.t_hint_text = '',
    this.n_after_decimal = 0,
    this.n_hint_text = '',
    this.n_min = 0.0,
    this.n_max = 0.0,
    this.n_unit = '',
    this.n_unit_val = 0,
    this.n_aim_type = 0,
    this.n_stat_condition = 0,
    this.n_possible_units_list_id = 0,
    this.rl_items = const [],
    this.rl_aim_limit = 0,
    this.rl_default_aim_index = 0,
    this.rl_hint_text = '',
    this.rl_is_multi_choice = 0,
    this.d_default_start_time = 0,
    this.d_default_interval_time = 0,
    this.d_max_duration_min = 0,
    this.d_start_time_ts = 0,
    this.d_is_realtime = 0,
    this.r_max = 0,
    this.r_max_string = '',
    this.r_min_string = '',
    this.r_min = 0,
    this.is_manual_fill = 0,
    this.has_goal = 0,
  });

  TrackPropertyModel copyWith({
    int id,
    int track_id,
    int property_type,
    String property_name,
    String property_key,
    String property_description,
    String property_question,
    String property_icon_url,
    int priority,
    int is_required,
    int is_active,
    int is_move_ahead,
    int auto_fill_status,
    int last_autofill_ts,
    String t_hint_text,
    int n_after_decimal,
    String n_hint_text,
    double n_min,
    double n_max,
    String n_unit,
    int n_unit_val,
    int n_aim_type,
    int n_stat_condition,
    int n_possible_units_list_id,
    List<String> rl_items,
    int rl_aim_limit,
    int rl_default_aim_index,
    String rl_hint_text,
    int rl_is_multi_choice,
    int d_default_start_time,
    int d_default_interval_time,
    int d_max_duration_min,
    int d_start_time_ts,
    int d_is_realtime,
    int r_max,
    String r_max_string,
    String r_min_string,
    int r_min,
    int is_manual_fill,
    String has_goal,
  }) {
    return TrackPropertyModel(
      id: id ?? this.id,
      track_id: track_id ?? this.track_id,
      property_type: property_type ?? this.property_type,
      property_name: property_name ?? this.property_name,
      property_key: property_key ?? this.property_key,
      property_description: property_description ?? this.property_description,
      property_question: property_question ?? this.property_question,
      property_icon_url: property_icon_url ?? this.property_icon_url,
      priority: priority ?? this.priority,
      is_required: is_required ?? this.is_required,
      is_active: is_active ?? this.is_active,
      is_move_ahead: is_move_ahead ?? this.is_move_ahead,
      auto_fill_status: auto_fill_status ?? this.auto_fill_status,
      last_autofill_ts: last_autofill_ts ?? this.last_autofill_ts,
      t_hint_text: t_hint_text ?? this.t_hint_text,
      n_after_decimal: n_after_decimal ?? this.n_after_decimal,
      n_hint_text: n_hint_text ?? this.n_hint_text,
      n_min: n_min ?? this.n_min,
      n_max: n_max ?? this.n_max,
      n_unit: n_unit ?? this.n_unit,
      n_unit_val: n_unit_val ?? this.n_unit_val,
      n_aim_type: n_aim_type ?? this.n_aim_type,
      n_stat_condition: n_stat_condition ?? this.n_stat_condition,
      n_possible_units_list_id:
          n_possible_units_list_id ?? this.n_possible_units_list_id,
      rl_items: rl_items ?? this.rl_items,
      rl_aim_limit: rl_aim_limit ?? this.rl_aim_limit,
      rl_default_aim_index: rl_default_aim_index ?? this.rl_default_aim_index,
      rl_hint_text: rl_hint_text ?? this.rl_hint_text,
      rl_is_multi_choice: rl_is_multi_choice ?? this.rl_is_multi_choice,
      d_default_start_time: d_default_start_time ?? this.d_default_start_time,
      d_default_interval_time:
          d_default_interval_time ?? this.d_default_interval_time,
      d_max_duration_min: d_max_duration_min ?? this.d_max_duration_min,
      d_start_time_ts: d_start_time_ts ?? this.d_start_time_ts,
      d_is_realtime: d_is_realtime ?? this.d_is_realtime,
      r_max: r_max ?? this.r_max,
      r_max_string: r_max_string ?? this.r_max_string,
      r_min_string: r_min_string ?? this.r_min_string,
      r_min: r_min ?? this.r_min,
      is_manual_fill: is_manual_fill ?? this.is_manual_fill,
      has_goal: has_goal ?? this.has_goal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'track_id': track_id,
      'property_type': property_type,
      'property_name': property_name,
      'property_key': property_key,
      'property_description': property_description,
      'property_question': property_question,
      'property_icon_url': property_icon_url,
      'priority': priority,
      'is_required': is_required,
      'is_active': is_active,
      'is_move_ahead': is_move_ahead,
      'auto_fill_status': auto_fill_status,
      'last_autofill_ts': last_autofill_ts,
      't_hint_text': t_hint_text,
      'n_after_decimal': n_after_decimal,
      'n_hint_text': n_hint_text,
      'n_min': n_min,
      'n_max': n_max,
      'n_unit': n_unit,
      'n_unit_val': n_unit_val,
      'n_aim_type': n_aim_type,
      'n_stat_condition': n_stat_condition,
      'n_possible_units_list_id': n_possible_units_list_id,
      'rl_items': rl_items,
      'rl_aim_limit': rl_aim_limit,
      'rl_default_aim_index': rl_default_aim_index,
      'rl_hint_text': rl_hint_text,
      'rl_is_multi_choice': rl_is_multi_choice,
      'd_default_start_time': d_default_start_time,
      'd_default_interval_time': d_default_interval_time,
      'd_max_duration_min': d_max_duration_min,
      'd_start_time_ts': d_start_time_ts,
      'd_is_realtime': d_is_realtime,
      'r_max': r_max,
      'r_max_string': r_max_string,
      'r_min_string': r_min_string,
      'r_min': r_min,
      'is_manual_fill': is_manual_fill,
      'has_goal': has_goal,
    };
  }

  factory TrackPropertyModel.fromMap(Map<String, dynamic> map) {
    return TrackPropertyModel(
      id: map['id'] ?? 0,
      track_id: map['track_id'] ?? 0,
      property_type: map['property_type'] ?? 0,
      property_name: map['property_name'] ?? '',
      property_key: map['property_key'] ?? '',
      property_description: map['property_description'] ?? '',
      property_question: map['property_question'] ?? '',
      property_icon_url: map['property_icon_url'] ?? '',
      priority: map['priority'] ?? 0,
      is_required: map['is_required'] ?? 0,
      is_active: map['is_active'] ?? 0,
      is_move_ahead: map['is_move_ahead'] ?? 0,
      auto_fill_status: map['auto_fill_status'] ?? 0,
      last_autofill_ts: map['last_autofill_ts'] ?? 0,
      t_hint_text: map['t_hint_text'] ?? '',
      n_after_decimal: map['n_after_decimal'] ?? 0,
      n_hint_text: map['n_hint_text'] ?? '',
      n_min: map['n_min'] ?? 0.0,
      n_max: map['n_max'] ?? 0.0,
      n_unit: map['n_unit'] ?? '',
      n_unit_val: map['n_unit_val'] ?? 0,
      n_aim_type: map['n_aim_type'] ?? 0,
      n_stat_condition: map['n_stat_condition'] ?? 0,
      n_possible_units_list_id: map['n_possible_units_list_id'] ?? 0,
      rl_items: List<String>.from(map['rl_items'] ?? const []),
      rl_aim_limit: map['rl_aim_limit'] ?? 0,
      rl_default_aim_index: map['rl_default_aim_index'] ?? 0,
      rl_hint_text: map['rl_hint_text'] ?? '',
      rl_is_multi_choice: map['rl_is_multi_choice'] ?? 0,
      d_default_start_time: map['d_default_start_time'] ?? 0,
      d_default_interval_time: map['d_default_interval_time'] ?? 0,
      d_max_duration_min: map['d_max_duration_min'] ?? 0,
      d_start_time_ts: map['d_start_time_ts'] ?? 0,
      d_is_realtime: map['d_is_realtime'] ?? 0,
      r_max: map['r_max'] ?? 0,
      r_max_string: map['r_max_string'] ?? '',
      r_min_string: map['r_min_string'] ?? '',
      r_min: map['r_min'] ?? 0,
      is_manual_fill: map['is_manual_fill'] ?? 0,
      has_goal: map['has_goal'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackPropertyModel.fromJson(String source) =>
      TrackPropertyModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      track_id,
      property_type,
      property_name,
      property_key,
      property_description,
      property_question,
      property_icon_url,
      priority,
      is_required,
      is_active,
      is_move_ahead,
      auto_fill_status,
      last_autofill_ts,
      t_hint_text,
      n_after_decimal,
      n_hint_text,
      n_min,
      n_max,
      n_unit,
      n_unit_val,
      n_aim_type,
      n_stat_condition,
      n_possible_units_list_id,
      rl_items,
      rl_aim_limit,
      rl_default_aim_index,
      rl_hint_text,
      rl_is_multi_choice,
      d_default_start_time,
      d_default_interval_time,
      d_max_duration_min,
      d_start_time_ts,
      d_is_realtime,
      r_max,
      r_max_string,
      r_min_string,
      r_min,
      is_manual_fill,
      has_goal,
    ];
  }
}
