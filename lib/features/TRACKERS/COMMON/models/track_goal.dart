import 'dart:convert';

import 'package:equatable/equatable.dart';

class TrackGoal extends Equatable {
  int id;
  int track_id;
  String goal_name;
  String goal_description;
  String icon_url;
  TrackGoal({
    this.id = 0,
    this.track_id = 0,
    this.goal_name = '',
    this.goal_description = '',
    this.icon_url = '',
  });

  TrackGoal copyWith({
    int id,
    int track_id,
    String goal_name,
    String goal_description,
    String icon_url,
  }) {
    return TrackGoal(
      id: id ?? this.id,
      track_id: track_id ?? this.track_id,
      goal_name: goal_name ?? this.goal_name,
      goal_description: goal_description ?? this.goal_description,
      icon_url: icon_url ?? this.icon_url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'track_id': track_id,
      'goal_name': goal_name,
      'goal_description': goal_description,
      'icon_url': icon_url,
    };
  }

  factory TrackGoal.fromMap(Map<String, dynamic> map) {
    return TrackGoal(
      id: map['id'] ?? 0,
      track_id: map['track_id'] ?? 0,
      goal_name: map['goal_name'] ?? '',
      goal_description: map['goal_description'] ?? '',
      icon_url: map['icon_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackGoal.fromJson(String source) =>
      TrackGoal.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      track_id,
      goal_name,
      goal_description,
      icon_url,
    ];
  }
}
