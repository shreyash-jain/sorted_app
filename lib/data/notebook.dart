import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/models.dart';

class NoteBookModel {
  int id;
  String title;
  int notes_num;
  bool isImportant;
  DateTime date;
  DateTime saved_ts;
  NoteBookModel(
      {this.id, this.title,   this.saved_ts,this.notes_num, this.isImportant, this.date});

  NoteBookModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.title = map['title'];
    this.notes_num = map['notes_num'];
    this.date = DateTime.parse(map['date']);
    this.isImportant = map['isImportant'] == 1 ? true : false;
    this.saved_ts =DateTime.parse(map['saved_ts']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'notes_num': this.notes_num,
      'isImportant': this.isImportant == true ? 1 : 0,
      'date': this.date.toIso8601String(),
      'saved_ts':this.saved_ts.toIso8601String()
    };
  }

  NoteBookModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
    this.title = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
    this.notes_num = Random(10).nextInt(100) + 1;
    this.isImportant = Random().nextBool();
    this.date = DateTime.now().add(Duration(hours: Random().nextInt(100)));
  }
}
