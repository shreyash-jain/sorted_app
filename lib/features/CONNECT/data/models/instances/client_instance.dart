import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClientInstance extends Equatable {
  String uid;
  String imageUrl;
  String name;
  ClientInstance({
    this.uid = '',
    this.imageUrl = '',
    this.name = '',
  });

  ClientInstance copyWith({
    String uid,
    String imageUrl,
    String name,
  }) {
    return ClientInstance(
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'imageUrl': imageUrl,
      'name': name,
    };
  }

  factory ClientInstance.fromMap(Map<String, dynamic> map) {
    return ClientInstance(
      uid: map['uid'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientInstance.fromJson(String source) => ClientInstance.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [uid, imageUrl, name];
}
