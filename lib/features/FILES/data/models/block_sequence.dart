import 'dart:convert';

import 'package:equatable/equatable.dart';

class SequenceBlock extends Equatable {
  int id;
  int savedTs;
  String title;
  int date;
  String content;
  int decoration;
  SequenceBlock({
    this.id = 0,
    this.savedTs = 0,
    this.title = '',
    this.date = 0,
    this.content = '',
    this.decoration = 0,
  });

  SequenceBlock copyWith({
    int id,
    int savedTs,
    String title,
    int date,
    String content,
    int decoration,
  }) {
    return SequenceBlock(
      id: id ?? this.id,
      savedTs: savedTs ?? this.savedTs,
      title: title ?? this.title,
      date: date ?? this.date,
      content: content ?? this.content,
      decoration: decoration ?? this.decoration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savedTs': savedTs,
      'title': title,
      'date': date,
      'content': content,
      'decoration': decoration,
    };
  }

  factory SequenceBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SequenceBlock(
      id: map['id'],
      savedTs: map['savedTs'],
      title: map['title'],
      date: map['date'],
      content: map['content'],
      decoration: map['decoration'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockSequence";
  factory SequenceBlock.fromJson(String source) =>
      SequenceBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      savedTs,
      title,
      date,
      content,
      decoration,
    ];
  }
}
