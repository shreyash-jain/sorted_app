import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MarketBanner extends Equatable {
  int id;
  int action;
  String heading;
  String sub_heading;
  String image_url;
  List<int> tracks;
  MarketBanner({
    this.id = 0,
    this.action = 0,
    this.heading = '',
    this.sub_heading = '',
    this.image_url = '',
    this.tracks = const [],
  });

  MarketBanner copyWith({
    int id,
    int action,
    String heading,
    String sub_heading,
    String image_url,
    List<int> tracks,
  }) {
    return MarketBanner(
      id: id ?? this.id,
      action: action ?? this.action,
      heading: heading ?? this.heading,
      sub_heading: sub_heading ?? this.sub_heading,
      image_url: image_url ?? this.image_url,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'heading': heading,
      'sub_heading': sub_heading,
      'image_url': image_url,
      'tracks': tracks,
    };
  }

  factory MarketBanner.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MarketBanner(
      id: map['id'],
      action: map['action'],
      heading: map['heading'],
      sub_heading: map['sub_heading'],
      image_url: map['image_url'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  factory MarketBanner.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;

    return MarketBanner(
      id: map['id'],
      action: map['action'],
      heading: map['heading'],
      sub_heading: map['sub_heading'],
      image_url: map['image_url'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketBanner.fromJson(String source) =>
      MarketBanner.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      action,
      heading,
      sub_heading,
      image_url,
      tracks,
    ];
  }
}
