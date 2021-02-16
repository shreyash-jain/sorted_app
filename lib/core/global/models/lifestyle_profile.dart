import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class LifestyleProfile extends Equatable {
  int is_early_bird;
  int is_night_owl;
  int is_humming_bird;
  int is_vegan;
  int is_vegetarian;
  int is_keto;
  int is_sattvik;
  int is_high_protien;
  int is_low_calorie;

  int is_ambitious;
  int is_enviornmentalist;
  int is_humanist;
  int is_feminist;
  int is_open_minded;
  int is_calm;
  int is_cheerful;
  int is_competitive;
  int is_easy_going;
  int is_friendly;
  int is_talkitive;
  int is_creative;
  int is_energetic;
  int is_mindful;
  int is_optimist;
  int is_spiritual;
  int is_addiction_free;
  LifestyleProfile({
    this.is_early_bird = 0,
    this.is_night_owl = 0,
    this.is_humming_bird = 0,
    this.is_vegan = 0,
    this.is_vegetarian = 0,
    this.is_keto = 0,
    this.is_sattvik = 0,
    this.is_high_protien = 0,
    this.is_low_calorie = 0,
    this.is_ambitious = 0,
    this.is_enviornmentalist = 0,
    this.is_humanist = 0,
    this.is_feminist = 0,
    this.is_open_minded = 0,
    this.is_calm = 0,
    this.is_cheerful = 0,
    this.is_competitive = 0,
    this.is_easy_going = 0,
    this.is_friendly = 0,
    this.is_talkitive = 0,
    this.is_creative = 0,
    this.is_energetic = 0,
    this.is_mindful = 0,
    this.is_optimist = 0,
    this.is_spiritual = 0,
    this.is_addiction_free = 0,
  });

  LifestyleProfile copyWith({
    int is_early_bird,
    int is_night_owl,
    int is_humming_bird,
    int is_vegan,
    int is_vegetarian,
    int is_keto,
    int is_sattvik,
    int is_high_protien,
    int is_low_calorie,
    int is_ambitious,
    int is_enviornmentalist,
    int is_humanist,
    int is_feminist,
    int is_open_minded,
    int is_calm,
    int is_cheerful,
    int is_competitive,
    int is_easy_going,
    int is_friendly,
    int is_talkitive,
    int is_creative,
    int is_energetic,
    int is_mindful,
    int is_optimist,
    int is_spiritual,
    int is_addiction_free,
  }) {
    return LifestyleProfile(
      is_early_bird: is_early_bird ?? this.is_early_bird,
      is_night_owl: is_night_owl ?? this.is_night_owl,
      is_humming_bird: is_humming_bird ?? this.is_humming_bird,
      is_vegan: is_vegan ?? this.is_vegan,
      is_vegetarian: is_vegetarian ?? this.is_vegetarian,
      is_keto: is_keto ?? this.is_keto,
      is_sattvik: is_sattvik ?? this.is_sattvik,
      is_high_protien: is_high_protien ?? this.is_high_protien,
      is_low_calorie: is_low_calorie ?? this.is_low_calorie,
      is_ambitious: is_ambitious ?? this.is_ambitious,
      is_enviornmentalist: is_enviornmentalist ?? this.is_enviornmentalist,
      is_humanist: is_humanist ?? this.is_humanist,
      is_feminist: is_feminist ?? this.is_feminist,
      is_open_minded: is_open_minded ?? this.is_open_minded,
      is_calm: is_calm ?? this.is_calm,
      is_cheerful: is_cheerful ?? this.is_cheerful,
      is_competitive: is_competitive ?? this.is_competitive,
      is_easy_going: is_easy_going ?? this.is_easy_going,
      is_friendly: is_friendly ?? this.is_friendly,
      is_talkitive: is_talkitive ?? this.is_talkitive,
      is_creative: is_creative ?? this.is_creative,
      is_energetic: is_energetic ?? this.is_energetic,
      is_mindful: is_mindful ?? this.is_mindful,
      is_optimist: is_optimist ?? this.is_optimist,
      is_spiritual: is_spiritual ?? this.is_spiritual,
      is_addiction_free: is_addiction_free ?? this.is_addiction_free,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'is_early_bird': is_early_bird,
      'is_night_owl': is_night_owl,
      'is_humming_bird': is_humming_bird,
      'is_vegan': is_vegan,
      'is_vegetarian': is_vegetarian,
      'is_keto': is_keto,
      'is_sattvik': is_sattvik,
      'is_high_protien': is_high_protien,
      'is_low_calorie': is_low_calorie,
      'is_ambitious': is_ambitious,
      'is_enviornmentalist': is_enviornmentalist,
      'is_humanist': is_humanist,
      'is_feminist': is_feminist,
      'is_open_minded': is_open_minded,
      'is_calm': is_calm,
      'is_cheerful': is_cheerful,
      'is_competitive': is_competitive,
      'is_easy_going': is_easy_going,
      'is_friendly': is_friendly,
      'is_talkitive': is_talkitive,
      'is_creative': is_creative,
      'is_energetic': is_energetic,
      'is_mindful': is_mindful,
      'is_optimist': is_optimist,
      'is_spiritual': is_spiritual,
      'is_addiction_free': is_addiction_free,
    };
  }

  factory LifestyleProfile.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LifestyleProfile(
      is_early_bird: map['is_early_bird'],
      is_night_owl: map['is_night_owl'],
      is_humming_bird: map['is_humming_bird'],
      is_vegan: map['is_vegan'],
      is_vegetarian: map['is_vegetarian'],
      is_keto: map['is_keto'],
      is_sattvik: map['is_sattvik'],
      is_high_protien: map['is_high_protien'],
      is_low_calorie: map['is_low_calorie'],
      is_ambitious: map['is_ambitious'],
      is_enviornmentalist: map['is_enviornmentalist'],
      is_humanist: map['is_humanist'],
      is_feminist: map['is_feminist'],
      is_open_minded: map['is_open_minded'],
      is_calm: map['is_calm'],
      is_cheerful: map['is_cheerful'],
      is_competitive: map['is_competitive'],
      is_easy_going: map['is_easy_going'],
      is_friendly: map['is_friendly'],
      is_talkitive: map['is_talkitive'],
      is_creative: map['is_creative'],
      is_energetic: map['is_energetic'],
      is_mindful: map['is_mindful'],
      is_optimist: map['is_optimist'],
      is_spiritual: map['is_spiritual'],
      is_addiction_free: map['is_addiction_free'],
    );
  }

  factory LifestyleProfile.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;

    return LifestyleProfile(
      is_early_bird: map['is_early_bird'],
      is_night_owl: map['is_night_owl'],
      is_humming_bird: map['is_humming_bird'],
      is_vegan: map['is_vegan'],
      is_vegetarian: map['is_vegetarian'],
      is_keto: map['is_keto'],
      is_sattvik: map['is_sattvik'],
      is_high_protien: map['is_high_protien'],
      is_low_calorie: map['is_low_calorie'],
      is_ambitious: map['is_ambitious'],
      is_enviornmentalist: map['is_enviornmentalist'],
      is_humanist: map['is_humanist'],
      is_feminist: map['is_feminist'],
      is_open_minded: map['is_open_minded'],
      is_calm: map['is_calm'],
      is_cheerful: map['is_cheerful'],
      is_competitive: map['is_competitive'],
      is_easy_going: map['is_easy_going'],
      is_friendly: map['is_friendly'],
      is_talkitive: map['is_talkitive'],
      is_creative: map['is_creative'],
      is_energetic: map['is_energetic'],
      is_mindful: map['is_mindful'],
      is_optimist: map['is_optimist'],
      is_spiritual: map['is_spiritual'],
      is_addiction_free: map['is_addiction_free'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LifestyleProfile.fromJson(String source) =>
      LifestyleProfile.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      is_early_bird,
      is_night_owl,
      is_humming_bird,
      is_vegan,
      is_vegetarian,
      is_keto,
      is_sattvik,
      is_high_protien,
      is_low_calorie,
      is_ambitious,
      is_enviornmentalist,
      is_humanist,
      is_feminist,
      is_open_minded,
      is_calm,
      is_cheerful,
      is_competitive,
      is_easy_going,
      is_friendly,
      is_talkitive,
      is_creative,
      is_energetic,
      is_mindful,
      is_optimist,
      is_spiritual,
      is_addiction_free,
    ];
  }
}
