import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClassPrivateModel extends Equatable {
  int id;
  int classId;
  int type;
  int value;
  int feeCollectionStartDay;
  DateTime startDay;
  DateTime endDay;
  
  ClassPrivateModel({
    this.id = 0,
    this.classId = 0,
    this.type = 0,
    this.value = 0,
    this.feeCollectionStartDay = 0,
    this.startDay,
    this.endDay,
  });

  ClassPrivateModel copyWith({
    int id,
    int classId,
    int type,
    int value,
    int feeCollectionStartDay,
    DateTime startDay,
    DateTime endDay,
  }) {
    return ClassPrivateModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      type: type ?? this.type,
      value: value ?? this.value,
      feeCollectionStartDay:
          feeCollectionStartDay ?? this.feeCollectionStartDay,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classId': classId,
      'type': type,
      'value': value,
      'feeCollectionStartDay': feeCollectionStartDay,
      'startDay': startDay.millisecondsSinceEpoch,
      'endDay': endDay.millisecondsSinceEpoch,
    };
  }

  factory ClassPrivateModel.fromMap(Map<String, dynamic> map) {
    return ClassPrivateModel(
      id: map['id'] ?? 0,
      classId: map['classId'] ?? 0,
      type: map['type'] ?? 0,
      value: map['value'] ?? 0,
      feeCollectionStartDay: map['feeCollectionStartDay'] ?? 0,
      startDay: DateTime.fromMillisecondsSinceEpoch(map['startDay']),
      endDay: DateTime.fromMillisecondsSinceEpoch(map['endDay']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassPrivateModel.fromJson(String source) =>
      ClassPrivateModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      classId,
      type,
      value,
      feeCollectionStartDay,
      startDay,
      endDay,
    ];
  }
}
