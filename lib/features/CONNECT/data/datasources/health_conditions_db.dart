

import 'package:sorted/core/global/entities/sub_profiles/health_condition.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_speciality.dart';

List<KeyValueModel> healthConditionsTags = [
  KeyValueModel(key: 0, value: "Diabetes"),
  KeyValueModel(key: 1, value: "Cholesterol"),
  KeyValueModel(key: 2, value: "Thyroid"),
  KeyValueModel(key: 3, value: "BP Condition"),
];

int getIdfromString(String topic) {
  return healthConditionsTags
          .where((element) => (element.value == topic))
          .toList()[0]
          ?.key ??
      -1;
}

List<String> getConditionStringsFromKey(List<int> goals) {
  List<String> values = [];
  for (var i = 0; i < goals.length; i++) {
    values.add(getStringFromId(goals[i]));
  }
  return values;
}

String getStringFromId(int id) {
  return healthConditionsTags
          .where((element) => (element.key == id))
          .toList()[0]
          ?.value ??
      "";
}

HealthConditions healthConditionsFromTags(List<int> tags) {
  return HealthConditions(
    has_high_bp: tags.contains(0) ? 1 : 0,
    has_diabetes: tags.contains(1) ? 1 : 0,
    has_cholesterol: tags.contains(2) ? 1 : 0,
    has_thyroid: tags.contains(3) ? 1 : 0,
  );
}

List<int> listFromHealthConditions(HealthConditions conditions) {
  List<int> tags = [];
  if (conditions.has_high_bp == 1) tags.add(0);
  if (conditions.has_diabetes == 1) tags.add(1);
  if (conditions.has_cholesterol == 1) tags.add(2);
  if (conditions.has_thyroid == 1) tags.add(3);

  return tags;
}
