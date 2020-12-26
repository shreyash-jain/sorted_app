import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/presentation/heading_bloc/heading_bloc.dart';

class FormFieldBlock extends Equatable {
  int id;
  int savedTs;
  String url;
  String field;
  int type;
  int decoration;
  String fieldValue;
  FormFieldBlock({
    this.id = 0,
    this.savedTs = 0,
    this.url = '',
    this.field = '',
    this.type = 0,
    this.decoration = 0,
    this.fieldValue = '',
  });

  FormFieldBlock copyWith({
    int id,
    int savedTs,
    String url,
    String field,
    int type,
    int decoration,
    String fieldValue,
  }) {
    return FormFieldBlock(
      id: id ?? this.id,
      savedTs: savedTs ?? this.savedTs,
      url: url ?? this.url,
      field: field ?? this.field,
      type: type ?? this.type,
      decoration: decoration ?? this.decoration,
      fieldValue: fieldValue ?? this.fieldValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savedTs': savedTs,
      'url': url,
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
      savedTs: map['savedTs'],
      url: map['url'],
      field: map['field'],
      type: map['type'],
      decoration: map['decoration'],
      fieldValue: map['fieldValue'],
    );
  }

  String toJson() => json.encode(toMap());

  String getTable() => "BlockFormField";

  HeadingBlock toHeading() {
    return HeadingBlock(
        id: id, heading: field, subHeading: fieldValue, decoration: decoration);
  }

  factory FormFieldBlock.fromJson(String source) =>
      FormFieldBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      savedTs,
      url,
      field,
      type,
      decoration,
      fieldValue,
    ];
  }
}
