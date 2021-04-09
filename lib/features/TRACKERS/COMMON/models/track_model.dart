import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../TRACK_STORE/domain/entities/track.dart';

class TrackModel extends Track with EquatableMixin implements Equatable {
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
  String m_db_string;
  String m_custom_db_string;
  String m_template_string;
  String m_db_icon;
  String m_custom_db_icon;
  String m_template_icon;

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
  int ts_has_confirmation;
  String ts_templates_path;
  String ts_combined_db_path;

  int u_active_state;
  int u_pause_open_ts;
  int ts_reminder_state;
  String ts_reminder_text;
  String ts_reminder_sub_text;
  int ts_reminder_week_day_sun;
  int ts_reminder_week_day_mon;
  int ts_reminder_week_day_tue;
  int ts_reminder_week_day_wed;
  int ts_reminder_week_day_thu;
  int ts_reminder_week_day_fri;
  int ts_reminder_week_day_sat;
  int ts_reminder_interval_days;
  int ts_reminder_day_state;
  int ts_reminder_day_start_ts;
  int ts_reminder_day_end_ts;

  int u_last_reminded_ts;
  int ts_realtime_id;
  TrackModel({
    this.id = 0,
    this.name = '',
    this.m_description = '',
    this.is_m_description_rich = 0,
    this.m_facts = '',
    this.is_m_facts_rich = 0,
    this.m_reward = '',
    this.is_m_reward_rich = 0,
    this.icon = '',
    this.m_banner = '',
    this.m_level = 0,
    this.m_u_freq = 0,
    this.ts_multifil = 0,
    this.ts_log_types = 0,
    this.ts_root_logging_db_path = '',
    this.m_db_string = '',
    this.m_custom_db_string = '',
    this.m_template_string = '',
    this.m_db_icon = '',
    this.m_custom_db_icon = '',
    this.m_template_icon = '',
    this.u_root_level_logging_saved_path = '',
    this.u_root_level_logging_history_path = '',
    this.has_market_detail = 0,
    this.ts_num_properties = 0,
    this.m_num_subs = 0,
    this.u_chat_groups = 0,
    this.m_num_expert_groups = 0,
    this.num_comments = 0,
    this.m_recent_subs = 0,
    this.m_string_1 = '',
    this.m_string_2 = '',
    this.m_color = '',
    this.saved_ts = 0,
    this.u_sub_ts = 0,
    this.u_sub_end_ts = 0,
    this.m_rating = 0.0,
    this.ts_default_sub_days = 0,
    this.u_first_fill = 0,
    this.u_last_fill = 0,
    this.u_num_fills = 0,
    this.u_habit_score = 0.0,
    this.u_expert_sub = 0,
    this.u_friends_sub = 0,
    this.ts_can_delete = 0,
    this.ts_autofill = 0,
    this.ts_permission_type = 0,
    this.ts_autofill_freq = 0,
    this.u_last_autofill_ts = 0,
    this.ts_has_confirmation = 0,
    this.ts_templates_path = '',
    this.ts_combined_db_path = '',
    this.u_active_state = 0,
    this.u_pause_open_ts = 0,
    this.ts_reminder_state = 0,
    this.ts_reminder_text = '',
    this.ts_reminder_sub_text = '',
    this.ts_reminder_week_day_sun = 0,
    this.ts_reminder_week_day_mon = 0,
    this.ts_reminder_week_day_tue = 0,
    this.ts_reminder_week_day_wed = 0,
    this.ts_reminder_week_day_thu = 0,
    this.ts_reminder_week_day_fri = 0,
    this.ts_reminder_week_day_sat = 0,
    this.ts_reminder_interval_days = 0,
    this.ts_reminder_day_state = 0,
    this.ts_reminder_day_start_ts = 0,
    this.ts_reminder_day_end_ts = 0,
    this.u_last_reminded_ts = 0,
    this.ts_realtime_id = 0,
  });

  TrackModel copyWith({
    int id,
    String name,
    String m_description,
    int is_m_description_rich,
    String m_facts,
    int is_m_facts_rich,
    String m_reward,
    int is_m_reward_rich,
    String icon,
    String m_banner,
    int m_level,
    int m_u_freq,
    int ts_multifil,
    int ts_log_types,
    String ts_root_logging_db_path,
    String m_db_string,
    String m_custom_db_string,
    String m_template_string,
    String m_db_icon,
    String m_custom_db_icon,
    String m_template_icon,
    String u_root_level_logging_saved_path,
    String u_root_level_logging_history_path,
    int has_market_detail,
    int ts_num_properties,
    int m_num_subs,
    int u_chat_groups,
    int m_num_expert_groups,
    int num_comments,
    int m_recent_subs,
    String m_string_1,
    String m_string_2,
    String m_color,
    int saved_ts,
    int u_sub_ts,
    int u_sub_end_ts,
    double m_rating,
    int ts_default_sub_days,
    int u_first_fill,
    int u_last_fill,
    int u_num_fills,
    double u_habit_score,
    int u_expert_sub,
    int u_friends_sub,
    int ts_can_delete,
    int ts_autofill,
    int ts_permission_type,
    int ts_autofill_freq,
    int u_last_autofill_ts,
    int ts_has_confirmation,
    String ts_templates_path,
    String ts_combined_db_path,
    int u_active_state,
    int u_pause_open_ts,
    int ts_reminder_state,
    String ts_reminder_text,
    String ts_reminder_sub_text,
    int ts_reminder_week_day_sun,
    int ts_reminder_week_day_mon,
    int ts_reminder_week_day_tue,
    int ts_reminder_week_day_wed,
    int ts_reminder_week_day_thu,
    int ts_reminder_week_day_fri,
    int ts_reminder_week_day_sat,
    int ts_reminder_interval_days,
    int ts_reminder_day_state,
    int ts_reminder_day_start_ts,
    int ts_reminder_day_end_ts,
    int u_last_reminded_ts,
    int ts_realtime_id,
  }) {
    return TrackModel(
      id: id ?? this.id,
      name: name ?? this.name,
      m_description: m_description ?? this.m_description,
      is_m_description_rich:
          is_m_description_rich ?? this.is_m_description_rich,
      m_facts: m_facts ?? this.m_facts,
      is_m_facts_rich: is_m_facts_rich ?? this.is_m_facts_rich,
      m_reward: m_reward ?? this.m_reward,
      is_m_reward_rich: is_m_reward_rich ?? this.is_m_reward_rich,
      icon: icon ?? this.icon,
      m_banner: m_banner ?? this.m_banner,
      m_level: m_level ?? this.m_level,
      m_u_freq: m_u_freq ?? this.m_u_freq,
      ts_multifil: ts_multifil ?? this.ts_multifil,
      ts_log_types: ts_log_types ?? this.ts_log_types,
      ts_root_logging_db_path:
          ts_root_logging_db_path ?? this.ts_root_logging_db_path,
      m_db_string: m_db_string ?? this.m_db_string,
      m_custom_db_string: m_custom_db_string ?? this.m_custom_db_string,
      m_template_string: m_template_string ?? this.m_template_string,
      m_db_icon: m_db_icon ?? this.m_db_icon,
      m_custom_db_icon: m_custom_db_icon ?? this.m_custom_db_icon,
      m_template_icon: m_template_icon ?? this.m_template_icon,
      u_root_level_logging_saved_path: u_root_level_logging_saved_path ??
          this.u_root_level_logging_saved_path,
      u_root_level_logging_history_path: u_root_level_logging_history_path ??
          this.u_root_level_logging_history_path,
      has_market_detail: has_market_detail ?? this.has_market_detail,
      ts_num_properties: ts_num_properties ?? this.ts_num_properties,
      m_num_subs: m_num_subs ?? this.m_num_subs,
      u_chat_groups: u_chat_groups ?? this.u_chat_groups,
      m_num_expert_groups: m_num_expert_groups ?? this.m_num_expert_groups,
      num_comments: num_comments ?? this.num_comments,
      m_recent_subs: m_recent_subs ?? this.m_recent_subs,
      m_string_1: m_string_1 ?? this.m_string_1,
      m_string_2: m_string_2 ?? this.m_string_2,
      m_color: m_color ?? this.m_color,
      saved_ts: saved_ts ?? this.saved_ts,
      u_sub_ts: u_sub_ts ?? this.u_sub_ts,
      u_sub_end_ts: u_sub_end_ts ?? this.u_sub_end_ts,
      m_rating: m_rating ?? this.m_rating,
      ts_default_sub_days: ts_default_sub_days ?? this.ts_default_sub_days,
      u_first_fill: u_first_fill ?? this.u_first_fill,
      u_last_fill: u_last_fill ?? this.u_last_fill,
      u_num_fills: u_num_fills ?? this.u_num_fills,
      u_habit_score: u_habit_score ?? this.u_habit_score,
      u_expert_sub: u_expert_sub ?? this.u_expert_sub,
      u_friends_sub: u_friends_sub ?? this.u_friends_sub,
      ts_can_delete: ts_can_delete ?? this.ts_can_delete,
      ts_autofill: ts_autofill ?? this.ts_autofill,
      ts_permission_type: ts_permission_type ?? this.ts_permission_type,
      ts_autofill_freq: ts_autofill_freq ?? this.ts_autofill_freq,
      u_last_autofill_ts: u_last_autofill_ts ?? this.u_last_autofill_ts,
      ts_has_confirmation: ts_has_confirmation ?? this.ts_has_confirmation,
      ts_templates_path: ts_templates_path ?? this.ts_templates_path,
      ts_combined_db_path: ts_combined_db_path ?? this.ts_combined_db_path,
      u_active_state: u_active_state ?? this.u_active_state,
      u_pause_open_ts: u_pause_open_ts ?? this.u_pause_open_ts,
      ts_reminder_state: ts_reminder_state ?? this.ts_reminder_state,
      ts_reminder_text: ts_reminder_text ?? this.ts_reminder_text,
      ts_reminder_sub_text: ts_reminder_sub_text ?? this.ts_reminder_sub_text,
      ts_reminder_week_day_sun:
          ts_reminder_week_day_sun ?? this.ts_reminder_week_day_sun,
      ts_reminder_week_day_mon:
          ts_reminder_week_day_mon ?? this.ts_reminder_week_day_mon,
      ts_reminder_week_day_tue:
          ts_reminder_week_day_tue ?? this.ts_reminder_week_day_tue,
      ts_reminder_week_day_wed:
          ts_reminder_week_day_wed ?? this.ts_reminder_week_day_wed,
      ts_reminder_week_day_thu:
          ts_reminder_week_day_thu ?? this.ts_reminder_week_day_thu,
      ts_reminder_week_day_fri:
          ts_reminder_week_day_fri ?? this.ts_reminder_week_day_fri,
      ts_reminder_week_day_sat:
          ts_reminder_week_day_sat ?? this.ts_reminder_week_day_sat,
      ts_reminder_interval_days:
          ts_reminder_interval_days ?? this.ts_reminder_interval_days,
      ts_reminder_day_state:
          ts_reminder_day_state ?? this.ts_reminder_day_state,
      ts_reminder_day_start_ts:
          ts_reminder_day_start_ts ?? this.ts_reminder_day_start_ts,
      ts_reminder_day_end_ts:
          ts_reminder_day_end_ts ?? this.ts_reminder_day_end_ts,
      u_last_reminded_ts: u_last_reminded_ts ?? this.u_last_reminded_ts,
      ts_realtime_id: ts_realtime_id ?? this.ts_realtime_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'm_description': m_description,
      'is_m_description_rich': is_m_description_rich,
      'm_facts': m_facts,
      'is_m_facts_rich': is_m_facts_rich,
      'm_reward': m_reward,
      'is_m_reward_rich': is_m_reward_rich,
      'icon': icon,
      'm_banner': m_banner,
      'm_level': m_level,
      'm_u_freq': m_u_freq,
      'ts_multifil': ts_multifil,
      'ts_log_types': ts_log_types,
      'ts_root_logging_db_path': ts_root_logging_db_path,
      'm_db_string': m_db_string,
      'm_custom_db_string': m_custom_db_string,
      'm_template_string': m_template_string,
      'm_db_icon': m_db_icon,
      'm_custom_db_icon': m_custom_db_icon,
      'm_template_icon': m_template_icon,
      'u_root_level_logging_saved_path': u_root_level_logging_saved_path,
      'u_root_level_logging_history_path': u_root_level_logging_history_path,
      'has_market_detail': has_market_detail,
      'ts_num_properties': ts_num_properties,
      'm_num_subs': m_num_subs,
      'u_chat_groups': u_chat_groups,
      'm_num_expert_groups': m_num_expert_groups,
      'num_comments': num_comments,
      'm_recent_subs': m_recent_subs,
      'm_string_1': m_string_1,
      'm_string_2': m_string_2,
      'm_color': m_color,
      'saved_ts': saved_ts,
      'u_sub_ts': u_sub_ts,
      'u_sub_end_ts': u_sub_end_ts,
      'm_rating': m_rating,
      'ts_default_sub_days': ts_default_sub_days,
      'u_first_fill': u_first_fill,
      'u_last_fill': u_last_fill,
      'u_num_fills': u_num_fills,
      'u_habit_score': u_habit_score,
      'u_expert_sub': u_expert_sub,
      'u_friends_sub': u_friends_sub,
      'ts_can_delete': ts_can_delete,
      'ts_autofill': ts_autofill,
      'ts_permission_type': ts_permission_type,
      'ts_autofill_freq': ts_autofill_freq,
      'u_last_autofill_ts': u_last_autofill_ts,
      'ts_has_confirmation': ts_has_confirmation,
      'ts_templates_path': ts_templates_path,
      'ts_combined_db_path': ts_combined_db_path,
      'u_active_state': u_active_state,
      'u_pause_open_ts': u_pause_open_ts,
      'ts_reminder_state': ts_reminder_state,
      'ts_reminder_text': ts_reminder_text,
      'ts_reminder_sub_text': ts_reminder_sub_text,
      'ts_reminder_week_day_sun': ts_reminder_week_day_sun,
      'ts_reminder_week_day_mon': ts_reminder_week_day_mon,
      'ts_reminder_week_day_tue': ts_reminder_week_day_tue,
      'ts_reminder_week_day_wed': ts_reminder_week_day_wed,
      'ts_reminder_week_day_thu': ts_reminder_week_day_thu,
      'ts_reminder_week_day_fri': ts_reminder_week_day_fri,
      'ts_reminder_week_day_sat': ts_reminder_week_day_sat,
      'ts_reminder_interval_days': ts_reminder_interval_days,
      'ts_reminder_day_state': ts_reminder_day_state,
      'ts_reminder_day_start_ts': ts_reminder_day_start_ts,
      'ts_reminder_day_end_ts': ts_reminder_day_end_ts,
      'u_last_reminded_ts': u_last_reminded_ts,
      'ts_realtime_id': ts_realtime_id,
    };
  }

  factory TrackModel.fromMap(Map<String, dynamic> map) {
    return TrackModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      m_description: map['m_description'] ?? '',
      is_m_description_rich: map['is_m_description_rich'] ?? 0,
      m_facts: map['m_facts'] ?? '',
      is_m_facts_rich: map['is_m_facts_rich'] ?? 0,
      m_reward: map['m_reward'] ?? '',
      is_m_reward_rich: map['is_m_reward_rich'] ?? 0,
      icon: map['icon'] ?? '',
      m_banner: map['m_banner'] ?? '',
      m_level: map['m_level'] ?? 0,
      m_u_freq: map['m_u_freq'] ?? 0,
      ts_multifil: map['ts_multifil'] ?? 0,
      ts_log_types: map['ts_log_types'] ?? 0,
      ts_root_logging_db_path: map['ts_root_logging_db_path'] ?? '',
      m_db_string: map['m_db_string'] ?? '',
      m_custom_db_string: map['m_custom_db_string'] ?? '',
      m_template_string: map['m_template_string'] ?? '',
      m_db_icon: map['m_db_icon'] ?? '',
      m_custom_db_icon: map['m_custom_db_icon'] ?? '',
      m_template_icon: map['m_template_icon'] ?? '',
      u_root_level_logging_saved_path:
          map['u_root_level_logging_saved_path'] ?? '',
      u_root_level_logging_history_path:
          map['u_root_level_logging_history_path'] ?? '',
      has_market_detail: map['has_market_detail'] ?? 0,
      ts_num_properties: map['ts_num_properties'] ?? 0,
      m_num_subs: map['m_num_subs'] ?? 0,
      u_chat_groups: map['u_chat_groups'] ?? 0,
      m_num_expert_groups: map['m_num_expert_groups'] ?? 0,
      num_comments: map['num_comments'] ?? 0,
      m_recent_subs: map['m_recent_subs'] ?? 0,
      m_string_1: map['m_string_1'] ?? '',
      m_string_2: map['m_string_2'] ?? '',
      m_color: map['m_color'] ?? '',
      saved_ts: map['saved_ts'] ?? 0,
      u_sub_ts: map['u_sub_ts'] ?? 0,
      u_sub_end_ts: map['u_sub_end_ts'] ?? 0,
      m_rating: map['m_rating'] ?? 0.0,
      ts_default_sub_days: map['ts_default_sub_days'] ?? 0,
      u_first_fill: map['u_first_fill'] ?? 0,
      u_last_fill: map['u_last_fill'] ?? 0,
      u_num_fills: map['u_num_fills'] ?? 0,
      u_habit_score: map['u_habit_score'] ?? 0.0,
      u_expert_sub: map['u_expert_sub'] ?? 0,
      u_friends_sub: map['u_friends_sub'] ?? 0,
      ts_can_delete: map['ts_can_delete'] ?? 0,
      ts_autofill: map['ts_autofill'] ?? 0,
      ts_permission_type: map['ts_permission_type'] ?? 0,
      ts_autofill_freq: map['ts_autofill_freq'] ?? 0,
      u_last_autofill_ts: map['u_last_autofill_ts'] ?? 0,
      ts_has_confirmation: map['ts_has_confirmation'] ?? 0,
      ts_templates_path: map['ts_templates_path'] ?? '',
      ts_combined_db_path: map['ts_combined_db_path'] ?? '',
      u_active_state: map['u_active_state'] ?? 0,
      u_pause_open_ts: map['u_pause_open_ts'] ?? 0,
      ts_reminder_state: map['ts_reminder_state'] ?? 0,
      ts_reminder_text: map['ts_reminder_text'] ?? '',
      ts_reminder_sub_text: map['ts_reminder_sub_text'] ?? '',
      ts_reminder_week_day_sun: map['ts_reminder_week_day_sun'] ?? 0,
      ts_reminder_week_day_mon: map['ts_reminder_week_day_mon'] ?? 0,
      ts_reminder_week_day_tue: map['ts_reminder_week_day_tue'] ?? 0,
      ts_reminder_week_day_wed: map['ts_reminder_week_day_wed'] ?? 0,
      ts_reminder_week_day_thu: map['ts_reminder_week_day_thu'] ?? 0,
      ts_reminder_week_day_fri: map['ts_reminder_week_day_fri'] ?? 0,
      ts_reminder_week_day_sat: map['ts_reminder_week_day_sat'] ?? 0,
      ts_reminder_interval_days: map['ts_reminder_interval_days'] ?? 0,
      ts_reminder_day_state: map['ts_reminder_day_state'] ?? 0,
      ts_reminder_day_start_ts: map['ts_reminder_day_start_ts'] ?? 0,
      ts_reminder_day_end_ts: map['ts_reminder_day_end_ts'] ?? 0,
      u_last_reminded_ts: map['u_last_reminded_ts'] ?? 0,
      ts_realtime_id: map['ts_realtime_id'] ?? 0,
    );
  }

  factory TrackModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;
    return TrackModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      m_description: map['m_description'] ?? '',
      is_m_description_rich: map['is_m_description_rich'] ?? 0,
      m_facts: map['m_facts'] ?? '',
      is_m_facts_rich: map['is_m_facts_rich'] ?? 0,
      m_reward: map['m_reward'] ?? '',
      is_m_reward_rich: map['is_m_reward_rich'] ?? 0,
      icon: map['icon'] ?? '',
      m_banner: map['m_banner'] ?? '',
      m_level: map['m_level'] ?? 0,
      m_u_freq: map['m_u_freq'] ?? 0,
      ts_multifil: map['ts_multifil'] ?? 0,
      ts_log_types: map['ts_log_types'] ?? 0,
      ts_root_logging_db_path: map['ts_root_logging_db_path'] ?? '',
      m_db_string: map['m_db_string'] ?? '',
      m_custom_db_string: map['m_custom_db_string'] ?? '',
      m_template_string: map['m_template_string'] ?? '',
      m_db_icon: map['m_db_icon'] ?? '',
      m_custom_db_icon: map['m_custom_db_icon'] ?? '',
      m_template_icon: map['m_template_icon'] ?? '',
      u_root_level_logging_saved_path:
          map['u_root_level_logging_saved_path'] ?? '',
      u_root_level_logging_history_path:
          map['u_root_level_logging_history_path'] ?? '',
      has_market_detail: map['has_market_detail'] ?? 0,
      ts_num_properties: map['ts_num_properties'] ?? 0,
      m_num_subs: map['m_num_subs'] ?? 0,
      u_chat_groups: map['u_chat_groups'] ?? 0,
      m_num_expert_groups: map['m_num_expert_groups'] ?? 0,
      num_comments: map['num_comments'] ?? 0,
      m_recent_subs: map['m_recent_subs'] ?? 0,
      m_string_1: map['m_string_1'] ?? '',
      m_string_2: map['m_string_2'] ?? '',
      m_color: map['m_color'] ?? '',
      saved_ts: map['saved_ts'] ?? 0,
      u_sub_ts: map['u_sub_ts'] ?? 0,
      u_sub_end_ts: map['u_sub_end_ts'] ?? 0,
      m_rating: map['m_rating'] ?? 0.0,
      ts_default_sub_days: map['ts_default_sub_days'] ?? 0,
      u_first_fill: map['u_first_fill'] ?? 0,
      u_last_fill: map['u_last_fill'] ?? 0,
      u_num_fills: map['u_num_fills'] ?? 0,
      u_habit_score: map['u_habit_score'] ?? 0.0,
      u_expert_sub: map['u_expert_sub'] ?? 0,
      u_friends_sub: map['u_friends_sub'] ?? 0,
      ts_can_delete: map['ts_can_delete'] ?? 0,
      ts_autofill: map['ts_autofill'] ?? 0,
      ts_permission_type: map['ts_permission_type'] ?? 0,
      ts_autofill_freq: map['ts_autofill_freq'] ?? 0,
      u_last_autofill_ts: map['u_last_autofill_ts'] ?? 0,
      ts_has_confirmation: map['ts_has_confirmation'] ?? 0,
      ts_templates_path: map['ts_templates_path'] ?? '',
      ts_combined_db_path: map['ts_combined_db_path'] ?? '',
      u_active_state: map['u_active_state'] ?? 0,
      u_pause_open_ts: map['u_pause_open_ts'] ?? 0,
      ts_reminder_state: map['ts_reminder_state'] ?? 0,
      ts_reminder_text: map['ts_reminder_text'] ?? '',
      ts_reminder_sub_text: map['ts_reminder_sub_text'] ?? '',
      ts_reminder_week_day_sun: map['ts_reminder_week_day_sun'] ?? 0,
      ts_reminder_week_day_mon: map['ts_reminder_week_day_mon'] ?? 0,
      ts_reminder_week_day_tue: map['ts_reminder_week_day_tue'] ?? 0,
      ts_reminder_week_day_wed: map['ts_reminder_week_day_wed'] ?? 0,
      ts_reminder_week_day_thu: map['ts_reminder_week_day_thu'] ?? 0,
      ts_reminder_week_day_fri: map['ts_reminder_week_day_fri'] ?? 0,
      ts_reminder_week_day_sat: map['ts_reminder_week_day_sat'] ?? 0,
      ts_reminder_interval_days: map['ts_reminder_interval_days'] ?? 0,
      ts_reminder_day_state: map['ts_reminder_day_state'] ?? 0,
      ts_reminder_day_start_ts: map['ts_reminder_day_start_ts'] ?? 0,
      ts_reminder_day_end_ts: map['ts_reminder_day_end_ts'] ?? 0,
      u_last_reminded_ts: map['u_last_reminded_ts'] ?? 0,
      ts_realtime_id: map['ts_realtime_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackModel.fromJson(String source) =>
      TrackModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      m_description,
      is_m_description_rich,
      m_facts,
      is_m_facts_rich,
      m_reward,
      is_m_reward_rich,
      icon,
      m_banner,
      m_level,
      m_u_freq,
      ts_multifil,
      ts_log_types,
      ts_root_logging_db_path,
      m_db_string,
      m_custom_db_string,
      m_template_string,
      m_db_icon,
      m_custom_db_icon,
      m_template_icon,
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
      ts_has_confirmation,
      ts_templates_path,
      ts_combined_db_path,
      u_active_state,
      u_pause_open_ts,
      ts_reminder_state,
      ts_reminder_text,
      ts_reminder_sub_text,
      ts_reminder_week_day_sun,
      ts_reminder_week_day_mon,
      ts_reminder_week_day_tue,
      ts_reminder_week_day_wed,
      ts_reminder_week_day_thu,
      ts_reminder_week_day_fri,
      ts_reminder_week_day_sat,
      ts_reminder_interval_days,
      ts_reminder_day_state,
      ts_reminder_day_start_ts,
      ts_reminder_day_end_ts,
      u_last_reminded_ts,
      ts_realtime_id,
    ];
  }
}