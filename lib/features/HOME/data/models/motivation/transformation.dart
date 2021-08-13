import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TransformationModel extends Equatable {
  int id;
  String image_url;
  String person;
  String source_link;
  String source_title;
  String story;
  String title;
  TransformationModel({
    this.id = 0,
    this.image_url = '',
    this.person = '',
    this.source_link = '',
    this.source_title = '',
    this.story = '',
    this.title = '',
  });

  TransformationModel copyWith({
    int id,
    String image_url,
    String person,
    String source_link,
    String source_title,
    String story,
    String title,
  }) {
    return TransformationModel(
      id: id ?? this.id,
      image_url: image_url ?? this.image_url,
      person: person ?? this.person,
      source_link: source_link ?? this.source_link,
      source_title: source_title ?? this.source_title,
      story: story ?? this.story,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_url': image_url,
      'person': person,
      'source_link': source_link,
      'source_title': source_title,
      'story': story,
      'title': title,
    };
  }

  factory TransformationModel.fromMap(Map<String, dynamic> map) {
    return TransformationModel(
      id: map['id'] ?? 0,
      image_url: map['image_url'] ?? '',
      person: map['person'] ?? '',
      source_link: map['source_link'] ?? '',
      source_title: map['source_title'] ?? '',
      story: map['story'] ?? '',
      title: map['title'] ?? '',
    );
  }
  factory TransformationModel.empty() {
    return TransformationModel(
      id: -1,
      image_url: '',
      person: '',
      source_link: '',
      source_title: '',
      story: '',
      title: '',
    );
  }
  factory TransformationModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;
    return TransformationModel(
      id: map['id'] ?? 0,
      image_url: map['image_url'] ?? '',
      person: map['person'] ?? '',
      source_link: map['source_link'] ?? '',
      source_title: map['source_title'] ?? '',
      story: map['story'] ?? '',
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TransformationModel.fromJson(String source) =>
      TransformationModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      image_url,
      person,
      source_link,
      source_title,
      story,
      title,
    ];
  }
}
