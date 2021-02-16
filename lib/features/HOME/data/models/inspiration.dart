import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InspirationModel extends Equatable {
  final String auther;
  final String text;
  final String imageUrl;
  InspirationModel({
    this.auther = 'Anonymous',
    this.text = 'Lets do it !',
    this.imageUrl = '',
  });

  @override
  // TODO: implement props
  List<Object> get props => [auther, text, imageUrl];

  InspirationModel copyWith({
    String auther,
    String text,
    String imageUrl,
  }) {
    return InspirationModel(
      auther: auther ?? this.auther,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'auther': auther,
      'text': text,
      'imageUrl': imageUrl,
    };
  }

  factory InspirationModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return InspirationModel(
      auther: map['auther'],
      text: map['text'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InspirationModel.fromJson(String source) =>
      InspirationModel.fromMap(json.decode(source));
  factory InspirationModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data();
    if (map == null) return null;

    return InspirationModel(
      auther: map['auther'],
      text: map['text'],
      imageUrl: map['imageUrl'],
    );
  }
  @override
  bool get stringify => true;
}
