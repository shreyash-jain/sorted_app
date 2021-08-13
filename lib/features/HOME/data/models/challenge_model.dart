import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChallengeModel extends Equatable {
  int id;
  int category;
  String name;
  int output_type;
  int type;
  ChallengeModel({
    this.id = 0,
    this.category = 0,
    this.name = '',
    this.output_type = 0,
    this.type = 0,
  });
  

  ChallengeModel copyWith({
    int id,
    int category,
    String name,
    int output_type,
    int type,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      output_type: output_type ?? this.output_type,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'output_type': output_type,
      'type': type,
    };
  }

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      id: map['id'] ?? 0,
      category: map['category'] ?? 0,
      name: map['name'] ?? '',
      output_type: map['output_type'] ?? 0,
      type: map['type'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChallengeModel.fromJson(String source) => ChallengeModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      category,
      name,
      output_type,
      type,
    ];
  }
}
