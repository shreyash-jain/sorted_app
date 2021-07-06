import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeStep extends Equatable {
  String description;
  int id;
  int recipe_id;
  int step;
  RecipeStep({
    this.description = '',
    this.id = 0,
    this.recipe_id = 0,
    this.step = 0,
  });

  RecipeStep copyWith({
    String description,
    int id,
    int recipe_id,
    int step,
  }) {
    return RecipeStep(
      description: description ?? this.description,
      id: id ?? this.id,
      recipe_id: recipe_id ?? this.recipe_id,
      step: step ?? this.step,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'id': id,
      'recipe_id': recipe_id,
      'step': step,
    };
  }

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      description: map['description'] ?? '',
      id: map['id'] ?? 0,
      recipe_id: map['recipe_id'] ?? 0,
      step: map['step'] ?? 0,
    );
  }

  factory RecipeStep.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    return RecipeStep(
      description: map['description'] ?? '',
      id: map['id'] ?? 0,
      recipe_id: map['recipe_id'] ?? 0,
      step: map['step'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeStep.fromJson(String source) =>
      RecipeStep.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [description, id, recipe_id, step];
}
