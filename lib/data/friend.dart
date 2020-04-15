import 'dart:math';

class FriendModel {
  int id;
  String name;



  double total;

  FriendModel(
      {this.id,
        this.name,

        this.total});

  FriendModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.total = map['total'];
    this.name = map['name'];


  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,

      'total': this.total

    };
  }


}
