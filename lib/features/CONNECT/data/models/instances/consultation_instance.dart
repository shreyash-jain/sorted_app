import 'dart:convert';

import 'package:equatable/equatable.dart';

class ConsultationInstanceModel extends Equatable {
  String id;
  String name;
  String imageUrl;
  ConsultationInstanceModel({
    this.id = '',
    this.name = '',
    this.imageUrl = '',
  });

  ConsultationInstanceModel copyWith({
    String id,
    String name,
    String imageUrl,
  }) {
    return ConsultationInstanceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory ConsultationInstanceModel.fromMap(Map<String, dynamic> map) {
    return ConsultationInstanceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsultationInstanceModel.fromJson(String source) => ConsultationInstanceModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, imageUrl];
}
