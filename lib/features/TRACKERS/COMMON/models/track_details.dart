import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserTracks extends Equatable {
  List<int> subscribed_ids;
  List<int> paused_ids;
  UserTracks({
    this.subscribed_ids = const [],
    this.paused_ids = const [],
  });

  UserTracks copyWith({
    List<int> subscribed_ids,
    List<int> paused_ids,
  }) {
    return UserTracks(
      subscribed_ids: subscribed_ids ?? this.subscribed_ids,
      paused_ids: paused_ids ?? this.paused_ids,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subscribed_ids': subscribed_ids,
      'paused_ids': paused_ids,
    };
  }

  factory UserTracks.fromMap(Map<String, dynamic> map) {
    return UserTracks(
      subscribed_ids: List<int>.from(map['subscribed_ids'] ?? const []),
      paused_ids: List<int>.from(map['paused_ids'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTracks.fromJson(String source) =>
      UserTracks.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [subscribed_ids, paused_ids];
}
