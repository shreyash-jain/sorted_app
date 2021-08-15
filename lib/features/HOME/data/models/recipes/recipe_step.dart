import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeStep extends Equatable {
  String description;

  int step;
  RecipeStep({
    this.description = '',
    this.step = 0,
  });


  RecipeStep copyWith({
    String description,
    int step,
  }) {
    return RecipeStep(
      description: description ?? this.description,
      step: step ?? this.step,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'step': step,
    };
  }

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      description: map['description'] ?? '',
      step: map['step'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeStep.fromJson(String source) => RecipeStep.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [description, step];
}
