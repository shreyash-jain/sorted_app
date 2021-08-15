import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sorted/features/TRACKERS/COMMON/models/activity_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_log.dart';

class DietLogSummary extends Equatable {
  List<DietLog> diets;
  DateTime last_log;
  String calorieTaken;
  DietLogSummary({
    this.diets = const [],
    this.last_log,
    this.calorieTaken = '',
  });

  DietLogSummary copyWith({
    List<DietLog> diets,
    DateTime last_log,
    String calorieTaken,
  }) {
    return DietLogSummary(
      diets: diets ?? this.diets,
      last_log: last_log ?? this.last_log,
      calorieTaken: calorieTaken ?? this.calorieTaken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'diets': diets?.map((x) => x.toMap())?.toList(),
      'last_log': last_log.toIso8601String(),
      'calorieTaken': calorieTaken,
    };
  }

  factory DietLogSummary.fromMap(Map<String, dynamic> map) {

    return DietLogSummary(
      diets: List<DietLog>.from(map['diets']?.map((x) {
            var z = Map<String, dynamic>.from(x);
            return DietLog.fromMap(z) ?? DietLog();
          }) ??
          const []),
      last_log: DateTime.parse((map['last_log'])),
      calorieTaken: map['calorieTaken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DietLogSummary.fromJson(String source) =>
      DietLogSummary.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [diets, last_log, calorieTaken];
}
