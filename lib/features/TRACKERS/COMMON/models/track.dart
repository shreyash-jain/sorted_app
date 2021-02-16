import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TrackModel extends Equatable {
  int id;
  String name;
  String m_description;
  String is_m_description_rich;
  String m_facts;
  String is_m_facts_rich;
  String m_reward;
  String is_m_reward_rich;
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
  TrackModel({
    this.id = 0,
    this.name = '',
    this.m_description = '',
    this.is_m_description_rich = '',
    this.icon = '',
    this.m_banner = '',
    this.m_level = 0,
    this.m_u_freq = 0,
    this.ts_multifil = 0,
    this.ts_log_types = 0,
    this.ts_root_logging_db_path = '',
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
  });

  TrackModel copyWith({
    int id,
    String name,
    String m_description,
    String is_m_description_rich,
    String icon,
    String m_banner,
    int m_level,
    int m_u_freq,
    int ts_multifil,
    int ts_log_types,
    String ts_root_logging_db_path,
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
  }) {
    return TrackModel(
      id: id ?? this.id,
      name: name ?? this.name,
      m_description: m_description ?? this.m_description,
      is_m_description_rich:
          is_m_description_rich ?? this.is_m_description_rich,
      icon: icon ?? this.icon,
      m_banner: m_banner ?? this.m_banner,
      m_level: m_level ?? this.m_level,
      m_u_freq: m_u_freq ?? this.m_u_freq,
      ts_multifil: ts_multifil ?? this.ts_multifil,
      ts_log_types: ts_log_types ?? this.ts_log_types,
      ts_root_logging_db_path:
          ts_root_logging_db_path ?? this.ts_root_logging_db_path,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'm_description': m_description,
      'is_m_description_rich': is_m_description_rich,
      'icon': icon,
      'm_banner': m_banner,
      'm_level': m_level,
      'm_u_freq': m_u_freq,
      'ts_multifil': ts_multifil,
      'ts_log_types': ts_log_types,
      'ts_root_logging_db_path': ts_root_logging_db_path,
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
    };
  }

  factory TrackModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TrackModel(
      id: map['id'],
      name: map['name'],
      m_description: map['m_description'],
      is_m_description_rich: map['is_m_description_rich'],
      icon: map['icon'],
      m_banner: map['m_banner'],
      m_level: map['m_level'],
      m_u_freq: map['m_u_freq'],
      ts_multifil: map['ts_multifil'],
      ts_log_types: map['ts_log_types'],
      ts_root_logging_db_path: map['ts_root_logging_db_path'],
      u_root_level_logging_saved_path: map['u_root_level_logging_saved_path'],
      u_root_level_logging_history_path:
          map['u_root_level_logging_history_path'],
      has_market_detail: map['has_market_detail'],
      ts_num_properties: map['ts_num_properties'],
      m_num_subs: map['m_num_subs'],
      u_chat_groups: map['u_chat_groups'],
      m_num_expert_groups: map['m_num_expert_groups'],
      num_comments: map['num_comments'],
      m_recent_subs: map['m_recent_subs'],
      m_string_1: map['m_string_1'],
      m_string_2: map['m_string_2'],
      m_color: map['m_color'],
      saved_ts: map['saved_ts'],
      u_sub_ts: map['u_sub_ts'],
      u_sub_end_ts: map['u_sub_end_ts'],
      m_rating: map['m_rating'],
      ts_default_sub_days: map['ts_default_sub_days'],
      u_first_fill: map['u_first_fill'],
      u_last_fill: map['u_last_fill'],
      u_num_fills: map['u_num_fills'],
      u_habit_score: map['u_habit_score'],
      u_expert_sub: map['u_expert_sub'],
      u_friends_sub: map['u_friends_sub'],
      ts_can_delete: map['ts_can_delete'],
      ts_autofill: map['ts_autofill'],
      ts_permission_type: map['ts_permission_type'],
      ts_autofill_freq: map['ts_autofill_freq'],
      u_last_autofill_ts: map['u_last_autofill_ts'],
    );
  }

  factory TrackModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;

    return TrackModel(
      id: map['id'],
      name: map['name'],
      m_description: map['m_description'],
      is_m_description_rich: map['is_m_description_rich'],
      icon: map['icon'],
      m_banner: map['m_banner'],
      m_level: map['m_level'],
      m_u_freq: map['m_u_freq'],
      ts_multifil: map['ts_multifil'],
      ts_log_types: map['ts_log_types'],
      ts_root_logging_db_path: map['ts_root_logging_db_path'],
      u_root_level_logging_saved_path: map['u_root_level_logging_saved_path'],
      u_root_level_logging_history_path:
          map['u_root_level_logging_history_path'],
      has_market_detail: map['has_market_detail'],
      ts_num_properties: map['ts_num_properties'],
      m_num_subs: map['m_num_subs'],
      u_chat_groups: map['u_chat_groups'],
      m_num_expert_groups: map['m_num_expert_groups'],
      num_comments: map['num_comments'],
      m_recent_subs: map['m_recent_subs'],
      m_string_1: map['m_string_1'],
      m_string_2: map['m_string_2'],
      m_color: map['m_color'],
      saved_ts: map['saved_ts'],
      u_sub_ts: map['u_sub_ts'],
      u_sub_end_ts: map['u_sub_end_ts'],
      m_rating: map['m_rating'],
      ts_default_sub_days: map['ts_default_sub_days'],
      u_first_fill: map['u_first_fill'],
      u_last_fill: map['u_last_fill'],
      u_num_fills: map['u_num_fills'],
      u_habit_score: map['u_habit_score'],
      u_expert_sub: map['u_expert_sub'],
      u_friends_sub: map['u_friends_sub'],
      ts_can_delete: map['ts_can_delete'],
      ts_autofill: map['ts_autofill'],
      ts_permission_type: map['ts_permission_type'],
      ts_autofill_freq: map['ts_autofill_freq'],
      u_last_autofill_ts: map['u_last_autofill_ts'],
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
