import 'dart:convert';

import 'package:equatable/equatable.dart';

class FormFieldBlock extends Equatable {
  int id;
  int savedId;
  String field;
  int type;
  int decoration;
  String fieldValue;
  FormFieldBlock({
    this.id = 0,
    this.savedId = 0,
    this.field = '',
    this.type = 0,
    this.decoration = 0,
    this.fieldValue = '',
  });

  FormFieldBlock copyWith({
    int id,
    int savedId,
    String field,
    int type,
    int decoration,
    String fieldValue,
  }) {
    return FormFieldBlock(
      id: id ?? this.id,
      savedId: savedId ?? this.savedId,
      field: field ?? this.field,
      type: type ?? this.type,
      decoration: decoration ?? this.decoration,
      fieldValue: fieldValue ?? this.fieldValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savedId': savedId,
      'field': field,
      'type': type,
      'decoration': decoration,
      'fieldValue': fieldValue,
    };
  }

  factory FormFieldBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return FormFieldBlock(
      id: map['id'],
      savedId: map['savedId'],
      field: map['field'],
      type: map['type'],
      decoration: map['decoration'],
      fieldValue: map['fieldValue'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FormFieldBlock.fromJson(String source) => FormFieldBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      savedId,
      field,
      type,
      decoration,
      fieldValue,
    ];
  }
}
