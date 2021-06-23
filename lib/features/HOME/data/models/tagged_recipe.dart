import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TaggedRecipe extends Equatable {
  String difficulty;
  int id;
  String is_breakfast;
  String is_dieting;
  String is_dinner;
  String is_healthy;
  String is_high_calorie;
  String is_high_protien;
  String is_kapha_balancing;
  String is_keto;
  String is_loose_weight;
  String is_low_cholesterol;
  String is_low_sugar;
  String is_lunch;
  String is_pitta_balancing;
  String is_pregnency;
  String is_sattvik;
  String is_vata_balancing;
  String is_vegan;
  String is_vegetarian;
  String is_weight_gain;
  String name;
  int recipe_id;
  String recipe_link;
  String image_url;
  String description;
  TaggedRecipe({
    this.difficulty = '',
    this.id = 0,
    this.is_breakfast = '',
    this.is_dieting = '',
    this.is_dinner = '',
    this.is_healthy = '',
    this.is_high_calorie = '',
    this.is_high_protien = '',
    this.is_kapha_balancing = '',
    this.is_keto = '',
    this.is_loose_weight = '',
    this.is_low_cholesterol = '',
    this.is_low_sugar = '',
    this.is_lunch = '',
    this.is_pitta_balancing = '',
    this.is_pregnency = '',
    this.is_sattvik = '',
    this.is_vata_balancing = '',
    this.is_vegan = '',
    this.is_vegetarian = '',
    this.is_weight_gain = '',
    this.name = '',
    this.recipe_id = 0,
    this.recipe_link = '',
    this.image_url = '',
    this.description = '',
  });

  TaggedRecipe copyWith({
    String difficulty,
    int id,
    String is_breakfast,
    String is_dieting,
    String is_dinner,
    String is_healthy,
    String is_high_calorie,
    String is_high_protien,
    String is_kapha_balancing,
    String is_keto,
    String is_loose_weight,
    String is_low_cholesterol,
    String is_low_sugar,
    String is_lunch,
    String is_pitta_balancing,
    String is_pregnency,
    String is_sattvik,
    String is_vata_balancing,
    String is_vegan,
    String is_vegetarian,
    String is_weight_gain,
    String name,
    int recipe_id,
    String recipe_link,
    String image_url,
    String description,
  }) {
    return TaggedRecipe(
      difficulty: difficulty ?? this.difficulty,
      id: id ?? this.id,
      is_breakfast: is_breakfast ?? this.is_breakfast,
      is_dieting: is_dieting ?? this.is_dieting,
      is_dinner: is_dinner ?? this.is_dinner,
      is_healthy: is_healthy ?? this.is_healthy,
      is_high_calorie: is_high_calorie ?? this.is_high_calorie,
      is_high_protien: is_high_protien ?? this.is_high_protien,
      is_kapha_balancing: is_kapha_balancing ?? this.is_kapha_balancing,
      is_keto: is_keto ?? this.is_keto,
      is_loose_weight: is_loose_weight ?? this.is_loose_weight,
      is_low_cholesterol: is_low_cholesterol ?? this.is_low_cholesterol,
      is_low_sugar: is_low_sugar ?? this.is_low_sugar,
      is_lunch: is_lunch ?? this.is_lunch,
      is_pitta_balancing: is_pitta_balancing ?? this.is_pitta_balancing,
      is_pregnency: is_pregnency ?? this.is_pregnency,
      is_sattvik: is_sattvik ?? this.is_sattvik,
      is_vata_balancing: is_vata_balancing ?? this.is_vata_balancing,
      is_vegan: is_vegan ?? this.is_vegan,
      is_vegetarian: is_vegetarian ?? this.is_vegetarian,
      is_weight_gain: is_weight_gain ?? this.is_weight_gain,
      name: name ?? this.name,
      recipe_id: recipe_id ?? this.recipe_id,
      recipe_link: recipe_link ?? this.recipe_link,
      image_url: image_url ?? this.image_url,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'difficulty': difficulty,
      'id': id,
      'is_breakfast': is_breakfast,
      'is_dieting': is_dieting,
      'is_dinner': is_dinner,
      'is_healthy': is_healthy,
      'is_high_calorie': is_high_calorie,
      'is_high_protien': is_high_protien,
      'is_kapha_balancing': is_kapha_balancing,
      'is_keto': is_keto,
      'is_loose_weight': is_loose_weight,
      'is_low_cholesterol': is_low_cholesterol,
      'is_low_sugar': is_low_sugar,
      'is_lunch': is_lunch,
      'is_pitta_balancing': is_pitta_balancing,
      'is_pregnency': is_pregnency,
      'is_sattvik': is_sattvik,
      'is_vata_balancing': is_vata_balancing,
      'is_vegan': is_vegan,
      'is_vegetarian': is_vegetarian,
      'is_weight_gain': is_weight_gain,
      'name': name,
      'recipe_id': recipe_id,
      'recipe_link': recipe_link,
      'image_url': image_url,
      'description': description,
    };
  }

  factory TaggedRecipe.fromMap(Map<String, dynamic> map) {
    return TaggedRecipe(
      difficulty: map['difficulty'] ?? '',
      id: map['id'] ?? 0,
      is_breakfast: map['is_breakfast'] ?? '',
      is_dieting: map['is_dieting'] ?? '',
      is_dinner: map['is_dinner'] ?? '',
      is_healthy: map['is_healthy'] ?? '',
      is_high_calorie: map['is_high_calorie'] ?? '',
      is_high_protien: map['is_high_protien'] ?? '',
      is_kapha_balancing: map['is_kapha_balancing'] ?? '',
      is_keto: map['is_keto'] ?? '',
      is_loose_weight: map['is_loose_weight'] ?? '',
      is_low_cholesterol: map['is_low_cholesterol'] ?? '',
      is_low_sugar: map['is_low_sugar'] ?? '',
      is_lunch: map['is_lunch'] ?? '',
      is_pitta_balancing: map['is_pitta_balancing'] ?? '',
      is_pregnency: map['is_pregnency'] ?? '',
      is_sattvik: map['is_sattvik'] ?? '',
      is_vata_balancing: map['is_vata_balancing'] ?? '',
      is_vegan: map['is_vegan'] ?? '',
      is_vegetarian: map['is_vegetarian'] ?? '',
      is_weight_gain: map['is_weight_gain'] ?? '',
      name: map['name'] ?? '',
      recipe_id: map['recipe_id'] ?? 0,
      recipe_link: map['recipe_link'] ?? '',
      image_url: map['image_url'] ?? '',
      description: map['description'] ?? '',
    );
  }
  factory TaggedRecipe.empty() {
    return TaggedRecipe(
      difficulty:'',
      id: -1,
      is_breakfast: '',
      is_dieting:  '',
      is_dinner: '',
      is_healthy: '',
      is_high_calorie:  '',
      is_high_protien: '',
      is_kapha_balancing:  '',
      is_keto: '',
      is_loose_weight:  '',
      is_low_cholesterol: '',
      is_low_sugar: '',
      is_lunch: '',
      is_pitta_balancing: '',
      is_pregnency:  '',
      is_sattvik:  '',
      is_vata_balancing:  '',
      is_vegan: '',
      is_vegetarian: '',
      is_weight_gain:  '',
      name:  '',
      recipe_id:  0,
      recipe_link:  '',
      image_url:  '',
      description:  '',
    );
  }

  factory TaggedRecipe.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;
    return TaggedRecipe(
      difficulty: map['difficulty'] ?? '',
      id: map['id'] ?? 0,
      is_breakfast: map['is_breakfast'] ?? '',
      is_dieting: map['is_dieting'] ?? '',
      is_dinner: map['is_dinner'] ?? '',
      is_healthy: map['is_healthy'] ?? '',
      is_high_calorie: map['is_high_calorie'] ?? '',
      is_high_protien: map['is_high_protien'] ?? '',
      is_kapha_balancing: map['is_kapha_balancing'] ?? '',
      is_keto: map['is_keto'] ?? '',
      is_loose_weight: map['is_loose_weight'] ?? '',
      is_low_cholesterol: map['is_low_cholesterol'] ?? '',
      is_low_sugar: map['is_low_sugar'] ?? '',
      is_lunch: map['is_lunch'] ?? '',
      is_pitta_balancing: map['is_pitta_balancing'] ?? '',
      is_pregnency: map['is_pregnency'] ?? '',
      is_sattvik: map['is_sattvik'] ?? '',
      is_vata_balancing: map['is_vata_balancing'] ?? '',
      is_vegan: map['is_vegan'] ?? '',
      is_vegetarian: map['is_vegetarian'] ?? '',
      is_weight_gain: map['is_weight_gain'] ?? '',
      name: map['name'] ?? '',
      recipe_id: map['recipe_id'] ?? 0,
      recipe_link: map['recipe_link'] ?? '',
      image_url: map['image_url'] ?? '',
      description: map['description'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory TaggedRecipe.fromJson(String source) =>
      TaggedRecipe.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      difficulty,
      id,
      is_breakfast,
      is_dieting,
      is_dinner,
      is_healthy,
      is_high_calorie,
      is_high_protien,
      is_kapha_balancing,
      is_keto,
      is_loose_weight,
      is_low_cholesterol,
      is_low_sugar,
      is_lunch,
      is_pitta_balancing,
      is_pregnency,
      is_sattvik,
      is_vata_balancing,
      is_vegan,
      is_vegetarian,
      is_weight_gain,
      name,
      recipe_id,
      recipe_link,
      image_url,
      description,
    ];
  }
}
