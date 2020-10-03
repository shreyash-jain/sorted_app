import 'dart:convert';

import 'package:equatable/equatable.dart';

class LinkModel extends Equatable {
  int id;
  String url;
  String title;
  String description;
  String image;
  String siteName;
  DateTime savedTs;
  LinkModel({
    this.id = 0,
    this.url = '',
    this.title = '',
    this.description = '',
    this.image = '',
    this.siteName = '',
    this.savedTs,
  });

  LinkModel copyWith({
    int id,
    String url,
    String title,
    String description,
    String image,
    String siteName,
    DateTime savedTs,
  }) {
    return LinkModel(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      siteName: siteName ?? this.siteName,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'description': description,
      'image': image,
      'siteName': siteName,
      'savedTs': savedTs?.millisecondsSinceEpoch,
    };
  }

  factory LinkModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return LinkModel(
      id: map['id'],
      url: map['url'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
      siteName: map['siteName'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LinkModel.fromJson(String source) => LinkModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      url,
      title,
      description,
      image,
      siteName,
      savedTs,
    ];
  }
}