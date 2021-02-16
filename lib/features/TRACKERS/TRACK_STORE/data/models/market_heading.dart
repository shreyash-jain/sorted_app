import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MarketHeading extends Equatable {
  int id;
  String icon;
  String heading;
  String sub_heading;
  String image_url;
  List<int> tracks;
  MarketHeading({
    this.id = 0,
    this.icon = '',
    this.heading = '',
    this.sub_heading = '',
    this.image_url = '',
    this.tracks = const [],
  });

  MarketHeading copyWith({
    int id,
    String icon,
    String heading,
    String sub_heading,
    String image_url,
    List<int> tracks,
  }) {
    return MarketHeading(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      heading: heading ?? this.heading,
      sub_heading: sub_heading ?? this.sub_heading,
      image_url: image_url ?? this.image_url,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'heading': heading,
      'sub_heading': sub_heading,
      'image_url': image_url,
      'tracks': tracks,
    };
  }

  factory MarketHeading.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MarketHeading(
      id: map['id'],
      icon: map['icon'],
      heading: map['heading'],
      sub_heading: map['sub_heading'],
      image_url: map['image_url'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  factory MarketHeading.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;

    return MarketHeading(
      id: map['id'],
      icon: map['icon'],
      heading: map['heading'],
      sub_heading: map['sub_heading'],
      image_url: map['image_url'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketHeading.fromJson(String source) =>
      MarketHeading.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      icon,
      heading,
      sub_heading,
      image_url,
      tracks,
    ];
  }
}
