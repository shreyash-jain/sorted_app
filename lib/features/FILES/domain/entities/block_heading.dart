import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';

class HeadingBlock extends Equatable {
  String heading;
  String subHeading;
  int id;
  int decoration;
  int savedTs;
  HeadingBlock({
    this.heading = '',
    this.subHeading = '',
    this.id = 0,
    this.decoration = 0,
    this.savedTs = 0,
  });

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      heading,
      subHeading,
      id,
      decoration,
      savedTs,
    ];
  }

  HeadingBlock copyWith({
    String heading,
    String subHeading,
    int id,
    int decoration,
    int savedTs,
  }) {
    return HeadingBlock(
      heading: heading ?? this.heading,
      subHeading: subHeading ?? this.subHeading,
      id: id ?? this.id,
      decoration: decoration ?? this.decoration,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'heading': heading,
      'subHeading': subHeading,
      'id': id,
      'decoration': decoration,
      'savedTs': savedTs,
    };
  }

  factory HeadingBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return HeadingBlock(
      heading: map['heading'],
      subHeading: map['subHeading'],
      id: map['id'],
      decoration: map['decoration'],
      savedTs: map['savedTs'],
    );
  }

  String toJson() => json.encode(toMap());

  FormFieldBlock toFormFieldBlock() {
    return FormFieldBlock(
        id: id,
        decoration: decoration,
        savedTs: DateTime.now().millisecondsSinceEpoch,
        field: heading,
        fieldValue: subHeading);
  }

  factory HeadingBlock.fromJson(String source) =>
      HeadingBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
