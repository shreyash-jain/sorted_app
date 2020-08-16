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
      'savedTs': savedTs?.toIso8601String(),
      'weight': weight,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ActivityModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      savedTs: DateTime.parse(map['savedTs']),
      weight: map['weight'],
    );
  }
  factory ActivityModel.fromSnapshot(DocumentSnapshot map) {
    if (map == null) return null;

    return ActivityModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      savedTs: DateTime.parse(map['savedTs']),
      weight: map['weight'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
