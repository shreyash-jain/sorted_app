import 'dart:convert';

import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  int id;
  String caption;
  String url;
  String localPath;
  DateTime savedTs;
  ImageModel({
    this.id = 0,
    this.caption = '',
    this.url = '',
    this.localPath = '',
    this.savedTs,
  });

  ImageModel copyWith({
    int id,
    String caption,
    String url,
    String localPath,
    DateTime savedTs,
  }) {
    return ImageModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caption': caption,
      'url': url,
      'localPath': localPath,
      'savedTs': savedTs?.millisecondsSinceEpoch,
    };
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ImageModel(
      id: map['id'],
      caption: map['caption'],
      url: map['url'],
      localPath: map['localPath'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageModel.fromJson(String source) => ImageModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      caption,
      url,
      localPath,
      savedTs,
    ];
  }
}
