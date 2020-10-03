import 'dart:convert';

import 'package:equatable/equatable.dart';

class AudioModel extends Equatable {
  int id;
  String url;
  String title;
  String description;
  DateTime savedTs;
  double length;
  AudioModel({
    this.id = 0,
    this.url = '',
    this.title = '',
    this.description = '',
    this.savedTs,
    this.length = 0.0,
  });
  

  AudioModel copyWith({
    int id,
    String url,
    String title,
    String description,
    DateTime savedTs,
    double length,
  }) {
    return AudioModel(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      savedTs: savedTs ?? this.savedTs,
      length: length ?? this.length,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'description': description,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'length': length,
    };
  }

  factory AudioModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AudioModel(
      id: map['id'],
      url: map['url'],
      title: map['title'],
      description: map['description'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
      length: map['length'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioModel.fromJson(String source) => AudioModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      url,
      title,
      description,
      savedTs,
      length,
    ];
  }
}
