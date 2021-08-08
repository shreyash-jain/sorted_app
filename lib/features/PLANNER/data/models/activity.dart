import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_activity_response_parser.dart';

class ActivityModel extends Equatable {
  int id;
  String link;
  String exercise_name;
  String image_url;
  String instructions;
  int require_instrument;
  String how_to_start;
  String benefits;
  double calorie_burn;
  int is_yoga;
  int is_w_gain;
  int is_w_loose;
  int has_reps;
  double time_in_min;
  int level;
  int is_strength;
  int is_cardio;
  int is_streaching;
  String pmt;
  String smt;
  String gif;
  String tracking_type;
  String contraindications;
  ActivityModel({
    this.id = 0,
    this.link = '',
    this.exercise_name = '',
    this.image_url = '',
    this.instructions = '',
    this.require_instrument = 0,
    this.how_to_start = '',
    this.benefits = '',
    this.calorie_burn = 0.0,
    this.is_yoga = 0,
    this.is_w_gain = 0,
    this.is_w_loose = 0,
    this.has_reps = 0,
    this.time_in_min = 0.0,
    this.level = 0,
    this.is_strength = 0,
    this.is_cardio = 0,
    this.is_streaching = 0,
    this.pmt = '',
    this.smt = '',
    this.gif = '',
    this.tracking_type = '',
    this.contraindications = '',
  });

  ActivityModel copyWith({
    int id,
    String link,
    String exercise_name,
    String image_url,
    String instructions,
    int require_instrument,
    String how_to_start,
    String benefits,
    double calorie_burn,
    int is_yoga,
    int is_w_gain,
    int is_w_loose,
    int has_reps,
    double time_in_min,
    int level,
    int is_strength,
    int is_cardio,
    int is_streaching,
    String pmt,
    String smt,
    String gif,
    String tracking_type,
    String contraindications,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      link: link ?? this.link,
      exercise_name: exercise_name ?? this.exercise_name,
      image_url: image_url ?? this.image_url,
      instructions: instructions ?? this.instructions,
      require_instrument: require_instrument ?? this.require_instrument,
      how_to_start: how_to_start ?? this.how_to_start,
      benefits: benefits ?? this.benefits,
      calorie_burn: calorie_burn ?? this.calorie_burn,
      is_yoga: is_yoga ?? this.is_yoga,
      is_w_gain: is_w_gain ?? this.is_w_gain,
      is_w_loose: is_w_loose ?? this.is_w_loose,
      has_reps: has_reps ?? this.has_reps,
      time_in_min: time_in_min ?? this.time_in_min,
      level: level ?? this.level,
      is_strength: is_strength ?? this.is_strength,
      is_cardio: is_cardio ?? this.is_cardio,
      is_streaching: is_streaching ?? this.is_streaching,
      pmt: pmt ?? this.pmt,
      smt: smt ?? this.smt,
      gif: gif ?? this.gif,
      tracking_type: tracking_type ?? this.tracking_type,
      contraindications: contraindications ?? this.contraindications,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'link': link,
      'exercise_name': exercise_name,
      'image_url': image_url,
      'instructions': instructions,
      'require_instrument': require_instrument,
      'how_to_start': how_to_start,
      'benefits': benefits,
      'calorie_burn': calorie_burn,
      'is_yoga': is_yoga,
      'is_w_gain': is_w_gain,
      'is_w_loose': is_w_loose,
      'has_reps': has_reps,
      'time_in_min': time_in_min,
      'level': level,
      'is_strength': is_strength,
      'is_cardio': is_cardio,
      'is_streaching': is_streaching,
      'pmt': pmt,
      'smt': smt,
      'gif': gif,
      'tracking_type': tracking_type,
      'contraindications': contraindications,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? 0,
      link: map['link'] ?? '',
      exercise_name: map['exercise_name'] ?? '',
      image_url: map['image_url'] ?? '',
      instructions: map['instructions'] ?? '',
      require_instrument: map['require_instrument'] ?? 0,
      how_to_start: map['how_to_start'] ?? '',
      benefits: map['benefits'] ?? '',
      calorie_burn: map['calorie_burn'] ?? 0.0,
      is_yoga: map['is_yoga'] ?? 0,
      is_w_gain: map['is_w_gain'] ?? 0,
      is_w_loose: map['is_w_loose'] ?? 0,
      has_reps: map['has_reps'] ?? 0,
      time_in_min: map['time_in_min'] ?? 0.0,
      level: map['level'] ?? 0,
      is_strength: map['is_strength'] ?? 0,
      is_cardio: map['is_cardio'] ?? 0,
      is_streaching: map['is_streaching'] ?? 0,
      pmt: map['pmt'] ?? '',
      smt: map['smt'] ?? '',
      gif: map['gif'] ?? '',
      tracking_type: map['tracking_type'] ?? '',
      contraindications: map['contraindications'] ?? '',
    );
  }

  factory ActivityModel.fromActivityModel(ElasticActivity activity) {
    return ActivityModel(
        id: activity.id,
        link: activity.link,
        exercise_name: activity.exerciseName,
        image_url: activity.imageUrl,
        instructions: activity.instructions,
        require_instrument: activity.requireInstrument,
        how_to_start: activity.howToStart,
        benefits: activity.benefits,
        calorie_burn: activity.calorieBurn.toDouble(),
        is_yoga: activity.isYoga,
        is_w_gain: activity.isWGain,
        is_w_loose: activity.isWLoose,
        has_reps: activity.hasReps,
        time_in_min: activity.timeInMin.toDouble(),
        level: activity.level,
        is_strength: activity.isStrength,
        is_cardio: activity.isCardio,
        is_streaching: activity.isStreaching,
        pmt: activity.pmt,
        smt: activity.smt,
        gif: activity.gif,
        tracking_type: activity.trackingType,
        contraindications: activity.contraindications);
  }

  factory ActivityModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;

    return ActivityModel(
      id: map['id'] ?? 0,
      link: map['link'] ?? '',
      exercise_name: map['exercise_name'] ?? '',
      image_url: map['image_url'] ?? '',
      instructions: map['instructions'] ?? '',
      require_instrument: (map['require_instrument'] is String)
          ? 0
          : map['require_instrument'] ?? 0,
      how_to_start: map['how_to_start'] ?? '',
      benefits: map['benefits'] ?? '',
      calorie_burn: (map['calorie_burn'] is double)
          ? map['calorie_burn']
          : (map['calorie_burn']).toDouble() ?? 0.0,
      is_yoga: map['is_yoga'] ?? 0,
      is_w_gain: (map['is_w_gain'] is String) ? 0 : map['is_w_gain'] ?? 0,
      is_w_loose: (map['is_w_loose'] is String) ? 0 : map['is_w_loose'] ?? 0,
      has_reps: (map['has_reps'] is String) ? 0 : map['has_reps'] ?? 0,
      time_in_min: 0.0,
      level: 0,
      is_strength: (map['is_strength'] is String) ? 0 : map['is_strength'] ?? 0,
      is_cardio: (map['is_cardio'] is String) ? 0 : map['is_cardio'] ?? 0,
      is_streaching:
          (map['is_streaching'] is String) ? 0 : map['is_streaching'] ?? 0,
      pmt: map['pmt'] ?? '',
      smt: map['smt'] ?? '',
      gif: map['gif'] ?? '',
      tracking_type: map['tracking_type'] ?? '',
      contraindications: map['contraindications'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      link,
      exercise_name,
      image_url,
      instructions,
      require_instrument,
      how_to_start,
      benefits,
      calorie_burn,
      is_yoga,
      is_w_gain,
      is_w_loose,
      has_reps,
      time_in_min,
      level,
      is_strength,
      is_cardio,
      is_streaching,
      pmt,
      smt,
      gif,
      tracking_type,
      contraindications,
    ];
  }
}
