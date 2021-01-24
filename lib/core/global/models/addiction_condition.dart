import 'dart:convert';

import 'package:equatable/equatable.dart';

class AddictionConditions extends Equatable {
  int has_alcohol_addiction;
  int has_pornography_addiction;
  int has_tobaco_addiction;
  int has_internet_addiction;
  int has_drug_addiction;
  int has_cigearette_addiction;
  int has_videi_games_addiction;
  AddictionConditions({
    this.has_alcohol_addiction = 0,
    this.has_pornography_addiction = 0,
    this.has_tobaco_addiction = 0,
    this.has_internet_addiction = 0,
    this.has_drug_addiction = 0,
    this.has_cigearette_addiction = 0,
    this.has_videi_games_addiction = 0,
  });

  AddictionConditions copyWith({
    int has_alcohol_addiction,
    int has_pornography_addiction,
    int has_tobaco_addiction,
    int has_internet_addiction,
    int has_drug_addiction,
    int has_cigearette_addiction,
    int has_videi_games_addiction,
  }) {
    return AddictionConditions(
      has_alcohol_addiction:
          has_alcohol_addiction ?? this.has_alcohol_addiction,
      has_pornography_addiction:
          has_pornography_addiction ?? this.has_pornography_addiction,
      has_tobaco_addiction: has_tobaco_addiction ?? this.has_tobaco_addiction,
      has_internet_addiction:
          has_internet_addiction ?? this.has_internet_addiction,
      has_drug_addiction: has_drug_addiction ?? this.has_drug_addiction,
      has_cigearette_addiction:
          has_cigearette_addiction ?? this.has_cigearette_addiction,
      has_videi_games_addiction:
          has_videi_games_addiction ?? this.has_videi_games_addiction,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'has_alcohol_addiction': has_alcohol_addiction,
      'has_pornography_addiction': has_pornography_addiction,
      'has_tobaco_addiction': has_tobaco_addiction,
      'has_internet_addiction': has_internet_addiction,
      'has_drug_addiction': has_drug_addiction,
      'has_cigearette_addiction': has_cigearette_addiction,
      'has_videi_games_addiction': has_videi_games_addiction,
    };
  }

  factory AddictionConditions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AddictionConditions(
      has_alcohol_addiction: map['has_alcohol_addiction'],
      has_pornography_addiction: map['has_pornography_addiction'],
      has_tobaco_addiction: map['has_tobaco_addiction'],
      has_internet_addiction: map['has_internet_addiction'],
      has_drug_addiction: map['has_drug_addiction'],
      has_cigearette_addiction: map['has_cigearette_addiction'],
      has_videi_games_addiction: map['has_videi_games_addiction'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddictionConditions.fromJson(String source) =>
      AddictionConditions.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      has_alcohol_addiction,
      has_pornography_addiction,
      has_tobaco_addiction,
      has_internet_addiction,
      has_drug_addiction,
      has_cigearette_addiction,
      has_videi_games_addiction,
    ];
  }
}
