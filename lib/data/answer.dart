import 'dart:math';


class AnswerModel {
  int id, q_id;
  double a_rating;
  String content,discription;
  int res1, res2, res3;
  DateTime date;
  int date_id;
  String c_summary;
  String c_keywords;
  double p_rating;
  int p_ans;
  DateTime saved_ts;
  AnswerModel(
      {this.id,
      this.q_id,
      this.a_rating,
      this.content,
        this.date_id,
        this.discription,
      this.res1,
        this.c_summary,
        this.c_keywords,
        this.p_ans,
        this.p_rating,
        this.saved_ts,
      this.res2,
      this.res3,
      this.date});

  AnswerModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.a_rating = map['a_rating'];
    this.date = DateTime.parse(map['date']);
    this.q_id = map['q_id'];
    this.content = map['content'];
    this.res1 = map['response1'];
    this.date_id=map['date_id'];
    this.res2 = map['response2'];
    this.p_rating=map['p_rating'];
    this.p_ans=map['p_ans'];
    this.c_keywords=map['c_keywords'];
    this.c_summary=map['c_summary'];
    this.res3 = map['response3'];
    this.discription=map['discription'];
    this.saved_ts =DateTime.parse(map['saved_ts']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'q_id': this.q_id,
      'content': this.content,
      'date': this.date.toIso8601String(),
      'date_id':this.date_id,
      'a_rating': this.a_rating,
      'response1': this.res1,
      'response2': this.res2,
      'response3': this.res3,
      'discription':this.discription,
      'saved_ts':this.saved_ts.toIso8601String(),
      'c_summary':this.c_summary,
      'c_keywords':this.c_keywords,
      'p_rating':this.p_rating,
      'p_ans':this.p_ans,

    };
  }

  AnswerModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
  }
}
