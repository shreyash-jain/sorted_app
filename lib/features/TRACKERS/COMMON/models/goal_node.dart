import 'dart:convert';

import 'package:equatable/equatable.dart';

class GoalNode extends Equatable {
  String key;
  String value;
  int key_type;
  GoalNode({
    this.key = '',
    this.value = '',
    this.key_type = 0,
  });

  GoalNode copyWith({
    String key,
    String value,
    int key_type,
  }) {
    return GoalNode(
      key: key ?? this.key,
      value: value ?? this.value,
      key_type: key_type ?? this.key_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'key_type': key_type,
    };
  }

  factory GoalNode.fromMap(Map<String, dynamic> map) {
    return GoalNode(
      key: map['key'] ?? '',
      value: map['value'] ?? '',
      key_type: map['key_type'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalNode.fromJson(String source) =>
      GoalNode.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [key, value, key_type];
}
