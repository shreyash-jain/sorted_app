import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeIngredients extends Equatable {


  int quality;
  String name;
  String unit;
  RecipeIngredients({
    this.quality = 0,
    this.name = '',
    this.unit = '',
  });


 

  RecipeIngredients copyWith({
    int quality,
    String name,
    String unit,
  }) {
    return RecipeIngredients(
      quality: quality ?? this.quality,
      name: name ?? this.name,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quality': quality,
      'name': name,
      'unit': unit,
    };
  }

  factory RecipeIngredients.fromMap(Map<String, dynamic> map) {
    return RecipeIngredients(
      quality: map['quality'] ?? 0,
      name: map['name'] ?? '',
      unit: map['unit'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeIngredients.fromJson(String source) => RecipeIngredients.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [quality, name, unit];
}
