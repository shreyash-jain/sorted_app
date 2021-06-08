import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Placeholder extends Equatable {
  final String name;
  final String path;
  final int total;
  Placeholder({
    this.name = '',
    this.path = '',
    this.total = 0,
  });
  @override
  // TODO: implement props
  List<Object> get props => [name, path, total];

  Placeholder copyWith({
    String name,
    String path,
    int total,
  }) {
    return Placeholder(
      name: name ?? this.name,
      path: path ?? this.path,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'path': path,
      'total': total,
    };
  }

  factory Placeholder.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Placeholder(
      name: map['name'],
      path: map['path'],
      total: map['total'],
    );
  }

  factory Placeholder.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;

    return Placeholder(
      name: map['name'],
      path: map['path'],
      total: map['total'],
    );
  }
  String toJson() => json.encode(toMap());

  factory Placeholder.fromJson(String source) =>
      Placeholder.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
