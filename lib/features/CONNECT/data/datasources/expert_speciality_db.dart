

import 'package:sorted/features/CONNECT/data/models/expert/expert_speciality.dart';

List<KeyValueModel> specialities = [
  KeyValueModel(key: 0, value: "Yoga"),
  KeyValueModel(key: 1, value: "Vinyasa"),
  KeyValueModel(key: 2, value: "Breathing Exercises"),
  KeyValueModel(key: 3, value: "Pranayama"),
  KeyValueModel(key: 4, value: "Meditation"),
  KeyValueModel(key: 5, value: "Asanas"),
  KeyValueModel(key: 6, value: "Pilates"),
  KeyValueModel(key: 7, value: "Stretching"),
  KeyValueModel(key: 8, value: "HIIT"),
  KeyValueModel(key: 9, value: "Resistance Training"),
  KeyValueModel(key: 10, value: "Elliptical"),
  KeyValueModel(key: 11, value: "Strength Training"),
  KeyValueModel(key: 12, value: "TRX"),
  KeyValueModel(key: 13, value: "Mobility Work"),
  KeyValueModel(key: 14, value: "Cardio"),
  KeyValueModel(key: 15, value: "Yog Nindra"),
  KeyValueModel(key: 16, value: "Zumba"),
  KeyValueModel(key: 17, value: "Dance"),
  KeyValueModel(key: 18, value: "Aerobics"),
  KeyValueModel(key: 19, value: "Cross Functional"),
  KeyValueModel(key: 20, value: "Martial Arts"),
  KeyValueModel(key: 21, value: "Boxing"),
];

int getIdfromString(String topic) {
  return specialities
          .where((element) => (element.value == topic))
          .toList()[0]
          ?.key ??
      -1;
}

String getStringFromId(int id) {
  return specialities
          .where((element) => (element.key == id))
          .toList()[0]
          ?.value ??
      "";
}
