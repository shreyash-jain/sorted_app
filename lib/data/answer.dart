import 'dart:math';


class AnswerModel {
  int id, q_id, streak;
  String content,discription;
  int res1, res2, res3;
  DateTime date;

  AnswerModel(
      {this.id,
      this.q_id,
      this.streak,
      this.content,
        this.discription,
      this.res1,
      this.res2,
      this.res3,
      this.date});

  AnswerModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.streak = map['streak'];
    this.date = DateTime.parse(map['date']);
    this.q_id = map['q_id'];
    this.content = map['content'];
    this.res1 = map['response1'];
    this.res2 = map['response2'];
    this.res3 = map['response3'];
    this.discription=map['discription'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'q_id': this.q_id,
      'content': this.content,
      'date': this.date.toIso8601String(),
      'streak': this.streak,
      'response1': this.res1,
      'response2': this.res2,
      'response3': this.res3,
      'discription':this.discription
    };
  }

  AnswerModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
  }
}
