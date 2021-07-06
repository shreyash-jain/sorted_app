import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeIngredient extends Equatable {
  String hind_name;
  int id;
  String image_url;
  String name;
  String wikipedia_links;
  RecipeIngredient({
    this.hind_name = '',
    this.id = 0,
    this.image_url = '',
    this.name = '',
    this.wikipedia_links = '',
  });

  RecipeIngredient copyWith({
    String hind_name,
    int id,
    String image_url,
    String name,
    String wikipedia_links,
  }) {
    return RecipeIngredient(
      hind_name: hind_name ?? this.hind_name,
      id: id ?? this.id,
      image_url: image_url ?? this.image_url,
      name: name ?? this.name,
      wikipedia_links: wikipedia_links ?? this.wikipedia_links,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hind_name': hind_name,
      'id': id,
      'image_url': image_url,
      'name': name,
      'wikipedia_links': wikipedia_links,
    };
  }

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(
      hind_name: map['hind_name'] ?? '',
      id: map['id'] ?? 0,
      image_url: map['image_url'] ?? '',
      name: map['name'] ?? '',
      wikipedia_links: map['wikipedia_links'] ?? '',
    );
  }
  factory RecipeIngredient.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    return RecipeIngredient(
      hind_name: map['hind_name'] ?? '',
      id: map['id'] ?? 0,
      image_url: map['image_url'] ?? '',
      name: map['name'] ?? '',
      wikipedia_links: map['wikipedia_links'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeIngredient.fromJson(String source) =>
      RecipeIngredient.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      hind_name,
      id,
      image_url,
      name,
      wikipedia_links,
    ];
  }
}
