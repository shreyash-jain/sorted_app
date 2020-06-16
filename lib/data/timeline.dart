import 'dart:math';

class TimelineModel {
  int id;
  String title;
  String content;
  DateTime saved_ts;
  DateTime end_date;
  DateTime date;
  int status;  // 1 -> ongoing ; 2 -> paused ; 3 -> completed

  TimelineModel(
      {this.id,
        this.title,
        this.content,
        this.saved_ts,
        this.end_date,
        this.date,
        this.status});

  TimelineModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.status = map['book_id'];
    this.title = map['title'];
    this.content = map['content'];
    this.end_date =map['end_date'];
    this.date = DateTime.parse(map['date']);
    this.saved_ts =DateTime.parse(map['saved_ts']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'title': this.title,
      'end_date': this.end_date,
      'content': this.content,
      'book_id': this.status,
      'saved_ts':this.saved_ts.toIso8601String(),
      'date': this.date.toIso8601String()
    };
  }


}
