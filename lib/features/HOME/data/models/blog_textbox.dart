import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BlogTextboxModel extends Equatable {
  String content;
  String heading;
  int id;
  String imageUrl;
  int word_count;
  BlogTextboxModel({
    this.content = '',
    this.heading = '',
    this.id = 0,
    this.imageUrl = '',
    this.word_count = 0,
  });

  BlogTextboxModel copyWith({
    String content,
    String heading,
    int id,
    String imageUrl,
    int word_count,
  }) {
    return BlogTextboxModel(
      content: content ?? this.content,
      heading: heading ?? this.heading,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      word_count: word_count ?? this.word_count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'heading': heading,
      'id': id,
      'imageUrl': imageUrl,
      'word_count': word_count,
    };
  }

  factory BlogTextboxModel.fromMap(Map<String, dynamic> map) {
    return BlogTextboxModel(
      content: map['content'] ?? '',
      heading: map['heading'] ?? '',
      id: map['id'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      word_count: map['word_count'] ?? 0,
    );
  }

  factory BlogTextboxModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;
    return BlogTextboxModel(
      content: json.encode(map['content']) ?? '',
      heading: map['heading'] ?? '',
      id: map['id'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      word_count: map['word_count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogTextboxModel.fromJson(String source) =>
      BlogTextboxModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      content,
      heading,
      id,
      imageUrl,
      word_count,
    ];
  }
}
