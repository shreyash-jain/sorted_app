import 'dart:convert';

import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  int id;
  int numTodoItems;
  String title;
  String description;
  DateTime savedTs;
  TodoModel({
    this.id = 0,
    this.numTodoItems = 0,
    this.title = '',
    this.description = '',
    this.savedTs,
  });
  

  TodoModel copyWith({
    int id,
    int numTodoItems,
    String title,
    String description,
    DateTime savedTs,
  }) {
    return TodoModel(
      id: id ?? this.id,
      numTodoItems: numTodoItems ?? this.numTodoItems,
      title: title ?? this.title,
      description: description ?? this.description,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numTodoItems': numTodoItems,
      'title': title,
      'description': description,
      'savedTs': savedTs?.millisecondsSinceEpoch,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) => TodoModel.fromMap(json.decode(source));

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
    ];
  }
}
