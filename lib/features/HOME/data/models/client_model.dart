import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClientModel extends Equatable {
  String name;
  int id;
  String email;
  int phoneNumber;
  String imageUrl;
  ClientModel({
    this.name = '',
    this.id = 0,
    this.email = '',
    this.phoneNumber = 0,
    this.imageUrl = '',
  });
  

  ClientModel copyWith({
    String name,
    int id,
    String email,
    int phoneNumber,
    String imageUrl,
  }) {
    return ClientModel(
      name: name ?? this.name,
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      name: map['name'] ?? '',
      id: map['id'] ?? 0,
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) => ClientModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      id,
      email,
      phoneNumber,
      imageUrl,
    ];
  }
}
