import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserTag extends Equatable {
  int id;
  int has_children;
  int count;
  String tag;
  UserTag({
    this.id = 0,
    this.has_children = 0,
    this.count = 0,
    this.tag = '',
  });

  @override
  // TODO: implement props
  List<Object> get props => [id, has_children, count, tag];

  UserTag copyWith({
    int id,
    int has_children,
    int count,
    String tag,
  }) {
    return UserTag(
      id: id ?? this.id,
      has_children: has_children ?? this.has_children,
      count: count ?? this.count,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'has_children': has_children,
      'count': count,
      'tag': tag,
    };
  }

  factory UserTag.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserTag(
      id: map['id'],
      has_children: map['has_children'],
      count: map['count'],
      tag: map['tag'],
    );
  }
  factory UserTag.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;
    int children = 0;
    if (map['has_children'] != null) children = map['has_children'];

    return UserTag(
      id: map['id'],
      tag: map['tag'],
      has_children: children,
      count: map['count'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTag.fromJson(String source) =>
      UserTag.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
