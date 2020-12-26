import 'dart:convert';

import 'package:equatable/equatable.dart';

class CalendarBlock extends Equatable {
  int id;
  int savedTs;
  String title;
  DateTime startDate;
  int view;
  int decoration;
  int numEvents;
  CalendarBlock({
    this.id = 0,
    this.savedTs = 0,
    this.title = '',
    this.startDate,
    this.view = 0,
    this.decoration = 0,
    this.numEvents = 0,
  });

  CalendarBlock copyWith({
    int id,
    int savedTs,
    String title,
    DateTime startDate,
    int view,
    int decoration,
    int numEvents,
  }) {
    return CalendarBlock(
      id: id ?? this.id,
      savedTs: savedTs ?? this.savedTs,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      view: view ?? this.view,
      decoration: decoration ?? this.decoration,
      numEvents: numEvents ?? this.numEvents,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savedTs': savedTs,
      'title': title,
      'startDate': startDate?.millisecondsSinceEpoch,
      'view': view,
      'decoration': decoration,
      'numEvents': numEvents,
    };
  }

  factory CalendarBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CalendarBlock(
      id: map['id'],
      savedTs: map['savedTs'],
      title: map['title'],
      startDate: (map['startDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      view: map['view'],
      decoration: map['decoration'],
      numEvents: map['numEvents'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockCalendar";

  factory CalendarBlock.fromJson(String source) =>
      CalendarBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      savedTs,
      title,
      startDate,
      view,
      decoration,
      numEvents,
    ];
  }
}
