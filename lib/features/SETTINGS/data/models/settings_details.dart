import 'dart:convert';

import 'package:equatable/equatable.dart';

class SettingsDetails extends Equatable {
  bool unfilledSurveyPreference;
  double budget;
  int currency;
  SettingsDetails({
    this.unfilledSurveyPreference = false,
    this.budget = 1000.0,
    this.currency = 1,
  });

  @override
  // TODO: implement props
  List<Object> get props => [unfilledSurveyPreference, budget, currency];
  

  SettingsDetails copyWith({
    bool unfilledSurveyPreference,
    double budget,
    int currency,
  }) {
    return SettingsDetails(
      unfilledSurveyPreference: unfilledSurveyPreference ?? this.unfilledSurveyPreference,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unfilledSurveyPreference': unfilledSurveyPreference,
      'budget': budget,
      'currency': currency,
    };
  }

  factory SettingsDetails.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SettingsDetails(
      unfilledSurveyPreference: map['unfilledSurveyPreference'],
      budget: map['budget'],
      currency: map['currency'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsDetails.fromJson(String source) => SettingsDetails.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
