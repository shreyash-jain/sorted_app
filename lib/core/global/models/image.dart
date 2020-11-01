import 'dart:convert';

import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  int id;
  String caption;
  String url;
  String localPath;
  DateTime savedTs;
  int canDetete;
  int position;
  String storagePath;
  ImageModel({
    this.id = 0,
    this.caption = '',
    this.url = '',
    this.localPath = '',
    this.savedTs,
    this.canDetete = 0,
    this.position = 0,
    this.storagePath = '',
  });

  ImageModel copyWith({
    int id,
    String caption,
    String url,
    String localPath,
    DateTime savedTs,
    int canDetete,
    int position,
    String storagePath,
  }) {
    return ImageModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      savedTs: savedTs ?? this.savedTs,
      canDetete: canDetete ?? this.canDetete,
      position: position ?? this.position,
      storagePath: storagePath ?? this.storagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caption': caption,
      'url': url,
      'localPath': localPath,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'canDetete': canDetete,
      'position': position,
      'storagePath': storagePath,
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
      canDetete: map['canDetete'],
      position: map['position'],
      storagePath: map['storagePath'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "Images";

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
      canDetete,
      position,
      storagePath,
    ];
  }
}
