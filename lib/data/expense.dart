import 'dart:math';

import 'package:intl/intl.dart';

class ExpenseModel {
  int id;
  String title;
  String content;

  DateTime date;
  int cat_id;
  int friend_id;
  double money;
  int type;
  ExpenseModel(
      {this.id,
        this.title,
        this.type,
        this.friend_id,
        this.content,
        this.money,
        this.date,
        this.cat_id});

  ExpenseModel.fromMap(Map<String, dynamic> map) {
    var formatter = new DateFormat('dd-MM-yyyy');
    this.id = map['id'];
    this.cat_id = map['cat_id'];
    this.title = map['title'];
    this.content = map['content'];
    this.date = formatter.parse(map['date']);
   this.type=map['type'];
   this.friend_id=map['friend_id'];
   this.money=map['money'];
  }

  Map<String, dynamic> toMap() {
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted_date = formatter.format(this.date);
    return <String, dynamic>{
      'id': this.id,
      'title': this.title,
      'content': this.content,
      'cat_id': this.cat_id,
      'money': this.money,
      'friend_id': this.friend_id,
      'type': this.type,
      'date': formatted_date
    };
  }

  ExpenseModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
    this.title = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
    this.content = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);

  }
}
