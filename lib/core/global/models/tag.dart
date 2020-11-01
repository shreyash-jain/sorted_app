import 'dart:convert';

import 'package:equatable/equatable.dart';

class TagModel extends Equatable {
  int id;
  String tag;
  String url;
  String color;
  int items;
  DateTime savedTs;
  TagModel({
    this.id = 0,
    this.tag = '',
    this.url = '',
    this.color = '',
    this.items = 0,
    this.savedTs,
  });

  TagModel copyWith({
    int id,
    String tag,
    String url,
    String color,
    int items,
    DateTime savedTs,
  }) {
    return TagModel(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      url: url ?? this.url,
      color: color ?? this.color,
      items: items ?? this.items,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tag': tag,
      'url': url,
      'color': color,
      'items': items,
      'savedTs': savedTs?.millisecondsSinceEpoch,
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TagModel(
      id: map['id'],
      tag: map['tag'],
      url: map['url'],
      color: map['color'],
      items: map['items'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "Tags";

  factory TagModel.fromJson(String source) => TagModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      tag,
      url,
      color,
      items,
      savedTs,
    ];
  }
}
