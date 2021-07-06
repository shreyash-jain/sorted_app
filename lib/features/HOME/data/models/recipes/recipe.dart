import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeModel extends Equatable {
  int cook_time;
  String description;
  int id;
  String image_url;
  String name;
  int preparation_time;
  int total_time;
  RecipeModel({
    this.cook_time = 0,
    this.description = '',
    this.id = 0,
    this.image_url = '',
    this.name = '',
    this.preparation_time = 0,
    this.total_time = 0,
  });

  RecipeModel copyWith({
    int cook_time,
    String description,
    int id,
    String image_url,
    String name,
    int preparation_time,
    int total_time,
  }) {
    return RecipeModel(
      cook_time: cook_time ?? this.cook_time,
      description: description ?? this.description,
      id: id ?? this.id,
      image_url: image_url ?? this.image_url,
      name: name ?? this.name,
      preparation_time: preparation_time ?? this.preparation_time,
      total_time: total_time ?? this.total_time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cook_time': cook_time,
      'description': description,
      'id': id,
      'image_url': image_url,
      'name': name,
      'preparation_time': preparation_time,
      'total_time': total_time,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      cook_time: map['cook_time'] ?? 0,
      description: map['description'] ?? '',
      id: map['id'] ?? 0,
      image_url: map['image_url'] ?? '',
      name: map['name'] ?? '',
      preparation_time: map['preparation_time'] ?? 0,
      total_time: map['total_time'] ?? 0,
    );
  }

  factory RecipeModel.empty() {
    return RecipeModel(
      cook_time: 0,
      description:'',
      id: -1,
      image_url:  '',
      name: '',
      preparation_time: 0,
      total_time: 0,
    );
  }
    factory RecipeModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;
    return RecipeModel(
      cook_time: map['cook_time'] ?? 0,
      description: map['description'] ?? '',
      id: map['id'] ?? 0,
      image_url: map['image_url'] ?? '',
      name: map['name'] ?? '',
      preparation_time: map['preparation_time'] ?? 0,
      total_time: map['total_time'] ?? 0,
    );
  }


  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(String source) =>
      RecipeModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      cook_time,
      description,
      id,
      image_url,
      name,
      preparation_time,
      total_time,
    ];
  }
}
