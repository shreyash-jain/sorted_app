import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/market_heading.dart';

class MarketHeadingModel extends MarketHeading implements Equatable {
  int id;
  String icon;
  String name;
  String image_url;
  List<int> tracks;
  List<Track> tracksDetail;
  MarketHeadingModel({
    this.id = 0,
    this.icon = '',
    this.name = '',
    this.image_url = '',
    this.tracks = const [],
  });

  MarketHeadingModel copyWith({
    int id,
    String icon,
    String name,
    String image_url,
    List<int> tracks,
  }) {
    return MarketHeadingModel(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      image_url: image_url ?? this.image_url,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'image_url': image_url,
      'tracks': tracks,
    };
  }

  factory MarketHeadingModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MarketHeadingModel(
      id: map['id'],
      icon: map['icon'],
      name: map['name'],
      image_url: map['image_url'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  factory MarketHeadingModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;

    return MarketHeadingModel(
      id: map['id'],
      icon: map['icon'],
      name: map['name'],
      image_url: map['image_url'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketHeadingModel.fromJson(String source) =>
      MarketHeadingModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      icon,
      name,
      image_url,
      tracks,
    ];
  }
}