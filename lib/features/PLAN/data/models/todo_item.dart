import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';

class TodoItemModel extends Equatable {
  int id;
  String todoItem;
  String description;
  int state;
  int position;
  DateTime savedTs;
  TodoItemModel({
    this.id = 0,
    this.todoItem = '',
    this.description = '',
    this.state = 0,
    this.position = 0,
    this.savedTs,
  });

  TodoItemModel copyWith({
    int id,
    String todoItem,
    String description,
    int state,
    int position,
    DateTime savedTs,
  }) {
    return TodoItemModel(
      id: id ?? this.id,
      todoItem: todoItem ?? this.todoItem,
      description: description ?? this.description,
      state: state ?? this.state,
      position: position ?? this.position,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoItem': todoItem,
      'description': description,
      'state': state,
      'position': position,
      'savedTs': savedTs?.millisecondsSinceEpoch,
    };
  }

  factory TodoItemModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TodoItemModel(
      id: map['id'],
      todoItem: map['todoItem'],
      description: map['description'],
      state: map['state'],
      position: map['position'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
    );
  }
  factory TodoItemModel.makeRandom() {
    DateTime now = DateTime.now();

    return TodoItemModel(
        id: now.millisecondsSinceEpoch,
        todoItem: faker.lorem.sentence(),
        description: "",
        state: 0,
        savedTs: now,
        position: 0);
  }

  String toJson() => json.encode(toMap());

  factory TodoItemModel.fromJson(String source) =>
      TodoItemModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      todoItem,
      description,
      state,
      position,
      savedTs,
    ];
  }
}
