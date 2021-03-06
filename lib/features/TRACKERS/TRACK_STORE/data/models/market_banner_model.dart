import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/market_banner.dart';
import '../../domain/entities/track.dart';
import '../../../COMMON/models/track_model.dart';

class MarketBannerModel extends MarketBanner implements Equatable {
  int id;
  int action;
  String heading;
  String sub_heading;
  String image_url;
  String text_color;
  List<int> tracks;
  List<Track> tracksDetail;
  MarketBannerModel({
    this.id = 0,
    this.action = 0,
    this.heading = '',
    this.sub_heading = '',
    this.image_url = '',
    this.text_color = '',
    this.tracks = const [],
  });

  MarketBannerModel copyWith({
    int id,
    int action,
    String heading,
    String sub_heading,
    String image_url,
    String text_color,
    List<int> tracks,
  }) {
    return MarketBannerModel(
      id: id ?? this.id,
      action: action ?? this.action,
      heading: heading ?? this.heading,
      sub_heading: sub_heading ?? this.sub_heading,
      image_url: image_url ?? this.image_url,
      text_color: text_color ?? this.text_color,
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
      'text_color': text_color,
      'tracks': tracks,
    };
  }

  factory MarketBannerModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MarketBannerModel(
      id: map['id'],
      action: map['action'],
      heading: map['heading'],
      sub_heading: map['sub_heading'],
      image_url: map['image_url'],
      text_color: map['text_color'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  factory MarketBannerModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;

    return MarketBannerModel(
      id: map['id'],
      action: map['action'],
      heading: map['heading'],
      sub_heading: map['sub_heading'],
      image_url: map['image_url'],
      text_color: map['text_color'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketBannerModel.fromJson(String source) =>
      MarketBannerModel.fromMap(json.decode(source));

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
      text_color,
      tracks,
    ];
  }
}
