import 'dart:math';


class QuestionModel {
  int id;
  String title;
  int num_ans;
  int interval, type;
  String ans1, ans2, ans3;
  int archive;
  int correct_ans;
  int priority;

  QuestionModel(
      {this.id,
      this.title,
      this.type,
        this.priority,
        this.archive,
        this.correct_ans,
      this.num_ans,
      this.ans1,
      this.ans2,
      this.ans3,
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
    this.archive=map['archive'];
    this.priority=map['priority'];
    this.correct_ans=map['correct_ans'];
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
    'archive':this.archive,
    'priority':this.priority,
    'correct_ans':this.correct_ans,
    };
  }

  QuestionModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
    this.title = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
  }
}
