import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/global/models/health_profile.dart';

class HealthConditions extends Equatable {
  int has_diabetes;
  int has_cholesterol;
  int has_hypertension;
  int has_thyroid;
  int has_high_bp;
  int has_low_bp;
  HealthConditions({
    this.has_diabetes = 0,
    this.has_cholesterol = 0,
    this.has_hypertension = 0,
    this.has_thyroid = 0,
    this.has_high_bp = 0,
    this.has_low_bp = 0,
  });

  HealthConditions copyWith({
    int has_diabetes,
    int has_cholesterol,
    int has_hypertension,
    int has_thyroid,
    int has_high_bp,
    int has_low_bp,
  }) {
    return HealthConditions(
      has_diabetes: has_diabetes ?? this.has_diabetes,
      has_cholesterol: has_cholesterol ?? this.has_cholesterol,
      has_hypertension: has_hypertension ?? this.has_hypertension,
      has_thyroid: has_thyroid ?? this.has_thyroid,
      has_high_bp: has_high_bp ?? this.has_high_bp,
      has_low_bp: has_low_bp ?? this.has_low_bp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'has_diabetes': has_diabetes,
      'has_cholesterol': has_cholesterol,
      'has_hypertension': has_hypertension,
      'has_thyroid': has_thyroid,
      'has_high_bp': has_high_bp,
      'has_low_bp': has_low_bp,
    };
  }

  factory HealthConditions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return HealthConditions(
      has_diabetes: map['has_diabetes'],
      has_cholesterol: map['has_cholesterol'],
      has_hypertension: map['has_hypertension'],
      has_thyroid: map['has_thyroid'],
      has_high_bp: map['has_high_bp'],
      has_low_bp: map['has_low_bp'],
    );
  }

  factory HealthConditions.fromHealthProfile(HealthProfile healthProfile) {
    return HealthConditions(
      has_diabetes: healthProfile.has_diabetes ?? 0,
      has_cholesterol: healthProfile.has_cholesterol ?? 0,
      has_hypertension: healthProfile.has_hypertension ?? 0,
      has_thyroid: healthProfile.has_thyroid ?? 0,
      has_high_bp: healthProfile.has_high_bp ?? 0,
      has_low_bp: healthProfile.has_low_bp ?? 0,
    );
  }

  HealthProfile updateHealthProfile(
      HealthConditions fitnessGoals, HealthProfile healthProfile) {
    return healthProfile.copyWith(
      has_diabetes: healthProfile.has_diabetes ?? 0,
      has_cholesterol: healthProfile.has_cholesterol ?? 0,
      has_hypertension: healthProfile.has_hypertension ?? 0,
      has_thyroid: healthProfile.has_thyroid ?? 0,
      has_high_bp: healthProfile.has_high_bp ?? 0,
      has_low_bp: healthProfile.has_low_bp ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthConditions.fromJson(String source) =>
      HealthConditions.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      has_diabetes,
      has_cholesterol,
      has_hypertension,
      has_thyroid,
      has_high_bp,
      has_low_bp,
    ];
  }
}
