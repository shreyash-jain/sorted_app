import 'dart:convert';

import 'package:equatable/equatable.dart';

class KeyValueModel extends Equatable {
  int key;
  String value;
  KeyValueModel({
    this.key = 0,
    this.value = '',
  });
  

  KeyValueModel copyWith({
    int key,
    String value,
  }) {
    return KeyValueModel(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
    };
  }

  factory KeyValueModel.fromMap(Map<String, dynamic> map) {
    return KeyValueModel(
      key: map['key'] ?? 0,
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory KeyValueModel.fromJson(String source) => KeyValueModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [key, value];
}
