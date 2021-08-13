import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TrackComments extends Equatable {
  String text;
  int id;
  int date;
  int track_id;
  int likes;
  TrackComments({
    this.text = '',
    this.id = 0,
    this.date = 0,
    this.track_id = 0,
    this.likes = 0,
  });

  TrackComments copyWith({
    String text,
    int id,
    int date,
    int track_id,
    int likes,
  }) {
    return TrackComments(
      text: text ?? this.text,
      id: id ?? this.id,
      date: date ?? this.date,
      track_id: track_id ?? this.track_id,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'id': id,
      'date': date,
      'track_id': track_id,
      'likes': likes,
    };
  }

  factory TrackComments.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TrackComments(
      text: map['text'],
      id: map['id'],
      date: map['date'],
      track_id: map['track_id'],
      likes: map['likes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackComments.fromJson(String source) =>
      TrackComments.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      text,
      id,
      date,
      track_id,
      likes,
    ];
  }
}
