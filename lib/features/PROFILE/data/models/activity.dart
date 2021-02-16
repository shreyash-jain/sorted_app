import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ActivityModel extends Equatable {
  final int id;
  final String name;
  final String image;
  final DateTime savedTs;
  final double weight;

  ActivityModel({
    this.id,
    this.name,
    this.image,
    this.savedTs,
    this.weight,
  });

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      id,
      name,
      image,
      savedTs,
      weight,
    ];
  }

  ActivityModel copyWith({
    int id,
    String name,
    String image,
    DateTime savedTs,
    double weight,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      savedTs: savedTs ?? this.savedTs,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'saved_ts': savedTs?.millisecondsSinceEpoch,
      'weight': weight,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ActivityModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      savedTs:  DateTime.fromMillisecondsSinceEpoch(map['saved_ts']),
      weight: map['weight'].toDouble(),
    );
  }
  factory ActivityModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;
    print(map['id']);
    print(map['weight']);

    return ActivityModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['saved_ts']),
      weight: map['weight'].toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
