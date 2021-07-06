import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VideoRecipe extends Equatable {
  int id;
  String image_url;
  String name;
  int recipe_id;
  String video_url;
  VideoRecipe({
    this.id = 0,
    this.image_url = '',
    this.name = '',
    this.recipe_id = 0,
    this.video_url = '',
  });

  VideoRecipe copyWith({
    int id,
    String image_url,
    String name,
    int recipe_id,
    String video_url,
  }) {
    return VideoRecipe(
      id: id ?? this.id,
      image_url: image_url ?? this.image_url,
      name: name ?? this.name,
      recipe_id: recipe_id ?? this.recipe_id,
      video_url: video_url ?? this.video_url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_url': image_url,
      'name': name,
      'recipe_id': recipe_id,
      'video_url': video_url,
    };
  }

  factory VideoRecipe.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;
    return VideoRecipe(
      id: map['id'] ?? 0,
      image_url: map['image_url'] ?? '',
      name: map['name'] ?? '',
      recipe_id: map['recipe_id'] ?? 0,
      video_url: map['video_url'] ?? '',
    );
  }

  factory VideoRecipe.empty() {
    return VideoRecipe(
      id: -1,
      image_url: '',
      name: '',
      recipe_id: 0,
      video_url: '',
    );
  }

  factory VideoRecipe.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return VideoRecipe(
      id: map['id'] ?? 0,
      image_url: map['image_url'] ?? '',
      name: map['name'] ?? '',
      recipe_id: map['recipe_id'] ?? 0,
      video_url: map['video_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoRecipe.fromJson(String source) =>
      VideoRecipe.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      image_url,
      name,
      recipe_id,
      video_url,
    ];
  }
}
