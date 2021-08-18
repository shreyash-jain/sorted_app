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
  List<String> ingredients_name;
  List<int> ingredients_quantity;
  List<String> ingredients_units;
  List<String> steps;
  List<String> nutrients_name;
  List<double> nutrients_value;
  List<String> nutrients_units;
  RecipeModel({
    this.cook_time = 0,
    this.description = '',
    this.id = 0,
    this.image_url = '',
    this.name = '',
    this.preparation_time = 0,
    this.total_time = 0,
    this.ingredients_name = const [],
    this.ingredients_quantity = const [],
    this.ingredients_units = const [],
    this.steps = const [],
    this.nutrients_name = const [],
    this.nutrients_value = const [],
    this.nutrients_units = const [],
  });

  factory RecipeModel.empty() {
    return RecipeModel().copyWith(id: -1);
  }
  factory RecipeModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;

    String imageUrl = map['image_url'] ?? '';
    https: //www.tarladalal.com/https://cdn.tarladalal.com/members/9306/big/big_sweet_potato_and_spring_onion_soup-7188.jpg?

    imageUrl = imageUrl.replaceAll("https://www.tarladalal.com/", "");

    return RecipeModel(
      cook_time: map['cook_time'].toInt() ?? 0,
      description: map['description'] ?? '',
      id: map['id'] ?? 0,
      image_url: imageUrl,
      name: map['name'] ?? '',
      preparation_time: map['preparation_time'].toInt() ?? 0,
      total_time: map['total_time'] ?? 0,
      ingredients_name: List<String>.from(map['ingredients_name'] ?? const []),
      ingredients_quantity: List<int>.from(map['ingredients_quantity'].map((e) {
            if (e != null) return (e.toInt());
          }) ??
          const []),
      ingredients_units:
          List<String>.from(map['ingredients_units'] ?? const []),
      steps: List<String>.from(map['steps'] ?? const []),
      nutrients_name: List<String>.from(map['nutrients_name'] ?? const []),
      nutrients_value: List<double>.from(map['nutrients_value'].map((e) {
            if (e != null) return (e.toDouble());
          }) ??
          const []),
      nutrients_units: List<String>.from(map['nutrients_units'] ?? const []),
    );
  }

  RecipeModel copyWith({
    int cook_time,
    String description,
    int id,
    String image_url,
    String name,
    int preparation_time,
    int total_time,
    List<String> ingredients_name,
    List<int> ingredients_quantity,
    List<String> ingredients_units,
    List<String> steps,
    List<String> nutrients_name,
    List<int> nutrients_value,
    List<String> nutrients_units,
  }) {
    return RecipeModel(
      cook_time: cook_time ?? this.cook_time,
      description: description ?? this.description,
      id: id ?? this.id,
      image_url: image_url ?? this.image_url,
      name: name ?? this.name,
      preparation_time: preparation_time ?? this.preparation_time,
      total_time: total_time ?? this.total_time,
      ingredients_name: ingredients_name ?? this.ingredients_name,
      ingredients_quantity: ingredients_quantity ?? this.ingredients_quantity,
      ingredients_units: ingredients_units ?? this.ingredients_units,
      steps: steps ?? this.steps,
      nutrients_name: nutrients_name ?? this.nutrients_name,
      nutrients_value: nutrients_value ?? this.nutrients_value,
      nutrients_units: nutrients_units ?? this.nutrients_units,
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
      'ingredients_name': ingredients_name,
      'ingredients_quantity': ingredients_quantity,
      'ingredients_units': ingredients_units,
      'steps': steps,
      'nutrients_name': nutrients_name,
      'nutrients_value': nutrients_value,
      'nutrients_units': nutrients_units,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    String imageUrl = map['image_url'] ?? '';

    imageUrl = imageUrl.replaceAll("https://www.tarladalal.com/", "");
    return RecipeModel(
      cook_time: map['cook_time'].toInt() ?? 0,
      description: map['description'] ?? '',
      id: map['id'] ?? 0,
      image_url: imageUrl,
      name: map['name'] ?? '',
      preparation_time: map['preparation_time'].toInt() ?? 0,
      total_time: map['total_time'] ?? 0,
      ingredients_name: List<String>.from(map['ingredients_name'] ?? const []),
      ingredients_quantity: List<int>.from(map['ingredients_quantity'].map((e) {
            if (e != null) return (e.toInt());
          }) ??
          const []),
      ingredients_units:
          List<String>.from(map['ingredients_units'] ?? const []),
      steps: List<String>.from(map['steps'] ?? const []),
      nutrients_name: List<String>.from(map['nutrients_name'] ?? const []),
      nutrients_value: List<double>.from(map['nutrients_value'].map((e) {
            if (e != null) return (e.toDouble());
          }) ??
          const []),
      nutrients_units: List<String>.from(map['nutrients_units'] ?? const []),
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
      ingredients_name,
      ingredients_quantity,
      ingredients_units,
      steps,
      nutrients_name,
      nutrients_value,
      nutrients_units,
    ];
  }
}
