import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  int id;
  String title;
  int num_ans;
  int interval, type;
  String ans1, ans2, ans3;
  int archive;
  DateTime last_date;
  int correct_ans;
  int priority;
  int c_id;
  String content;
  String c_name;

  double weight;
  int showDashboard;
  int c_streak, l_streak, l_interval;
  String v_streak;
  DateTime saved_ts;

  QuestionModel(
      {this.id,
      this.title,
      this.type,
      this.priority,
      this.last_date,
      this.archive,
      this.correct_ans,
      this.showDashboard,
      this.num_ans,
      this.ans1,
      this.ans2,
      this.ans3,
      this.c_id,
      this.c_name,
      this.content,
      this.weight,
      this.l_interval,
      this.l_streak,
      this.c_streak,
      this.saved_ts,
      this.v_streak,
      this.interval});

  QuestionModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.title = map['title'];
    this.num_ans = map['num_ans'];
    this.type = map['type'];
    this.interval = map['interval'];
    this.ans1 = map['ans1'];
    this.ans2 = map['ans2'];
    this.ans3 = map['ans3'];
    this.l_streak = map['l_streak'];
    this.l_interval = map['l_interval'];
    this.c_streak = map['c_streak'];
    this.v_streak = map['v_streak'];
    this.archive = map['archive'];
    this.priority = map['priority'];
    this.c_name = map['c_name'];
    this.c_id = map['c_id'];
    this.content = map['content'];
    this.correct_ans = map['correct_ans'];
    this.weight = map['weight'];
    this.last_date = DateTime.parse(map['last_date']);
    this.showDashboard = map['showDashboard'];
    this.saved_ts = DateTime.parse(map['saved_ts']);
  }

  QuestionModel.fromSnapshot(DocumentSnapshot map) {
    this.id = int.parse(map.documentID);
    this.title = map.data['title'];
    this.num_ans = map.data['num_ans'];
    this.type = map.data['type'];
    this.interval = map.data['interval'];
    this.ans1 = map.data['ans1'];
    this.ans2 = map.data['ans2'];
    this.ans3 = map.data['ans3'];
    this.l_streak = map.data['l_streak'];
    this.l_interval = map.data['l_interval'];
    this.c_streak = map.data['c_streak'];
    this.v_streak = map.data['v_streak'];
    this.archive = map.data['archive'];
    this.priority = map.data['priority'];
    this.c_id = map.data['c_id'];
    this.c_name = map.data['c_name'];
    this.content = map.data['content'];
    this.correct_ans = map.data['correct_ans'];
    this.weight = map.data['weight'];
    this.last_date = DateTime.parse(map.data['last_date']);
    this.showDashboard = map.data['showDashboard'];
    this.saved_ts = DateTime.parse(map.data['saved_ts']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'num_ans': this.num_ans,
      'type': this.type,
      'interval': this.interval,
      'ans1': this.ans1,
      'ans2': this.ans2,
      'ans3': this.ans3,
      'archive': this.archive,
      'c_streak': this.c_streak,
      'l_streak': this.l_streak,
      'l_interval': this.l_interval,
      'v_streak': this.v_streak,
      'c_name': this.c_name,
      'c_id': this.c_id,
      'content': this.content,
      'saved_ts': this.saved_ts.toIso8601String(),
      'priority': this.priority,
      'correct_ans': this.correct_ans,
      'weight': this.weight,
      'last_date': this.last_date.toIso8601String(),
      'showDashboard': this.showDashboard
    };
  }

  QuestionModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
    this.title = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
  }
}
