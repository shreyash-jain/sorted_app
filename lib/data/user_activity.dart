import 'dart:math';

class UserAModel {
  int id;
  String name;
  String image;
  DateTime saved_ts;

  int a_id;

  UserAModel(
      {this.id,
        this.name,
        this.image,
       this.saved_ts,
        this.a_id});

  UserAModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.a_id = map['a_id'];
    this.name = map['name'];
    this.image = map['image'];
    this.saved_ts =DateTime.parse(map['saved_ts']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'a_id': this.a_id,
      'saved_ts':this.saved_ts.toIso8601String()
    };
  }


}
