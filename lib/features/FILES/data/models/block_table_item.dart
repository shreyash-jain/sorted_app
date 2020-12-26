import 'dart:convert';

import 'package:equatable/equatable.dart';

class TableItemBlock extends Equatable {
  int id;
  int savedTs;
  int type;
  String value;
  String color;
  int colId;
  int align;
  TableItemBlock({
    this.id = 0,
    this.savedTs = 0,
    this.type = 0,
    this.value = '',
    this.color = '',
    this.colId = 0,
    this.align = 0,
  });

  TableItemBlock copyWith({
    int id,
    int savedTs,
    int type,
    String value,
    String color,
    int colId,
    int align,
  }) {
    return TableItemBlock(
      id: id ?? this.id,
      savedTs: savedTs ?? this.savedTs,
      type: type ?? this.type,
      value: value ?? this.value,
      color: color ?? this.color,
      colId: colId ?? this.colId,
      align: align ?? this.align,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savedTs': savedTs,
      'type': type,
      'value': value,
      'color': color,
      'colId': colId,
      'align': align,
    };
  }

  factory TableItemBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TableItemBlock(
      id: map['id'],
      savedTs: map['savedTs'],
      type: map['type'],
      value: map['value'],
      color: map['color'],
      colId: map['colId'],
      align: map['align'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockTableItem";

  factory TableItemBlock.fromJson(String source) =>
      TableItemBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      savedTs,
      type,
      value,
      color,
      colId,
      align,
    ];
  }
}
