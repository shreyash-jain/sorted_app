import 'dart:math';
import 'package:notes/data/models.dart';

class ReminderModel {
  int id, note_id;
  String content;
  int type;
  DateTime date;

  ReminderModel({this.id, this.note_id, this.content, this.type, this.date});

  ReminderModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.date = DateTime.parse(map['date']);
    this.note_id = map['note_id'];
    this.content = map['content'];
    this.type = map['type'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'note_id': this.note_id,
      'content': this.content,
      'date': this.date.toIso8601String(),
      'type': this.type,
    };
  }

  ReminderModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
  }
}
