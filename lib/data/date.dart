import 'dart:math';

import 'package:intl/intl.dart';

class DateModel {
  int id;
  DateTime time_start;
  DateTime time_end;
  DateTime date;
  int survey;
  String ImageUrl;
  String dayName;
  double p_rating,a_rating;
  int c_streak,l_streak,l_interval;
  DateTime saved_ts;
  DateModel({this.saved_ts,this.id, this.time_end, this.time_start,  this.date, this.survey,this.p_rating,this.a_rating,this.c_streak,this.ImageUrl,this.dayName,this.l_interval,this.l_streak});

  DateModel.fromMap(Map<String, dynamic> map) {
    var formatter = new DateFormat('dd-MM-yyyy');
    this.id = map['id'];
    this.survey=map['survey'];
    this.date = formatter.parse(map['date']);
    this.time_start = DateTime.parse(map['time_start']);
    this.time_end = DateTime.parse(map['time_end']);
    this.l_streak=map['l_streak'];
    this.l_interval=map['l_interval'];
    this.dayName=map['dayName'];
    this.ImageUrl=map['ImageUrl'];
    this.c_streak=map['c_streak'];
    this.a_rating=map['a_rating'];
    this.p_rating=map['p_rating'];
    this.saved_ts =DateTime.parse(map['saved_ts']);

  }

  Map<String, dynamic> toMap() {
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted_date = formatter.format(this.date);
    return <String, dynamic>{
      'id': this.id,
      'time_start': this.time_start.toIso8601String(),
      'time_end': this.time_end.toIso8601String(),
      'date':formatted_date,
      'survey':this.survey,
      'saved_ts':this.saved_ts.toIso8601String(),
      'c_streak':this.c_streak,
      'l_streak':this.l_streak,
      'ImageUrl':this.ImageUrl,
      'p_rating':this.p_rating,
      'a_rating':this.a_rating,
      'l_interval':this.l_interval,
      'dayName':this.dayName
    };
  }


}
