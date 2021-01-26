import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MentalHealthProfile extends Equatable {
  int do_talk_ablout_feelings;
  int do_meditation;
  int do_enjoy_work;
  int do_love_self;
  int do_stay_positive;

  int is_mind_activity_private;

  int goal_control_anger;
  int goal_reduce_stress;
  int goal_sleep_more;
  int goal_control_thoughts;
  int goal_live_in_present;
  int goal_improve_will_power;
  int goal_overcome_addiction;

  int make_goal_private;
  MentalHealthProfile({
    this.do_talk_ablout_feelings = 0,
    this.do_meditation = 0,
    this.do_enjoy_work = 0,
    this.do_love_self = 0,
    this.do_stay_positive = 0,
    this.is_mind_activity_private = 0,
    this.goal_control_anger = 0,
    this.goal_reduce_stress = 0,
    this.goal_sleep_more = 0,
    this.goal_control_thoughts = 0,
    this.goal_live_in_present = 0,
    this.goal_improve_will_power = 0,
    this.goal_overcome_addiction = 0,
    this.make_goal_private = 0,
  });

  MentalHealthProfile copyWith({
    int do_talk_ablout_feelings,
    int do_meditation,
    int do_enjoy_work,
    int do_love_self,
    int do_stay_positive,
    int is_mind_activity_private,
    int goal_control_anger,
    int goal_reduce_stress,
    int goal_sleep_more,
    int goal_control_thoughts,
    int goal_live_in_present,
    int goal_improve_will_power,
    int goal_overcome_addiction,
    int make_goal_private,
  }) {
    return MentalHealthProfile(
      do_talk_ablout_feelings: do_talk_ablout_feelings ?? this.do_talk_ablout_feelings,
      do_meditation: do_meditation ?? this.do_meditation,
      do_enjoy_work: do_enjoy_work ?? this.do_enjoy_work,
      do_love_self: do_love_self ?? this.do_love_self,
      do_stay_positive: do_stay_positive ?? this.do_stay_positive,
      is_mind_activity_private: is_mind_activity_private ?? this.is_mind_activity_private,
      goal_control_anger: goal_control_anger ?? this.goal_control_anger,
      goal_reduce_stress: goal_reduce_stress ?? this.goal_reduce_stress,
      goal_sleep_more: goal_sleep_more ?? this.goal_sleep_more,
      goal_control_thoughts: goal_control_thoughts ?? this.goal_control_thoughts,
      goal_live_in_present: goal_live_in_present ?? this.goal_live_in_present,
      goal_improve_will_power: goal_improve_will_power ?? this.goal_improve_will_power,
      goal_overcome_addiction: goal_overcome_addiction ?? this.goal_overcome_addiction,
      make_goal_private: make_goal_private ?? this.make_goal_private,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'do_talk_ablout_feelings': do_talk_ablout_feelings,
      'do_meditation': do_meditation,
      'do_enjoy_work': do_enjoy_work,
      'do_love_self': do_love_self,
      'do_stay_positive': do_stay_positive,
      'is_mind_activity_private': is_mind_activity_private,
      'goal_control_anger': goal_control_anger,
      'goal_reduce_stress': goal_reduce_stress,
      'goal_sleep_more': goal_sleep_more,
      'goal_control_thoughts': goal_control_thoughts,
      'goal_live_in_present': goal_live_in_present,
      'goal_improve_will_power': goal_improve_will_power,
      'goal_overcome_addiction': goal_overcome_addiction,
      'make_goal_private': make_goal_private,
    };
  }

  factory MentalHealthProfile.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MentalHealthProfile(
      do_talk_ablout_feelings: map['do_talk_ablout_feelings'],
      do_meditation: map['do_meditation'],
      do_enjoy_work: map['do_enjoy_work'],
      do_love_self: map['do_love_self'],
      do_stay_positive: map['do_stay_positive'],
      is_mind_activity_private: map['is_mind_activity_private'],
      goal_control_anger: map['goal_control_anger'],
      goal_reduce_stress: map['goal_reduce_stress'],
      goal_sleep_more: map['goal_sleep_more'],
      goal_control_thoughts: map['goal_control_thoughts'],
      goal_live_in_present: map['goal_live_in_present'],
      goal_improve_will_power: map['goal_improve_will_power'],
      goal_overcome_addiction: map['goal_overcome_addiction'],
      make_goal_private: map['make_goal_private'],
    );
  }


  
  factory MentalHealthProfile.fromSnapshot(DocumentSnapshot map) {
    if (map == null) return null;
  
    return MentalHealthProfile(
      do_talk_ablout_feelings: map['do_talk_ablout_feelings'],
      do_meditation: map['do_meditation'],
      do_enjoy_work: map['do_enjoy_work'],
      do_love_self: map['do_love_self'],
      do_stay_positive: map['do_stay_positive'],
      is_mind_activity_private: map['is_mind_activity_private'],
      goal_control_anger: map['goal_control_anger'],
      goal_reduce_stress: map['goal_reduce_stress'],
      goal_sleep_more: map['goal_sleep_more'],
      goal_control_thoughts: map['goal_control_thoughts'],
      goal_live_in_present: map['goal_live_in_present'],
      goal_improve_will_power: map['goal_improve_will_power'],
      goal_overcome_addiction: map['goal_overcome_addiction'],
      make_goal_private: map['make_goal_private'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MentalHealthProfile.fromJson(String source) => MentalHealthProfile.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      do_talk_ablout_feelings,
      do_meditation,
      do_enjoy_work,
      do_love_self,
      do_stay_positive,
      is_mind_activity_private,
      goal_control_anger,
      goal_reduce_stress,
      goal_sleep_more,
      goal_control_thoughts,
      goal_live_in_present,
      goal_improve_will_power,
      goal_overcome_addiction,
      make_goal_private,
    ];
  }
}
