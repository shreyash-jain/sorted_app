import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../TRACK_STORE/domain/entities/track.dart';

//m_facts	is_m_facts_rich	m_reward	is_m_reward_rich

class TrackModel extends Track implements Equatable {
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

  TrackModel({
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

  TrackModel copyWith({
    int id,
    String name,
    String m_description,
    String is_m_description_rich,
    String m_facts,
    String is_m_facts_rich,
    String m_reward,
    String is_m_reward_rich,
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
      m_facts: map['m_facts'],
      is_m_facts_rich: map['is_m_facts_rich'],
      m_reward: map['m_reward'],
      is_m_reward_rich: map['is_m_reward_rich'],
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
    print('MAP ==> ' + map.toString());
    return TrackModel(
      id: map['id'],
      name: map['name'],
      m_description: map['m_description'],
      is_m_description_rich: map['is_m_description_rich'],
      m_facts: map['m_facts'],
      is_m_facts_rich: map['is_m_facts_rich'],
      m_reward: map['m_reward'],
      is_m_reward_rich: map['is_m_reward_rich'],
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
  String toString() {
    return 'TrackModel(id: $id, name: $name, m_description: $m_description, is_m_description_rich: $is_m_description_rich, m_facts: $m_facts, is_m_facts_rich: $is_m_facts_rich, m_reward: $m_reward, is_m_reward_rich: $is_m_reward_rich, icon: $icon, m_banner: $m_banner, m_level: $m_level, m_u_freq: $m_u_freq, ts_multifil: $ts_multifil, ts_log_types: $ts_log_types, ts_root_logging_db_path: $ts_root_logging_db_path, u_root_level_logging_saved_path: $u_root_level_logging_saved_path, u_root_level_logging_history_path: $u_root_level_logging_history_path, has_market_detail: $has_market_detail, ts_num_properties: $ts_num_properties, m_num_subs: $m_num_subs, u_chat_groups: $u_chat_groups, m_num_expert_groups: $m_num_expert_groups, num_comments: $num_comments, m_recent_subs: $m_recent_subs, m_string_1: $m_string_1, m_string_2: $m_string_2, m_color: $m_color, saved_ts: $saved_ts, u_sub_ts: $u_sub_ts, u_sub_end_ts: $u_sub_end_ts, m_rating: $m_rating, ts_default_sub_days: $ts_default_sub_days, u_first_fill: $u_first_fill, u_last_fill: $u_last_fill, u_num_fills: $u_num_fills, u_habit_score: $u_habit_score, u_expert_sub: $u_expert_sub, u_friends_sub: $u_friends_sub, ts_can_delete: $ts_can_delete, ts_autofill: $ts_autofill, ts_permission_type: $ts_permission_type, ts_autofill_freq: $ts_autofill_freq, u_last_autofill_ts: $u_last_autofill_ts)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TrackModel &&
        o.id == id &&
        o.name == name &&
        o.m_description == m_description &&
        o.is_m_description_rich == is_m_description_rich &&
        o.m_facts == m_facts &&
        o.is_m_facts_rich == is_m_facts_rich &&
        o.m_reward == m_reward &&
        o.is_m_reward_rich == is_m_reward_rich &&
        o.icon == icon &&
        o.m_banner == m_banner &&
        o.m_level == m_level &&
        o.m_u_freq == m_u_freq &&
        o.ts_multifil == ts_multifil &&
        o.ts_log_types == ts_log_types &&
        o.ts_root_logging_db_path == ts_root_logging_db_path &&
        o.u_root_level_logging_saved_path == u_root_level_logging_saved_path &&
        o.u_root_level_logging_history_path ==
            u_root_level_logging_history_path &&
        o.has_market_detail == has_market_detail &&
        o.ts_num_properties == ts_num_properties &&
        o.m_num_subs == m_num_subs &&
        o.u_chat_groups == u_chat_groups &&
        o.m_num_expert_groups == m_num_expert_groups &&
        o.num_comments == num_comments &&
        o.m_recent_subs == m_recent_subs &&
        o.m_string_1 == m_string_1 &&
        o.m_string_2 == m_string_2 &&
        o.m_color == m_color &&
        o.saved_ts == saved_ts &&
        o.u_sub_ts == u_sub_ts &&
        o.u_sub_end_ts == u_sub_end_ts &&
        o.m_rating == m_rating &&
        o.ts_default_sub_days == ts_default_sub_days &&
        o.u_first_fill == u_first_fill &&
        o.u_last_fill == u_last_fill &&
        o.u_num_fills == u_num_fills &&
        o.u_habit_score == u_habit_score &&
        o.u_expert_sub == u_expert_sub &&
        o.u_friends_sub == u_friends_sub &&
        o.ts_can_delete == ts_can_delete &&
        o.ts_autofill == ts_autofill &&
        o.ts_permission_type == ts_permission_type &&
        o.ts_autofill_freq == ts_autofill_freq &&
        o.u_last_autofill_ts == u_last_autofill_ts;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        m_description.hashCode ^
        is_m_description_rich.hashCode ^
        m_facts.hashCode ^
        is_m_facts_rich.hashCode ^
        m_reward.hashCode ^
        is_m_reward_rich.hashCode ^
        icon.hashCode ^
        m_banner.hashCode ^
        m_level.hashCode ^
        m_u_freq.hashCode ^
        ts_multifil.hashCode ^
        ts_log_types.hashCode ^
        ts_root_logging_db_path.hashCode ^
        u_root_level_logging_saved_path.hashCode ^
        u_root_level_logging_history_path.hashCode ^
        has_market_detail.hashCode ^
        ts_num_properties.hashCode ^
        m_num_subs.hashCode ^
        u_chat_groups.hashCode ^
        m_num_expert_groups.hashCode ^
        num_comments.hashCode ^
        m_recent_subs.hashCode ^
        m_string_1.hashCode ^
        m_string_2.hashCode ^
        m_color.hashCode ^
        saved_ts.hashCode ^
        u_sub_ts.hashCode ^
        u_sub_end_ts.hashCode ^
        m_rating.hashCode ^
        ts_default_sub_days.hashCode ^
        u_first_fill.hashCode ^
        u_last_fill.hashCode ^
        u_num_fills.hashCode ^
        u_habit_score.hashCode ^
        u_expert_sub.hashCode ^
        u_friends_sub.hashCode ^
        ts_can_delete.hashCode ^
        ts_autofill.hashCode ^
        ts_permission_type.hashCode ^
        ts_autofill_freq.hashCode ^
        u_last_autofill_ts.hashCode;
  }
}
