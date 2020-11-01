import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sorted/core/global/models/date.dart';

class ReviewModel extends Equatable {
  int id;
  DateTime startDate;
  DateTime endDate;
  DateTime time;
  int frequency;
  // 0 -> daily | 1-> weekly | 2-> monthly | 3 -> yearly
  String title;
  String description;
  String notificationTitle;
  String imagePath;
  int remind;
  int type;
  int sun;
  int mon;
  int tue;
  int wed;
  int thu;
  int fri;
  int sat;
  DateModel savedTs;
  ReviewModel({
    this.id = 0,
    this.startDate,
    this.endDate,
    this.time,
    this.frequency = 0,
    this.title = '',
    this.description = '',
    this.notificationTitle = '',
    this.imagePath = '',
    this.remind = 0,
    this.type = 0,
    this.sun = 0,
    this.mon = 0,
    this.tue = 0,
    this.wed = 0,
    this.thu = 0,
    this.fri = 0,
    this.sat = 0,
    this.savedTs,
  });
 

  ReviewModel copyWith({
    int id,
    DateTime startDate,
    DateTime endDate,
    DateTime time,
    int frequency,
    String title,
    String description,
    String notificationTitle,
    String imagePath,
    int remind,
    int type,
    int sun,
    int mon,
    int tue,
    int wed,
    int thu,
    int fri,
    int sat,
    DateModel savedTs,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      time: time ?? this.time,
      frequency: frequency ?? this.frequency,
      title: title ?? this.title,
      description: description ?? this.description,
      notificationTitle: notificationTitle ?? this.notificationTitle,
      imagePath: imagePath ?? this.imagePath,
      remind: remind ?? this.remind,
      type: type ?? this.type,
      sun: sun ?? this.sun,
      mon: mon ?? this.mon,
      tue: tue ?? this.tue,
      wed: wed ?? this.wed,
      thu: thu ?? this.thu,
      fri: fri ?? this.fri,
      sat: sat ?? this.sat,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'time': time?.millisecondsSinceEpoch,
      'frequency': frequency,
      'title': title,
      'description': description,
      'notificationTitle': notificationTitle,
      'imagePath': imagePath,
      'remind': remind,
      'type': type,
      'sun': sun,
      'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'sat': sat,
      'savedTs': savedTs?.toMap(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ReviewModel(
      id: map['id'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      frequency: map['frequency'],
      title: map['title'],
      description: map['description'],
      notificationTitle: map['notificationTitle'],
      imagePath: map['imagePath'],
      remind: map['remind'],
      type: map['type'],
      sun: map['sun'],
      mon: map['mon'],
      tue: map['tue'],
      wed: map['wed'],
      thu: map['thu'],
      fri: map['fri'],
      sat: map['sat'],
      savedTs: DateModel.fromMap(map['savedTs']),
    );
  }

  String toJson() => json.encode(toMap());
  String getString() => "Reviews";

  factory ReviewModel.fromJson(String source) => ReviewModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;


  @override
  List<Object> get props {
    return [
      id,
      startDate,
      endDate,
      time,
      frequency,
      title,
      description,
      notificationTitle,
      imagePath,
      remind,
      type,
      sun,
      mon,
      tue,
      wed,
      thu,
      fri,
      sat,
      savedTs,
    ];
  }
}
