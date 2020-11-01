import 'dart:convert';

import 'package:equatable/equatable.dart';

class AttachmentModel extends Equatable {
  int id;
  String url;
  String title;
  int type;
  String typeString;
  String localPath;
  String storagePath;
  int canDetete;
  String description;
  DateTime savedTs;
  double length;
  int position;
  AttachmentModel({
    this.id = 0,
    this.url = '',
    this.title = '',
    this.type = 0,
    this.typeString = '',
    this.localPath = '',
    this.storagePath = '',
    this.canDetete = 0,
    this.description = '',
    this.savedTs,
    this.length = 0.0,
    this.position = 0,
  });
  

  AttachmentModel copyWith({
    int id,
    String url,
    String title,
    int type,
    String typeString,
    String localPath,
    String storagePath,
    int canDetete,
    String description,
    DateTime savedTs,
    double length,
    int position,
  }) {
    return AttachmentModel(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      type: type ?? this.type,
      typeString: typeString ?? this.typeString,
      localPath: localPath ?? this.localPath,
      storagePath: storagePath ?? this.storagePath,
      canDetete: canDetete ?? this.canDetete,
      description: description ?? this.description,
      savedTs: savedTs ?? this.savedTs,
      length: length ?? this.length,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'type': type,
      'typeString': typeString,
      'localPath': localPath,
      'storagePath': storagePath,
      'canDetete': canDetete,
      'description': description,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'length': length,
      'position': position,
    };
  }

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AttachmentModel(
      id: map['id'],
      url: map['url'],
      title: map['title'],
      type: map['type'],
      typeString: map['typeString'],
      localPath: map['localPath'],
      storagePath: map['storagePath'],
      canDetete: map['canDetete'],
      description: map['description'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
      length: map['length'],
      position: map['position'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AttachmentModel.fromJson(String source) => AttachmentModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
  String getTable() => "Attachments";

  @override
  List<Object> get props {
    return [
      id,
      url,
      title,
      type,
      typeString,
      localPath,
      storagePath,
      canDetete,
      description,
      savedTs,
      length,
      position,
    ];
  }
}
