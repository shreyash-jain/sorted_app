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
}
