import 'dart:convert';

import 'package:equatable/equatable.dart';

class TableBlock extends Equatable {
  int id;
  int savedTs;
  int rows;
  int cols;
  String title;
  int decoration;
  TableBlock({
    this.id = 0,
    this.savedTs = 0,
    this.rows = 0,
    this.cols = 0,
    this.title = '',
    this.decoration = 0,
  });

  TableBlock copyWith({
    int id,
    int savedTs,
    int rows,
    int cols,
    String title,
    int decoration,
  }) {
    return TableBlock(
      id: id ?? this.id,
      savedTs: savedTs ?? this.savedTs,
      rows: rows ?? this.rows,
      cols: cols ?? this.cols,
      title: title ?? this.title,
      decoration: decoration ?? this.decoration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savedTs': savedTs,
      'rows': rows,
      'cols': cols,
      'title': title,
      'decoration': decoration,
    };
  }

  factory TableBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TableBlock(
      id: map['id'],
      savedTs: map['savedTs'],
      rows: map['rows'],
      cols: map['cols'],
      title: map['title'],
      decoration: map['decoration'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockTable";

  factory TableBlock.fromJson(String source) =>
      TableBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      savedTs,
      rows,
      cols,
      title,
      decoration,
    ];
  }
}
