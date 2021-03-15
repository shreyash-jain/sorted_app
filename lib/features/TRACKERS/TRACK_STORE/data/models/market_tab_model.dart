import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/market_tab.dart';
import '../../domain/entities/track.dart';

class MarketTabModel extends MarketTab implements Equatable {
  int id;
  String name;
  List<int> tracks;
  MarketTabModel({
    this.id,
    this.name,
    this.tracks,
  });

  MarketTabModel copyWith({
    int id,
    String name,
    List<int> tracks,
  }) {
    return MarketTabModel(
      id: id ?? this.id,
      name: name ?? this.name,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tracks': tracks,
    };
  }

  factory MarketTabModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MarketTabModel(
      id: map['id'],
      name: map['name'],
      tracks: List<int>.from(map['tracks']),
    );
  }

  factory MarketTabModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;
    return MarketTabModel.fromMap(map);
  }

  String toJson() => json.encode(toMap());

  factory MarketTabModel.fromJson(String source) =>
      MarketTabModel.fromMap(json.decode(source));

  @override
  String toString() => 'MarketTabModel(id: $id, name: $name, tracks: $tracks)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MarketTabModel &&
        o.id == id &&
        o.name == name &&
        listEquals(o.tracks, tracks);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ tracks.hashCode;
}
