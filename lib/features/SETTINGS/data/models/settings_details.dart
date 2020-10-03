import 'dart:convert';

import 'package:equatable/equatable.dart';

class SettingsDetails extends Equatable {
  bool unfilledSurveyPreference;
  double budget;
  String currency;
  DateTime reminderTime;
  String theme;
  int surveyTime;
  SettingsDetails({
    this.unfilledSurveyPreference = false,
    this.budget = 0.0,
    this.currency = '',
    this.reminderTime,
    this.theme = '',
    this.surveyTime = 0,
  });


  SettingsDetails copyWith({
    bool unfilledSurveyPreference,
    double budget,
    String currency,
    DateTime reminderTime,
    String theme,
    int surveyTime,
  }) {
    return SettingsDetails(
      unfilledSurveyPreference: unfilledSurveyPreference ?? this.unfilledSurveyPreference,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      reminderTime: reminderTime ?? this.reminderTime,
      theme: theme ?? this.theme,
      surveyTime: surveyTime ?? this.surveyTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unfilledSurveyPreference': unfilledSurveyPreference== true ? 1 : 0,
      'budget': budget,
      'currency': currency,
      'reminderTime': reminderTime?.toIso8601String(),
      'theme': theme,
      'surveyTime': surveyTime,
    };
  }

  factory SettingsDetails.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SettingsDetails(
      unfilledSurveyPreference: map['unfilledSurveyPreference']== 1 ? true : false,
      budget: map['budget'],
      currency: map['currency'],
      reminderTime: DateTime.parse(map['reminderTime']),
      theme: map['theme'],
      surveyTime: map['surveyTime'],
    );
  }

  factory SettingsDetails.empty() {
    
  
    return SettingsDetails(unfilledSurveyPreference: false,currency: "₹",budget: 1000.0,reminderTime: DateTime(2020,1,1,21,00),theme: "dark",surveyTime: 20);
  }

  String toJson() => json.encode(toMap());

  factory SettingsDetails.fromJson(String source) => SettingsDetails.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      unfilledSurveyPreference,
      budget,
      currency,
      reminderTime,
      theme,
      surveyTime,
    ];
  }
}
