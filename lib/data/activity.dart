import 'dart:math';

class ActivityModel {
  int id;
  String name;
  String image;
  DateTime saved_ts;


  int weight;

  ActivityModel(
      {this.id,
        this.name,
        this.image,
        this.saved_ts,

        this.weight});

  ActivityModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.weight = map['weight'];
    this.name = map['name'];
    this.image = map['image'];
    this.saved_ts =DateTime.parse(map['saved_ts']);

  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'weight': this.weight,
      'saved_ts':this.saved_ts.toIso8601String()

    };
  }


}
