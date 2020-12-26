import 'dart:convert';

import 'package:equatable/equatable.dart';

class ColumnBlock extends Equatable {
  int id;
  int tableId;
  int savedTs;
  int type;
  int position;
  double width;
  String color;
  String title;
  int isFirstCol;
  int isLastCol;
  ColumnBlock({
    this.id = 0,
    this.tableId = 0,
    this.savedTs = 0,
    this.type = 0,
    this.position = 0,
    this.width = 0.0,
    this.color = '',
    this.title = '',
    this.isFirstCol = 0,
    this.isLastCol = 0,
  });

  ColumnBlock copyWith({
    int id,
    int tableId,
    int savedTs,
    int type,
    int position,
    double width,
    String color,
    String title,
    int isFirstCol,
    int isLastCol,
  }) {
    return ColumnBlock(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      savedTs: savedTs ?? this.savedTs,
      type: type ?? this.type,
      position: position ?? this.position,
      width: width ?? this.width,
      color: color ?? this.color,
      title: title ?? this.title,
      isFirstCol: isFirstCol ?? this.isFirstCol,
      isLastCol: isLastCol ?? this.isLastCol,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableId': tableId,
      'savedTs': savedTs,
      'type': type,
      'position': position,
      'width': width,
      'color': color,
      'title': title,
      'isFirstCol': isFirstCol,
      'isLastCol': isLastCol,
    };
  }

  factory ColumnBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ColumnBlock(
      id: map['id'],
      tableId: map['tableId'],
      savedTs: map['savedTs'],
      type: map['type'],
      position: map['position'],
      width: map['width'],
      color: map['color'],
      title: map['title'],
      isFirstCol: map['isFirstCol'],
      isLastCol: map['isLastCol'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockColumn";

  factory ColumnBlock.fromJson(String source) =>
      ColumnBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      tableId,
      savedTs,
      type,
      position,
      width,
      color,
      title,
      isFirstCol,
      isLastCol,
    ];
  }
}
