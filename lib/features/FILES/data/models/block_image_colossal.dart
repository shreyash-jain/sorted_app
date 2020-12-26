import 'dart:convert';

import 'package:equatable/equatable.dart';

class ColossalBlock extends Equatable {
  int id;
  int savedTs;
  int decoration;
  String title;
  int numImages;
  ColossalBlock({
    this.id = 0,
    this.savedTs = 0,
    this.decoration = 0,
    this.title = '',
    this.numImages = 0,
  });

  ColossalBlock copyWith({
    int id,
    int savedTs,
    int decoration,
    String title,
    int numImages,
  }) {
    return ColossalBlock(
      id: id ?? this.id,
      savedTs: savedTs ?? this.savedTs,
      decoration: decoration ?? this.decoration,
      title: title ?? this.title,
      numImages: numImages ?? this.numImages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savedTs': savedTs,
      'decoration': decoration,
      'title': title,
      'numImages': numImages,
    };
  }

  factory ColossalBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ColossalBlock(
      id: map['id'],
      savedTs: map['savedTs'],
      decoration: map['decoration'],
      title: map['title'],
      numImages: map['numImages'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockColossal";

  factory ColossalBlock.fromJson(String source) =>
      ColossalBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      savedTs,
      decoration,
      title,
      numImages,
    ];
  }
}
