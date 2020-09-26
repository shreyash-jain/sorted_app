import 'dart:convert';

import 'package:equatable/equatable.dart';


class DisplayThumbnail extends Equatable {
  final String thumbnailUrl;
  final String category;
  DisplayThumbnail({
    this.thumbnailUrl = '',
    this.category = '',
  });
  
  @override
  // TODO: implement props
  List<Object> get props => [thumbnailUrl, category];

  DisplayThumbnail copyWith({
    String thumbnailUrl,
    String category,
  }) {
    return DisplayThumbnail(
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'thumbnailUrl': thumbnailUrl,
      'category': category,
    };
  }

  factory DisplayThumbnail.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DisplayThumbnail(
      thumbnailUrl: map['thumbnailUrl'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DisplayThumbnail.fromJson(String source) => DisplayThumbnail.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
