import 'dart:convert';

import 'package:equatable/equatable.dart';

class HeadingBlock extends Equatable {
  String heading;
  int id;
  int decoration;
  int savedTs;
  HeadingBlock({
    this.heading = '',
    this.id = 0,
    this.decoration = 0,
    this.savedTs = 0,
  });

  HeadingBlock copyWith({
    String heading,
    int id,
    int decoration,
    int savedTs,
  }) {
    return HeadingBlock(
      heading: heading ?? this.heading,
      id: id ?? this.id,
      decoration: decoration ?? this.decoration,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'heading': heading,
      'id': id,
      'decoration': decoration,
      'savedTs': savedTs,
    };
  }

  factory HeadingBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return HeadingBlock(
      heading: map['heading'],
      id: map['id'],
      decoration: map['decoration'],
      savedTs: map['savedTs'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HeadingBlock.fromJson(String source) => HeadingBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [heading, id, decoration, savedTs];
}
