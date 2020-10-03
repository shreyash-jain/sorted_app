import 'dart:convert';

import 'package:equatable/equatable.dart';

class TaskStatusModel extends Equatable {
  int id;
  String status;
  DateTime savedTs;
  String imagePath;
  
  TaskStatusModel({
    this.id = 0,
    this.status = '',
    this.savedTs,
    this.imagePath = '',
  });

  TaskStatusModel copyWith({
    int id,
    String status,
    DateTime savedTs,
    String imagePath,
  }) {
    return TaskStatusModel(
      id: id ?? this.id,
      status: status ?? this.status,
      savedTs: savedTs ?? this.savedTs,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'imagePath': imagePath,
    };
  }

  factory TaskStatusModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TaskStatusModel(
      id: map['id'],
      status: map['status'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
      imagePath: map['imagePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskStatusModel.fromJson(String source) => TaskStatusModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, status, savedTs, imagePath];
}
