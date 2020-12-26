import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';

class TodoItemModel extends Equatable {
  int id;
  String todoItem;
  String description;
  int state;
  int todolistId;
  int position;
  DateTime savedTs;
  double value;
  String url;
  String unit;
  TodoItemModel({
    this.id = 0,
    this.todoItem = '',
    this.description = '',
    this.state = 0,
    this.todolistId = 0,
    this.position = 0,
    this.savedTs,
    this.value = 0.0,
    this.url = '',
    this.unit = 'Unit',
  });

  String getTable() => "TodoItems";
  TodoItemModel copyWith({
    int id,
    String todoItem,
    String description,
    int state,
    int todolistId,
    int position,
    DateTime savedTs,
    double value,
    String url,
    String unit,
  }) {
    return TodoItemModel(
      id: id ?? this.id,
      todoItem: todoItem ?? this.todoItem,
      description: description ?? this.description,
      state: state ?? this.state,
      todolistId: todolistId ?? this.todolistId,
      position: position ?? this.position,
      savedTs: savedTs ?? this.savedTs,
      value: value ?? this.value,
      url: url ?? this.url,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoItem': todoItem,
      'description': description,
      'state': state,
      'todolistId': todolistId,
      'position': position,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'value': value,
      'url': url,
      'unit': unit,
    };
  }

  factory TodoItemModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TodoItemModel(
      id: map['id'],
      todoItem: map['todoItem'],
      description: map['description'],
      state: map['state'],
      todolistId: map['todolistId'],
      position: map['position'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
      value: map['value'],
      url: map['url'],
      unit: map['unit'],
    );
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
      todolistId,
      position,
      savedTs,
      value,
      url,
      unit,
    ];
  }
}
