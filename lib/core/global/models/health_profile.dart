import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
//!Do changes at trainer's app
class HealthProfile extends Equatable {
  int is_early_bird;
  int is_night_owl;
  int is_humming_bird;
  int is_vegan;
  int is_vegetarian;
  int is_keto;
  int is_sattvik;
  int has_alcohol_addiction;
  int has_pornography_addiction;
  int has_tobaco_addiction;
  int has_internet_addiction;
  int has_drug_addiction;
  int has_cigearette_addiction;
  int has_videi_games_addiction;
  int do_talk_ablout_feelings;
  int do_meditation;
  int do_enjoy_work;
  int do_love_self;
  int do_stay_positive;

  int has_diabetes;
  int has_cholesterol;
  int has_hypertension;
  int has_thyroid;
  int has_high_bp;
  int has_low_bp;

  int is_mind_activity_private;

  int goal_control_anger;
  int goal_reduce_stress;
  int goal_sleep_more;
  int goal_control_thoughts;
  int goal_live_in_present;
  int goal_improve_will_power;
  int goal_overcome_addiction;

  int make_goal_private;
  double weight_kg;
  int weight_unit;
  double height_cm;
  int height_unit;
  int is_w_h_private;

  int do_walk;
  int ride_cycle;
  int do_exercise;
  int do_yoga;
  int play_sports;
  int do_dance;

  int is_health_activity_private;

  int have_health_condition;
  int goal_stay_fit;
  int goal_gain_muscle;
  int goal_loose_weight;
  int goal_get_more_active;

  double target_weight_kg;




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
  HealthProfile({
    this.is_early_bird = 0,
    this.is_night_owl = 0,
    this.is_humming_bird = 0,
    this.is_vegan = 0,
    this.is_vegetarian = 0,
    this.is_keto = 0,
    this.is_sattvik = 0,
    this.has_alcohol_addiction = 0,
    this.has_pornography_addiction = 0,
    this.has_tobaco_addiction = 0,
    this.has_internet_addiction = 0,
    this.has_drug_addiction = 0,
    this.has_cigearette_addiction = 0,
    this.has_videi_games_addiction = 0,
    this.do_talk_ablout_feelings = 0,
    this.do_meditation = 0,
    this.do_enjoy_work = 0,
    this.do_love_self = 0,
    this.do_stay_positive = 0,
    this.has_diabetes = 0,
    this.has_cholesterol = 0,
    this.has_hypertension = 0,
    this.has_thyroid = 0,
    this.has_high_bp = 0,
    this.has_low_bp = 0,
    this.is_mind_activity_private = 0,
    this.goal_control_anger = 0,
    this.goal_reduce_stress = 0,
    this.goal_sleep_more = 0,
    this.goal_control_thoughts = 0,
    this.goal_live_in_present = 0,
    this.goal_improve_will_power = 0,
    this.goal_overcome_addiction = 0,
    this.make_goal_private = 0,
    this.weight_kg = 0.0,
    this.weight_unit = 0,
    this.height_cm = 0.0,
    this.height_unit = 0,
    this.is_w_h_private = 0,
    this.do_walk = 0,
    this.ride_cycle = 0,
    this.do_exercise = 0,
    this.do_yoga = 0,
    this.play_sports = 0,
    this.do_dance = 0,
    this.is_health_activity_private = 0,
    this.have_health_condition = 0,
    this.goal_stay_fit = 0,
    this.goal_gain_muscle = 0,
    this.goal_loose_weight = 0,
    this.goal_get_more_active = 0,
    this.target_weight_kg = 0.0,
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
 

  HealthProfile copyWith({
   int is_early_bird,
    int is_night_owl,
    int is_humming_bird,
    int is_vegan,
    int is_vegetarian,
    int is_keto,
    int is_sattvik,
    int has_alcohol_addiction,
    int has_pornography_addiction,
    int has_tobaco_addiction,
    int has_internet_addiction,
    int has_drug_addiction,
    int has_cigearette_addiction,
    int has_videi_games_addiction,
    int do_talk_ablout_feelings,
    int do_meditation,
    int do_enjoy_work,
    int do_love_self,
    int do_stay_positive,
    int has_diabetes,
    int has_cholesterol,
    int has_hypertension,
    int has_thyroid,
    int has_high_bp,
    int has_low_bp,
    int is_mind_activity_private,
    int goal_control_anger,
    int goal_reduce_stress,
    int goal_sleep_more,
    int goal_control_thoughts,
    int goal_live_in_present,
    int goal_improve_will_power,
    int goal_overcome_addiction,
    int make_goal_private,
    double weight_kg,
    int weight_unit,
    double height_cm,
    int height_unit,
    int is_w_h_private,
    int do_walk,
    int ride_cycle,
    int do_exercise,
    int do_yoga,
    int play_sports,
    int do_dance,
    int is_health_activity_private,
    int have_health_condition,
    int goal_stay_fit,
    int goal_gain_muscle,
    int goal_loose_weight,
    int goal_get_more_active,
    double target_weight_kg,
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
    List<int> mindfulness_endorsed,
    List<int> nutritionist_id,
    List<String> nutritionist_image_url,
    List<String> nutritionist_name,
    String status,
    List<int> trainer_id,
    List<String> trainer_image_url,
    List<String> trainer_name,
  }) {
    return HealthProfile(
      is_early_bird: is_early_bird ?? this.is_early_bird,
      is_night_owl: is_night_owl ?? this.is_night_owl,
      is_humming_bird: is_humming_bird ?? this.is_humming_bird,
      is_vegan: is_vegan ?? this.is_vegan,
      is_vegetarian: is_vegetarian ?? this.is_vegetarian,
      is_keto: is_keto ?? this.is_keto,
      is_sattvik: is_sattvik ?? this.is_sattvik,
      has_alcohol_addiction: has_alcohol_addiction ?? this.has_alcohol_addiction,
      has_pornography_addiction: has_pornography_addiction ?? this.has_pornography_addiction,
      has_tobaco_addiction: has_tobaco_addiction ?? this.has_tobaco_addiction,
      has_internet_addiction: has_internet_addiction ?? this.has_internet_addiction,
      has_drug_addiction: has_drug_addiction ?? this.has_drug_addiction,
      has_cigearette_addiction: has_cigearette_addiction ?? this.has_cigearette_addiction,
      has_videi_games_addiction: has_videi_games_addiction ?? this.has_videi_games_addiction,
      do_talk_ablout_feelings: do_talk_ablout_feelings ?? this.do_talk_ablout_feelings,
      do_meditation: do_meditation ?? this.do_meditation,
      do_enjoy_work: do_enjoy_work ?? this.do_enjoy_work,
      do_love_self: do_love_self ?? this.do_love_self,
      do_stay_positive: do_stay_positive ?? this.do_stay_positive,
      has_diabetes: has_diabetes ?? this.has_diabetes,
      has_cholesterol: has_cholesterol ?? this.has_cholesterol,
      has_hypertension: has_hypertension ?? this.has_hypertension,
      has_thyroid: has_thyroid ?? this.has_thyroid,
      has_high_bp: has_high_bp ?? this.has_high_bp,
      has_low_bp: has_low_bp ?? this.has_low_bp,
      is_mind_activity_private: is_mind_activity_private ?? this.is_mind_activity_private,
      goal_control_anger: goal_control_anger ?? this.goal_control_anger,
      goal_reduce_stress: goal_reduce_stress ?? this.goal_reduce_stress,
      goal_sleep_more: goal_sleep_more ?? this.goal_sleep_more,
      goal_control_thoughts: goal_control_thoughts ?? this.goal_control_thoughts,
      goal_live_in_present: goal_live_in_present ?? this.goal_live_in_present,
      goal_improve_will_power: goal_improve_will_power ?? this.goal_improve_will_power,
      goal_overcome_addiction: goal_overcome_addiction ?? this.goal_overcome_addiction,
      make_goal_private: make_goal_private ?? this.make_goal_private,
      weight_kg: weight_kg ?? this.weight_kg,
      weight_unit: weight_unit ?? this.weight_unit,
      height_cm: height_cm ?? this.height_cm,
      height_unit: height_unit ?? this.height_unit,
      is_w_h_private: is_w_h_private ?? this.is_w_h_private,
      do_walk: do_walk ?? this.do_walk,
      ride_cycle: ride_cycle ?? this.ride_cycle,
      do_exercise: do_exercise ?? this.do_exercise,
      do_yoga: do_yoga ?? this.do_yoga,
      play_sports: play_sports ?? this.play_sports,
      do_dance: do_dance ?? this.do_dance,
      is_health_activity_private: is_health_activity_private ?? this.is_health_activity_private,
      have_health_condition: have_health_condition ?? this.have_health_condition,
      goal_stay_fit: goal_stay_fit ?? this.goal_stay_fit,
      goal_gain_muscle: goal_gain_muscle ?? this.goal_gain_muscle,
      goal_loose_weight: goal_loose_weight ?? this.goal_loose_weight,
      goal_get_more_active: goal_get_more_active ?? this.goal_get_more_active,
      target_weight_kg: target_weight_kg ?? this.target_weight_kg,
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
      nutritionist_image_url: nutritionist_image_url ?? this.nutritionist_image_url,
      nutritionist_name: nutritionist_name ?? this.nutritionist_name,
      status: status ?? this.status,
      trainer_id: trainer_id ?? this.trainer_id,
      trainer_image_url: trainer_image_url ?? this.trainer_image_url,
      trainer_name: trainer_name ?? this.trainer_name,
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
      'has_alcohol_addiction': has_alcohol_addiction,
      'has_pornography_addiction': has_pornography_addiction,
      'has_tobaco_addiction': has_tobaco_addiction,
      'has_internet_addiction': has_internet_addiction,
      'has_drug_addiction': has_drug_addiction,
      'has_cigearette_addiction': has_cigearette_addiction,
      'has_videi_games_addiction': has_videi_games_addiction,
      'do_talk_ablout_feelings': do_talk_ablout_feelings,
      'do_meditation': do_meditation,
      'do_enjoy_work': do_enjoy_work,
      'do_love_self': do_love_self,
      'do_stay_positive': do_stay_positive,
      'has_diabetes': has_diabetes,
      'has_cholesterol': has_cholesterol,
      'has_hypertension': has_hypertension,
      'has_thyroid': has_thyroid,
      'has_high_bp': has_high_bp,
      'has_low_bp': has_low_bp,
      'is_mind_activity_private': is_mind_activity_private,
      'goal_control_anger': goal_control_anger,
      'goal_reduce_stress': goal_reduce_stress,
      'goal_sleep_more': goal_sleep_more,
      'goal_control_thoughts': goal_control_thoughts,
      'goal_live_in_present': goal_live_in_present,
      'goal_improve_will_power': goal_improve_will_power,
      'goal_overcome_addiction': goal_overcome_addiction,
      'make_goal_private': make_goal_private,
      'weight_kg': weight_kg,
      'weight_unit': weight_unit,
      'height_cm': height_cm,
      'height_unit': height_unit,
      'is_w_h_private': is_w_h_private,
      'do_walk': do_walk,
      'ride_cycle': ride_cycle,
      'do_exercise': do_exercise,
      'do_yoga': do_yoga,
      'play_sports': play_sports,
      'do_dance': do_dance,
      'is_health_activity_private': is_health_activity_private,
      'have_health_condition': have_health_condition,
      'goal_stay_fit': goal_stay_fit,
      'goal_gain_muscle': goal_gain_muscle,
      'goal_loose_weight': goal_loose_weight,
      'goal_get_more_active': goal_get_more_active,
      'target_weight_kg': target_weight_kg,
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

  factory HealthProfile.fromMap(Map<String, dynamic> map) {
    return HealthProfile(
      is_early_bird: map['is_early_bird'] ?? 0,
      is_night_owl: map['is_night_owl'] ?? 0,
      is_humming_bird: map['is_humming_bird'] ?? 0,
      is_vegan: map['is_vegan'] ?? 0,
      is_vegetarian: map['is_vegetarian'] ?? 0,
      is_keto: map['is_keto'] ?? 0,
      is_sattvik: map['is_sattvik'] ?? 0,
      has_alcohol_addiction: map['has_alcohol_addiction'] ?? 0,
      has_pornography_addiction: map['has_pornography_addiction'] ?? 0,
      has_tobaco_addiction: map['has_tobaco_addiction'] ?? 0,
      has_internet_addiction: map['has_internet_addiction'] ?? 0,
      has_drug_addiction: map['has_drug_addiction'] ?? 0,
      has_cigearette_addiction: map['has_cigearette_addiction'] ?? 0,
      has_videi_games_addiction: map['has_videi_games_addiction'] ?? 0,
      do_talk_ablout_feelings: map['do_talk_ablout_feelings'] ?? 0,
      do_meditation: map['do_meditation'] ?? 0,
      do_enjoy_work: map['do_enjoy_work'] ?? 0,
      do_love_self: map['do_love_self'] ?? 0,
      do_stay_positive: map['do_stay_positive'] ?? 0,
      has_diabetes: map['has_diabetes'] ?? 0,
      has_cholesterol: map['has_cholesterol'] ?? 0,
      has_hypertension: map['has_hypertension'] ?? 0,
      has_thyroid: map['has_thyroid'] ?? 0,
      has_high_bp: map['has_high_bp'] ?? 0,
      has_low_bp: map['has_low_bp'] ?? 0,
      is_mind_activity_private: map['is_mind_activity_private'] ?? 0,
      goal_control_anger: map['goal_control_anger'] ?? 0,
      goal_reduce_stress: map['goal_reduce_stress'] ?? 0,
      goal_sleep_more: map['goal_sleep_more'] ?? 0,
      goal_control_thoughts: map['goal_control_thoughts'] ?? 0,
      goal_live_in_present: map['goal_live_in_present'] ?? 0,
      goal_improve_will_power: map['goal_improve_will_power'] ?? 0,
      goal_overcome_addiction: map['goal_overcome_addiction'] ?? 0,
      make_goal_private: map['make_goal_private'] ?? 0,
      weight_kg: map['weight_kg'] ?? 0.0,
      weight_unit: map['weight_unit'] ?? 0,
      height_cm: map['height_cm'] ?? 0.0,
      height_unit: map['height_unit'] ?? 0,
      is_w_h_private: map['is_w_h_private'] ?? 0,
      do_walk: map['do_walk'] ?? 0,
      ride_cycle: map['ride_cycle'] ?? 0,
      do_exercise: map['do_exercise'] ?? 0,
      do_yoga: map['do_yoga'] ?? 0,
      play_sports: map['play_sports'] ?? 0,
      do_dance: map['do_dance'] ?? 0,
      is_health_activity_private: map['is_health_activity_private'] ?? 0,
      have_health_condition: map['have_health_condition'] ?? 0,
      goal_stay_fit: map['goal_stay_fit'] ?? 0,
      goal_gain_muscle: map['goal_gain_muscle'] ?? 0,
      goal_loose_weight: map['goal_loose_weight'] ?? 0,
      goal_get_more_active: map['goal_get_more_active'] ?? 0,
      target_weight_kg: map['target_weight_kg'] ?? 0.0,
      coins: map['coins'] ?? 0,
      councellor_id: List<int>.from(map['councellor_id'] ?? const []),
      councellor_image_url: List<String>.from(map['councellor_image_url'] ?? const []),
      councellor_name: List<String>.from(map['councellor_name'] ?? const []),
      fitness_endorsed: List<int>.from(map['fitness_endorsed'] ?? const []),
      fitness_growth: map['fitness_growth'] ?? 0.0,
      fitness_score: map['fitness_score'] ?? 0.0,
      fitness_skills: List<String>.from(map['fitness_skills'] ?? const []),
      mindfulness_growth: map['mindfulness_growth'] ?? 0.0,
      mindfulness_score: map['mindfulness_score'] ?? 0.0,
      mindfulness_skills: List<String>.from(map['mindfulness_skills'] ?? const []),
      mindfulness_endorsed: List<int>.from(map['mindfulness_endorsed'] ?? const []),
      nutritionist_id: List<int>.from(map['nutritionist_id'] ?? const []),
      nutritionist_image_url: List<String>.from(map['nutritionist_image_url'] ?? const []),
      nutritionist_name: List<String>.from(map['nutritionist_name'] ?? const []),
      status: map['status'] ?? '',
      trainer_id: List<int>.from(map['trainer_id'] ?? const []),
      trainer_image_url: List<String>.from(map['trainer_image_url'] ?? const []),
      trainer_name: List<String>.from(map['trainer_name'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthProfile.fromJson(String source) => HealthProfile.fromMap(json.decode(source));

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
      has_alcohol_addiction,
      has_pornography_addiction,
      has_tobaco_addiction,
      has_internet_addiction,
      has_drug_addiction,
      has_cigearette_addiction,
      has_videi_games_addiction,
      do_talk_ablout_feelings,
      do_meditation,
      do_enjoy_work,
      do_love_self,
      do_stay_positive,
      has_diabetes,
      has_cholesterol,
      has_hypertension,
      has_thyroid,
      has_high_bp,
      has_low_bp,
      is_mind_activity_private,
      goal_control_anger,
      goal_reduce_stress,
      goal_sleep_more,
      goal_control_thoughts,
      goal_live_in_present,
      goal_improve_will_power,
      goal_overcome_addiction,
      make_goal_private,
      weight_kg,
      weight_unit,
      height_cm,
      height_unit,
      is_w_h_private,
      do_walk,
      ride_cycle,
      do_exercise,
      do_yoga,
      play_sports,
      do_dance,
      is_health_activity_private,
      have_health_condition,
      goal_stay_fit,
      goal_gain_muscle,
      goal_loose_weight,
      goal_get_more_active,
      target_weight_kg,
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
