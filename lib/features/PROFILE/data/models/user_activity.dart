import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserAModel extends Equatable {
  final int id;
  final String name;
  final String image;
  final DateTime savedTs;

  final int aId;
  UserAModel({
    this.id,
    this.name = '',
    this.image = '',
    this.savedTs,
    this.aId = 0,
  });

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      id,
      name,
      image,
      savedTs,
      aId,
    ];
  }

  UserAModel copyWith({
    int id,
    String name,
    String image,
    DateTime savedTs,
    int aId,
  }) {
    return UserAModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      savedTs: savedTs ?? this.savedTs,
      aId: aId ?? this.aId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'saved_ts': savedTs?.millisecondsSinceEpoch,
      'a_id': aId,
    };
  }

  factory UserAModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserAModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      savedTs:  DateTime.fromMillisecondsSinceEpoch(map['saved_ts']),
      aId: map['a_id'],
    );
  }
  factory UserAModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data()  as Map;
    if (map == null) return null;

    return UserAModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['saved_ts']),
      aId: map['a_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAModel.fromJson(String source) =>
      UserAModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
