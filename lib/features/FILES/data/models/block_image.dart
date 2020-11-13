import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ImageBlock extends Equatable {
  int id;
  int color1;
  int color2;
  int decoration;
  String title;
  int colossalId;
  String caption;
  String url;
  String remotePath;
  int iconData;
  String imagePath;
  int savedTs;
  ImageBlock({
    this.id = 0,
    this.color1 = 0,
    this.color2 = 0,
    this.decoration = 0,
    this.title = '',
    this.colossalId = 0,
    this.caption = '',
    this.url = '',
    this.remotePath = '',
    this.iconData = 0,
    this.imagePath = '',
    this.savedTs = 0,
  });

  ImageBlock copyWith({
    int id,
    int color1,
    int color2,
    int decoration,
    String title,
    int colossalId,
    String caption,
    String url,
    String remotePath,
    int iconData,
    String imagePath,
    int savedTs,
  }) {
    return ImageBlock(
      id: id ?? this.id,
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      decoration: decoration ?? this.decoration,
      title: title ?? this.title,
      colossalId: colossalId ?? this.colossalId,
      caption: caption ?? this.caption,
      url: url ?? this.url,
      remotePath: remotePath ?? this.remotePath,
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
      'colossalId': colossalId,
      'caption': caption,
      'url': url,
      'remotePath': remotePath,
      'iconData': iconData,
      'imagePath': imagePath,
      'savedTs': savedTs,
    };
  }

  factory ImageBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ImageBlock(
      id: map['id'],
      color1: map['color1'],
      color2: map['color2'],
      decoration: map['decoration'],
      title: map['title'],
      colossalId: map['colossalId'],
      caption: map['caption'],
      url: map['url'],
      remotePath: map['remotePath'],
      iconData: map['iconData'],
      imagePath: map['imagePath'],
      savedTs: map['savedTs'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockImage";

  factory ImageBlock.fromJson(String source) =>
      ImageBlock.fromMap(json.decode(source));

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
      colossalId,
      caption,
      url,
      remotePath,
      iconData,
      imagePath,
      savedTs,
    ];
  }
}
