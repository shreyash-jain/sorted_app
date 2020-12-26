import 'dart:convert';

import 'package:equatable/equatable.dart';

class SliderBlock extends Equatable {
  int id;
  int savedTs;
  double max;
  String maxItem;
  String minItem;
  double value;
  int isNotInt;
  int decoration;
  double min;
  String title;
  SliderBlock({
    this.id = 0,
    this.savedTs = 0,
    this.max = 10,
    this.maxItem = '',
    this.minItem = '',
    this.value = 0.0,
    this.isNotInt = 0,
    this.decoration = 0,
    this.min = 0.0,
    this.title = '',
  });

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      id,
      savedTs,
      max,
      maxItem,
      minItem,
      value,
      isNotInt,
      decoration,
      min,
      title,
    ];
  }

  SliderBlock copyWith({
    int id,
    int savedTs,
    double max,
    String maxItem,
    String minItem,
    double value,
    int isNotInt,
    int decoration,
    double min,
    String title,
  }) {
    return SliderBlock(
      id: id ?? this.id,
      savedTs: savedTs ?? this.savedTs,
      max: max ?? this.max,
      maxItem: maxItem ?? this.maxItem,
      minItem: minItem ?? this.minItem,
      value: value ?? this.value,
      isNotInt: isNotInt ?? this.isNotInt,
      decoration: decoration ?? this.decoration,
      min: min ?? this.min,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savedTs': savedTs,
      'max': max,
      'maxItem': maxItem,
      'minItem': minItem,
      'value': value,
      'isNotInt': isNotInt,
      'decoration': decoration,
      'min': min,
      'title': title,
    };
  }

  factory SliderBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SliderBlock(
      id: map['id'],
      savedTs: map['savedTs'],
      max: map['max'],
      maxItem: map['maxItem'],
      minItem: map['minItem'],
      value: map['value'],
      isNotInt: map['isNotInt'],
      decoration: map['decoration'],
      min: map['min'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "BlockSlider";

  factory SliderBlock.fromJson(String source) =>
      SliderBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
