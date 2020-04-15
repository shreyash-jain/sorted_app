import 'dart:math';

import 'package:intl/intl.dart';

class DateModel {
  int id;
  DateTime time_start;
  DateTime time_end;
  DateTime date;
  int survey;

  DateModel({this.id, this.time_end, this.time_start,  this.date, this.survey});

  DateModel.fromMap(Map<String, dynamic> map) {
    var formatter = new DateFormat('dd-MM-yyyy');
    this.id = map['id'];
    this.survey=map['survey'];
    this.date = formatter.parse(map['date']);
    this.time_start = DateTime.parse(map['time_start']);
    this.time_end = DateTime.parse(map['time_end']);

  }

  Map<String, dynamic> toMap() {
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted_date = formatter.format(this.date);
    return <String, dynamic>{
      'id': this.id,
      'time_start': this.time_start.toIso8601String(),
      'time_end': this.time_end.toIso8601String(),
      'date':formatted_date,
      'survey':this.survey
    };
  }


}
