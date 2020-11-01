import 'dart:convert';

import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  int id;
  int numTodoItems;
  String title;
  String description;
  DateTime savedTs;
  int position;
  TodoModel({
    this.id = 0,
    this.numTodoItems = 0,
    this.title = '',
    this.description = '',
    this.savedTs,
    this.position = 0,
  });
  

  TodoModel copyWith({
    int id,
    int numTodoItems,
    String title,
    String description,
    DateTime savedTs,
    int position,
  }) {
    return TodoModel(
      id: id ?? this.id,
      numTodoItems: numTodoItems ?? this.numTodoItems,
      title: title ?? this.title,
      description: description ?? this.description,
      savedTs: savedTs ?? this.savedTs,
      position: position ?? this.position,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) => TodoModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
  String getTable() => "Todos";
  String getItemsTable() => "Todos_TodoItems";

  @override
  List<Object> get props {
    return [
      id,
      numTodoItems,
      title,
      description,
      savedTs,
      position,
    ];
  }
}
