import 'dart:math';

class ActivityModel {
  int id;
  String name;
  String image;


  int weight;

  ActivityModel(
      {this.id,
        this.name,
        this.image,

        this.weight});

  ActivityModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.weight = map['weight'];
    this.name = map['name'];
    this.image = map['image'];

  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'weight': this.weight

    };
  }


}
