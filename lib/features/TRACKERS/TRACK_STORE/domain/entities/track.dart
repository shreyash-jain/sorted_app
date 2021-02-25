import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Track extends Equatable {
  int id;
  String name;
  String m_description;
  int is_m_description_rich;
  String m_facts;
  int is_m_facts_rich;
  String m_reward;
  int is_m_reward_rich;
  String icon;
  String m_banner;
  int m_level;
  int m_u_freq;
  int ts_multifil;
  int ts_log_types;
  String ts_root_logging_db_path;
  String u_root_level_logging_saved_path;
  String u_root_level_logging_history_path;
  int has_market_detail;
  int ts_num_properties;
  int m_num_subs;
  int u_chat_groups;
  int m_num_expert_groups;
  int num_comments;
  int m_recent_subs;
  String m_string_1;
  String m_string_2;
  String m_color;
  int saved_ts;
  int u_sub_ts;
  int u_sub_end_ts;
  double m_rating;
  int ts_default_sub_days;
  int u_first_fill;
  int u_last_fill;
  int u_num_fills;
  double u_habit_score;
  int u_expert_sub;
  int u_friends_sub;
  int ts_can_delete;
  int ts_autofill;
  int ts_permission_type;
  int ts_autofill_freq;
  int u_last_autofill_ts;
  int ts_autolog_type;

  Track({
    this.id,
    this.name,
    this.m_description,
    this.is_m_description_rich,
    this.m_facts,
    this.is_m_facts_rich,
    this.m_reward,
    this.is_m_reward_rich,
    this.icon,
    this.m_banner,
    this.m_level,
    this.m_u_freq,
    this.ts_multifil,
    this.ts_log_types,
    this.ts_root_logging_db_path,
    this.u_root_level_logging_saved_path,
    this.u_root_level_logging_history_path,
    this.has_market_detail,
    this.ts_num_properties,
    this.m_num_subs,
    this.u_chat_groups,
    this.m_num_expert_groups,
    this.num_comments,
    this.m_recent_subs,
    this.m_string_1,
    this.m_string_2,
    this.m_color,
    this.saved_ts,
    this.u_sub_ts,
    this.u_sub_end_ts,
    this.m_rating,
    this.ts_default_sub_days,
    this.u_first_fill,
    this.u_last_fill,
    this.u_num_fills,
    this.u_habit_score,
    this.u_expert_sub,
    this.u_friends_sub,
    this.ts_can_delete,
    this.ts_autofill,
    this.ts_permission_type,
    this.ts_autofill_freq,
    this.u_last_autofill_ts,
  });
  @override
  List<Object> get props {
    return [
      id,
      name,
      m_description,
      is_m_description_rich,
      icon,
      m_banner,
      m_level,
      m_u_freq,
      ts_multifil,
      ts_log_types,
      ts_root_logging_db_path,
      u_root_level_logging_saved_path,
      u_root_level_logging_history_path,
      has_market_detail,
      ts_num_properties,
      m_num_subs,
      u_chat_groups,
      m_num_expert_groups,
      num_comments,
      m_recent_subs,
      m_string_1,
      m_string_2,
      m_color,
      saved_ts,
      u_sub_ts,
      u_sub_end_ts,
      m_rating,
      ts_default_sub_days,
      u_first_fill,
      u_last_fill,
      u_num_fills,
      u_habit_score,
      u_expert_sub,
      u_friends_sub,
      ts_can_delete,
      ts_autofill,
      ts_permission_type,
      ts_autofill_freq,
      u_last_autofill_ts,
    ];
  }
}
