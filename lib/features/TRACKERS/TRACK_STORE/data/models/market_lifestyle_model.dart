import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/track.dart';

class MarketLifestyleModel extends Equatable {
  int id;
  String heading;
  String sub_heading;
  String description;
  String url;
  List<int> tracks;
  List<Track> tracksDetail;
  MarketLifestyleModel({
    this.id = 0,
    this.heading = '',
    this.sub_heading = '',
    this.description = '',
    this.url = '',
    this.tracks = const [],
  });

  MarketLifestyleModel copyWith({
    int id,
    String heading,
    String sub_heading,
    String description,
    String url,
    List<int> tracks,
  }) {
    return MarketLifestyleModel(
      id: id ?? this.id,
      heading: heading ?? this.heading,
      sub_heading: sub_heading ?? this.sub_heading,
      description: description ?? this.description,
      url: url ?? this.url,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'heading': heading,
      'sub_heading': sub_heading,
      'description': description,
      'url': url,
      'tracks': tracks,
    };
  }

  factory MarketLifestyleModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MarketLifestyleModel(
      id: map['id'],
      heading: map['heading'],
      sub_heading: map['sub_heading'],
      description: map['description'],
      url: map['url'],
      tracks: List<int>.from(map['tracks']),
    );
  }
  factory MarketLifestyleModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;

    return MarketLifestyleModel(
      id: map['id'],
      heading: map['heading'],
      sub_heading: map['sub_heading'],
      description: map['description'],
      url: map['url'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketLifestyleModel.fromJson(String source) =>
      MarketLifestyleModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      heading,
      sub_heading,
      description,
      url,
      tracks,
    ];
  }
}
