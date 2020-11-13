import 'dart:convert';

import 'package:equatable/equatable.dart';

class BlockInfo extends Equatable {
  int type;
  double height;
  int id;
  int itemId;
  int position;
  int savedTs;
  BlockInfo({
    this.type = 0,
    this.height = 0.0,
    this.id = 0,
    this.itemId = 0,
    this.position = 0,
    this.savedTs = 0,
  });
  

  BlockInfo copyWith({
    int type,
    double height,
    int id,
    int itemId,
    int position,
    int savedTs,
  }) {
    return BlockInfo(
      type: type ?? this.type,
      height: height ?? this.height,
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      position: position ?? this.position,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'height': height,
      'id': id,
      'itemId': itemId,
      'position': position,
      'savedTs': savedTs,
    };
  }

  factory BlockInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return BlockInfo(
      type: map['type'],
      height: map['height'],
      id: map['id'],
      itemId: map['itemId'],
      position: map['position'],
      savedTs: map['savedTs'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockInfo";

  factory BlockInfo.fromJson(String source) => BlockInfo.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      type,
      height,
      id,
      itemId,
      position,
      savedTs,
    ];
  }
}
