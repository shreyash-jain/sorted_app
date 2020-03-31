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
  int reminder;
  DateTime time;


  EventModel(
      {this.id, this.title,this.time, this.content, this.isImportant, this.date, this.todo_id, this.duration, this.reminder, this.date_id});

  EventModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.reminder = map['reminder'];
    this.date_id = map['date_id'];
    this.duration = map['duration'];
    this.todo_id = map['todo_id'];
this.time=DateTime.parse(map['time']);
    this.title = map['title'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
    this.isImportant = map['isImportant'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'title': this.title,
      'content': this.content,
      'isImportant': this.isImportant == true ? 1 : 0,
      'date': this.date.toIso8601String(),
      'reminder': this.reminder,
      'todo_id': this.todo_id,
      'duration': this.duration,
      'date_id': this.date_id,
      'time':this.time.toIso8601String(),
    };
  }
}