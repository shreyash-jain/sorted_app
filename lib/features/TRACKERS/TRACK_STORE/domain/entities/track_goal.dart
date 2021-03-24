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
