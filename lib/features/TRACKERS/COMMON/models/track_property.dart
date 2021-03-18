import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';

class TrackProperty extends Equatable {
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
  String default_db_path;
  String u_history_path;
  String custom_user_path;
  int t_text_length;
  int t_limit;
  int t_is_rich;
  String t_hint_text;
  int n_after_decimal;
  String n_hint_text;
  double n_min;
  double n_max;
  String n_unit;
  int n_unit_val;
  double n_u_aim_start;
  double n_u_aim_end;
  int n_aim_type;
  int n_default_unit_id;
  int n_u_unfilled_autofill;
  int n_u_aim_condition;
  int n_stat_condition;
  int n_possible_units_list_id;
  int el_max_items;
  String el_hint_text;
  int el_aim_limit;
  int el_default_aim_limit;
  int el_aim_condition;
  int el_is_multi_choice;
  int rl_item_num;
  int rl_aim_limit;
  int rl_default_aim_limit;
  String rl_hint_text;
  int rl_is_multi_choice;
  int erl_item_num;
  String erl_hint_text;
  int erl_is_multi_choice;
  int erl_aim_limit;
  int erl_default_aim_limit;
  String erl_property_link;
  int erl_operation_type;
  int d_default_start_time;
  int d_u_start_time;
  int d_default_interval_time;
  int d_u_interval_time;
  int d_max_duration_min;
  int d_start_time_ts;
  int d_is_realtime;
  int l_num_levels;
  String l_map_level_path;
  String l_map_image_path;
  int l_u_start_level;
  int r_max;
  String r_map_value_path;
  String i_url;
  String i_cloud_path;
  double i_width;
  double i_height;
  TrackProperty({
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
    this.default_db_path = '',
    this.u_history_path = '',
    this.custom_user_path = '',
    this.t_text_length = 0,
    this.t_limit = 0,
    this.t_is_rich = 0,
    this.t_hint_text = '',
    this.n_after_decimal = 0,
    this.n_hint_text = '',
    this.n_min = 0.0,
    this.n_max = 0.0,
    this.n_unit = '',
    this.n_unit_val = 0,
    this.n_u_aim_start = 0.0,
    this.n_u_aim_end = 0.0,
    this.n_aim_type = 0,
    this.n_default_unit_id = 0,
    this.n_u_unfilled_autofill = 0,
    this.n_u_aim_condition = 0,
    this.n_stat_condition = 0,
    this.n_possible_units_list_id = 0,
    this.el_max_items = 0,
    this.el_hint_text = '',
    this.el_aim_limit = 0,
    this.el_default_aim_limit = 0,
    this.el_aim_condition = 0,
    this.el_is_multi_choice = 0,
    this.rl_item_num = 0,
    this.rl_aim_limit = 0,
    this.rl_default_aim_limit = 0,
    this.rl_hint_text = '',
    this.rl_is_multi_choice = 0,
    this.erl_item_num = 0,
    this.erl_hint_text = '',
    this.erl_is_multi_choice = 0,
    this.erl_aim_limit = 0,
    this.erl_default_aim_limit = 0,
    this.erl_property_link = '',
    this.erl_operation_type = 0,
    this.d_default_start_time = 0,
    this.d_u_start_time = 0,
    this.d_default_interval_time = 0,
    this.d_u_interval_time = 0,
    this.d_max_duration_min = 0,
    this.d_start_time_ts = 0,
    this.d_is_realtime = 0,
    this.l_num_levels = 0,
    this.l_map_level_path = '',
    this.l_map_image_path = '',
    this.l_u_start_level = 0,
    this.r_max = 0,
    this.r_map_value_path = '',
    this.i_url = '',
    this.i_cloud_path = '',
    this.i_width = 0.0,
    this.i_height = 0.0,
  });

  @override
  // TODO: implement props
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
      default_db_path,
      u_history_path,
      custom_user_path,
      t_text_length,
      t_limit,
      t_is_rich,
      t_hint_text,
      n_after_decimal,
      n_hint_text,
      n_min,
      n_max,
      n_unit,
      n_unit_val,
      n_u_aim_start,
      n_u_aim_end,
      n_aim_type,
      n_default_unit_id,
      n_u_unfilled_autofill,
      n_u_aim_condition,
      n_stat_condition,
      n_possible_units_list_id,
      el_max_items,
      el_hint_text,
      el_aim_limit,
      el_default_aim_limit,
      el_aim_condition,
      el_is_multi_choice,
      rl_item_num,
      rl_aim_limit,
      rl_default_aim_limit,
      rl_hint_text,
      rl_is_multi_choice,
      erl_item_num,
      erl_hint_text,
      erl_is_multi_choice,
      erl_aim_limit,
      erl_default_aim_limit,
      erl_property_link,
      erl_operation_type,
      d_default_start_time,
      d_u_start_time,
      d_default_interval_time,
      d_u_interval_time,
      d_max_duration_min,
      d_start_time_ts,
      d_is_realtime,
      l_num_levels,
      l_map_level_path,
      l_map_image_path,
      l_u_start_level,
      r_max,
      r_map_value_path,
      i_url,
      i_cloud_path,
      i_width,
      i_height,
    ];
  }

  TrackProperty copyWith({
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
    String default_db_path,
    String u_history_path,
    String custom_user_path,
    int t_text_length,
    int t_limit,
    int t_is_rich,
    String t_hint_text,
    int n_after_decimal,
    String n_hint_text,
    double n_min,
    double n_max,
    String n_unit,
    int n_unit_val,
    double n_u_aim_start,
    double n_u_aim_end,
    int n_aim_type,
    int n_default_unit_id,
    int n_u_unfilled_autofill,
    int n_u_aim_condition,
    int n_stat_condition,
    int n_possible_units_list_id,
    int el_max_items,
    String el_hint_text,
    int el_aim_limit,
    int el_default_aim_limit,
    int el_aim_condition,
    int el_is_multi_choice,
    int rl_item_num,
    int rl_aim_limit,
    int rl_default_aim_limit,
    String rl_hint_text,
    int rl_is_multi_choice,
    int erl_item_num,
    String erl_hint_text,
    int erl_is_multi_choice,
    int erl_aim_limit,
    int erl_default_aim_limit,
    String erl_property_link,
    int erl_operation_type,
    int d_default_start_time,
    int d_u_start_time,
    int d_default_interval_time,
    int d_u_interval_time,
    int d_max_duration_min,
    int d_start_time_ts,
    int d_is_realtime,
    int l_num_levels,
    String l_map_level_path,
    String l_map_image_path,
    int l_u_start_level,
    int r_max,
    String r_map_value_path,
    String i_url,
    String i_cloud_path,
    double i_width,
    double i_height,
  }) {
    return TrackProperty(
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
      default_db_path: default_db_path ?? this.default_db_path,
      u_history_path: u_history_path ?? this.u_history_path,
      custom_user_path: custom_user_path ?? this.custom_user_path,
      t_text_length: t_text_length ?? this.t_text_length,
      t_limit: t_limit ?? this.t_limit,
      t_is_rich: t_is_rich ?? this.t_is_rich,
      t_hint_text: t_hint_text ?? this.t_hint_text,
      n_after_decimal: n_after_decimal ?? this.n_after_decimal,
      n_hint_text: n_hint_text ?? this.n_hint_text,
      n_min: n_min ?? this.n_min,
      n_max: n_max ?? this.n_max,
      n_unit: n_unit ?? this.n_unit,
      n_unit_val: n_unit_val ?? this.n_unit_val,
      n_u_aim_start: n_u_aim_start ?? this.n_u_aim_start,
      n_u_aim_end: n_u_aim_end ?? this.n_u_aim_end,
      n_aim_type: n_aim_type ?? this.n_aim_type,
      n_default_unit_id: n_default_unit_id ?? this.n_default_unit_id,
      n_u_unfilled_autofill:
          n_u_unfilled_autofill ?? this.n_u_unfilled_autofill,
      n_u_aim_condition: n_u_aim_condition ?? this.n_u_aim_condition,
      n_stat_condition: n_stat_condition ?? this.n_stat_condition,
      n_possible_units_list_id:
          n_possible_units_list_id ?? this.n_possible_units_list_id,
      el_max_items: el_max_items ?? this.el_max_items,
      el_hint_text: el_hint_text ?? this.el_hint_text,
      el_aim_limit: el_aim_limit ?? this.el_aim_limit,
      el_default_aim_limit: el_default_aim_limit ?? this.el_default_aim_limit,
      el_aim_condition: el_aim_condition ?? this.el_aim_condition,
      el_is_multi_choice: el_is_multi_choice ?? this.el_is_multi_choice,
      rl_item_num: rl_item_num ?? this.rl_item_num,
      rl_aim_limit: rl_aim_limit ?? this.rl_aim_limit,
      rl_default_aim_limit: rl_default_aim_limit ?? this.rl_default_aim_limit,
      rl_hint_text: rl_hint_text ?? this.rl_hint_text,
      rl_is_multi_choice: rl_is_multi_choice ?? this.rl_is_multi_choice,
      erl_item_num: erl_item_num ?? this.erl_item_num,
      erl_hint_text: erl_hint_text ?? this.erl_hint_text,
      erl_is_multi_choice: erl_is_multi_choice ?? this.erl_is_multi_choice,
      erl_aim_limit: erl_aim_limit ?? this.erl_aim_limit,
      erl_default_aim_limit:
          erl_default_aim_limit ?? this.erl_default_aim_limit,
      erl_property_link: erl_property_link ?? this.erl_property_link,
      erl_operation_type: erl_operation_type ?? this.erl_operation_type,
      d_default_start_time: d_default_start_time ?? this.d_default_start_time,
      d_u_start_time: d_u_start_time ?? this.d_u_start_time,
      d_default_interval_time:
          d_default_interval_time ?? this.d_default_interval_time,
      d_u_interval_time: d_u_interval_time ?? this.d_u_interval_time,
      d_max_duration_min: d_max_duration_min ?? this.d_max_duration_min,
      d_start_time_ts: d_start_time_ts ?? this.d_start_time_ts,
      d_is_realtime: d_is_realtime ?? this.d_is_realtime,
      l_num_levels: l_num_levels ?? this.l_num_levels,
      l_map_level_path: l_map_level_path ?? this.l_map_level_path,
      l_map_image_path: l_map_image_path ?? this.l_map_image_path,
      l_u_start_level: l_u_start_level ?? this.l_u_start_level,
      r_max: r_max ?? this.r_max,
      r_map_value_path: r_map_value_path ?? this.r_map_value_path,
      i_url: i_url ?? this.i_url,
      i_cloud_path: i_cloud_path ?? this.i_cloud_path,
      i_width: i_width ?? this.i_width,
      i_height: i_height ?? this.i_height,
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
      'default_db_path': default_db_path,
      'u_history_path': u_history_path,
      'custom_user_path': custom_user_path,
      't_text_length': t_text_length,
      't_limit': t_limit,
      't_is_rich': t_is_rich,
      't_hint_text': t_hint_text,
      'n_after_decimal': n_after_decimal,
      'n_hint_text': n_hint_text,
      'n_min': n_min,
      'n_max': n_max,
      'n_unit': n_unit,
      'n_unit_val': n_unit_val,
      'n_u_aim_start': n_u_aim_start,
      'n_u_aim_end': n_u_aim_end,
      'n_aim_type': n_aim_type,
      'n_default_unit_id': n_default_unit_id,
      'n_u_unfilled_autofill': n_u_unfilled_autofill,
      'n_u_aim_condition': n_u_aim_condition,
      'n_stat_condition': n_stat_condition,
      'n_possible_units_list_id': n_possible_units_list_id,
      'el_max_items': el_max_items,
      'el_hint_text': el_hint_text,
      'el_aim_limit': el_aim_limit,
      'el_default_aim_limit': el_default_aim_limit,
      'el_aim_condition': el_aim_condition,
      'el_is_multi_choice': el_is_multi_choice,
      'rl_item_num': rl_item_num,
      'rl_aim_limit': rl_aim_limit,
      'rl_default_aim_limit': rl_default_aim_limit,
      'rl_hint_text': rl_hint_text,
      'rl_is_multi_choice': rl_is_multi_choice,
      'erl_item_num': erl_item_num,
      'erl_hint_text': erl_hint_text,
      'erl_is_multi_choice': erl_is_multi_choice,
      'erl_aim_limit': erl_aim_limit,
      'erl_default_aim_limit': erl_default_aim_limit,
      'erl_property_link': erl_property_link,
      'erl_operation_type': erl_operation_type,
      'd_default_start_time': d_default_start_time,
      'd_u_start_time': d_u_start_time,
      'd_default_interval_time': d_default_interval_time,
      'd_u_interval_time': d_u_interval_time,
      'd_max_duration_min': d_max_duration_min,
      'd_start_time_ts': d_start_time_ts,
      'd_is_realtime': d_is_realtime,
      'l_num_levels': l_num_levels,
      'l_map_level_path': l_map_level_path,
      'l_map_image_path': l_map_image_path,
      'l_u_start_level': l_u_start_level,
      'r_max': r_max,
      'r_map_value_path': r_map_value_path,
      'i_url': i_url,
      'i_cloud_path': i_cloud_path,
      'i_width': i_width,
      'i_height': i_height,
    };
  }

  factory TrackProperty.fromMap(Map<String, dynamic> map) {
    return TrackProperty(
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
      default_db_path: map['default_db_path'] ?? '',
      u_history_path: map['u_history_path'] ?? '',
      custom_user_path: map['custom_user_path'] ?? '',
      t_text_length: map['t_text_length'] ?? 0,
      t_limit: map['t_limit'] ?? 0,
      t_is_rich: map['t_is_rich'] ?? 0,
      t_hint_text: map['t_hint_text'] ?? '',
      n_after_decimal: map['n_after_decimal'] ?? 0,
      n_hint_text: map['n_hint_text'] ?? '',
      n_min: map['n_min'] ?? 0.0,
      n_max: map['n_max'] ?? 0.0,
      n_unit: map['n_unit'] ?? '',
      n_unit_val: map['n_unit_val'] ?? 0,
      n_u_aim_start: map['n_u_aim_start'] ?? 0.0,
      n_u_aim_end: map['n_u_aim_end'] ?? 0.0,
      n_aim_type: map['n_aim_type'] ?? 0,
      n_default_unit_id: map['n_default_unit_id'] ?? 0,
      n_u_unfilled_autofill: map['n_u_unfilled_autofill'] ?? 0,
      n_u_aim_condition: map['n_u_aim_condition'] ?? 0,
      n_stat_condition: map['n_stat_condition'] ?? 0,
      n_possible_units_list_id: map['n_possible_units_list_id'] ?? 0,
      el_max_items: map['el_max_items'] ?? 0,
      el_hint_text: map['el_hint_text'] ?? '',
      el_aim_limit: map['el_aim_limit'] ?? 0,
      el_default_aim_limit: map['el_default_aim_limit'] ?? 0,
      el_aim_condition: map['el_aim_condition'] ?? 0,
      el_is_multi_choice: map['el_is_multi_choice'] ?? 0,
      rl_item_num: map['rl_item_num'] ?? 0,
      rl_aim_limit: map['rl_aim_limit'] ?? 0,
      rl_default_aim_limit: map['rl_default_aim_limit'] ?? 0,
      rl_hint_text: map['rl_hint_text'] ?? '',
      rl_is_multi_choice: map['rl_is_multi_choice'] ?? 0,
      erl_item_num: map['erl_item_num'] ?? 0,
      erl_hint_text: map['erl_hint_text'] ?? '',
      erl_is_multi_choice: map['erl_is_multi_choice'] ?? 0,
      erl_aim_limit: map['erl_aim_limit'] ?? 0,
      erl_default_aim_limit: map['erl_default_aim_limit'] ?? 0,
      erl_property_link: map['erl_property_link'] ?? '',
      erl_operation_type: map['erl_operation_type'] ?? 0,
      d_default_start_time: map['d_default_start_time'] ?? 0,
      d_u_start_time: map['d_u_start_time'] ?? 0,
      d_default_interval_time: map['d_default_interval_time'] ?? 0,
      d_u_interval_time: map['d_u_interval_time'] ?? 0,
      d_max_duration_min: map['d_max_duration_min'] ?? 0,
      d_start_time_ts: map['d_start_time_ts'] ?? 0,
      d_is_realtime: map['d_is_realtime'] ?? 0,
      l_num_levels: map['l_num_levels'] ?? 0,
      l_map_level_path: map['l_map_level_path'] ?? '',
      l_map_image_path: map['l_map_image_path'] ?? '',
      l_u_start_level: map['l_u_start_level'] ?? 0,
      r_max: map['r_max'] ?? 0,
      r_map_value_path: map['r_map_value_path'] ?? '',
      i_url: map['i_url'] ?? '',
      i_cloud_path: map['i_cloud_path'] ?? '',
      i_width: map['i_width'] ?? 0.0,
      i_height: map['i_height'] ?? 0.0,
    );
  }

  factory TrackProperty.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;
    return TrackProperty(
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
      default_db_path: map['default_db_path'] ?? '',
      u_history_path: map['u_history_path'] ?? '',
      custom_user_path: map['custom_user_path'] ?? '',
      t_text_length: map['t_text_length'] ?? 0,
      t_limit: map['t_limit'] ?? 0,
      t_is_rich: map['t_is_rich'] ?? 0,
      t_hint_text: map['t_hint_text'] ?? '',
      n_after_decimal: map['n_after_decimal'] ?? 0,
      n_hint_text: map['n_hint_text'] ?? '',
      n_min: map['n_min'] ?? 0.0,
      n_max: map['n_max'] ?? 0.0,
      n_unit: map['n_unit'] ?? '',
      n_unit_val: map['n_unit_val'] ?? 0,
      n_u_aim_start: map['n_u_aim_start'] ?? 0.0,
      n_u_aim_end: map['n_u_aim_end'] ?? 0.0,
      n_aim_type: map['n_aim_type'] ?? 0,
      n_default_unit_id: map['n_default_unit_id'] ?? 0,
      n_u_unfilled_autofill: map['n_u_unfilled_autofill'] ?? 0,
      n_u_aim_condition: map['n_u_aim_condition'] ?? 0,
      n_stat_condition: map['n_stat_condition'] ?? 0,
      n_possible_units_list_id: map['n_possible_units_list_id'] ?? 0,
      el_max_items: map['el_max_items'] ?? 0,
      el_hint_text: map['el_hint_text'] ?? '',
      el_aim_limit: map['el_aim_limit'] ?? 0,
      el_default_aim_limit: map['el_default_aim_limit'] ?? 0,
      el_aim_condition: map['el_aim_condition'] ?? 0,
      el_is_multi_choice: map['el_is_multi_choice'] ?? 0,
      rl_item_num: map['rl_item_num'] ?? 0,
      rl_aim_limit: map['rl_aim_limit'] ?? 0,
      rl_default_aim_limit: map['rl_default_aim_limit'] ?? 0,
      rl_hint_text: map['rl_hint_text'] ?? '',
      rl_is_multi_choice: map['rl_is_multi_choice'] ?? 0,
      erl_item_num: map['erl_item_num'] ?? 0,
      erl_hint_text: map['erl_hint_text'] ?? '',
      erl_is_multi_choice: map['erl_is_multi_choice'] ?? 0,
      erl_aim_limit: map['erl_aim_limit'] ?? 0,
      erl_default_aim_limit: map['erl_default_aim_limit'] ?? 0,
      erl_property_link: map['erl_property_link'] ?? '',
      erl_operation_type: map['erl_operation_type'] ?? 0,
      d_default_start_time: map['d_default_start_time'] ?? 0,
      d_u_start_time: map['d_u_start_time'] ?? 0,
      d_default_interval_time: map['d_default_interval_time'] ?? 0,
      d_u_interval_time: map['d_u_interval_time'] ?? 0,
      d_max_duration_min: map['d_max_duration_min'] ?? 0,
      d_start_time_ts: map['d_start_time_ts'] ?? 0,
      d_is_realtime: map['d_is_realtime'] ?? 0,
      l_num_levels: map['l_num_levels'] ?? 0,
      l_map_level_path: map['l_map_level_path'] ?? '',
      l_map_image_path: map['l_map_image_path'] ?? '',
      l_u_start_level: map['l_u_start_level'] ?? 0,
      r_max: map['r_max'] ?? 0,
      r_map_value_path: map['r_map_value_path'] ?? '',
      i_url: map['i_url'] ?? '',
      i_cloud_path: map['i_cloud_path'] ?? '',
      i_width: map['i_width'] ?? 0.0,
      i_height: map['i_height'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackProperty.fromJson(String source) =>
      TrackProperty.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
