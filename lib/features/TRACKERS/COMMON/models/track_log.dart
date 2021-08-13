import 'dart:convert';

import 'package:equatable/equatable.dart';

class TrackLog extends Equatable {
  int property_id;
  int track_id;
  int id;
  String value;
  int property_type;
  DateTime time;
  TrackLog({
    this.property_id = 0,
    this.track_id = 0,
    this.id = 0,
    this.value = '',
    this.property_type = 0,
    this.time,
  });

  TrackLog copyWith({
    int property_id,
    int track_id,
    String value,
    int property_type,
    DateTime time,
    DateTime id,
  }) {
    return TrackLog(
      property_id: property_id ?? this.property_id,
      track_id: track_id ?? this.track_id,
      id: id ?? this.id,
      value: value ?? this.value,
      property_type: property_type ?? this.property_type,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'property_id': property_id,
      'track_id': track_id,
      'id': id,
      'value': value,
      'property_type': property_type,
      'time': time.toIso8601String(),
    };
  }

  factory TrackLog.fromMap(Map<String, dynamic> map) {
    var timethis = DateTime.parse(map['time']);

    
    return TrackLog(
      property_id: map['property_id'] ?? 0,
      track_id: map['track_id'] ?? 0,
      id: map['id'] ?? 0,
      value: map['value'] ?? '',
      property_type: map['property_type'] ?? 0,
      time: DateTime.parse(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackLog.fromJson(String source) =>
      TrackLog.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      property_id,
      track_id,
      id,
      value,
      property_type,
      time,
    ];
  }
}
