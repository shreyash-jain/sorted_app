import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:googleapis/compute/v1.dart';

class ProfileModel extends Equatable {
  int coins;
  List<int> councellor_id;
  List<String> councellor_image_url;
  List<String> councellor_name;
  List<int> fitness_endorsed;
  double fitness_growth;
  double fitness_score;
  List<String> fitness_skills;
  double mindfulness_growth;
  double mindfulness_score;
  List<String> mindfulness_skills;
  List<int> mindfulness_endorsed;
  List<int> nutritionist_id;
  List<String> nutritionist_image_url;
  List<String> nutritionist_name;
  String status;
  List<int> trainer_id;
  List<String> trainer_image_url;
  List<String> trainer_name;
  ProfileModel({
    this.coins = 0,
    this.councellor_id = const [],
    this.councellor_image_url = const [],
    this.councellor_name = const [],
    this.fitness_endorsed = const [],
    this.fitness_growth = 0.0,
    this.fitness_score = 0.0,
    this.fitness_skills = const [],
    this.mindfulness_growth = 0.0,
    this.mindfulness_score = 0.0,
    this.mindfulness_skills = const [],
    this.mindfulness_endorsed = const [],
    this.nutritionist_id = const [],
    this.nutritionist_image_url = const [],
    this.nutritionist_name = const [],
    this.status = '',
    this.trainer_id = const [],
    this.trainer_image_url = const [],
    this.trainer_name = const [],
  });

  ProfileModel copyWith({
    int coins,
    List<int> councellor_id,
    List<String> councellor_image_url,
    List<String> councellor_name,
    List<int> fitness_endorsed,
    double fitness_growth,
    double fitness_score,
    List<String> fitness_skills,
    double mindfulness_growth,
    double mindfulness_score,
    List<String> mindfulness_skills,
    List<int> minfulness_endorsed,
    List<int> nutritionist_id,
    List<String> nutritionist_image_url,
    List<String> nutritionist_name,
    String status,
    List<int> trainer_id,
    List<String> trainer_image_url,
    List<String> trainer_name,
  }) {
    return ProfileModel(
      coins: coins ?? this.coins,
      councellor_id: councellor_id ?? this.councellor_id,
      councellor_image_url: councellor_image_url ?? this.councellor_image_url,
      councellor_name: councellor_name ?? this.councellor_name,
      fitness_endorsed: fitness_endorsed ?? this.fitness_endorsed,
      fitness_growth: fitness_growth ?? this.fitness_growth,
      fitness_score: fitness_score ?? this.fitness_score,
      fitness_skills: fitness_skills ?? this.fitness_skills,
      mindfulness_growth: mindfulness_growth ?? this.mindfulness_growth,
      mindfulness_score: mindfulness_score ?? this.mindfulness_score,
      mindfulness_skills: mindfulness_skills ?? this.mindfulness_skills,
      mindfulness_endorsed: mindfulness_endorsed ?? this.mindfulness_endorsed,
      nutritionist_id: nutritionist_id ?? this.nutritionist_id,
      nutritionist_image_url:
          nutritionist_image_url ?? this.nutritionist_image_url,
      nutritionist_name: nutritionist_name ?? this.nutritionist_name,
      status: status ?? this.status,
      trainer_id: trainer_id ?? this.trainer_id,
      trainer_image_url: trainer_image_url ?? this.trainer_image_url,
      trainer_name: trainer_name ?? this.trainer_name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coins': coins,
      'councellor_id': councellor_id,
      'councellor_image_url': councellor_image_url,
      'councellor_name': councellor_name,
      'fitness_endorsed': fitness_endorsed,
      'fitness_growth': fitness_growth,
      'fitness_score': fitness_score,
      'fitness_skills': fitness_skills,
      'mindfulness_growth': mindfulness_growth,
      'mindfulness_score': mindfulness_score,
      'mindfulness_skills': mindfulness_skills,
      'mindfulness_endorsed': mindfulness_endorsed,
      'nutritionist_id': nutritionist_id,
      'nutritionist_image_url': nutritionist_image_url,
      'nutritionist_name': nutritionist_name,
      'status': status,
      'trainer_id': trainer_id,
      'trainer_image_url': trainer_image_url,
      'trainer_name': trainer_name,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      coins: map['coins'] ?? 0,
      councellor_id: List<int>.from(map['councellor_id'] ?? const []),
      councellor_image_url:
          List<String>.from(map['councellor_image_url'] ?? const []),
      councellor_name: List<String>.from(map['councellor_name'] ?? const []),
      fitness_endorsed: List<int>.from(map['fitness_endorsed'] ?? const []),
      fitness_growth: map['fitness_growth'] ?? 0.0,
      fitness_score: map['fitness_score'] ?? 0.0,
      fitness_skills: List<String>.from(map['fitness_skills'] ?? const []),
      mindfulness_growth: map['mindfulness_growth'] ?? 0.0,
      mindfulness_score: map['mindfulness_score'] ?? 0.0,
      mindfulness_skills:
          List<String>.from(map['mindfulness_skills'] ?? const []),
      mindfulness_endorsed:
          List<int>.from(map['mindfulness_endorsed'] ?? const []),
      nutritionist_id: List<int>.from(map['nutritionist_id'] ?? const []),
      nutritionist_image_url:
          List<String>.from(map['nutritionist_image_url'] ?? const []),
      nutritionist_name:
          List<String>.from(map['nutritionist_name'] ?? const []),
      status: map['status'] ?? '',
      trainer_id: List<int>.from(map['trainer_id'] ?? const []),
      trainer_image_url:
          List<String>.from(map['trainer_image_url'] ?? const []),
      trainer_name: List<String>.from(map['trainer_name'] ?? const []),
    );
  }

  factory ProfileModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;

    return ProfileModel(
      coins: map['coins'] ?? 0,
      councellor_id: List<int>.from(map['councellor_id'] ?? const []),
      councellor_image_url:
          List<String>.from(map['councellor_image_url'] ?? const []),
      councellor_name: List<String>.from(map['councellor_name'] ?? const []),
      fitness_endorsed: List<int>.from(map['fitness_endorsed'] ?? const []),
      fitness_growth: (map['fitness_growth']).toDouble() ?? 0.0,
      fitness_score: map['fitness_score'] ?? 0.0,
      fitness_skills: List<String>.from(map['fitness_skills'] ?? const []),
      mindfulness_growth: (map['mindfulness_growth']).toDouble() ?? 0.0,
      mindfulness_score: map['mindfulness_score'] ?? 0.0,
      mindfulness_skills:
          List<String>.from(map['mindfulness_skills'] ?? const []),
      mindfulness_endorsed:
          List<int>.from(map['mindfulness_endorsed'] ?? const []),
      nutritionist_id: List<int>.from(map['nutritionist_id'] ?? const []),
      nutritionist_image_url:
          List<String>.from(map['nutritionist_image_url'] ?? const []),
      nutritionist_name:
          List<String>.from(map['nutritionist_name'] ?? const []),
      status: map['status'] ?? '',
      trainer_id: List<int>.from(map['trainer_id'] ?? const []),
      trainer_image_url:
          List<String>.from(map['trainer_image_url'] ?? const []),
      trainer_name: List<String>.from(map['trainer_name'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      coins,
      councellor_id,
      councellor_image_url,
      councellor_name,
      fitness_endorsed,
      fitness_growth,
      fitness_score,
      fitness_skills,
      mindfulness_growth,
      mindfulness_score,
      mindfulness_skills,
      mindfulness_endorsed,
      nutritionist_id,
      nutritionist_image_url,
      nutritionist_name,
      status,
      trainer_id,
      trainer_image_url,
      trainer_name,
    ];
  }
}
