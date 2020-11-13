import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TextboxBlock extends Equatable {
  int id;
  int color1;
  int color2;
  int decoration;
  String title;
  String text;
  int isRich;
  int iconData;
  String imagePath;
  int savedTs;
  TextboxBlock({
    this.id = 0,
    this.color1 = 0,
    this.color2 = 0,
    this.decoration = 0,
    this.title = '',
    this.text =
        '[{"insert":"Hey"},{"insert":"\\n","attributes":{"heading":3}},{"insert":"Lets start "},{"insert":"writing...","attributes":{"b":true}},{"insert":"\\n\\n\\n\\n"}]',
    this.isRich = 0,
    this.iconData = 0,
    this.imagePath: 'https://picsum.photos/800/500',
    this.savedTs = 0,
  });

  TextboxBlock copyWith({
    int id,
    int color1,
    int color2,
    int decoration,
    String title,
    String text,
    int isRich,
    int iconData,
    String imagePath,
    int savedTs,
  }) {
    return TextboxBlock(
      id: id ?? this.id,
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      decoration: decoration ?? this.decoration,
      title: title ?? this.title,
      text: text ?? this.text,
      isRich: isRich ?? this.isRich,
      iconData: iconData ?? this.iconData,
      imagePath: imagePath ?? this.imagePath,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color1': color1,
      'color2': color2,
      'decoration': decoration,
      'title': title,
      'text': text,
      'isRich': isRich,
      'iconData': iconData,
      'imagePath': imagePath,
      'savedTs': savedTs,
    };
  }

  factory TextboxBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TextboxBlock(
      id: map['id'],
      color1: map['color1'],
      color2: map['color2'],
      decoration: map['decoration'],
      title: map['title'],
      text: map['text'],
      isRich: map['isRich'],
      iconData: map['iconData'],
      imagePath: map['imagePath'],
      savedTs: map['savedTs'],
    );
  }

  factory TextboxBlock.startTextbox(int id, String title) {
    return TextboxBlock(
      id: id,
      color1: Colors.deepPurple.value,
      color2: Colors.deepPurpleAccent.value,
      decoration: 0,
      title: title,
      text:
          '[{"insert":"Hey"},{"insert":"\\n","attributes":{"heading":3}},{"insert":"Lets start "},{"insert":"writing...","attributes":{"b":true}},{"insert":"\\n\\n\\n\\n"}]',
      isRich: 0,
      iconData: Icons.note.codePoint,
      imagePath: 'https://picsum.photos/800/500',
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockTextbox";

  factory TextboxBlock.fromJson(String source) =>
      TextboxBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      color1,
      color2,
      decoration,
      title,
      text,
      isRich,
      iconData,
      imagePath,
      savedTs,
    ];
  }
}
