import 'dart:ffi';
import 'dart:math';

class ReventModel {
  int id;
  DateTime end_date;
  DateTime start_date;
  int event_id;
  int sun,mon,tue,wed,thu,fri,sat;

  ReventModel(
      {this.id,

        this.end_date,
        this.event_id,
        this.start_date,
        this.sun,
        this.mon,
        this.tue,
        this.wed,
        this.thu,
        this.fri,
        this.sat,
      });

  ReventModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.event_id = map['event_id'];

    this.start_date = DateTime.parse(map['start_date']);
    this.end_date = DateTime.parse(map['end_date']);
    this.sun=map['sun'];
    this.mon=map['mon'];
    this.tue=map['tue'];
    this.wed=map['wed'];
    this.thu=map['thu'];
    this.fri=map['fri'];
    this.sat=map['sat'];


  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,

      'event_id': this.event_id,

      'start_date': this.start_date.toIso8601String(),
      'end_date': this.end_date.toIso8601String(),
      'sun':this.sun,
      'mon':this.mon,
      'tue':this.tue,
      'wed':this.wed,
      'thu':this.thu,
      'fri':this.fri,
      'sat':this.sat,
    };
  }


}
