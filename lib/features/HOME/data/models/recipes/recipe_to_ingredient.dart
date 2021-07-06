import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeToIngredient extends Equatable {
  int id;
  int ingredient_id;
  int quality;
  int recipe_id;
  String unit;
  RecipeToIngredient({
    this.id = 0,
    this.ingredient_id = 0,
    this.quality = 0,
    this.recipe_id = 0,
    this.unit = '',
  });

  RecipeToIngredient copyWith({
    int id,
    int ingredient_id,
    int quality,
    int recipe_id,
    String unit,
  }) {
    return RecipeToIngredient(
      id: id ?? this.id,
      ingredient_id: ingredient_id ?? this.ingredient_id,
      quality: quality ?? this.quality,
      recipe_id: recipe_id ?? this.recipe_id,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ingredient_id': ingredient_id,
      'quality': quality,
      'recipe_id': recipe_id,
      'unit': unit,
    };
  }

  factory RecipeToIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeToIngredient(
      id: map['id'] ?? 0,
      ingredient_id: map['ingredient_id'] ?? 0,
      quality: map['quality'] ?? 0,
      recipe_id: map['recipe_id'] ?? 0,
      unit: map['unit'] ?? '',
    );
  }

  factory RecipeToIngredient.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    return RecipeToIngredient(
      id: map['id'] ?? 0,
      ingredient_id: map['ingredient_id'] ?? 0,
      quality: map['quality'] ?? 0,
      recipe_id: map['recipe_id'] ?? 0,
      unit: map['unit'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeToIngredient.fromJson(String source) =>
      RecipeToIngredient.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      ingredient_id,
      quality,
      recipe_id,
      unit,
    ];
  }
}
