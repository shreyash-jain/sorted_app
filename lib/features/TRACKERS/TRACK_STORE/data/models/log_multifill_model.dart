import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/log_multifill.dart';

class LogMultifillModel extends LogMultifill {
  final int id;
  final int track_id;
  final int confirmation_value;
  final int ts;
  final int rating;
  final double sum;
  LogMultifillModel({
    this.id,
    this.track_id,
    this.confirmation_value,
    this.ts,
    this.rating,
    this.sum,
  });

  LogMultifillModel copyWith({
    int id,
    int track_id,
    int confirmation_value,
    int ts,
    int rating,
    double sum,
  }) {
    return LogMultifillModel(
      id: id ?? this.id,
      track_id: track_id ?? this.track_id,
      confirmation_value: confirmation_value ?? this.confirmation_value,
      ts: ts ?? this.ts,
      rating: rating ?? this.rating,
      sum: sum ?? this.sum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'track_id': track_id,
      'confirmation_value': confirmation_value,
      'ts': ts,
      'rating': rating,
      'sum': sum,
    };
  }

  factory LogMultifillModel.fromMap(Map<String, dynamic> map) {
    return LogMultifillModel(
      id: map['id'] ?? null,
      track_id: map['track_id'] ?? null,
      confirmation_value: map['confirmation_value'] ?? null,
      ts: map['ts'] ?? null,
      rating: map['rating'] ?? null,
      sum: map['sum'] ?? null,
    );
  }
  factory LogMultifillModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;
    return LogMultifillModel.fromMap(map);
  }

  String toJson() => json.encode(toMap());

  factory LogMultifillModel.fromJson(String source) =>
      LogMultifillModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LogMultifillModel(id: $id, track_id: $track_id, confirmation_value: $confirmation_value, ts: $ts, rating: $rating, sum: $sum)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LogMultifillModel &&
        other.id == id &&
        other.track_id == track_id &&
        other.confirmation_value == confirmation_value &&
        other.ts == ts &&
        other.rating == rating &&
        other.sum == sum;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        track_id.hashCode ^
        confirmation_value.hashCode ^
        ts.hashCode ^
        rating.hashCode ^
        sum.hashCode;
  }
}
