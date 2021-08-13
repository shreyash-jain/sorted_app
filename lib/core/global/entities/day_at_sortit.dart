import 'dart:convert';

import 'package:equatable/equatable.dart';

class DayAtSortit extends Equatable {
  DateTime loginTime;
  int day;
  DayAtSortit({
     this.loginTime,
    this.day = 0,
  });

  DayAtSortit copyWith({
    DateTime loginTime,
    int day,
  }) {
    return DayAtSortit(
      loginTime: loginTime ?? this.loginTime,
      day: day ?? this.day,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loginTime': loginTime.toIso8601String(),
      'day': day,
    };
  }

  factory DayAtSortit.fromMap(Map<String, dynamic> map) {
    return DayAtSortit(
      loginTime: DateTime.parse(map['loginTime']),
      day: map['day'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DayAtSortit.fromJson(String source) => DayAtSortit.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [loginTime, day];
}
