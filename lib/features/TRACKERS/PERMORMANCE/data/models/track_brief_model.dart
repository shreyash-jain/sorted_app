import 'dart:convert';

import 'package:equatable/equatable.dart';
import '../../domain/entities/track_brief.dart';

class TrackBriefModel extends TrackBrief implements Equatable {
  int track_id;
  String track_name;
  String track_icon;
  TrackBriefModel({
    this.track_id,
    this.track_name,
    this.track_icon,
  });

  TrackBriefModel copyWith({
    int track_id,
    String track_name,
    String track_icon,
  }) {
    return TrackBriefModel(
      track_id: track_id ?? this.track_id,
      track_name: track_name ?? this.track_name,
      track_icon: track_icon ?? this.track_icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'track_id': track_id,
      'track_name': track_name,
      'track_icon': track_icon,
    };
  }

  factory TrackBriefModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TrackBriefModel(
      track_id: map['track_id'],
      track_name: map['track_name'],
      track_icon: map['track_icon'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackBriefModel.fromJson(String source) =>
      TrackBriefModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [track_id, track_name, track_icon];
}
