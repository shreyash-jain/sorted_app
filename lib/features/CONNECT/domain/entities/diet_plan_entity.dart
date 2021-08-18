import 'dart:convert';


import 'package:equatable/equatable.dart';
import 'package:sorted/features/PLANNER/data/models/day_diets.dart';

class DietPlanEntitiy extends Equatable {
  int planLength;
  String planName;
  List<String> foodsToAvoid;
  List<String> foodsToEat;
  String snacks;
  String drinks;
  int startDate;
  String planImage;
  List<DayDiet> dayDiets;

  int id;
  DietPlanEntitiy({
    this.planLength = 0,
    this.planName = '',
    this.foodsToAvoid = const [],
    this.foodsToEat = const [],
    this.snacks = '',
    this.drinks = '',
    this.startDate = 0,
    this.planImage = '',
    this.dayDiets = const [],
    this.id = 0,
  });

  DietPlanEntitiy copyWith({
    int planLength,
    String planName,
    List<String> foodsToAvoid,
    List<String> foodsToEat,
    String snacks,
    String drinks,
    int startDate,
    String planImage,
    List<DayDiet> dayDiets,
    int id,
  }) {
    return DietPlanEntitiy(
      planLength: planLength ?? this.planLength,
      planName: planName ?? this.planName,
      foodsToAvoid: foodsToAvoid ?? this.foodsToAvoid,
      foodsToEat: foodsToEat ?? this.foodsToEat,
      snacks: snacks ?? this.snacks,
      drinks: drinks ?? this.drinks,
      startDate: startDate ?? this.startDate,
      planImage: planImage ?? this.planImage,
      dayDiets: dayDiets ?? this.dayDiets,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'planLength': planLength,
      'planName': planName,
      'foodsToAvoid': foodsToAvoid,
      'foodsToEat': foodsToEat,
      'snacks': snacks,
      'drinks': drinks,
      'startDate': startDate,
      'planImage': planImage,
      'dayDiets': dayDiets?.map((x) => x.toMap())?.toList(),
      'id': id,
    };
  }

  factory DietPlanEntitiy.fromMap(Map<String, dynamic> map) {
    return DietPlanEntitiy(
      planLength: map['planLength'] ?? 0,
      planName: map['planName'] ?? '',
      foodsToAvoid: List<String>.from(map['foodsToAvoid'] ?? const []),
      foodsToEat: List<String>.from(map['foodsToEat'] ?? const []),
      snacks: map['snacks'] ?? '',
      drinks: map['drinks'] ?? '',
      startDate: map['startDate'] ?? 0,
      planImage: map['planImage'] ?? '',
      dayDiets: List<DayDiet>.from(map['dayDiets']?.map((x) => DayDiet.fromMap(x) ?? DayDiet()) ?? const []),
      id: map['id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DietPlanEntitiy.fromJson(String source) => DietPlanEntitiy.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      planLength,
      planName,
      foodsToAvoid,
      foodsToEat,
      snacks,
      drinks,
      startDate,
      planImage,
      dayDiets,
      id,
    ];
  }
}
