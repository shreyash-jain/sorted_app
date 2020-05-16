import 'dart:math';

class CatModel {
  int id;
  String name;
  String image;
  DateTime saved_ts;


  double total;

  CatModel(
      {this.id,
        this.name,
        this.image,
        this.saved_ts,

        this.total});

  CatModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.total = map['total'];
    this.name = map['name'];
    this.image = map['image'];
    this.saved_ts =DateTime.parse(map['saved_ts']);

  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'total': this.total,
      'saved_ts':this.saved_ts.toIso8601String()

    };
  }


}
