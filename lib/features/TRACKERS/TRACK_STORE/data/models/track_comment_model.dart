import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/track_comment.dart';

class TrackCommentModel extends TrackComment implements Equatable {
  int id;
  String user_name;
  String user_id;
  String user_icon;
  String comment;
  double sentiment_value;
  TrackCommentModel({
    this.id,
    this.user_name,
    this.user_id,
    this.user_icon,
    this.comment,
    this.sentiment_value,
  });

  TrackCommentModel copyWith({
    int id,
    String user_name,
    String user_id,
    String user_icon,
    String comment,
    double sentiment_value,
  }) {
    return TrackCommentModel(
      id: id ?? this.id,
      user_name: user_name ?? this.user_name,
      user_id: user_id ?? this.user_id,
      user_icon: user_icon ?? this.user_icon,
      comment: comment ?? this.comment,
      sentiment_value: sentiment_value ?? this.sentiment_value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': user_name,
      'user_id': user_id,
      'user_icon': user_icon,
      'comment': comment,
      'sentiment_value': sentiment_value,
    };
  }

  factory TrackCommentModel.fromMap(Map<String, dynamic> map) {
    return TrackCommentModel(
      id: map['id'],
      user_name: map['user_name'],
      user_id: map['user_id'],
      user_icon: map['user_icon'],
      comment: map['comment'],
      sentiment_value: map['sentiment_value'],
    );
  }

  factory TrackCommentModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;

    return TrackCommentModel(
      id: map['id'],
      user_name: map['user_name'],
      user_id: map['user_id'],
      user_icon: map['user_icon'],
      comment: map['comment'].toString().trim(),
      sentiment_value: map['sentiment_value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackCommentModel.fromJson(String source) =>
      TrackCommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TrackCommentModel(id: $id, user_name: $user_name, user_id: $user_id, user_icon: $user_icon, comment: $comment, sentiment_value: $sentiment_value)';
  }
}
