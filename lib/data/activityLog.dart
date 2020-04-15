import 'dart:math';

class AlogModel {
  int id;

  DateTime date;
  int a_id;
  int duration;

  AlogModel(
      {this.id,
       this.duration,
        this.date,
        this.a_id});

  AlogModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.a_id = map['a_id'];
    this.duration=map['duration'];
    this.date = DateTime.parse(map['date']);

  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
     'duration':this.duration,
      'a_id': this.a_id,

      'date': this.date.toIso8601String()
    };
  }


}
