import 'dart:convert';

import 'package:equatable/equatable.dart';

class DietLog extends Equatable {
  int id;
  DateTime time;
  int dietId;
  double servings;
  double calories;
  double fat;
  double protien;
  double carbs;
  int daySlot;
  DietLog({
    this.id = 0,
    this.time,
    this.dietId = 0,
    this.servings = 0.0,
    this.calories = 0.0,
    this.fat = 0.0,
    this.protien = 0.0,
    this.carbs = 0.0,
    this.daySlot = 0,
  });

  DietLog copyWith({
    int id,
    DateTime time,
    int dietId,
    double servings,
    double calories,
    double fat,
    double protien,
    double carbs,
    int daySlot,
  }) {
    return DietLog(
      id: id ?? this.id,
      time: time ?? this.time,
      dietId: dietId ?? this.dietId,
      servings: servings ?? this.servings,
      calories: calories ?? this.calories,
      fat: fat ?? this.fat,
      protien: protien ?? this.protien,
      carbs: carbs ?? this.carbs,
      daySlot: daySlot ?? this.daySlot,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.millisecondsSinceEpoch,
      'dietId': dietId,
      'servings': servings,
      'calories': calories,
      'fat': fat,
      'protien': protien,
      'carbs': carbs,
      'daySlot': daySlot,
    };
  }

  factory DietLog.fromMap(Map<String, dynamic> map) {
    return DietLog(
      id: map['id'] ?? 0,
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      dietId: map['dietId'] ?? 0,
      servings: map['servings'] ?? 0.0,
      calories: map['calories'] ?? 0.0,
      fat: map['fat'] ?? 0.0,
      protien: map['protien'] ?? 0.0,
      carbs: map['carbs'] ?? 0.0,
      daySlot: map['daySlot'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DietLog.fromJson(String source) =>
      DietLog.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      time,
      dietId,
      servings,
      calories,
      fat,
      protien,
      carbs,
      daySlot,
    ];
  }
}
