import 'dart:convert';

import 'package:equatable/equatable.dart';

class LogModel extends Equatable {
  int id;
  String message;
  DateTime date;
  DateTime savedTs;
  int type;
  int connectedId;
  int level;
  String path;
  LogModel({
    this.id = 0,
    this.message = '',
    this.date,
    this.savedTs,
    this.type = 0,
    this.connectedId = 0,
    this.level = 0,
    this.path = '',
  });


  LogModel copyWith({
    int id,
    String message,
    DateTime date,
    DateTime savedTs,
    int type,
    int connectedId,
    int level,
    String path,
  }) {
    return LogModel(
      id: id ?? this.id,
      message: message ?? this.message,
      date: date ?? this.date,
      savedTs: savedTs ?? this.savedTs,
      type: type ?? this.type,
      connectedId: connectedId ?? this.connectedId,
      level: level ?? this.level,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'date': date?.millisecondsSinceEpoch,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'type': type,
      'connectedId': connectedId,
      'level': level,
      'path': path,
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return LogModel(
      id: map['id'],
      message: map['message'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
      type: map['type'],
      connectedId: map['connectedId'],
      level: map['level'],
      path: map['path'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LogModel.fromJson(String source) => LogModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
  String getTable() => "Logs";

  @override
  List<Object> get props {
    return [
      id,
      message,
      date,
      savedTs,
      type,
      connectedId,
      level,
      path,
    ];
  }
}
