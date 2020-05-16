import 'dart:math';

import 'package:intl/intl.dart';

class ExpenseModel {
  int id;
  String title;
  String content;
  DateTime saved_ts;
  int date_id;
  DateTime date;
  int cat_id;
  int friend_id;
  double money;
  int type;
  ExpenseModel(
      {this.id,
        this.title,
        this.date_id,
        this.type,
        this.friend_id,
        this.saved_ts,
        this.content,
        this.money,
        this.date,
        this.cat_id});

  ExpenseModel.fromMap(Map<String, dynamic> map) {
    var formatter = new DateFormat('dd-MM-yyyy');
    this.id = map['id'];
    this.cat_id = map['cat_id'];
    this.title = map['title'];
    this.date_id =map['date_id'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
   this.type=map['type'];
   this.friend_id=map['friend_id'];
   this.money=map['money'];
    this.saved_ts =DateTime.parse(map['saved_ts']);
  }

  Map<String, dynamic> toMap() {


    return <String, dynamic>{
      'id': this.id,
      'title': this.title,
      'content': this.content,
      'cat_id': this.cat_id,
      'date_id':this.date_id,
      'money': this.money,
      'friend_id': this.friend_id,
      'type': this.type,
      'date': this.date.toIso8601String(),
      'saved_ts':this.saved_ts.toIso8601String()
    };
  }

  ExpenseModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
    this.title = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
    this.content = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);

  }
}
