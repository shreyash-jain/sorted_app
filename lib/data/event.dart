import 'dart:math';

class EventModel {
  int id;
  String title;
  String content;
  bool isImportant;
  DateTime date;
  int todo_id;
  double duration;
  int date_id;
  int r_id;
  String cal_id;
  int timeline_id;
  DateTime time;
  int a_id;
  DateTime saved_ts;

  EventModel(
      {this.id,this.cal_id,this.saved_ts,this.title,this.time, this.timeline_id,this.content, this.isImportant, this.date, this.todo_id, this.duration, this.r_id, this.date_id, this.a_id,});

  EventModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.r_id = map['r_id'];
    this.cal_id=map['r_id'];
    this.date_id = map['date_id'];
    this.duration = map['duration'];
    this.timeline_id = map['timeline_id'];
    this.todo_id = map['todo_id'];
this.time=DateTime.parse(map['time']);
    this.title = map['title'];
    this.content = map['content'];
    this.saved_ts =DateTime.parse(map['saved_ts']);
    this.a_id=map['a_id'];
    this.date = DateTime.parse(map['date']);
    this.isImportant = map['isImportant'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'cal_id':this.cal_id,
      'title': this.title,
      'a_id':this.a_id,
      'timeline_id':this.timeline_id,
      'content': this.content,
      'isImportant': this.isImportant == true ? 1 : 0,
      'date': this.date.toIso8601String(),
      'r_id': this.r_id,
      'todo_id': this.todo_id,
      'saved_ts':this.saved_ts.toIso8601String(),
      'duration': this.duration,
      'date_id': this.date_id,
      'time':this.time.toIso8601String(),
    };
  }
}