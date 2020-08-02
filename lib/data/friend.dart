import 'dart:math';

class FriendModel {
  int id;
  String name;


  DateTime saved_ts;
  double total;

  FriendModel(
      {this.id,
        this.name,
        this.saved_ts,
        this.total});

  FriendModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.total = map['total'];
    this.name = map['name'];
    this.saved_ts =DateTime.parse(map['saved_ts']);

  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,

      'total': this.total,
      'saved_ts':this.saved_ts.toIso8601String()

    };
  }


}
