import 'dart:math';

class CatModel {
  int id;
  String name;
  String image;


  double total;

  CatModel(
      {this.id,
        this.name,
        this.image,

        this.total});

  CatModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.total = map['total'];
    this.name = map['name'];
    this.image = map['image'];

  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'total': this.total

    };
  }


}
