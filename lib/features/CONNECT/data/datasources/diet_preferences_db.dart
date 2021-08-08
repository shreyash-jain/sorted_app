import 'package:sorted/core/global/entities/sub_profiles/fitness_goals.dart';
import 'package:sorted/core/global/entities/sub_profiles/food_preferences.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_speciality.dart';

List<KeyValueModel> dietPreferencesTags = [
  KeyValueModel(key: 0, value: "Vegan"),
  KeyValueModel(key: 1, value: "Vegetarian"),
  KeyValueModel(key: 2, value: "Keto"),
  KeyValueModel(key: 3, value: "Sattvik"),
];

int getIdfromString(String topic) {
  return dietPreferencesTags
          .where((element) => (element.value == topic))
          .toList()[0]
          ?.key ??
      -1;
}

UserFoodPreferences foodPreferencesFromTags(List<int> tags) {
  return UserFoodPreferences(
      is_vegan: tags.contains(0) ? 1 : 0,
      is_vegetarian: tags.contains(1) ? 1 : 0,
      is_keto: tags.contains(2) ? 1 : 0,
      is_sattvik: tags.contains(3) ? 1 : 0);
}

List<int> listFromFoodPreference(UserFoodPreferences preferences) {
  List<int> tags = [];
  if (preferences.is_vegan == 1) tags.add(0);
  if (preferences.is_vegetarian == 1) tags.add(1);
  if (preferences.is_keto == 1) tags.add(2);
  if (preferences.is_sattvik == 1) tags.add(3);
  return tags;
}

String getStringFromId(int id) {
  return dietPreferencesTags
          .where((element) => (element.key == id))
          .toList()[0]
          ?.value ??
      "";
}
