import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PepTalkModel extends Equatable {
  int id;
  String content;
  String fileLink;
  String imageUrl;
  String title;
  PepTalkModel({
    this.id = 0,
    this.content = '',
    this.fileLink = '',
    this.imageUrl = '',
    this.title = '',
  });

  PepTalkModel copyWith({
    int id,
    String content,
    String fileLink,
    String imageUrl,
    String title,
  }) {
    return PepTalkModel(
      id: id ?? this.id,
      content: content ?? this.content,
      fileLink: fileLink ?? this.fileLink,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'fileLink': fileLink,
      'imageUrl': imageUrl,
      'title': title,
    };
  }

  factory PepTalkModel.fromMap(Map<String, dynamic> map) {
    return PepTalkModel(
      id: map['id'] ?? 0,
      content: map['content'] ?? '',
      fileLink: map['fileLink'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      title: map['title'] ?? '',
    );
  }

  factory PepTalkModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    return PepTalkModel(
      id: map['id'] ?? 0,
      content: map['content'] ?? '',
      fileLink: map['fileLink'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PepTalkModel.fromJson(String source) =>
      PepTalkModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      content,
      fileLink,
      imageUrl,
      title,
    ];
  }
}
