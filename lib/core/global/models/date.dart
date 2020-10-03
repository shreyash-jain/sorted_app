import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class DateModel extends Equatable {
  DateTime date;
  int id;
  int dateMilliSec;
  String dateFormatted;
  int appOpened;
  DateTime savedTs;
  DateModel({
    this.date,
    this.id = 0,
    this.dateMilliSec = 0,
    this.dateFormatted = '',
    this.appOpened = 0,
    this.savedTs,
  });
 

  DateModel copyWith({
    DateTime date,
    int id,
    int dateMilliSec,
    String dateFormatted,
    int appOpened,
    DateTime savedTs,
  }) {
    return DateModel(
      date: date ?? this.date,
      id: id ?? this.id,
      dateMilliSec: dateMilliSec ?? this.dateMilliSec,
      dateFormatted: dateFormatted ?? this.dateFormatted,
      appOpened: appOpened ?? this.appOpened,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date?.millisecondsSinceEpoch,
      'id': id,
      'dateMilliSec': dateMilliSec,
      'dateFormatted': dateFormatted,
      'appOpened': appOpened,
      'savedTs': savedTs?.millisecondsSinceEpoch,
    };
  }

  factory DateModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DateModel(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      id: map['id'],
      dateMilliSec: map['dateMilliSec'],
      dateFormatted: map['dateFormatted'],
      appOpened: map['appOpened'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DateModel.fromJson(String source) => DateModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      date,
      id,
      dateMilliSec,
      dateFormatted,
      appOpened,
      savedTs,
    ];
  }
}
