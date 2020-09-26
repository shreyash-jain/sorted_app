import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AffirmationModel extends Equatable {
  final int id;
  final String text;
  final String imageUrl;
  final String category;
  AffirmationModel({
    this.id,
    this.text = '',
    this.imageUrl = '',
    this.category = '',
  });
  @override
  // TODO: implement props
  List<Object> get props => [id, text, imageUrl, category];

  AffirmationModel copyWith({
    int id,
    String text,
    String imageUrl,
    String category,
  }) {
    return AffirmationModel(
      id: id ?? this.id,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory AffirmationModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AffirmationModel(
      id: map['id'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());
  factory AffirmationModel.fromSnapshot(DocumentSnapshot map) {
    if (map == null) return null;

    return AffirmationModel(
      id: map['id'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      category: map['tag'],
    );
  }

  factory AffirmationModel.fromJson(String source) => AffirmationModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
