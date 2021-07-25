import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClassTimetableModel extends Equatable {
  int id;
  int classId;
  int mon;
  int tue;
  int wed;
  int thu;
  int fri;
  int sat;
  int sun;
  DateTime monStart;
  DateTime monEnd;
  DateTime tueStart;
  DateTime tueEnd;
  DateTime wedStart;
  DateTime wedEnd;
  DateTime thuStart;
  DateTime thuEnd;
  DateTime friStart;
  DateTime friEnd;
  DateTime satEnd;
  DateTime satStart;
  DateTime sunEnd;
  DateTime sunStart;
  DateTime defaultEnd;
  DateTime defaultStart;
  ClassTimetableModel({
    this.id = 0,
    this.classId = 0,
    this.mon = 0,
    this.tue = 0,
    this.wed = 0,
    this.thu = 0,
    this.fri = 0,
    this.sat = 0,
    this.sun = 0,
    this.monStart,
    this.monEnd,
    this.tueStart,
    this.tueEnd,
    this.wedStart,
    this.wedEnd,
    this.thuStart,
    this.thuEnd,
    this.friStart,
    this.friEnd,
    this.satEnd,
    this.satStart,
    this.sunEnd,
    this.sunStart,
    this.defaultEnd,
    this.defaultStart,
  });

  ClassTimetableModel copyWith({
    int id,
    int classId,
    int mon,
    int tue,
    int wed,
    int thu,
    int fri,
    int sat,
    int sun,
    DateTime monStart,
    DateTime monEnd,
    DateTime tueStart,
    DateTime tueEnd,
    DateTime wedStart,
    DateTime wedEnd,
    DateTime thuStart,
    DateTime thuEnd,
    DateTime friStart,
    DateTime friEnd,
    DateTime satEnd,
    DateTime satStart,
    DateTime sunEnd,
    DateTime sunStart,
    DateTime defaultEnd,
    DateTime defaultStart,
  }) {
    return ClassTimetableModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      mon: mon ?? this.mon,
      tue: tue ?? this.tue,
      wed: wed ?? this.wed,
      thu: thu ?? this.thu,
      fri: fri ?? this.fri,
      sat: sat ?? this.sat,
      sun: sun ?? this.sun,
      monStart: monStart ?? this.monStart,
      monEnd: monEnd ?? this.monEnd,
      tueStart: tueStart ?? this.tueStart,
      tueEnd: tueEnd ?? this.tueEnd,
      wedStart: wedStart ?? this.wedStart,
      wedEnd: wedEnd ?? this.wedEnd,
      thuStart: thuStart ?? this.thuStart,
      thuEnd: thuEnd ?? this.thuEnd,
      friStart: friStart ?? this.friStart,
      friEnd: friEnd ?? this.friEnd,
      satEnd: satEnd ?? this.satEnd,
      satStart: satStart ?? this.satStart,
      sunEnd: sunEnd ?? this.sunEnd,
      sunStart: sunStart ?? this.sunStart,
      defaultEnd: defaultEnd ?? this.defaultEnd,
      defaultStart: defaultStart ?? this.defaultStart,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classId': classId,
      'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'sat': sat,
      'sun': sun,
      'monStart': monStart.millisecondsSinceEpoch,
      'monEnd': monEnd.millisecondsSinceEpoch,
      'tueStart': tueStart.millisecondsSinceEpoch,
      'tueEnd': tueEnd.millisecondsSinceEpoch,
      'wedStart': wedStart.millisecondsSinceEpoch,
      'wedEnd': wedEnd.millisecondsSinceEpoch,
      'thuStart': thuStart.millisecondsSinceEpoch,
      'thuEnd': thuEnd.millisecondsSinceEpoch,
      'friStart': friStart.millisecondsSinceEpoch,
      'friEnd': friEnd.millisecondsSinceEpoch,
      'satEnd': satEnd.millisecondsSinceEpoch,
      'satStart': satStart.millisecondsSinceEpoch,
      'sunEnd': sunEnd.millisecondsSinceEpoch,
      'sunStart': sunStart.millisecondsSinceEpoch,
      'defaultEnd': defaultEnd.millisecondsSinceEpoch,
      'defaultStart': defaultStart.millisecondsSinceEpoch,
    };
  }

  factory ClassTimetableModel.fromMap(Map<String, dynamic> map) {
    return ClassTimetableModel(
      id: map['id'] ?? 0,
      classId: map['classId'] ?? 0,
      mon: map['mon'] ?? 0,
      tue: map['tue'] ?? 0,
      wed: map['wed'] ?? 0,
      thu: map['thu'] ?? 0,
      fri: map['fri'] ?? 0,
      sat: map['sat'] ?? 0,
      sun: map['sun'] ?? 0,
      monStart: DateTime.fromMillisecondsSinceEpoch(map['monStart']),
      monEnd: DateTime.fromMillisecondsSinceEpoch(map['monEnd']),
      tueStart: DateTime.fromMillisecondsSinceEpoch(map['tueStart']),
      tueEnd: DateTime.fromMillisecondsSinceEpoch(map['tueEnd']),
      wedStart: DateTime.fromMillisecondsSinceEpoch(map['wedStart']),
      wedEnd: DateTime.fromMillisecondsSinceEpoch(map['wedEnd']),
      thuStart: DateTime.fromMillisecondsSinceEpoch(map['thuStart']),
      thuEnd: DateTime.fromMillisecondsSinceEpoch(map['thuEnd']),
      friStart: DateTime.fromMillisecondsSinceEpoch(map['friStart']),
      friEnd: DateTime.fromMillisecondsSinceEpoch(map['friEnd']),
      satEnd: DateTime.fromMillisecondsSinceEpoch(map['satEnd']),
      satStart: DateTime.fromMillisecondsSinceEpoch(map['satStart']),
      sunEnd: DateTime.fromMillisecondsSinceEpoch(map['sunEnd']),
      sunStart: DateTime.fromMillisecondsSinceEpoch(map['sunStart']),
      defaultEnd: DateTime.fromMillisecondsSinceEpoch(map['defaultEnd']),
      defaultStart: DateTime.fromMillisecondsSinceEpoch(map['defaultStart']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassTimetableModel.fromJson(String source) =>
      ClassTimetableModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      classId,
      mon,
      tue,
      wed,
      thu,
      fri,
      sat,
      sun,
      monStart,
      monEnd,
      tueStart,
      tueEnd,
      wedStart,
      wedEnd,
      thuStart,
      thuEnd,
      friStart,
      friEnd,
      satEnd,
      satStart,
      sunEnd,
      sunStart,
      defaultEnd,
      defaultStart,
    ];
  }
}
