import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClassInstanceModel extends Equatable {
  String classId;
  String className;
  String imageUrl;
  ClassInstanceModel({
    this.classId = '',
    this.className = '',
    this.imageUrl = '',
  });

  ClassInstanceModel copyWith({
    String classId,
    String className,
    String imageUrl,
  }) {
    return ClassInstanceModel(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'className': className,
      'imageUrl': imageUrl,
    };
  }

  factory ClassInstanceModel.fromMap(Map<String, dynamic> map) {
    return ClassInstanceModel(
      classId: map['classId'] ?? '',
      className: map['className'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassInstanceModel.fromJson(String source) => ClassInstanceModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [classId, className, imageUrl];
}
