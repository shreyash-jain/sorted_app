import 'dart:convert';

import 'package:equatable/equatable.dart';

class TaskStatusModel extends Equatable {
  int id;
  String status;
  DateTime savedTs;
  String imagePath;
  int canDelete;
  int numItems;
  TaskStatusModel({
    this.id = 0,
    this.status = '',
    this.savedTs,
    this.imagePath = '',
    this.canDelete = 1,
    this.numItems = 0,
  });

  TaskStatusModel copyWith({
    int id,
    String status,
    DateTime savedTs,
    String imagePath,
    int canDelete,
    int numItems,
  }) {
    return TaskStatusModel(
      id: id ?? this.id,
      status: status ?? this.status,
      savedTs: savedTs ?? this.savedTs,
      imagePath: imagePath ?? this.imagePath,
      canDelete: canDelete ?? this.canDelete,
      numItems: numItems ?? this.numItems,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'canDelete': canDelete,
      'numItems': numItems,
    };
  }

  factory TaskStatusModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TaskStatusModel(
      id: map['id'],
      status: map['status'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
      imagePath: map['imagePath'],
      canDelete: map['canDelete'],
      numItems: map['numItems'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskStatusModel.fromJson(String source) =>
      TaskStatusModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  String getTable() => "TaskStatus";

  @override
  List<Object> get props {
    return [
      id,
      status,
      savedTs,
      imagePath,
      canDelete,
      numItems,
    ];
  }
}
