import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TrackModel extends Equatable {
  int id;
  String name;
  String m_description;
  String m_facts;
  String m_reward;
  String icon;
  int m_level;

  int ts_multifil;
  int ts_log_types;

  int ts_default_sub_days;
  int ts_can_delete;
  int ts_autofill;
  int ts_permission_type;
  int ts_autofill_freq;

  int ts_has_confirmation;

  List<String> carousel;
  String confirmation_question;
  int primary_property_id;
  TrackModel({
    this.id = 0,
    this.name = '',
    this.m_description = '',
    this.m_facts = '',
    this.m_reward = '',
    this.icon = '',
    this.m_level = 0,
    this.ts_multifil = 0,
    this.ts_log_types = 0,
    this.ts_default_sub_days = 0,
    this.ts_can_delete = 0,
    this.ts_autofill = 0,
    this.ts_permission_type = 0,
    this.ts_autofill_freq = 0,
    this.ts_has_confirmation = 0,
    this.carousel = const [],
    this.confirmation_question = '',
    this.primary_property_id = 0,
  });

  TrackModel copyWith({
    int id,
    String name,
    String m_description,
    String m_facts,
    String m_reward,
    String icon,
    int m_level,
    int ts_multifil,
    int ts_log_types,
    int ts_default_sub_days,
    int ts_can_delete,
    int ts_autofill,
    int ts_permission_type,
    int ts_autofill_freq,
    int ts_has_confirmation,
    List<String> carousel,
    String confirmation_question,
    int primary_property_id,
  }) {
    return TrackModel(
      id: id ?? this.id,
      name: name ?? this.name,
      m_description: m_description ?? this.m_description,
      m_facts: m_facts ?? this.m_facts,
      m_reward: m_reward ?? this.m_reward,
      icon: icon ?? this.icon,
      m_level: m_level ?? this.m_level,
      ts_multifil: ts_multifil ?? this.ts_multifil,
      ts_log_types: ts_log_types ?? this.ts_log_types,
      ts_default_sub_days: ts_default_sub_days ?? this.ts_default_sub_days,
      ts_can_delete: ts_can_delete ?? this.ts_can_delete,
      ts_autofill: ts_autofill ?? this.ts_autofill,
      ts_permission_type: ts_permission_type ?? this.ts_permission_type,
      ts_autofill_freq: ts_autofill_freq ?? this.ts_autofill_freq,
      ts_has_confirmation: ts_has_confirmation ?? this.ts_has_confirmation,
      carousel: carousel ?? this.carousel,
      confirmation_question: confirmation_question ?? this.confirmation_question,
      primary_property_id: primary_property_id ?? this.primary_property_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'm_description': m_description,
      'm_facts': m_facts,
      'm_reward': m_reward,
      'icon': icon,
      'm_level': m_level,
      'ts_multifil': ts_multifil,
      'ts_log_types': ts_log_types,
      'ts_default_sub_days': ts_default_sub_days,
      'ts_can_delete': ts_can_delete,
      'ts_autofill': ts_autofill,
      'ts_permission_type': ts_permission_type,
      'ts_autofill_freq': ts_autofill_freq,
      'ts_has_confirmation': ts_has_confirmation,
      'carousel': carousel,
      'confirmation_question': confirmation_question,
      'primary_property_id': primary_property_id,
    };
  }

  factory TrackModel.fromMap(Map<String, dynamic> map) {
    return TrackModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      m_description: map['m_description'] ?? '',
      m_facts: map['m_facts'] ?? '',
      m_reward: map['m_reward'] ?? '',
      icon: map['icon'] ?? '',
      m_level: map['m_level'] ?? 0,
      ts_multifil: map['ts_multifil'] ?? 0,
      ts_log_types: map['ts_log_types'] ?? 0,
      ts_default_sub_days: map['ts_default_sub_days'] ?? 0,
      ts_can_delete: map['ts_can_delete'] ?? 0,
      ts_autofill: map['ts_autofill'] ?? 0,
      ts_permission_type: map['ts_permission_type'] ?? 0,
      ts_autofill_freq: map['ts_autofill_freq'] ?? 0,
      ts_has_confirmation: map['ts_has_confirmation'] ?? 0,
      carousel: List<String>.from(map['carousel'] ?? const []),
      confirmation_question: map['confirmation_question'] ?? '',
      primary_property_id: map['primary_property_id'] ?? 0,
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
      m_facts,
      m_reward,
      icon,
      m_level,
      ts_multifil,
      ts_log_types,
      ts_default_sub_days,
      ts_can_delete,
      ts_autofill,
      ts_permission_type,
      ts_autofill_freq,
      ts_has_confirmation,
      carousel,
      confirmation_question,
      primary_property_id,
    ];
  }
}
