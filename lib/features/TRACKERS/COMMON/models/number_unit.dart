import 'dart:convert';

import 'package:equatable/equatable.dart';

class NumberUnitModel extends Equatable {
  String unitString;
  int id;
  double mul_factor;
  int conv_fun;
  NumberUnitModel({
    this.unitString = '',
    this.id = 0,
    this.mul_factor = 0.0,
    this.conv_fun = 0,
  });

  NumberUnitModel copyWith({
    String unitString,
    int id,
    double mul_factor,
    int conv_fun,
  }) {
    return NumberUnitModel(
      unitString: unitString ?? this.unitString,
      id: id ?? this.id,
      mul_factor: mul_factor ?? this.mul_factor,
      conv_fun: conv_fun ?? this.conv_fun,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unitString': unitString,
      'id': id,
      'mul_factor': mul_factor,
      'conv_fun': conv_fun,
    };
  }

  factory NumberUnitModel.fromMap(Map<String, dynamic> map) {
    return NumberUnitModel(
      unitString: map['unitString'] ?? '',
      id: map['id'] ?? 0,
      mul_factor: map['mul_factor'] ?? 0.0,
      conv_fun: map['conv_fun'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NumberUnitModel.fromJson(String source) =>
      NumberUnitModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [unitString, id, mul_factor, conv_fun];
}
