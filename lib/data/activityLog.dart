import 'dart:math';

class AlogModel {
  int id;

  DateTime date;
  int a_id;
  int duration;
  DateTime saved_ts;
  AlogModel(
      {this.id,
       this.duration,
        this.saved_ts,
        this.date,
        this.a_id});

  AlogModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.a_id = map['a_id'];
    this.duration=map['duration'];
    this.date = DateTime.parse(map['date']);
    this.saved_ts =DateTime.parse(map['saved_ts']);

  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
     'duration':this.duration,
      'a_id': this.a_id,
      'saved_ts':this.saved_ts.toIso8601String(),
      'date': this.date.toIso8601String()
    };
  }


}
