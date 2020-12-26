import 'dart:convert';

import 'package:equatable/equatable.dart';

class CalendarEventBlock extends Equatable {
  int calId;
  DateTime date;
  int id;
  int savedTs;
  int state;
  int taskId;
  String title;
  int type;
  CalendarEventBlock({
    this.calId = 0,
    this.date,
    this.id = 0,
    this.savedTs = 0,
    this.state = 0,
    this.taskId = 0,
    this.title = '',
    this.type = 0,
  });

  CalendarEventBlock copyWith({
    int calId,
    DateTime date,
    int id,
    int savedTs,
    int state,
    int taskId,
    String title,
    int type,
  }) {
    return CalendarEventBlock(
      calId: calId ?? this.calId,
      date: date ?? this.date,
      id: id ?? this.id,
      savedTs: savedTs ?? this.savedTs,
      state: state ?? this.state,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calId': calId,
      'date': date?.millisecondsSinceEpoch,
      'id': id,
      'savedTs': savedTs,
      'state': state,
      'taskId': taskId,
      'title': title,
      'type': type,
    };
  }

  factory CalendarEventBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CalendarEventBlock(
      calId: map['calId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      id: map['id'],
      savedTs: map['savedTs'],
      state: map['state'],
      taskId: map['taskId'],
      title: map['title'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockCalendarEvent";

  factory CalendarEventBlock.fromJson(String source) =>
      CalendarEventBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      calId,
      date,
      id,
      savedTs,
      state,
      taskId,
      title,
      type,
    ];
  }
}
