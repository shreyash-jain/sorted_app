
import 'package:sorted/core/global/entities/sub_profiles/fitness_goals.dart';
import 'package:sorted/core/global/entities/sub_profiles/mindful_goals.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_speciality.dart';

List<KeyValueModel> fitnessGoalsTags = [
  KeyValueModel(key: 0, value: "Stay Fit"),
  KeyValueModel(key: 1, value: "Gain Muscles"),
  KeyValueModel(key: 2, value: "Lose Weight"),
  KeyValueModel(key: 3, value: "Be Active"),
  KeyValueModel(key: 4, value: "Control Anger"),
  KeyValueModel(key: 5, value: "Reduce Stress"),
  KeyValueModel(key: 6, value: "Get More Sleep"),
  KeyValueModel(key: 7, value: "Control Thoughts"),
  KeyValueModel(key: 8, value: "Live in Present"),
  KeyValueModel(key: 9, value: "Improve Will Power"),
  KeyValueModel(key: 10, value: "Overcome Addiction"),
];

int getIdfromString(String topic) {
  return fitnessGoalsTags
          .where((element) => (element.value == topic))
          .toList()[0]
          ?.key ??
      -1;
}

List<String> getFitnessStringsFromKey(List<int> goals) {
  List<String> values = [];
  for (var i = 0; i < goals.length; i++) {
    values.add(getStringFromId(goals[i]));
  }
  return values;
}

String getStringFromId(int id) {
  return fitnessGoalsTags
          .where((element) => (element.key == id))
          .toList()[0]
          ?.value ??
      "";
}


FitnessGoals fitnessGoalsFromTags(List<int> tags) {
  return FitnessGoals(
      goal_gain_muscle: tags.contains(1) ? 1 : 0,
      goal_stay_fit: tags.contains(0) ? 1 : 0,
      goal_loose_weight: tags.contains(2) ? 1 : 0,
      goal_get_more_active: tags.contains(3) ? 1 : 0);
}

MindfulGoals mindfulGoalsFromTags(List<int> tags) {
  return MindfulGoals(
      goal_control_anger: tags.contains(4) ? 1 : 0,
      goal_reduce_stress: tags.contains(5) ? 1 : 0,
      goal_sleep_more: tags.contains(6) ? 1 : 0,
      goal_control_thoughts: tags.contains(7) ? 1 : 0,
      goal_live_in_present: tags.contains(8) ? 1 : 0,
      goal_improve_will_power: tags.contains(9) ? 1 : 0,
      goal_overcome_addiction: tags.contains(10) ? 1 : 0);
}

List<int> listFromFitnessGoals(FitnessGoals fitnessGoals) {
  List<int> tags = [];
  if (fitnessGoals.goal_stay_fit == 1) tags.add(0);
  if (fitnessGoals.goal_gain_muscle == 1) tags.add(1);
  if (fitnessGoals.goal_loose_weight == 1) tags.add(2);
  if (fitnessGoals.goal_get_more_active == 1) tags.add(3);
  return tags;
}

List<int> listFromMindfulGoals(MindfulGoals minfulGoals) {
  List<int> tags = [];
  if (minfulGoals.goal_control_anger == 1) tags.add(4);
  if (minfulGoals.goal_reduce_stress == 1) tags.add(5);
  if (minfulGoals.goal_sleep_more == 1) tags.add(6);
  if (minfulGoals.goal_control_thoughts == 1) tags.add(7);
  if (minfulGoals.goal_live_in_present == 1) tags.add(8);
  if (minfulGoals.goal_improve_will_power == 1) tags.add(9);
  if (minfulGoals.goal_overcome_addiction == 1) tags.add(10);
  return tags;
}
