import 'dart:convert';

import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  int id;
  int numTodoItems;
  String title;
  String description;
  DateTime savedTs;
  int position;
  String unit;
  int type;
  int operation;
  int searchId;
  TodoModel({
    this.id = 0,
    this.numTodoItems = 0,
    this.title = '',
    this.description = '',
    this.savedTs,
    this.position = 0,
    this.unit = '',
    this.type = 0,
    this.operation = 0,
    this.searchId = 0,
  });

  TodoModel copyWith({
    int id,
    int numTodoItems,
    String title,
    String description,
    DateTime savedTs,
    int position,
    String unit,
    int type,
    int operation,
    int searchId,
  }) {
    return TodoModel(
      id: id ?? this.id,
      numTodoItems: numTodoItems ?? this.numTodoItems,
      title: title ?? this.title,
      description: description ?? this.description,
      savedTs: savedTs ?? this.savedTs,
      position: position ?? this.position,
      unit: unit ?? this.unit,
      type: type ?? this.type,
      operation: operation ?? this.operation,
      searchId: searchId ?? this.searchId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numTodoItems': numTodoItems,
      'title': title,
      'description': description,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'position': position,
      'unit': unit,
      'type': type,
      'operation': operation,
      'searchId': searchId,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TodoModel(
      id: map['id'],
      numTodoItems: map['numTodoItems'],
      title: map['title'],
      description: map['description'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
      position: map['position'],
      unit: map['unit'],
      type: map['type'],
      operation: map['operation'],
      searchId: map['searchId'],
    );
  }

  String toJson() => json.encode(toMap());
  String getItemsTable() => "Todos_TodoItems";
  String getTable() => "Todos";

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      numTodoItems,
      title,
      description,
      savedTs,
      position,
      unit,
      type,
      operation,
      searchId,
    ];
  }
}
