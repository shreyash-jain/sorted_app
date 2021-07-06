import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeNutrition extends Equatable {
  int id;
  String nutrients;
  int recipe_id;
  String units;
  double value;
  RecipeNutrition({
    this.id = 0,
    this.nutrients = '',
    this.recipe_id = 0,
    this.units = '',
    this.value = 0.0,
  });

  RecipeNutrition copyWith({
    int id,
    String nutrients,
    int recipe_id,
    String units,
    double value,
  }) {
    return RecipeNutrition(
      id: id ?? this.id,
      nutrients: nutrients ?? this.nutrients,
      recipe_id: recipe_id ?? this.recipe_id,
      units: units ?? this.units,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nutrients': nutrients,
      'recipe_id': recipe_id,
      'units': units,
      'value': value,
    };
  }

  factory RecipeNutrition.fromMap(Map<String, dynamic> map) {
    return RecipeNutrition(
      id: map['id'] ?? 0,
      nutrients: map['nutrients'] ?? '',
      recipe_id: map['recipe_id'] ?? 0,
      units: map['units'] ?? '',
      value: map['value'] ?? 0.0,
    );
  }

  factory RecipeNutrition.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    return RecipeNutrition(
      id: map['id'] ?? 0,
      nutrients: map['nutrients'] ?? '',
      recipe_id: map['recipe_id'] ?? 0,
      units: map['units'] ?? '',
      value: (map['value'] is double)
          ? map['value']
          : (map['value']).toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeNutrition.fromJson(String source) =>
      RecipeNutrition.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      nutrients,
      recipe_id,
      units,
      value,
    ];
  }
}
