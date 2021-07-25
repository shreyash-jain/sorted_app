import 'dart:convert';

import 'package:equatable/equatable.dart';

class InstituteInstanceModel extends Equatable {
  String id;
  String name;
  String imageUrl;
  InstituteInstanceModel({
    this.id = '',
    this.name = '',
    this.imageUrl = '',
  });
  

  InstituteInstanceModel copyWith({
    String id,
    String name,
    String imageUrl,
  }) {
    return InstituteInstanceModel(
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

  factory InstituteInstanceModel.fromMap(Map<String, dynamic> map) {
    return InstituteInstanceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InstituteInstanceModel.fromJson(String source) => InstituteInstanceModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, imageUrl];
}
