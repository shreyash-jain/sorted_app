import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:googleapis/compute/v1.dart';

class BlogModel extends Equatable {
  String article_title;
  String article_web_link;
  String base_content;
  int base_content_word_count;
  int id;
  List<String> tags;
  String image_url;
  int num_textbox;
  String summary;
  BlogModel({
    this.article_title = '',
    this.article_web_link = '',
    this.base_content,
    this.base_content_word_count = 0,
    this.id = 0,
    this.tags = const [],
    this.image_url = '',
    this.num_textbox = 0,
    this.summary = '',
  });

  BlogModel copyWith({
    String article_title,
    String article_web_link,
    String base_content,
    int base_content_word_count,
    int id,
    List<String> tags,
    String image_url,
    int num_textbox,
    String summary,
  }) {
    return BlogModel(
      article_title: article_title ?? this.article_title,
      article_web_link: article_web_link ?? this.article_web_link,
      base_content: base_content ?? this.base_content,
      base_content_word_count:
          base_content_word_count ?? this.base_content_word_count,
      id: id ?? this.id,
      tags: tags ?? this.tags,
      image_url: image_url ?? this.image_url,
      num_textbox: num_textbox ?? this.num_textbox,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'article_title': article_title,
      'article_web_link': article_web_link,
      'base_content': base_content,
      'base_content_word_count': base_content_word_count,
      'id': id,
      'tags': tags,
      'image_url': image_url,
      'num_textbox': num_textbox,
      'summary': summary,
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      article_title: map['article_title'] ?? '',
      article_web_link: map['article_web_link'] ?? '',
      base_content: map['base_content'] ?? '',
      base_content_word_count: map['base_content_word_count'] ?? 0,
      id: map['id'] ?? 0,
      tags: List<String>.from(map['tags'] ?? const []),
      image_url: map['image_url'] ?? '',
      num_textbox: map['num_textbox'] ?? 0,
      summary: map['summary'] ?? '',
    );
  }

  factory BlogModel.empty() {
    return BlogModel(
      article_title: '',
      article_web_link: '',
      base_content_word_count: 0,
      id: -1,
      image_url: '',
      num_textbox: 0,
      tags: [],
      summary: '',
    );
  }

  factory BlogModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;
    return BlogModel(
      article_title: map['article_title'] ?? '',
      article_web_link: map['article_web_link'] ?? '',
      base_content: json.encode(map['base_content']) ?? '',
      base_content_word_count: map['base_content_word_count'] ?? 0,
      id: map['id'] ?? 0,
      tags: List<String>.from(map['tags'] ?? const []),
      image_url: map['image_url'] ?? '',
      num_textbox: map['num_textbox'] ?? 0,
      summary: map['summary'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogModel.fromJson(String source) =>
      BlogModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      article_title,
      article_web_link,
      base_content,
      base_content_word_count,
      id,
      tags,
      image_url,
      num_textbox,
      summary,
    ];
  }
}
