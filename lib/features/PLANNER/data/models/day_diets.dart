import 'dart:convert';

import 'package:equatable/equatable.dart';


class DayDiet extends Equatable {
  int id;
  List<DietModel> dayBreakfastDiets;
  List<DietModel> dayLunchDiets;
  List<DietModel> dayDinnerDiets;
  int totalCalories;
  String dayName;
  
  DayDiet({
    this.id = 0,
    this.dayBreakfastDiets = const [],
    this.dayLunchDiets = const [],
    this.dayDinnerDiets = const [],
    this.totalCalories = 0,
    this.dayName = '',
  });

  DayDiet copyWith({
    int id,
    List<DietModel> dayBreakfastDiets,
    List<DietModel> dayLunchDiets,
    List<DietModel> dayDinnerDiets,
    int totalCalories,
    String dayName,
  }) {
    return DayDiet(
      id: id ?? this.id,
      dayBreakfastDiets: dayBreakfastDiets ?? this.dayBreakfastDiets,
      dayLunchDiets: dayLunchDiets ?? this.dayLunchDiets,
      dayDinnerDiets: dayDinnerDiets ?? this.dayDinnerDiets,
      totalCalories: totalCalories ?? this.totalCalories,
      dayName: dayName ?? this.dayName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayBreakfastDiets': dayBreakfastDiets?.map((x) => x.toMap())?.toList(),
      'dayLunchDiets': dayLunchDiets?.map((x) => x.toMap())?.toList(),
      'dayDinnerDiets': dayDinnerDiets?.map((x) => x.toMap())?.toList(),
      'totalCalories': totalCalories,
      'dayName': dayName,
    };
  }

  factory DayDiet.fromMap(Map<String, dynamic> map) {
    return DayDiet(
      id: map['id'] ?? 0,
      dayBreakfastDiets: List<DietModel>.from(map['dayBreakfastDiets']
              ?.map((x) => DietModel.fromMap(x) ?? DietModel()) ??
          const []),
      dayLunchDiets: List<DietModel>.from(map['dayLunchDiets']
              ?.map((x) => DietModel.fromMap(x) ?? DietModel()) ??
          const []),
      dayDinnerDiets: List<DietModel>.from(map['dayDinnerDiets']
              ?.map((x) => DietModel.fromMap(x) ?? DietModel()) ??
          const []),
      totalCalories: map['totalCalories'] ?? 0,
      dayName: map['dayName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DayDiet.fromJson(String source) =>
      DayDiet.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      dayBreakfastDiets,
      dayLunchDiets,
      dayDinnerDiets,
      totalCalories,
      dayName,
    ];
  }
}

class DietModel extends Equatable {
  int recipeId;
  String recipeImage;
  String name;
  int servings;
  int calories;
  String servingUnit;
  DietModel({
    this.recipeId = 0,
    this.recipeImage = '',
    this.name = '',
    this.servings = 0,
    this.calories = 0,
    this.servingUnit = '',
  });

  @override
  List<Object> get props {
    return [
      recipeId,
      recipeImage,
      name,
      servings,
      calories,
      servingUnit,
    ];
  }

  DietModel copyWith({
    int recipeId,
    String recipeImage,
    String name,
    int servings,
    int calories,
    String servingUnit,
  }) {
    return DietModel(
      recipeId: recipeId ?? this.recipeId,
      recipeImage: recipeImage ?? this.recipeImage,
      name: name ?? this.name,
      servings: servings ?? this.servings,
      calories: calories ?? this.calories,
      servingUnit: servingUnit ?? this.servingUnit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'recipeImage': recipeImage,
      'name': name,
      'servings': servings,
      'calories': calories,
      'servingUnit': servingUnit,
    };
  }

  factory DietModel.fromMap(Map<String, dynamic> map) {
    return DietModel(
      recipeId: map['recipeId'] ?? 0,
      recipeImage: map['recipeImage'] ?? '',
      name: map['name'] ?? '',
      servings: map['servings'] ?? 0,
      calories: map['calories'] ?? 0,
      servingUnit: map['servingUnit'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DietModel.fromJson(String source) =>
      DietModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
